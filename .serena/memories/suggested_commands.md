# Suggested Commands

- `make pre-commit-install` installs hooks.
- `make check` runs the repository check suite exposed by shared make snippets.
- `make tofu-init` initializes the OpenTofu stack with the configured backend.
- `make tofu-plan` previews GitHub infrastructure changes.
- `make tofu-apply` applies GitHub infrastructure changes.
- `tofu fmt -recursive` formats all Terraform/OpenTofu files.
- From `stacks/github-repos`: `tofu init -backend=false` installs local modules without remote state access; useful before validation in limited environments.
- From `stacks/github-repos`: `tofu validate` validates the stack once modules are installed.
- `gh auth login` sets up local GitHub provider authentication.
