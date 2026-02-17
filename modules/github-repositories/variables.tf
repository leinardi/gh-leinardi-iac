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
