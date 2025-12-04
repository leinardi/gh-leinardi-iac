# Resolve repository root (Makefile can live anywhere)
REPO_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null || pwd)

MK_COMMON_REPO        ?= leinardi/make-common
MK_COMMON_VERSION     ?= v1.1.0

MK_COMMON_DIR         := $(REPO_ROOT)/.mk
MK_COMMON_FILES       := help.mk pre-commit.mk opentofu.mk password.mk

MK_COMMON_BOOTSTRAP_SCRIPT := $(REPO_ROOT)/scripts/bootstrap-mk-common.sh

# Bootstrap: the script will self-update and fetch the selected .mk snippets
MK_COMMON_BOOTSTRAP := $(shell "$(MK_COMMON_BOOTSTRAP_SCRIPT)" \
  "$(MK_COMMON_REPO)" \
  "$(MK_COMMON_VERSION)" \
  "$(MK_COMMON_DIR)" \
  "$(MK_COMMON_FILES)")

TF_DIR = stacks/github-repos

# Include shared make logic
include $(addprefix $(MK_COMMON_DIR)/,$(MK_COMMON_FILES))
