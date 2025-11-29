variable "repos" {
  description = "Map of repository configurations"
  type = map(object({
    allow_auto_merge       = optional(bool)
    allow_merge_commit     = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_squash_merge     = optional(bool)
    allow_update_branch    = optional(bool)
    archive_on_destroy     = optional(bool)
    archived               = optional(bool)
    auto_init              = optional(bool)
    delete_branch_on_merge = optional(bool)
    description            = optional(string)
    has_issues             = optional(bool)
    has_projects           = optional(bool)
    has_wiki               = optional(bool)
    homepage_url           = optional(string)
    is_template            = optional(bool)
    license_template       = optional(string)
    name                   = string
    topics                 = optional(list(string))
    visibility             = string
    vulnerability_alerts   = optional(bool)

    # Optional template repo used to create this repository.
    # If omitted, the repo is created normally (no template).
    template = optional(object({
      owner                = string
      repository           = string
      include_all_branches = optional(bool)
    }))
  }))
}
