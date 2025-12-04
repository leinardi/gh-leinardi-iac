#!/usr/bin/env bash
set -euo pipefail

MK_REPO="${1:?MK repo (e.g. leinardi/make-common) required}"
VERSION="${2:?version (e.g. v1.0.0) required}"
MK_DIR="${3:?target .mk directory required}"
FILES="${4:?list of .mk files required}"

# Resolve repo root (so Makefile can live anywhere in the repo)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

SCRIPT_PATH="${REPO_ROOT}/scripts/bootstrap-mk-common.sh"

# Normalise MK_DIR and derive version file
MK_DIR="${MK_DIR%/}"
MK_VERSION_FILE="${MK_DIR}/.mk-common-version"
EXPECTED="${MK_REPO}@${VERSION}"

NEED_REFRESH=0

# Check version file
if [[ ! -f "${MK_VERSION_FILE}" ]]; then
  NEED_REFRESH=1
else
  STORED="$(cat "${MK_VERSION_FILE}" 2>/dev/null || echo "")"
  [[ "${STORED}" != "${EXPECTED}" ]] && NEED_REFRESH=1
fi

# Also refresh if any requested .mk file is missing
if [[ "${NEED_REFRESH}" -eq 0 ]]; then
  for f in ${FILES}; do
    if [[ ! -f "${MK_DIR}/${f}" ]]; then
      NEED_REFRESH=1
      break
    fi
  done
fi

if [[ "${NEED_REFRESH}" -eq 1 ]]; then
  echo "[mk] Updating bootstrap-mk-common.sh and .mk files from ${MK_REPO}@${VERSION}" >&2
  mkdir -p "${REPO_ROOT}/scripts" "${MK_DIR}"

  # Fetch the script itself from the tagged repo
  curl -fsSL \
    "https://raw.githubusercontent.com/${MK_REPO}/${VERSION}/scripts/bootstrap-mk-common.sh" \
    -o "${SCRIPT_PATH}"
  chmod +x "${SCRIPT_PATH}"

  # Fetch all requested .mk files
  for f in ${FILES}; do
    echo "[mk] Fetching ${f} from ${MK_REPO}@${VERSION}" >&2
    curl -fsSL \
      "https://raw.githubusercontent.com/${MK_REPO}/${VERSION}/.mk/${f}" \
      -o "${MK_DIR}/${f}"
  done

  printf '%s\n' "${EXPECTED}" > "${MK_VERSION_FILE}"

  # Re-exec the freshly downloaded script so any new logic applies immediately
  exec "${SCRIPT_PATH}" "$@"
fi

# If we reach here, script + .mk files are already up to date.
# Nothing else to do; Make just needed us for our side effects.
