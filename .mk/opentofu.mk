#
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
#

ifndef MK_COMMON_OPENTOFU_INCLUDED
MK_COMMON_OPENTOFU_INCLUDED := 1

TOFU ?= tofu

REPO_ROOT ?= $(shell git rev-parse --show-toplevel 2>/dev/null || pwd)

TF_BACKEND_CONFIG ?=
TF_VAR_FILE       ?=
TF_DIR            ?= .

TF_PLAN_FILE      ?= plan.tfplan

TF_COMMON_ARGS := -chdir=$(TF_DIR)
ifneq ($(TF_BACKEND_CONFIG),)
  TF_COMMON_ARGS += -backend-config=$(TF_BACKEND_CONFIG)
endif
ifneq ($(TF_VAR_FILE),)
  TF_COMMON_ARGS += -var-file=$(TF_VAR_FILE)
endif

.PHONY: tofu-init
tofu-init: ## Run 'tofu init'
	$(TOFU) $(TF_COMMON_ARGS) init

.PHONY: tofu-plan
tofu-plan: ## Run 'tofu plan'
	$(TOFU) $(TF_COMMON_ARGS) plan -out=$(TF_PLAN_FILE)

.PHONY: tofu-apply
tofu-apply: ## Run 'tofu apply' on previous plan
	$(TOFU) $(TF_COMMON_ARGS) apply $(TF_PLAN_FILE)

.PHONY: tofu-clean
tofu-clean: ## Delete local *.plan/*.tfplan under REPO_ROOT (safe local cleanup)
	@echo "Cleaning local OpenTofu plan files under $(REPO_ROOT)..."
	@find "$(REPO_ROOT)" -type f \( \
		-name '*.plan' -o \
		-name '*.tfplan' \
	\) -print -delete || true

.PHONY: tofu-clean-all
tofu-clean-all: ## Delete local tfstate, backups and .terraform dirs under REPO_ROOT (aggressive local cleanup)
	@echo "Removing local Terraform/OpenTofu state and .terraform dirs under $(REPO_ROOT)..."
	@find "$(REPO_ROOT)" -type f \( \
		-name 'terraform.tfstate' -o \
		-name 'terraform.tfstate.backup' \
	\) -print -delete || true
	@find "$(REPO_ROOT)" -type d -name '.terraform' -prune -print -exec rm -rf {} + || true

.PHONY: tofu-command
tofu-command: ## Run arbitrary tofu command: make tofu-command TOFU_ARGS="plan -destroy"
	@[ -n "$(TOFU_ARGS)" ] || { echo 'Usage: make tofu-command TOFU_ARGS="plan -destroy"'; exit 1; }
	$(TOFU) $(TF_COMMON_ARGS) $(TOFU_ARGS)

endif  # MK_COMMON_OPENTOFU_INCLUDED
