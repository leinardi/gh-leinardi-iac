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

  # Template-specific flags
  is_template = true

}
