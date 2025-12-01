module "repositories" {
  source = "../../modules/github-repositories"

  repos = local.resolved_repos
}

module "repo_labels" {
  source = "../../modules/github-labels"

  for_each      = local.repo_labels
  repository    = each.key
  labels        = each.value
  authoritative = true
}
