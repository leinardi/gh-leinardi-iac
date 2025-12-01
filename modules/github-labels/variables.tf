variable "repository" {
  description = "GitHub repository name (without owner), e.g. \"gh-leinardi-iac\""
  type        = string
}

variable "labels" {
  description = "Map of label name -> { color, description }"
  type = map(object({
    # 6-char hex; can be with or without leading '#'
    color       = string
    description = optional(string)
  }))
}

variable "authoritative" {
  description = <<EOT
Whether to manage labels in an authoritative way.

- true: authoritative sync using github_issue_labels, labels not defined here
        will be deleted from the repository.
- false: non-destructive, only creates/updates labels defined here,
                   leaves other labels on the repo untouched (github_issue_label).

EOT
  type        = bool
}
