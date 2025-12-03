########################################
# Template repositories
########################################

resource "github_repository" "default_template" {
  name        = "template-default"
  description = "Default @${var.github_owner} repository template"
  topics      = ["gh-leinardi-iac"]

  # Inherit shared defaults
  allow_auto_merge       = local.repo_defaults.allow_auto_merge
  allow_merge_commit     = local.repo_defaults.allow_merge_commit
  allow_rebase_merge     = local.repo_defaults.allow_rebase_merge
  allow_squash_merge     = local.repo_defaults.allow_squash_merge
  allow_update_branch    = local.repo_defaults.allow_update_branch
  archive_on_destroy     = local.repo_defaults.archive_on_destroy
  auto_init              = local.repo_defaults.auto_init
  delete_branch_on_merge = local.repo_defaults.delete_branch_on_merge
  has_issues             = local.repo_defaults.has_issues
  has_projects           = local.repo_defaults.has_projects
  has_wiki               = local.repo_defaults.has_wiki
  license_template       = local.repo_defaults.license_template
  visibility             = local.repo_defaults.visibility
  vulnerability_alerts   = local.repo_defaults.vulnerability_alerts

  is_template = true
}

resource "github_repository" "pre_commit_reviewdog_template" {
  name        = "gha-pre-commit-reviewdog-template"
  description = "Template for GitHub Actions that run pre-commit hooks"
  topics      = ["gh-leinardi-iac", "reviewdog", "pre-commit", "github-actions"]

  # Same shared defaults
  allow_auto_merge       = local.repo_defaults.allow_auto_merge
  allow_merge_commit     = local.repo_defaults.allow_merge_commit
  allow_rebase_merge     = local.repo_defaults.allow_rebase_merge
  allow_squash_merge     = local.repo_defaults.allow_squash_merge
  allow_update_branch    = local.repo_defaults.allow_update_branch
  archive_on_destroy     = local.repo_defaults.archive_on_destroy
  auto_init              = local.repo_defaults.auto_init
  delete_branch_on_merge = local.repo_defaults.delete_branch_on_merge
  has_issues             = local.repo_defaults.has_issues
  has_projects           = local.repo_defaults.has_projects
  has_wiki               = local.repo_defaults.has_wiki
  license_template       = local.repo_defaults.license_template
  visibility             = local.repo_defaults.visibility
  vulnerability_alerts   = local.repo_defaults.vulnerability_alerts

  is_template = true
}

module "template_default_labels_wipe" {
  source = "../../modules/github-labels"

  repository    = github_repository.default_template.name
  labels        = {} # <- empty set = "no labels should exist"
  authoritative = true
}

module "template_pre_commit_reviewdog_labels_wipe" {
  source = "../../modules/github-labels"

  repository    = github_repository.pre_commit_reviewdog_template.name
  labels        = {} # <- empty set = "no labels should exist"
  authoritative = true
}
