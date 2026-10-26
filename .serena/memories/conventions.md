# Conventions

- Keep MIT license header in Terraform files.
- Stack repository declarations are explicit, one `module "repo_*"` block per GitHub repository in `stacks/github-repos/repos.tf`.
- Module names use Terraform-safe snake_case derived from repo names, usually `repo_<repo_name_with_hyphens_as_underscores>`.
- Public repositories are the default; private repos set `visibility = "private"`.
- Descriptions and topics are set in repo module calls; do not include `gh-leinardi-iac` manually because `github-repo-stack` appends it.
- Use `local.default_template` or `local.reviewdog_template` only when the repo should be created from that template; templates are creation-time GitHub behavior.
- Pass `enable_rulesets_on_private = var.enable_rulesets_on_private` in repo module blocks to preserve the stack-wide private ruleset toggle.
- `github-repo-stack` labels are authoritative by default and merge default labels with per-repo overrides.
