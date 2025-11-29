locals {
  ########################################
  # Global defaults for all repos
  ########################################
  repo_defaults = {
    allow_merge_commit     = true
    allow_rebase_merge     = false
    allow_squash_merge     = false
    allow_update_branch    = true
    archive_on_destroy     = true
    auto_init              = true
    delete_branch_on_merge = true
    has_issues             = true
    has_projects           = false
    has_wiki               = false
    license_template       = "mit"
    template_mode          = "default" # "default", "none", "custom"
    visibility             = "public"
    vulnerability_alerts   = true
  }

  ########################################
  # Logical repo definitions
  ########################################
  #   - No template logic here; just describe the repos.
  #   - You can add `template_mode` per repo where needed.
  #   - You can import existing repos with tofu import   'module.repositories.github_repository.this["<repo name>"]'   <repo name>
  repos_base = {
    "make-common" = {
      description = "Shared Makefile snippets and reusable tasks."
      topics      = ["makefile", "automation", "tooling"]
    }

    "gh-reusable-workflows" = {
      description   = "Reusable GitHub Actions workflows for my projects."
      topics        = ["github-actions", "reusable-workflows", "ci"]
      template_mode = "none" # existing repo, do NOT create from template
    }

    "gotilert" = {
      description = "A small Gotify-compatible HTTP shim that forwards messages to Alertmanager."
      topics      = ["alertmanager", "gotify", "monitoring"]
    }

    "JDInstaller-macOS" = {
      description   = "An Ansible playbook to automate the setup of macOS personalizations."
      topics        = ["ansible", "macos", "automation"]
      template_mode = "none" # existing repo, do NOT create from template
    }

    "swarm-scheduler-exporter" = {
      description   = "Prometheus exporter for Docker Swarm focused on task state visibility, accurate desired replicas, and operability at scale."
      topics        = ["prometheus", "docker-swarm", "exporter", "monitoring"]
      template_mode = "none" # existing repo, do NOT create from template
    }

    "kotlin-awtrix-light" = {
      template_mode = "none" # existing repo, do NOT create from template
    }

    "dotfiles" = {
      visibility = "private"
    }

    "homelab" = {
      visibility    = "private"
      template_mode = "none" # existing repo, do NOT create from template
    }

    "gh-leinardi-iac" = {
      visibility    = "private"
      topics        = ["opentofu", "automation"]
      template_mode = "none" # existing repo, do NOT create from template
    }

    "gha-pre-commit-actionlint-reviewdog" = {
      description   = "GitHub Action to run actionlint via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "actionlint", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-ansible-lint-reviewdog" = {
      description   = "GitHub Action to run ansible-lint via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "ansible-lint", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-hooks-reviewdog" = {
      description   = "GitHub Action to run pre-commit hooks and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "hooks", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-markdownlint-cli2-reviewdog" = {
      description   = "GitHub Action to run markdownlint-cli2 via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "markdownlint-cli2", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-mypy-reviewdog" = {
      description   = "GitHub Action to run mypy via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "mypy", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-prettier-reviewdog" = {
      description   = "GitHub Action to run prettier via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "prettier", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-rain-format-reviewdog" = {
      description   = "GitHub Action to run rain-format via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "rain-format", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-ruff-reviewdog" = {
      description   = "GitHub Action to run ruff via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "ruff", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-shellcheck-reviewdog" = {
      description   = "GitHub Action to run shellcheck via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "shellcheck", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-sqlfluff-reviewdog" = {
      description   = "GitHub Action to run sqlfluff via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "sqlfluff", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-tofu-docs-reviewdog" = {
      description   = "GitHub Action to run tofu-docs via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "tofu-docs", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-tofu-fmt-reviewdog" = {
      description   = "GitHub Action to run tofu-fmt via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "tofu-fmt", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-tofu-tflint-reviewdog" = {
      description   = "GitHub Action to run tofu-tflint via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "tofu-tflint", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-tofu-trivy-reviewdog" = {
      description   = "GitHub Action to run tofu-trivy via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "tofu-trivy", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    "gha-pre-commit-yamllint-reviewdog" = {
      description   = "GitHub Action to run yamllint via pre-commit and comment results on PRs using reviewdog."
      topics        = ["github-actions", "pre-commit", "yamllint", "reviewdog"]
      template_mode = "custom" # use repo_template_overrides
    }

    # New repos go here...
  }

  ########################################
  # Template config
  ########################################
  default_template = {
    owner                = var.github_owner
    repository           = github_repository.default_template.name
    include_all_branches = false
  }

  repo_template_overrides = {
    "gha-pre-commit-actionlint-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-ansible-lint-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-hooks-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-markdownlint-cli2-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-mypy-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-prettier-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-rain-format-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-ruff-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-shellcheck-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-sqlfluff-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-tofu-docs-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-tofu-fmt-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-tofu-tflint-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-tofu-trivy-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-tofu-validate-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }

    "gha-pre-commit-yamllint-reviewdog" = {
      owner                = var.github_owner
      repository           = github_repository.pre_commit_reviewdog_template.name
      include_all_branches = false
    }
  }

  ########################################
  # Default branch protection overrides
  ########################################

  # Global default: enable default-branch protection for all managed repos
  default_branch_protection_default_enabled = true

  # Per-repo overrides:
  #   - true  -> force enable
  #   - false -> force disable
  #   - omit  -> use default local.immutable_tags_default_enabled
  default_branch_protection_overrides = {
  }

  ########################################
  # Immutable tags overrides
  ########################################

  # Global default: enable immutable tags for all managed repos
  immutable_tags_default_enabled = true

  # Per-repo overrides:
  #    - true  -> force-enable immutable tags even if default was false
  #    - false -> disable immutable tags even if default was true
  #    - omit  -> fall back to immutable_tags_default_enabled
  immutable_tags_overrides = {
  }

  ########################################
  # Final resolved_repos
  ########################################
  resolved_repos = {
    for name, cfg in local.repos_base :
    name => merge(
      local.repo_defaults,
      cfg,
      {
        name = name

        # Always tag repos managed by this stack
        topics = distinct(concat(try(cfg.topics, []), ["gh-leinardi-iac"]))

        template = (
          lookup(cfg, "template_mode", "default") == "none"
          ? null
          : (
            lookup(cfg, "template_mode", "default") == "default"
            ? local.default_template
            : local.repo_template_overrides[name]
          )
        )
      }
    )
  }
  repo_supports_rulesets = {
    for name, cfg in local.repos_base :
    name => lookup(cfg, "visibility", local.repo_defaults.visibility) == "public"
  }
}
