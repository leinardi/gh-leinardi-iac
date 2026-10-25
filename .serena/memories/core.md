# Core

- OpenTofu IaC for the `leinardi` GitHub account: repositories, templates, labels, and rulesets.
- Concrete deployment lives in `stacks/github-repos/`; reusable modules live in `modules/`.
- Repository inventory is declared one module block per repository in `stacks/github-repos/repos.tf` using `modules/github-repo-stack`.
- Template repositories are managed directly in `stacks/github-repos/repos-templates.tf`; `local.default_template` and `local.reviewdog_template` are passed to repo modules at creation time.
- `github-repo-stack` composes `github-repositories`, `github-labels`, and `github-rulesets`; it also appends the managed `gh-leinardi-iac` topic to every repo.
- Read `mem:tech_stack` for tools/provider details, `mem:conventions` for Terraform patterns, `mem:suggested_commands` for common commands, and `mem:task_completion` before finishing code changes.
