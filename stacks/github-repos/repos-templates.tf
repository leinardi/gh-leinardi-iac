# MIT License
#
# Copyright (c) 2025 Roberto Leinardi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

########################################
# Template repositories
########################################

resource "github_repository" "default_template" {
  name        = "template-default"
  description = "Default @${var.github_owner} repository template"
  topics      = ["gh-leinardi-iac"]

  # Inherit shared defaults
  allow_auto_merge       = try(local.repo_defaults.allow_auto_merge, true)
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

# Private vulnerability reporting, as modules/github-repo-stack sets it for every public repository
# (see the comment there: the provider has no resource for it yet,
# integrations/terraform-provider-github#2399 and #2969; replace this once that lands). The
# template's SECURITY.md points to it, like every repository created from it.
resource "terraform_data" "default_template_private_vulnerability_reporting" {
  triggers_replace = {
    repository = github_repository.default_template.name
    enabled    = true
  }

  provisioner "local-exec" {
    command = "for try in 1 2 3; do gh api --method PUT \"repos/$FULL_NAME/private-vulnerability-reporting\" --silent && exit 0; sleep 5; done; exit 1"
    environment = {
      FULL_NAME = github_repository.default_template.full_name
    }
  }
}
