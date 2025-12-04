ifndef MK_COMMON_HELP_INCLUDED
MK_COMMON_HELP_INCLUDED := 1

# Only set default if not already set
ifeq ($(.DEFAULT_GOAL),)
  .DEFAULT_GOAL := help
endif

.PHONY: help
help: ## Show this help and usage
	@awk 'BEGIN {FS=":.*##"; print "\nTargets:"} /^[a-zA-Z0-9_\/-]+:.*##/ { printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

endif  # MK_COMMON_HELP_INCLUDED
