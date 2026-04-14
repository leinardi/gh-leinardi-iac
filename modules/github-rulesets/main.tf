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
  required_checks_enabled = length(var.default_branch_required_checks) > 0
}

resource "github_repository_ruleset" "default_branch_protection" {
  count = (var.enabled && var.default_branch_ruleset_enabled) ? 1 : 0

  name        = "Protect default branch"
  repository  = var.repository
  target      = "branch"
  enforcement = "active"

  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion                = true
    non_fast_forward        = true
    required_linear_history = false

    pull_request {
      required_approving_review_count = 1
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = true
      require_last_push_approval      = true
    }

    dynamic "required_status_checks" {
      for_each = local.required_checks_enabled ? [1] : []
      content {
        dynamic "required_check" {
          for_each = var.default_branch_required_checks
          content {
            context = required_check.value
          }
        }

        strict_required_status_checks_policy = true
        do_not_enforce_on_create             = true
      }
    }
  }
}

resource "github_repository_ruleset" "immutable_tags" {
  count = (var.enabled && var.immutable_tags_ruleset_enabled) ? 1 : 0

  name        = "Immutable tags"
  repository  = var.repository
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = [
        "refs/tags/v[0-9]",
        "refs/tags/v[1-9][0-9]",
        "refs/tags/latest",
      ]
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true
    update           = true
  }
}
