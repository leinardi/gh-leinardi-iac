locals {
  ########################################
  # Global defaults for all repos
  ########################################
  repo_defaults = {
    allow_auto_merge       = true
    allow_merge_commit     = true
    allow_rebase_merge     = false
    allow_squash_merge     = true
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
      description   = "GitHub Action template for actionlint pre-commit + reviewdog."
      topics        = ["github-actions", "pre-commit", "actionlint", "reviewdog"]
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
    "gh-leinardi-iac" = false
    "homelab"         = false
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
    "gh-leinardi-iac" = false
    "homelab"         = false
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
}
