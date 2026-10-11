# MIT License
#
# Copyright (c) 2025 Roberto Leinardi
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

ifndef MK_COMMON_LOGIN_INCLUDED
MK_COMMON_LOGIN_INCLUDED := 1

REPO_ROOT ?= $(shell git rev-parse --show-toplevel 2>/dev/null || pwd)

R2_LOGIN_SCRIPT ?= $(REPO_ROOT)/scripts/r2_login.py
R2_LOGIN_PROFILE ?= r2-gh-leinardi-iac
# Prefer BW_ITEM_ID (unique); BW_ITEM_NAME is only a fallback.
BW_ITEM_ID ?=
BW_ITEM_NAME ?= cloudflare-r2-gh-leinardi-iac

# Use python3 from PATH unless overridden
PYTHON ?= python3

.PHONY: login
login: ## Mint Cloudflare R2 temp creds and update ~/.aws/credentials profile ($(R2_LOGIN_PROFILE))
	@echo "Logging in (profile: $(R2_LOGIN_PROFILE))..."
	@BW_ITEM_ID="$(BW_ITEM_ID)" BW_ITEM_NAME="$(BW_ITEM_NAME)" \
		"$(PYTHON)" "$(R2_LOGIN_SCRIPT)" --profile "$(R2_LOGIN_PROFILE)"

endif  # MK_COMMON_LOGIN_INCLUDED
