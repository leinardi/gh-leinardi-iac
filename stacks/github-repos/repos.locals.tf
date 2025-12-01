locals {
  ########################################
  # 1. Global defaults for all repos
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
    template_mode          = "default" #   "default", "none", "custom"
    visibility             = "public"
    vulnerability_alerts   = true

  }

  ########################################
  # 2. Logical repo definitions
  ########################################
  #   - No template logic here; just describe the repos.
  #   - You can add `template_mode` per repo where needed.
  repos_base = {
    "make-common" = {
      description = "Shared Makefile snippets and reusable tasks."
      topics      = ["makefile", "automation", "tooling"]
    }

    # New repos go here
    # "another-repo" = {
    #   description   = "..."
    #   template_mode = "none"
    # }
  }

  ########################################
  # 3. Default template config (from the resource)
  ########################################
  default_template = {
    owner                = var.github_owner
    repository           = github_repository.default_template.name
    include_all_branches = false
  }

  ########################################
  # 4. Custom templates per repo (optional / future)
  ########################################
  repo_template_overrides = {
    # Example:
    # "special-repo" = {
    #   owner                = var.github_owner
    #   repository           = "another-template-repo"
    #   include_all_branches = false
    # }
  }

  ########################################
  # 5. Final resolved_repos for the module
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
