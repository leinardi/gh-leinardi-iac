#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import re
import stat
import subprocess
import sys
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from pathlib import Path
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

DEFAULT_PROFILE = "r2-gh-leinardi-iac"
DEFAULT_ITEM_NAME = "cloudflare-r2-gh-leinardi-iac"
DEFAULT_TTL_SECONDS = 8 * 60 * 60  # 8 hours

DEFAULT_R2_BUCKET = "gh-leinardi-iac"
DEFAULT_R2_PREFIX = "github-repos/"

SECTION_RE = re.compile(r"^\s*\[([^\]]+)\]\s*$")


@dataclass(frozen=True)
class Logger:
    verbose: bool

    def debug(self, msg: str) -> None:
        if self.verbose:
            print(f"DEBUG: {msg}", file=sys.stderr)


def _run(cmd: list[str], *, interactive: bool, log: Logger) -> subprocess.CompletedProcess[str]:
    """
    interactive=True:
      - capture stdout (we need JSON)
      - inherit stderr so interactive prompts (Bitwarden unlock) are visible
    """
    log.debug(f"exec: {' '.join(cmd)} (interactive={interactive})")

    if interactive:
        return subprocess.run(
            cmd,
            check=False,
            stdout=subprocess.PIPE,
            stderr=None,  # inherit stderr -> prompts visible
            text=True,
        )

    return subprocess.run(
        cmd,
        check=False,
        capture_output=True,
        text=True,
    )


def _bw_fields(log: Logger, *, item_id: str | None, item_name: str | None) -> dict[str, str]:
    helper = Path(__file__).with_name("bw_fields.py")
    cmd = [sys.executable, str(helper)]
    if log.verbose:
        cmd.append("--verbose")

    if item_id:
        cmd += ["--bw-item-id", item_id]
    elif item_name:
        cmd += ["--bw-item-name", item_name]
    else:
        raise RuntimeError("Provide --bw-item-id or --bw-item-name / BW_ITEM_NAME.")

    # Require the secrets needed for R2 temp creds
    cmd += ["--require", "cf_account_id", "cf_api_token", "r2_parent_access_key_id"]

    # IMPORTANT: interactive=True so Bitwarden prompts are visible.
    res = _run(cmd, interactive=True, log=log)

    if res.returncode != 0:
        # stderr was inherited, so the error/prompt output is already shown above.
        raise RuntimeError(f"bw_fields.py failed (rc={res.returncode}). See output above.")

    try:
        out = json.loads(res.stdout or "")
    except json.JSONDecodeError as ex:
        raise RuntimeError(f"bw_fields.py returned invalid JSON: {ex}") from ex

    if not isinstance(out, dict):
        raise RuntimeError("bw_fields.py did not return a JSON object")

    # mypy-friendly narrowing
    fields: dict[str, str] = {}
    for k, v in out.items():
        if isinstance(k, str) and isinstance(v, str):
            fields[k] = v
    return fields


def parse_json(label: str, raw: str, *, log: Logger, safe_to_show: bool) -> Any:
    if not raw:
        raise RuntimeError(f"{label} returned empty output on stdout")

    try:
        return json.loads(raw)
    except json.JSONDecodeError as ex:
        if log.verbose and safe_to_show:
            log.debug(f"{label} raw stdout (first 500 chars): {raw[:500]!r}")
        raise RuntimeError(f"Failed to parse JSON from {label}: {ex}") from ex


def cf_temp_creds(
    log: Logger,
    *,
    cf_account_id: str,
    cf_api_token: str,
    payload: dict[str, Any],
) -> dict[str, str]:
    url = f"https://api.cloudflare.com/client/v4/accounts/{cf_account_id}/r2/temp-access-credentials"
    data = json.dumps(payload).encode("utf-8")

    log.debug(f"Requesting Cloudflare temp creds for account {cf_account_id} (payload keys: {sorted(payload.keys())}).")

    req = Request(
        url,
        method="POST",
        data=data,
        headers={
            "Authorization": f"Bearer {cf_api_token}",
            "Content-Type": "application/json",
        },
    )

    try:
        with urlopen(req, timeout=30) as resp:
            body = resp.read().decode("utf-8")
    except HTTPError as ex:
        msg = ex.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"Cloudflare API HTTP {ex.code}: {msg[:1000]}") from ex
    except URLError as ex:
        raise RuntimeError(f"Cloudflare API connection error: {ex}") from ex

    j = parse_json("Cloudflare API response", body, log=log, safe_to_show=True)
    if not isinstance(j, dict) or not j.get("success", False):
        errs = j.get("errors", [])
        raise RuntimeError(f"Cloudflare API error: {json.dumps(errs)[:1000]}")

    result = j.get("result")
    if not isinstance(result, dict):
        raise RuntimeError("Cloudflare API response missing result object")

    required = ("accessKeyId", "secretAccessKey", "sessionToken")
    out: dict[str, str] = {}
    for k in required:
        v = result.get(k)
        if not isinstance(v, str) or not v:
            raise RuntimeError(f"Cloudflare API response missing '{k}'")
        out[k] = v

    return out


