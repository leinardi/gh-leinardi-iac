locals {
  # 1) Global default labels for all repos managed by this stack
  default_labels = {
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

  # 2) Optional per-repo label overrides / additions
  #    (keys = repo name; usually empty to get pure defaults)
  repo_label_overrides = {
    # Example to customize only this repo later:
    # "gtk-kn" = {
    #   "language: kotlin" = {
    #     description = "Kotlin-specific issues"
    #     color       = "#A97BFF"
    #   }
    # }
  }

  # 3) Effective labels for each repo: defaults + repo-specific overrides
  #    local.resolved_repos already exists from your repo module
  repo_labels = {
    for repo_name, _ in local.resolved_repos :
    repo_name => merge(
      local.default_labels,
      lookup(local.repo_label_overrides, repo_name, {})
    )
  }
}
