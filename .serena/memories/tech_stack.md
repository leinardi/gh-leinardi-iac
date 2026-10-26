# Tech Stack

- Terraform language using OpenTofu; stack requires `>= 1.11.1`.
- GitHub provider: `integrations/github`, version constraint `~> 6.6`.
- Remote state uses an S3-compatible backend for `stacks/github-repos`; local validation may need `tofu init -backend=false` to install modules without remote state access.
- Makefile bootstraps shared targets from `leinardi/make-common` into `.mk/`; default stack dir is `stacks/github-repos` via `TF_DIR`.
- Local GitHub auth expected through `gh`; CI auth through token/GitHub App.
- Pre-commit includes OpenTofu fmt/validate/tflint/trivy, checkmake, mypy, ruff, actionlint, markdownlint-cli2, shellcheck, prettier-yaml, and yamllint.
