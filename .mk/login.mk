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
