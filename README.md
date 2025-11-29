# gh-leinardi-iac

This repository manages my GitHub account infrastructure using **OpenTofu**.

Its goal is to treat GitHub configuration (repositories, settings, labels, rulesets, etc.) as **infrastructure as code**, making it:

* reproducible
* auditable
* version-controlled
* easy to evolve over time

The repository is intentionally public and opinionated, but the patterns used here are generic and can be reused for other personal or organizational GitHub setups.

## 📦 What this repository manages

At the moment, this repository manages:

* GitHub repositories

    * creation
    * visibility
    * merge settings
    * topics
    * templates
* Repository templates (used when creating new repos)
* Issue labels
* Repository rulesets

    * default branch protection
    * immutable tags

The scope may grow over time as more GitHub features are managed declaratively.

## 🗂️ High-level structure

```text
.
├── modules/
│   ├── github-repositories/     # Reusable module to manage repositories
│   ├── github-labels/           # Reusable module to manage issue labels
│   └── …                        # Other reusable modules
│
├── stacks/
│   └── github-repos/            # Concrete GitHub account configuration
│       ├── repos.locals.tf     # Repository definitions and defaults
│       ├── repos-templates.tf  # Repository templates
│       ├── rulesets-*.tf       # Branch / tag rulesets
│       ├── backend.tf          # Remote state configuration
│       └── main.tf             # Providers and module wiring
│
├── .pre-commit-config.yaml     # Pre-commit checks (fmt, validate, lint, security)
├── .tflint.hcl                 # TFLint configuration
└── README.md
```

### `modules/`

Contains reusable OpenTofu modules.
These modules are generic and do not contain account-specific data.

### `stacks/github-repos/`

This is the actual “deployment” for my GitHub account.

* Defines **which repositories exist**
* Applies defaults and per-repo overrides
* Applies labels and rulesets where supported
* Uses a remote backend to store state safely

## 📐 Repository templates

A dedicated **template repository** is managed via OpenTofu and used when creating new repositories.

This template typically contains:

* minimal `.pre-commit-config.yaml`
* `.editorconfig`
* a simple CI workflow that runs pre-commit
* `CODEOWNERS`
* `dependabot.yml`

Repositories can:

* use the default template
* opt out of templates
* (in the future) use a custom template

Templates are only applied **at creation time**, as per GitHub behavior.

## 🛡️ Rulesets and feature availability

Some GitHub features (such as repository rulesets) are **not available on all plans or repository types**.

This configuration automatically:

* enables rulesets for supported repositories (e.g. public repos)
* skips unsupported repositories (e.g. private repos on free plans)
* avoids noisy diffs and failing applies

This logic is handled centrally, so individual repositories do not need manual overrides.

## 🔐 Authentication model

This setup is designed to work both locally and in CI:

* **Locally**: authentication is handled via the GitHub CLI (`gh auth login`)
* **CI**: authentication is performed using a GitHub App

No access tokens are committed to the repository.

## 🗄️ State management

The OpenTofu state is stored remotely using an S3-compatible backend.

This ensures:

* state is not stored in Git
* safe concurrent usage
* easy automation via GitHub Actions

## 🚀 Getting started

This repository is designed to be used via the provided `Makefile`.
All common operations (checks, initialization, planning, applying) are exposed as simple targets.

### Prerequisites

* OpenTofu
* `pre-commit`
* GitHub CLI (`gh`)
* Make
* Valid GitHub authentication (see below)

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

Authentication is handled via the GitHub CLI.

Make sure you are logged in:

```bash
gh auth login
```

The same configuration is designed to work in CI using a GitHub App.

### OpenTofu workflow

Initialize the working directory:

```bash
make tofu-init
```

Preview changes:

```bash
make tofu-plan
```

Apply the planned changes:

```bash
make tofu-apply
```

### Maintenance helpers

* Update shared Makefile snippets:

  ```bash
  make mk-common-update
  ```

* Update pre-commit hook versions:

  ```bash
  make pre-commit-autoupdate
  ```

* Clean local OpenTofu artifacts:

  ```bash
  make tofu-clean
  ```

  (Use `tofu-clean-all` for a more aggressive cleanup.)
