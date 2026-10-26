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
  # One deployment policy per environment and pattern, keyed so that adding or
  # removing a pattern touches only that pattern's policy.
  deployment_policies = merge([
    for name, environment in var.environments : merge(
      {
        for pattern in environment.deployment_branches : "${name}/branch/${pattern}" => {
          environment    = name
          branch_pattern = pattern
          tag_pattern    = null
        }
      },
      {
        for pattern in environment.deployment_tags : "${name}/tag/${pattern}" => {
          environment    = name
          branch_pattern = null
          tag_pattern    = pattern
        }
      },
    )
  ]...)
}

resource "github_repository_environment" "this" {
  for_each = var.environments

  repository          = var.repository
  environment         = each.key
  wait_timer          = each.value.wait_timer
  can_admins_bypass   = each.value.can_admins_bypass
  prevent_self_review = each.value.prevent_self_review

  dynamic "reviewers" {
    for_each = length(each.value.reviewer_users) + length(each.value.reviewer_teams) > 0 ? [1] : []
    content {
      users = each.value.reviewer_users
      teams = each.value.reviewer_teams
    }
  }

  # No block at all: every branch and tag may deploy (GitHub's default).
  dynamic "deployment_branch_policy" {
    for_each = (
      each.value.protected_branches
      || length(each.value.deployment_branches) + length(each.value.deployment_tags) > 0
    ) ? [1] : []
    content {
      protected_branches     = each.value.protected_branches
      custom_branch_policies = !each.value.protected_branches
    }
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = local.deployment_policies

  repository     = var.repository
  environment    = github_repository_environment.this[each.value.environment].environment
  branch_pattern = each.value.branch_pattern
  tag_pattern    = each.value.tag_pattern
}