def upsert_aws_credentials_profile(log: Logger, *, creds_path: Path, profile: str, kv_lines: list[str]) -> None:
    creds_path.parent.mkdir(parents=True, exist_ok=True)

    lines: list[str] = []
    if creds_path.exists():
        lines = creds_path.read_text(encoding="utf-8").splitlines(keepends=True)

    def nl(s: str) -> str:
        return s if s.endswith("\n") else s + "\n"

    header = f"[{profile}]"
    start: int | None = None

    for i, line in enumerate(lines):
        m = SECTION_RE.match(line)
        if m and m.group(1) == profile:
            start = i
            break

    new_block = [nl(header)] + [nl(x) for x in kv_lines] + [nl("")]

    if start is not None:
        end = len(lines)
        for j in range(start + 1, len(lines)):
            if SECTION_RE.match(lines[j]):
                end = j
                break
        lines = lines[:start] + new_block + lines[end:]
        log.debug(f"Updated existing profile [{profile}] in {creds_path}.")
    else:
        if lines and not lines[-1].endswith("\n"):
            lines[-1] = nl(lines[-1])
        if lines and lines[-1].strip() != "":
            lines.append(nl(""))
        lines += new_block
        log.debug(f"Added new profile [{profile}] in {creds_path}.")

    tmp = creds_path.with_suffix(".tmp")
    tmp.write_text("".join(lines), encoding="utf-8")
    os.chmod(tmp, stat.S_IRUSR | stat.S_IWUSR)  # 0600
    tmp.replace(creds_path)


def main() -> int:
    ap = argparse.ArgumentParser(description="Mint Cloudflare R2 temporary credentials and write ~/.aws/credentials.")
    ap.add_argument("--verbose", action="store_true", help="Verbose debug logging (secrets are never printed).")
    ap.add_argument("--profile", default=DEFAULT_PROFILE, help=f"AWS profile name (default: {DEFAULT_PROFILE})")
    ap.add_argument("--ttl-seconds", type=int, default=DEFAULT_TTL_SECONDS, help="TTL for temp creds (default: 8h)")
    ap.add_argument("--bw-item-id", default=os.environ.get("BW_ITEM_ID"), help="Bitwarden item ID (preferred).")
    ap.add_argument("--bw-item-name", default=os.environ.get("BW_ITEM_NAME", DEFAULT_ITEM_NAME), help="Item name (fallback).")
    ap.add_argument("--bucket", default=DEFAULT_R2_BUCKET, help=f"R2 bucket (default: {DEFAULT_R2_BUCKET})")
    ap.add_argument("--prefix", default=DEFAULT_R2_PREFIX, help=f"R2 prefixes scope (default: {DEFAULT_R2_PREFIX})")
    args = ap.parse_args()

    log = Logger(verbose=args.verbose)

    fields = _bw_fields(log, item_id=args.bw_item_id, item_name=args.bw_item_name)

    cf_account_id = fields["cf_account_id"]
    cf_api_token = fields["cf_api_token"]
    parent_access_key_id = fields["r2_parent_access_key_id"]

    bucket = fields.get("r2_bucket") or args.bucket
    prefix = fields.get("r2_prefix") or args.prefix

    payload: dict[str, Any] = {
        "bucket": bucket,
        "parentAccessKeyId": parent_access_key_id,
        "permission": "object-read-write",
        "ttlSeconds": int(args.ttl_seconds),
        "prefixes": [prefix],
    }

    result = cf_temp_creds(log, cf_account_id=cf_account_id, cf_api_token=cf_api_token, payload=payload)

    expires_at_utc = datetime.now(UTC) + timedelta(seconds=int(args.ttl_seconds))
    expires_at_local = expires_at_utc.astimezone()
    expires_str = expires_at_local.isoformat(timespec="seconds")

    kv = [
        f"# Generated by r2_login.py; expires {expires_str}",
        f"aws_access_key_id = {result['accessKeyId']}",
        f"aws_secret_access_key = {result['secretAccessKey']}",
        f"aws_session_token = {result['sessionToken']}",
    ]

    creds_path = Path.home() / ".aws" / "credentials"
    upsert_aws_credentials_profile(log, creds_path=creds_path, profile=args.profile, kv_lines=kv)

    print(f"Updated AWS profile [{args.profile}] in {creds_path} (expires {expires_str}).")
    print(f"Use: AWS_PROFILE={args.profile} tofu plan")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        print("ERROR: interrupted", file=sys.stderr)
        raise SystemExit(130) from None
    except Exception as ex:
        print(f"ERROR: {ex}", file=sys.stderr)
        raise SystemExit(1) from None
