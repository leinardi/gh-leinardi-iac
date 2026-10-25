# Task Completion

- For Terraform edits, run `tofu fmt -recursive` from the repo root.
- Validate the affected stack when feasible: from `stacks/github-repos`, run `tofu validate` after modules are installed.
- If validation reports modules not installed, run `tofu init -backend=false` from `stacks/github-repos`; remote backend credentials may still be checked in some cached-state situations, but local module installation can complete before the credential failure.
- For broader changes, run `make check` when dependencies/auth are available.
- Before final response, inspect `git status --short` and relevant `git diff` to report changed files and avoid mixing unrelated changes.
