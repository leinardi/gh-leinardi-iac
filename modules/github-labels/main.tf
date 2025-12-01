locals {
  # Normalize labels to a list with consistent fields
  normalized_labels = [
    for name, cfg in var.labels : {
      name        = name
      color       = replace(cfg.color, "#", "") # strip any leading '#'
      description = try(cfg.description, null)
    }
  ]

  # Map keyed by name for the non-authoritative mode
  normalized_labels_by_name = {
    for l in local.normalized_labels : l.name => l
  }
}

# Authoritative mode: use github_issue_labels
resource "github_issue_labels" "authoritative" {
  count = var.authoritative ? 1 : 0

  repository = var.repository

  dynamic "label" {
    for_each = local.normalized_labels
    content {
      name        = label.value.name
      color       = label.value.color
      description = label.value.description
    }
  }
}

# Non-authoritative mode: additive/update-only, one resource per label
resource "github_issue_label" "non_authoritative" {
  for_each = var.authoritative ? {} : local.normalized_labels_by_name

  repository  = var.repository
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}
