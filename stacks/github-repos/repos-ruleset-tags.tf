locals {
  # Final decision per repo: should we apply the Immutable tags ruleset?
  immutable_tag_repos_enabled = {
    for name, _ in local.resolved_repos :
    name => coalesce(
      lookup(local.immutable_tags_overrides, name, null),
      local.immutable_tags_default_enabled
    )
  }
}

resource "github_repository_ruleset" "immutable_tags" {
  # Create a ruleset only for repos where the final flag is true
  for_each = {
    for name, enabled in local.immutable_tag_repos_enabled :
    name => name
    if enabled
  }

  # Ensure all repositories exist before we start creating rulesets
  depends_on = [module.repositories]

  name        = "Immutable tags"
  repository  = each.key
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = [
        "refs/tags/v[0-9]",      # v0..v9 remain mutable
        "refs/tags/v[1-9][0-9]", # v10..v99 remain mutable
        "refs/tags/latest",      # latest remains mutable
      ]
    }
  }

  # Immutable tags: disallow delete, non-FF, and update
  rules {
    deletion         = true
    non_fast_forward = true
    update           = true
  }
}
