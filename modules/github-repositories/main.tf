resource "github_repository" "this" {
  for_each = var.repos

  allow_auto_merge       = try(each.value.allow_auto_merge, true)
  allow_update_branch    = try(each.value.allow_update_branch, true)
  archive_on_destroy     = try(each.value.archive_on_destroy, true)
  archived               = try(each.value.archived, false)
  auto_init              = try(each.value.auto_init, false)
  delete_branch_on_merge = try(each.value.delete_branch_on_merge, true)
  description            = try(each.value.description, null)
  has_issues             = try(each.value.has_issues, true)
  has_projects           = try(each.value.has_projects, false)
  has_wiki               = try(each.value.has_wiki, false)
  homepage_url           = try(each.value.homepage_url, null)
  is_template            = try(each.value.is_template, false)
  license_template       = try(each.value.license_template, null)
  name                   = each.value.name
  topics                 = try(each.value.topics, [])
  visibility             = each.value.visibility

  # Default: enable alerts, but they must be false if the repo is archived
  vulnerability_alerts = try(
    each.value.vulnerability_alerts,
    try(each.value.archived, false) ? false : true,
  )

  # Optional template repository used at creation time
  dynamic "template" {
    # if "template" is missing, we don't create the block
    for_each = try(each.value.template, null) == null ? [] : [each.value.template]

    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = try(template.value.include_all_branches, false)
    }
  }

  lifecycle {
    ignore_changes = [template]
  }
}
