# gh-leinardi-iac

This repository manages my GitHub account infrastructure using **OpenTofu**.

The goal is to treat GitHub configuration (repositories, settings, labels, rulesets, etc.) as **infrastructure as code**, so it stays:

- reproducible
- auditable
- version-controlled
- easy to evolve over time

The repository is intentionally public and opinionated, but the patterns used here are generic and can be reused for other personal or organizational GitHub setups.

## 📦 What this repository manages

At the moment, this repository manages:

- GitHub repositories
    - creation (including template-based creation)
    - visibility
    - merge strategy settings
    - topics
    - basic repo settings (issues/wiki/projects, etc.)
    - archival behavior
- Repository templates (used at creation time)
- Issue labels (authoritative sync)
- Repository rulesets
    - default branch protection
    - immutable tags

The scope may grow over time as more GitHub features are managed declaratively.

## 🗂️ High-level structure

```text
.
├── modules/
│   ├── github-repositories/      # Generic module: manages github_repository resources
│   ├── github-labels/            # Generic module: manages issue labels (authoritative or additive)
│   ├── github-repo-rulesets/     # Generic module: manages rulesets (branch + tag)
│   └── github-repo-stack/        # Wrapper module: sensible defaults + composes the 3 modules above
│
├── stacks/
│   └── github-repos/              # Concrete GitHub account configuration
│       ├── repos.tf               # One module call per repository
│       ├── repos-templates.tf     # Template repositories
│       ├── backend.tf             # Remote state configuration
│       ├── providers.tf           # Provider configuration
│       └── variables.tf           # Stack inputs
│
├── .pre-commit-config.yaml        # Pre-commit checks (fmt, validate, lint, security)
├── .tflint.hcl                    # TFLint configuration
└── README.md
```

### `modules/`

Contains reusable OpenTofu modules:

- **`github-repo-stack/`** is a wrapper module with sensible defaults that composes:

    - `github-repositories/`
    - `github-labels/`
    - `github-repo-rulesets/`

This keeps the stack configuration readable and reduces “blast radius”: each repo is managed by its own module call.

### `stacks/github-repos/`

This is the actual “deployment” for my GitHub account:

- declares repositories **one-by-one** in `repos.tf`
- applies defaults and optional per-repo overrides
- applies labels
- applies rulesets where supported

## 📐 Repository templates

This stack manages one or more **template repositories** via OpenTofu (see `repos-templates.tf`).

Templates are used when creating new repositories:

- default template for general repos
- specialized templates (e.g. GitHub Action templates)

Important: templates are only applied **at creation time**, as per GitHub behavior. The configuration ignores future drift on the `template` block so plans stay stable.

## 🛡️ Rulesets and feature availability

Repository rulesets may not be available for all repository types and plans.

This stack supports a simple switch:

- rulesets are enabled for public repositories by default
- private repos can optionally be included via a toggle

This is controlled through the wrapper module via:

- `enable_rulesets_on_private` (default: `false`)

## 🔐 Authentication model

This setup is designed to work both locally and in CI:

- **Locally**: authentication is handled via the GitHub CLI (`gh auth login`)
- **CI**: authentication is performed via GitHub Actions (token or GitHub App)

No access tokens are committed to the repository.

## 🗄️ State management

The OpenTofu state is stored remotely using an S3-compatible backend.

This ensures:

- state is not stored in Git
- safe concurrent usage (locking)
- easy automation via GitHub Actions

## 🚀 Getting started

This repository is designed to be used via the provided `Makefile`.
All common operations (checks, initialization, planning, applying) are exposed as simple targets.

### Prerequisites

- OpenTofu
- `pre-commit`
- GitHub CLI (`gh`)
- Make
- Valid GitHub authentication (see below)

### Initial setup

Clone the repository and install the pre-commit hooks:

```bash
make pre-commit-install
```

Run all checks locally:

```bash
make check
```

### Authentication

Authenticate via GitHub CLI:

```bash
gh auth login
```

### OpenTofu workflow

Initialize:

```bash
make tofu-init
```

Preview changes:

```bash
make tofu-plan
```

Apply:

```bash
make tofu-apply
```

## ➕ Managing repositories

Repositories are declared one-by-one in `stacks/github-repos/repos.tf` using the wrapper module `github-repo-stack`.

### Create a new repository (without a template)

Add a new module block:

```hcl
module "repo_new_repo" {
  source = "../../modules/github-repo-stack"

  repo_name    = "new-repo"
  description  = "My new repository"
  visibility   = "private"
  topics       = ["opentofu", "automation"]

  # Labels and rulesets are enabled by default (with sensible defaults).
}
```

Then run:

```bash
make tofu-plan
make tofu-apply
```

### Create a new repository using a template

Use the `template` input (creation-time only):

```hcl
module "repo_new_repo_from_template" {
  source = "../../modules/github-repo-stack"

  repo_name    = "new-repo-from-template"
  description  = "Repo created from template"
  visibility   = "public"

  template = {
    owner      = var.github_owner
    repository = github_repository.default_template.name
  }
}
```

### Import an existing repository

1. Add a module block for the repo (typically set `template = null` unless you created it from a template):

```hcl
module "repo_existing_repo" {
  source = "../../modules/github-repo-stack"

  repo_name   = "existing-repo"
  visibility  = "public"
  description = "Existing repo managed by OpenTofu"
}
```

1. Import the repository into the state:

```bash
make tofu-command "import 'module.repo_existing_repo.module.repo.github_repository.this[\"existing-repo\"]' existing-repo"
```

1. Plan/apply:

```bash
make tofu-plan
make tofu-apply
```

If you already have labels or rulesets on that repo, the next plan will reconcile them to match the configuration (labels are authoritative by default).

## 🧰 Maintenance helpers

- Update shared Makefile snippets:

  ```bash
  make mk-common-update
  ```

- Update pre-commit hook versions:

  ```bash
  make pre-commit-autoupdate
  ```

- Clean local OpenTofu artifacts:

  ```bash
  make tofu-clean
  ```

  (Use `tofu-clean-all` for a more aggressive cleanup.)
