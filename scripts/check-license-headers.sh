#!/usr/bin/env bash
#
# MIT License
#
# Copyright (c) 2026 Roberto Leinardi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# License header checker.
#
# gh-leinardi-iac is MIT-licensed, and every code file says so in its own header. This fails on any
# tracked code file whose first lines do not carry the MIT notice with Roberto Leinardi's
# copyright, so a missing header is caught as surely as one copied from another project.
#
# Governed: OpenTofu (.tf), shell and Python scripts, the Makefile (stacks/github-repos/Makefile is
# a symlink to it) and the repo-local .mk fragments. Never YAML, JSON, HCL or Markdown: the
# .terraform.lock.hcl files are written by tofu init, and the module READMEs are generated in part
# by terraform-docs. Exempt, each for a stated reason: the make-common files the bootstrap fetches
# (upstream, named in the Makefile's MK_COMMON_FILES) and scripts/bootstrap-mk-common.sh, which
# comes from make-common too; they carry make-common's own MIT header.

set -euo pipefail

usage() {
	cat <<'USAGE'
Usage: scripts/check-license-headers.sh

Checks every tracked code file for the MIT license header and lists the files that lack it. Run
from anywhere inside the repository.
USAGE
}

if [[ $# -gt 0 ]]; then
	usage >&2
	exit 2
fi

cd "$(git rev-parse --show-toplevel)"

# How many leading lines the header must sit in: a shebang and a comment line may precede it.
HEADER_WINDOW=30

REQUIRED_LINES=(
	"MIT License"
	"Permission is hereby granted, free of charge, to any person obtaining a copy"
	"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR"
)

# The copyright line names the year (or years) and the author, on one line.
COPYRIGHT_REGEX='Copyright \(c\) [0-9]{4}([-, ]+[0-9]{4})* Roberto Leinardi$'

# Exact paths that are not this repository's own code.
EXEMPT_PATHS=(
	"scripts/bootstrap-mk-common.sh"
)

# The shared make fragments, read from the Makefile so the list cannot drift from what the
# bootstrap actually fetches.
mk_common_files() {
	sed -n 's/^MK_COMMON_FILES[[:space:]]*:=[[:space:]]*//p' Makefile
}

is_governed() {
	local path="$1"

	case "${path}" in
	*.tf | *.sh | *.bash | *.py | .mk/*.mk | Makefile | */Makefile)
		return 0
		;;
	esac

	return 1
}

is_exempt() {
	local path="$1" entry

	for entry in "${EXEMPT_PATHS[@]}"; do
		if [[ ${path} == "${entry}" ]]; then
			return 0
		fi
	done

	for entry in ${COMMON_FILES}; do
		if [[ ${path} == ".mk/${entry}" ]]; then
			return 0
		fi
	done

	return 1
}

has_header() {
	local path="$1" head line
	head="$(head -n "${HEADER_WINDOW}" -- "${path}")"

	for line in "${REQUIRED_LINES[@]}"; do
		if [[ ${head} != *"${line}"* ]]; then
			return 1
		fi
	done

	grep -Eq -- "${COPYRIGHT_REGEX}" <<<"${head}"
}

COMMON_FILES="$(mk_common_files)"
if [[ -z ${COMMON_FILES} ]]; then
	echo "Could not read MK_COMMON_FILES from the Makefile." >&2
	exit 1
fi

missing=()
checked=0

while IFS= read -r -d '' path; do
	if ! is_governed "${path}" || is_exempt "${path}"; then
		continue
	fi

	# A tracked file deleted in the working tree is not this check's concern.
	if [[ ! -f ${path} ]]; then
		continue
	fi

	checked=$((checked + 1))

	if ! has_header "${path}"; then
		missing+=("${path}")
	fi
done < <(git ls-files -z)

if [[ ${checked} -eq 0 ]]; then
	echo "No governed files found: the check has nothing to check." >&2
	exit 1
fi

if [[ ${#missing[@]} -gt 0 ]]; then
	echo "These files lack the MIT license header:" >&2
	printf '  %s\n' "${missing[@]}" >&2
	echo "Copy the header from any .tf file (IntelliJ: the MIT copyright profile), with the year" >&2
	echo "of the file's first commit." >&2
	exit 1
fi

echo "License headers: ${checked} files checked, all carry the MIT header."
