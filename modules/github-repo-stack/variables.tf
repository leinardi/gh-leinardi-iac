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


variable "repo_name" {
  type        = string
  description = "Repository name"
}

variable "description" {
  type    = string
  default = null
}

variable "topics" {
  type        = list(string)
  default     = []
  description = "Extra topics. 'gh-leinardi-iac' is always added."
}

variable "visibility" {
  type        = string
  default     = "public"
  description = "public or private"
}

# Optional template used only at creation time.
# If null, repo is created without template (or imported).
variable "template" {
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool)
  })
  default = null
}

variable "labels_authoritative" {
  type    = bool
  default = true
}

variable "default_labels" {
  type = map(object({
    color       = string
    description = optional(string)
  }))
  default = {
    # === Type labels ===
    "bug" = {
      description = "Unexpected problem / unintended behavior"
      color       = "#D73A4A"
    }
    "regression" = {
      description = "Something that used to work now breaks"
      color       = "#B60205"
    }
    "feature" = {
      description = "New user-visible capability"
      color       = "#2CBE4E"
    }
    "enhancement" = {
      description = "Improvement to existing behavior / UX"
      color       = "#0E8A16"
    }
    "documentation" = {
      description = "Docs updates, examples, comments"
      color       = "#0075CA"
    }
    "chore" = {
      description = "Internal maintenance (repo hygiene, misc scripts)"
      color       = "#E4E669"
    }
    "refactor" = {
      description = "Code restructuring without behavior change"
      color       = "#BFDADC"
    }
    "performance" = {
      description = "Perf/latency/memory improvements"
      color       = "#F9D0C4"
    }
    "security" = {
      description = "Security issue or fix (public, non-sensitive)"
      color       = "#86181D"
    }
    "dependencies" = {
      description = "Dependency bumps, lockfile changes, dependency fixes"
      color       = "#1D76DB"
    }
    "test" = {
      description = "Adding/fixing tests"
      color       = "#FBCA04"
    }
    "ci" = {
      description = "CI/CD, build, release pipelines"
      color       = "#E4E669"
    }
    "ux/ui" = {
      description = "Visual or interaction design changes"
      color       = "#C5A5FF"
    }

    # === Status / workflow ===
    "status: needs triage" = {
      description = "New, not yet looked at by a maintainer"
      color       = "#D4C5F9"
    }
    "status: needs info" = {
      description = "Awaiting reporter clarification / repro steps"
      color       = "#FFEA7F"
    }
    "status: accepted" = {
      description = "Agreed it’s valid and we intend to address it"
      color       = "#0E8A16"
    }
    "status: in progress" = {
      description = "Someone is actively working on it"
      color       = "#BFDADC"
    }
    "status: blocked" = {
      description = "Blocked by another issue/PR or external dependency"
      color       = "#E99695"
    }
    "status: ready for review" = {
      description = "PR is ready for maintainer review"
      color       = "#0075CA"
    }
    "status: needs changes" = {
      description = "Review left requested changes"
      color       = "#D93F0B"
    }
    "status: ready to merge" = {
      description = "Approved, CI green, waiting to be merged"
      color       = "#0E8A16"
    }
    "status: duplicate" = {
      description = "Duplicate of another issue"
      color       = "#E4E7EB"
    }
    "status: wontfix" = {
      description = "Valid but not something we’ll address"
      color       = "#E4E7EB"
    }
    "status: invalid" = {
      description = "Not a bug / not actionable / out of scope"
      color       = "#E4E7EB"
    }
    "status: on hold" = {
      description = "Paused indefinitely but not explicitly wontfix"
      color       = "#E4E7EB"
    }

    # === Priority ===
    "priority: critical" = {
      description = "Outage, data loss, or severe regression"
      color       = "#B60205"
    }
    "priority: high" = {
      description = "Needs to be addressed soon"
      color       = "#D73A4A"
    }
    "priority: medium" = {
      description = "Normal work"
      color       = "#FBCA04"
    }
    "priority: low" = {
      description = "Nice to have / low impact"
      color       = "#C2E0C6"
    }

    # === Contributor & docs ===
    "good first issue" = {
      description = "Small, well-scoped, with guidance for newcomers"
      color       = "#7057FF"
    }
    "help wanted" = {
      description = "Maintainers explicitly invite contributions"
      color       = "#008672"
    }
    "docs-needed" = {
      description = "Docs must be updated/added before this is done"
      color       = "#1D76DB"
    }
    "tests-needed" = {
      description = "Tests missing or insufficient"
      color       = "#FBCA04"
    }
    "breaking change" = {
      description = "Introduces a breaking change; needs major release / notes"
      color       = "#D93F0B"
    }
    "design-needed" = {
      description = "Needs UX or visual design input"
      color       = "#C5A5FF"
    }

    # === Meta / communication ===
    "question" = {
      description = "Support / “how do I do X?” / usage questions"
      color       = "#D876E3"
    }
    "discussion" = {
      description = "Open-ended design or architecture discussion"
      color       = "#E99695"
    }
    "needs decision" = {
      description = "Awaiting a maintainer / steering decision"
      color       = "#D876E3"
    }
    "roadmap" = {
      description = "Part of a planned roadmap or milestone theme"
      color       = "#0E8A16"
    }
  }
}

variable "label_overrides" {
  type = map(object({
    color       = string
    description = optional(string)
  }))
  default     = {}
  description = "Per-repo label overrides/additions"
}

# Repo defaults
variable "allow_auto_merge" {
  # Keep parity with your github-repositories module default:
  # if null, module decides based on visibility (public => true).
  type    = bool
  default = null
}

variable "allow_merge_commit" {
  type    = bool
  default = true
}

variable "allow_rebase_merge" {
  type    = bool
  default = false
}

variable "allow_squash_merge" {
  type    = bool
  default = false
}

variable "allow_update_branch" {
  type    = bool
  default = true
}

variable "archive_on_destroy" {
  type    = bool
  default = true
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = false
}

variable "has_wiki" {
  type    = bool
  default = false
}

variable "license_template" {
  type    = string
  default = "mit"
}

variable "vulnerability_alerts" {
  type    = bool
  default = true
}

# Rulesets knobs
variable "enable_rulesets_on_private" {
  type        = bool
  default     = false
  description = "If false, rulesets only for public repos (GitHub Free limitation)."
}

variable "default_branch_ruleset_enabled" {
  type    = bool
  default = true
}

variable "immutable_tags_ruleset_enabled" {
  type    = bool
  default = true
}

variable "default_branch_required_checks" {
  type    = list(string)
  default = []
}

variable "default_branch_bypass_actors" {
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = [
    {
      actor_id    = 5
      actor_type  = "RepositoryRole"
      bypass_mode = "pull_request"
    }
  ]
}
