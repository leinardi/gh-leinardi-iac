# github-repo-stack

<!-- markdownlint-disable MD034 MD060 -->
<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | ../github-labels | n/a |
| <a name="module_repo"></a> [repo](#module\_repo) | ../github-repositories | n/a |
| <a name="module_rulesets"></a> [rulesets](#module\_rulesets) | ../github-rulesets | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Repo defaults | `bool` | `null` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | n/a | `bool` | `true` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | n/a | `bool` | `false` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | n/a | `bool` | `false` | no |
| <a name="input_allow_update_branch"></a> [allow\_update\_branch](#input\_allow\_update\_branch) | n/a | `bool` | `true` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | n/a | `bool` | `true` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | n/a | `bool` | `true` | no |
| <a name="input_default_branch_required_checks"></a> [default\_branch\_required\_checks](#input\_default\_branch\_required\_checks) | n/a | `list(string)` | `[]` | no |
| <a name="input_default_branch_ruleset_enabled"></a> [default\_branch\_ruleset\_enabled](#input\_default\_branch\_ruleset\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_default_labels"></a> [default\_labels](#input\_default\_labels) | n/a | <pre>map(object({<br/>    color       = string<br/>    description = optional(string)<br/>  }))</pre> | <pre>{<br/>  "breaking change": {<br/>    "color": "#D93F0B",<br/>    "description": "Introduces a breaking change; needs major release / notes"<br/>  },<br/>  "bug": {<br/>    "color": "#D73A4A",<br/>    "description": "Unexpected problem / unintended behavior"<br/>  },<br/>  "chore": {<br/>    "color": "#E4E669",<br/>    "description": "Internal maintenance (repo hygiene, misc scripts)"<br/>  },<br/>  "ci": {<br/>    "color": "#E4E669",<br/>    "description": "CI/CD, build, release pipelines"<br/>  },<br/>  "dependencies": {<br/>    "color": "#1D76DB",<br/>    "description": "Dependency bumps, lockfile changes, dependency fixes"<br/>  },<br/>  "design-needed": {<br/>    "color": "#C5A5FF",<br/>    "description": "Needs UX or visual design input"<br/>  },<br/>  "discussion": {<br/>    "color": "#E99695",<br/>    "description": "Open-ended design or architecture discussion"<br/>  },<br/>  "docs-needed": {<br/>    "color": "#1D76DB",<br/>    "description": "Docs must be updated/added before this is done"<br/>  },<br/>  "documentation": {<br/>    "color": "#0075CA",<br/>    "description": "Docs updates, examples, comments"<br/>  },<br/>  "enhancement": {<br/>    "color": "#0E8A16",<br/>    "description": "Improvement to existing behavior / UX"<br/>  },<br/>  "feature": {<br/>    "color": "#2CBE4E",<br/>    "description": "New user-visible capability"<br/>  },<br/>  "good first issue": {<br/>    "color": "#7057FF",<br/>    "description": "Small, well-scoped, with guidance for newcomers"<br/>  },<br/>  "help wanted": {<br/>    "color": "#008672",<br/>    "description": "Maintainers explicitly invite contributions"<br/>  },<br/>  "needs decision": {<br/>    "color": "#D876E3",<br/>    "description": "Awaiting a maintainer / steering decision"<br/>  },<br/>  "performance": {<br/>    "color": "#F9D0C4",<br/>    "description": "Perf/latency/memory improvements"<br/>  },<br/>  "priority: critical": {<br/>    "color": "#B60205",<br/>    "description": "Outage, data loss, or severe regression"<br/>  },<br/>  "priority: high": {<br/>    "color": "#D73A4A",<br/>    "description": "Needs to be addressed soon"<br/>  },<br/>  "priority: low": {<br/>    "color": "#C2E0C6",<br/>    "description": "Nice to have / low impact"<br/>  },<br/>  "priority: medium": {<br/>    "color": "#FBCA04",<br/>    "description": "Normal work"<br/>  },<br/>  "question": {<br/>    "color": "#D876E3",<br/>    "description": "Support / “how do I do X?” / usage questions"<br/>  },<br/>  "refactor": {<br/>    "color": "#BFDADC",<br/>    "description": "Code restructuring without behavior change"<br/>  },<br/>  "regression": {<br/>    "color": "#B60205",<br/>    "description": "Something that used to work now breaks"<br/>  },<br/>  "roadmap": {<br/>    "color": "#0E8A16",<br/>    "description": "Part of a planned roadmap or milestone theme"<br/>  },<br/>  "security": {<br/>    "color": "#86181D",<br/>    "description": "Security issue or fix (public, non-sensitive)"<br/>  },<br/>  "status: accepted": {<br/>    "color": "#0E8A16",<br/>    "description": "Agreed it’s valid and we intend to address it"<br/>  },<br/>  "status: blocked": {<br/>    "color": "#E99695",<br/>    "description": "Blocked by another issue/PR or external dependency"<br/>  },<br/>  "status: duplicate": {<br/>    "color": "#E4E7EB",<br/>    "description": "Duplicate of another issue"<br/>  },<br/>  "status: in progress": {<br/>    "color": "#BFDADC",<br/>    "description": "Someone is actively working on it"<br/>  },<br/>  "status: invalid": {<br/>    "color": "#E4E7EB",<br/>    "description": "Not a bug / not actionable / out of scope"<br/>  },<br/>  "status: needs changes": {<br/>    "color": "#D93F0B",<br/>    "description": "Review left requested changes"<br/>  },<br/>  "status: needs info": {<br/>    "color": "#FFEA7F",<br/>    "description": "Awaiting reporter clarification / repro steps"<br/>  },<br/>  "status: needs triage": {<br/>    "color": "#D4C5F9",<br/>    "description": "New, not yet looked at by a maintainer"<br/>  },<br/>  "status: on hold": {<br/>    "color": "#E4E7EB",<br/>    "description": "Paused indefinitely but not explicitly wontfix"<br/>  },<br/>  "status: ready for review": {<br/>    "color": "#0075CA",<br/>    "description": "PR is ready for maintainer review"<br/>  },<br/>  "status: ready to merge": {<br/>    "color": "#0E8A16",<br/>    "description": "Approved, CI green, waiting to be merged"<br/>  },<br/>  "status: wontfix": {<br/>    "color": "#E4E7EB",<br/>    "description": "Valid but not something we’ll address"<br/>  },<br/>  "test": {<br/>    "color": "#FBCA04",<br/>    "description": "Adding/fixing tests"<br/>  },<br/>  "tests-needed": {<br/>    "color": "#FBCA04",<br/>    "description": "Tests missing or insufficient"<br/>  },<br/>  "ux/ui": {<br/>    "color": "#C5A5FF",<br/>    "description": "Visual or interaction design changes"<br/>  }<br/>}</pre> | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | n/a | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_enable_rulesets_on_private"></a> [enable\_rulesets\_on\_private](#input\_enable\_rulesets\_on\_private) | If false, rulesets only for public repos (GitHub Free limitation). | `bool` | `false` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | n/a | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | n/a | `bool` | `false` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | n/a | `bool` | `false` | no |
| <a name="input_immutable_tags_ruleset_enabled"></a> [immutable\_tags\_ruleset\_enabled](#input\_immutable\_tags\_ruleset\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_label_overrides"></a> [label\_overrides](#input\_label\_overrides) | Per-repo label overrides/additions | <pre>map(object({<br/>    color       = string<br/>    description = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_labels_authoritative"></a> [labels\_authoritative](#input\_labels\_authoritative) | n/a | `bool` | `true` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | n/a | `string` | `"mit"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Repository name | `string` | n/a | yes |
| <a name="input_template"></a> [template](#input\_template) | Optional template used only at creation time. If null, repo is created without template (or imported). | <pre>object({<br/>    owner                = string<br/>    repository           = string<br/>    include_all_branches = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | Extra topics. 'gh-leinardi-iac' is always added. | `list(string)` | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | public or private | `string` | `"public"` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
