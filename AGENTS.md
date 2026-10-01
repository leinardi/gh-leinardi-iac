# AGENTS.md

## What this is

The OpenTofu configuration of the `leinardi` GitHub account: repositories and their settings, issue labels, repository-level
Actions variables, and rulesets (default-branch protection, immutable tags). `stacks/github-repos/` is the one stack; it declares
each repository as a call to the wrapper module `modules/github-repo-stack`, which composes the generic modules next to it. The
state lives in a Cloudflare R2 bucket (S3 backend, lockfile locking). [`README.md`](README.md) is the user-facing guide.

**`main` is not deployed by CI.** Nothing in `.github/workflows/` runs `tofu plan` or `tofu apply`: a change reaches GitHub only
when the owner applies it locally. There are no releases.

## Common commands

```bash
make check               # pre-commit on all files (tofu fmt/validate/docs/tflint/trivy, ruff, mypy, actionlint, markdownlint, …)
make check-stage         # pre-commit on the staged files only
make pre-commit-install  # installs the pre-commit and commit-msg hooks
make login               # mints temporary R2 credentials (Bitwarden) into the r2-gh-leinardi-iac AWS profile
make tofu-init           # tofu init in stacks/github-repos
make tofu-plan           # tofu plan, saved for tofu-apply
make tofu-apply          # applies the saved plan: changes the real GitHub account
make help                # lists every target
```

Before calling a change done, run `make check`. `make tofu-plan` needs `make login` and `gh auth login` first; read the plan
before anything is applied. **Never run `make tofu-apply` (or `tofu apply`/`destroy`/`import`/`state` through `tofu-command`)
unless the owner asked for it in this conversation**: it changes live repositories.

The Makefile pulls shared snippets from `leinardi/make-common@v1` into `.mk/` on first run. To refresh: `make mk-common-update`.
Project targets live in the local `.mk/*.mk` files listed in `MK_LOCAL_FILES` (`login.mk`), never as recipes in the Makefile.
`stacks/github-repos/Makefile` is a symlink to the root one, so the targets also work from the stack directory.

## Layout

| Path | What lives there |
| --- | --- |
| `stacks/github-repos/repos.tf` | one `module "repo_<name>"` block per repository |
| `stacks/github-repos/repos-templates.tf` | the template repositories, used only when a repository is created |
| `stacks/github-repos/defaults.tf` | `local.repo_defaults`, the settings every repository starts from |
| `stacks/github-repos/moved.tf` | `moved` blocks for renames still to be applied |
| `stacks/github-repos/.trivyignore` | accepted Trivy findings for the stack, each with a reason |
| `modules/github-repo-stack/` | wrapper module: defaults plus the four modules below |
| `modules/github-{repositories,labels,actions-variables,rulesets}/` | generic modules, one resource family each |
| `scripts/r2_login.py`, `scripts/bw_fields.py` | `make login`: Bitwarden item to temporary R2 credentials |
| `.github/workflows/ci.yaml` | the reviewdog jobs and `conventional-commits`, on pull requests |
| `.github/workflows/pre-commit-warmup.yaml` | refreshes the pre-commit cache on `main` when the hook config changes |
| `.agents/skills/` | project skills; `.claude/skills` is a symlink to it |

## Conventions

- **A rename is a `moved` block, not an edit.** `github-repo-stack` keys its resources by `repo_name`, so changing the name alone
  plans a destroy and create of the repository. Add both `moved` blocks (module address and `for_each` key) to `moved.tf`, as the
  existing ones do, and delete them once applied.
- **Labels are authoritative by default**: a label removed from `default_labels` (in `modules/github-repo-stack/variables.tf`)
  is deleted from every repository that uses the defaults, with its assignments, and so is a label someone created by hand.
  Per-repository additions or changes go in `label_overrides`.
- **Required checks must always report.** `default_branch_required_checks` names CI job names. A job gated on
  `github.event_name == 'pull_request'` never reports on a run fired by `workflow_dispatch` (for example a release bump pull
  request opened with `GITHUB_TOKEN`), so requiring it can leave such pull requests unmergeable: say in a comment why each
  required check always runs, as `repo_adversarial_review_loop` does.
- **Rulesets apply to public repositories only** unless `enable_rulesets_on_private` is set: private repositories on GitHub Free
  have no rulesets.
- **The repository is public.** `actions_variables` holds non-sensitive values only; secrets are never committed, not even in a
  test or an example.
- `template` is read at creation only (`ignore_changes`), and `archive_on_destroy` archives a repository removed from the config
  instead of deleting it.
- Module `README.md` files are generated between the `PRE-COMMIT-OPENTOFU DOCS HOOK` markers by the `tofu_docs` hook: edit the
  variables' descriptions, not the generated tables.
- Pin every action and reusable workflow by full commit SHA, with the version in a trailing comment (`@<sha> # vX.Y.Z`); give
  every workflow a top-level `permissions: contents: read` and widen it only on the job that needs more; pass `${{ }}`
  expressions into `run:` scripts through `env:`; name workflow files `.yaml`.

## Commit messages

All commits MUST be Conventional Commits 1.0.0 **with a scope**: `<type>(<scope>)[!]: <description>`, optional blank-line body
and footers. Use the repository or module as the scope (`runhold`, `rulesets`, `labels`, `stack`), or `ci`, `make`, `docs`,
`deps` for the rest. Enforced by the `conventional-pre-commit` `commit-msg` hook (`--force-scope`, installed by
`make pre-commit-install`) and by the `conventional-commits` CI job on pull requests. Breaking changes use `!` before `:` or a
`BREAKING CHANGE:` footer.

This repository has no releases: the history is the changelog. Pick the type by what changes on GitHub once applied: `feat` for
a newly managed repository or setting, `fix` for a correction, `refactor` for a change whose plan is empty, `docs`/`chore`/`ci`
when nothing applied changes. Examples: `feat(runhold): manage the repository`,
`fix(rulesets): require conventional-commits on the default branch`. Every commit of a pull request lands on `main` (merge
commits only), so every commit counts, not just the pull request title.

## Project skills

Skills live in `.agents/skills/` (symlinked as `.claude/skills`). Load `adversarial-review` for any review request ("review my
diff", "is this ready to merge").
