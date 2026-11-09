# MIT License
#
# Copyright (c) 2026 Roberto Leinardi
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

locals {
  managed_topic = "gh-leinardi-iac"

  effective_topics = distinct(concat(var.topics, [local.managed_topic]))

  repo_map = {
    (var.repo_name) = {
      name        = var.repo_name
      description = var.description
      topics      = local.effective_topics
      visibility  = var.visibility

      allow_auto_merge    = var.allow_auto_merge
      allow_merge_commit  = var.allow_merge_commit
      allow_rebase_merge  = var.allow_rebase_merge
      allow_squash_merge  = var.allow_squash_merge
      allow_update_branch = var.allow_update_branch

      archive_on_destroy     = var.archive_on_destroy
      auto_init              = var.auto_init
      delete_branch_on_merge = var.delete_branch_on_merge

      has_issues           = var.has_issues
      has_projects         = var.has_projects
      has_wiki             = var.has_wiki
      license_template     = var.license_template
      vulnerability_alerts = var.vulnerability_alerts

      template = var.template
    }
  }

  labels = merge(var.default_labels, var.label_overrides)

  supports_rulesets = (
    var.visibility == "public" || var.enable_rulesets_on_private
  )

  private_vulnerability_reporting = (
    var.private_vulnerability_reporting != null
    ? var.private_vulnerability_reporting
    : (var.visibility == "public" ? true : null)
  )
}

module "repo" {
  source = "../github-repositories"
  repos  = local.repo_map
}

# Right after creating a repository, GitHub seeds its default labels in the
# background and answers writes with "403 Repository has been locked" until it
# is done. The authoritative labels resource deletes those defaults, so a
# creation intermittently failed on it and passed on retry. The wait runs once,
# when this resource is created; later applies skip it.
resource "time_sleep" "after_repo_create" {
  create_duration = "5s"

  depends_on = [module.repo]
}

module "labels" {
  source        = "../github-labels"
  repository    = var.repo_name
  labels        = local.labels
  authoritative = var.labels_authoritative

  depends_on = [time_sleep.after_repo_create]
}

module "actions_variables" {
  source     = "../github-actions-variables"
  repository = var.repo_name
  variables  = var.actions_variables

  depends_on = [time_sleep.after_repo_create]
}

module "environments" {
  source       = "../github-environments"
  repository   = var.repo_name
  environments = var.environments

  depends_on = [time_sleep.after_repo_create]
}

module "rulesets" {
  source = "../github-rulesets"

  repository                     = var.repo_name
  enabled                        = local.supports_rulesets
  default_branch_ruleset_enabled = var.default_branch_ruleset_enabled
  immutable_tags_ruleset_enabled = var.immutable_tags_ruleset_enabled
  default_branch_required_checks = var.default_branch_required_checks
  bypass_actors                  = var.default_branch_bypass_actors

  depends_on = [time_sleep.after_repo_create]
}

resource "github_workflow_repository_permissions" "this" {
  count = var.actions_can_create_pull_requests == null ? 0 : 1

  repository                       = var.repo_name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = var.actions_can_create_pull_requests

  depends_on = [time_sleep.after_repo_create]
}

# Private vulnerability reporting, set through the REST API because the provider has no resource
# or argument for it yet: integrations/terraform-provider-github#2399 (the request) and #2969 (the
# pull request adding it). Once #2969 is released and #2399 closed, replace this with the
# provider's setting, and the one for template-default in stacks/github-repos/repos-templates.tf,
# and drop the full_names output of github-repositories if nothing else reads it.
#
# The call runs when the resource is created, and again whenever the repository or the wanted
# state changes (a replace): PUT turns reporting on, DELETE off. It does not detect a change made
# in the GitHub UI; `tofu apply -replace` on this resource re-applies the wanted state. gh
# authenticates as the provider does locally (gh auth login, or GITHUB_TOKEN).
resource "terraform_data" "private_vulnerability_reporting" {
  count = local.private_vulnerability_reporting == null ? 0 : 1

  triggers_replace = {
    repository = var.repo_name
    enabled    = local.private_vulnerability_reporting
  }

  provisioner "local-exec" {
    # Retried: with parallel calls GitHub now and then answers with an empty error body.
    command = "for try in 1 2 3; do gh api --method \"$METHOD\" \"repos/$FULL_NAME/private-vulnerability-reporting\" --silent && exit 0; sleep 5; done; exit 1"
    environment = {
      METHOD    = local.private_vulnerability_reporting ? "PUT" : "DELETE"
      FULL_NAME = module.repo.full_names[var.repo_name]
    }
  }

  depends_on = [time_sleep.after_repo_create]
}
