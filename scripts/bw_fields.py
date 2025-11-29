#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class ExecResult:
    stdout: str
    stderr: str
    returncode: int


@dataclass(frozen=True)
class Logger:
    verbose: bool

    def debug(self, msg: str) -> None:
        if self.verbose:
            print(f"DEBUG: {msg}", file=sys.stderr)


def _run(cmd: list[str], *, env: dict[str, str], interactive: bool, log: Logger) -> ExecResult:
    log.debug(f"exec: {' '.join(cmd)} (interactive={interactive})")

    if interactive:
        p = subprocess.run(
            cmd,
            check=False,
            stdout=subprocess.PIPE,
            stderr=None,  # show prompts
            text=True,
            env=env,
        )
        stderr = ""
    else:
        p = subprocess.run(
            cmd,
            check=False,
            capture_output=True,
            text=True,
            env=env,
        )
        stderr = p.stderr

    stdout = p.stdout
    log.debug(f"returncode={p.returncode}, stdout_len={len(stdout)}, stderr_len={len(stderr)}")
    return ExecResult(stdout=stdout, stderr=stderr, returncode=p.returncode)


def _bw(args: list[str], *, bw_session: str | None, interactive: bool, log: Logger) -> str:
    env = os.environ.copy()
    if bw_session:
        env["BW_SESSION"] = bw_session

    res = _run(["bw", *args], env=env, interactive=interactive, log=log)
    if res.returncode != 0:
        snippet = (res.stderr.strip()[:500] if res.stderr else "").strip()
        raise RuntimeError(f"bw {' '.join(args)} failed (rc={res.returncode}){(': ' + snippet) if snippet else ''}")
    return res.stdout.strip()


def _parse_json(label: str, raw: str, *, log: Logger, safe_to_show: bool) -> Any:
    if not raw:
        raise RuntimeError(f"{label} returned empty output on stdout")
    try:
        return json.loads(raw)
    except json.JSONDecodeError as ex:
        if log.verbose and safe_to_show:
            log.debug(f"{label} raw stdout (first 500 chars): {raw[:500]!r}")
        raise RuntimeError(f"Failed to parse JSON from {label}: {ex}") from ex


def _ensure_bw_session(log: Logger) -> str:
    existing = os.environ.get("BW_SESSION")

    status_raw = _bw(["status"], bw_session=existing, interactive=False, log=log)
    status = _parse_json("bw status", status_raw, log=log, safe_to_show=True)
    st = status.get("status")
    log.debug(f"bw status.status={st!r}")

    if st == "unlocked":
        if existing:
            return existing
        session = _bw(["unlock", "--raw"], bw_session=None, interactive=True, log=log)
        if not session:
            raise RuntimeError("bw unlock --raw returned empty session token")
        return session

    if st == "locked":
        session = _bw(["unlock", "--raw"], bw_session=None, interactive=True, log=log)
        if not session:
            raise RuntimeError("bw unlock --raw returned empty session token")
        return session

    if st == "unauthenticated":
        raise RuntimeError("Bitwarden CLI is not logged in. Run: bw login")

    raise RuntimeError(f"Unexpected bw status: {st!r}")


def _find_item_id(log: Logger, *, bw_session: str, item_id: str | None, item_name: str) -> str:
    if item_id:
        return item_id

    items_raw = _bw(["list", "items", "--search", item_name], bw_session=bw_session, interactive=False, log=log)
    items = _parse_json("bw list items", items_raw, log=log, safe_to_show=True)

    if not isinstance(items, list):
        raise RuntimeError("bw list items did not return a JSON list")
    if len(items) != 1:
        raise RuntimeError(f"Bitwarden search for '{item_name}' returned {len(items)} items. Use --bw-item-id to disambiguate.")

    item = items[0]
    if not isinstance(item, dict) or "id" not in item:
        raise RuntimeError("bw list items result missing item id")
    return str(item["id"])


def _get_item_fields(log: Logger, *, bw_session: str, bw_item_id: str) -> dict[str, str]:
    # SENSITIVE: do not log item JSON
    item_raw = _bw(["get", "item", bw_item_id], bw_session=bw_session, interactive=False, log=log)
    item = _parse_json("bw get item", item_raw, log=log, safe_to_show=False)

    if not isinstance(item, dict):
        raise RuntimeError("bw get item did not return a JSON object")

    fields = item.get("fields") or []
    if not isinstance(fields, list):
        raise RuntimeError("Bitwarden item fields are not a list")

    out: dict[str, str] = {}
    for f in fields:
        if not isinstance(f, dict):
            continue
        name = f.get("name")
        value = f.get("value")
        if isinstance(name, str) and isinstance(value, str):
            out[name] = value

    log.debug(f"Loaded {len(out)} custom fields (names only, values redacted).")
    if log.verbose:
        log.debug(f"Field names: {sorted(out.keys())!r}")
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description="Fetch Bitwarden item custom fields as JSON (safe for public repos).")
    ap.add_argument("--verbose", action="store_true", help="Verbose debug logging (never prints secret values).")
    ap.add_argument("--bw-item-id", default=os.environ.get("BW_ITEM_ID"), help="Bitwarden item ID (preferred).")
    ap.add_argument("--bw-item-name", default=os.environ.get("BW_ITEM_NAME", ""), help="Item name to search (fallback).")
    ap.add_argument(
        "--fields",
        nargs="*",
        default=[],
        help="Optional subset of field names to output. If empty, outputs all custom fields.",
    )
    ap.add_argument(
        "--require",
        nargs="*",
        default=[],
        help="Field names that must exist and be non-empty (in addition to --fields filtering).",
    )
    args = ap.parse_args()

    log = Logger(verbose=args.verbose)

    if not args.bw_item_id and not args.bw_item_name:
        raise RuntimeError("Provide --bw-item-id (preferred) or --bw-item-name / BW_ITEM_NAME.")

    bw_session = os.environ.get("BW_SESSION") or _ensure_bw_session(log)
    item_id = _find_item_id(log, bw_session=bw_session, item_id=args.bw_item_id, item_name=args.bw_item_name)
    fields = _get_item_fields(log, bw_session=bw_session, bw_item_id=item_id)

    required = set(args.require)
    if required:
        missing = sorted([k for k in required if not fields.get(k)])
        if missing:
            raise RuntimeError(f"Missing required Bitwarden fields: {', '.join(missing)}")

    if args.fields:
        # Filter to requested keys (missing keys are omitted)
        filtered = {k: v for k, v in fields.items() if k in set(args.fields)}
        fields = filtered

    json.dump(fields, sys.stdout, separators=(",", ":"))
    sys.stdout.write("\n")
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
