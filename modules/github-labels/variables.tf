# MIT License
#
# Copyright (c) 2025 Roberto Leinardi
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
