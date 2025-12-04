locals {
  # Final per-repo flag: should we apply the default-branch ruleset?
  default_branch_protection_enabled = {
    for name, _ in local.resolved_repos :
    name => coalesce(
      lookup(local.default_branch_protection_overrides, name, null),
      local.default_branch_protection_default_enabled
    )
  }

  # Per-repo required status checks for the default branch.
  # Empty list = no required checks yet.
  #
  # Example for later:
  # default_branch_required_checks = {
  #   for name, _ in local.resolved_repos :
  #   name => (
  #     name == "make-common"
  #     ? ["ci"]  # your workflow status check context
  #     : []
  #   )
  # }
  default_branch_required_checks = {
    for name, _ in local.resolved_repos :
    name => []
  }
}

resource "github_repository_ruleset" "default_branch_protection" {
  # One ruleset per repo where protection is enabled
  for_each = {
    for name, enabled in local.default_branch_protection_enabled :
    name => name
    if enabled
  }

  # Ensure all repositories exist before we start creating rulesets
  depends_on = [module.repositories]

  name        = "Protect default branch"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  # === Bypass list ===
  # Allow the repo Admin role to bypass this ruleset,
  # but *only* via pull requests (no direct pushes).
  bypass_actors {
    actor_id    = 5 # Admin
    actor_type  = "RepositoryRole"
    bypass_mode = "pull_request"
  }

  conditions {
    ref_name {
      # Only the default branch
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    # Restrict deletions of the default branch
    deletion = true

    # Block force pushes (non-fast-forward updates)
    non_fast_forward = true

    # Require linear history (no merge commits)
    required_linear_history = true

    # Require pull requests before merging, with one approval
    pull_request {
      required_approving_review_count = 1

      # Dismiss stale approvals when new commits are pushed
      dismiss_stale_reviews_on_push = true

      # Require review from CODEOWNERS (if CODEOWNERS file exists)
      require_code_owner_review = true

      # Require approval of the most recent reviewable push
      require_last_push_approval = true

      # Optional; leaving false by default
      # required_review_thread_resolution = false
    }

    # Require status checks to pass — only if we configured some contexts
    dynamic "required_status_checks" {
      for_each = length(local.default_branch_required_checks[each.key]) > 0 ? [true] : []
      content {
        dynamic "required_check" {
          for_each = local.default_branch_required_checks[each.key]
          content {
            context = required_check.value
          }
        }

        # Require PRs to be up-to-date with latest checks before merge
        strict_required_status_checks_policy = true

        # Allow branch creation before checks exist
        do_not_enforce_on_create = true
      }
    }
  }
}
