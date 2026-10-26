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

variable "repository" {
  description = "GitHub repository name (without owner), e.g. \"gh-leinardi-iac\""
  type        = string
}

variable "environments" {
  description = <<EOT
Map of deployment environment name -> settings. Every setting is optional:

- deployment_branches / deployment_tags: the only branch and tag name
  patterns (fnmatch, e.g. "main", "release/*", "v*") that may deploy to the
  environment. A workflow job running from any other ref is refused before it
  starts, and never sees the environment's secrets.
- protected_branches: allow only branches with branch protection instead of
  patterns; cannot be combined with them.
- With none of the three, any branch or tag may deploy (GitHub's default).
- reviewer_users / reviewer_teams: numeric user and team IDs, up to six in
  total, one of whom must approve each deployment; prevent_self_review stops
  the person who triggered it from approving it. None: no approval.
- wait_timer: minutes (0-43200) to wait before a deployment starts.
- can_admins_bypass: whether repository admins may bypass these rules.
  Defaults to false, unlike GitHub, so a rule holds for everyone.

Example, a release job that runs unattended but only from main:

    environments = {
      release = { deployment_branches = ["main"] }
    }
EOT
  type = map(object({
    deployment_branches = optional(list(string), [])
    deployment_tags     = optional(list(string), [])
    protected_branches  = optional(bool, false)
    reviewer_users      = optional(list(number), [])
    reviewer_teams      = optional(list(number), [])
    prevent_self_review = optional(bool, false)
    wait_timer          = optional(number, 0)
    can_admins_bypass   = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for environment in values(var.environments) :
      !(environment.protected_branches && length(environment.deployment_branches) + length(environment.deployment_tags) > 0)
    ])
    error_message = "An environment allows either protected_branches or deployment_branches/deployment_tags patterns, not both."
  }

  validation {
    condition = alltrue([
      for environment in values(var.environments) :
      environment.wait_timer >= 0 && environment.wait_timer <= 43200 && floor(environment.wait_timer) == environment.wait_timer
    ])
    error_message = "wait_timer is a whole number of minutes from 0 to 43200."
  }

  validation {
    condition = alltrue([
      for environment in values(var.environments) :
      length(environment.reviewer_users) + length(environment.reviewer_teams) <= 6
    ])
    error_message = "An environment takes at most six reviewers (users and teams together)."
  }
}
