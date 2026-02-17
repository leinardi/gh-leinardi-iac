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
  # Normalize labels to a list with consistent fields
  normalized_labels = [
    for name, cfg in var.labels : {
      name        = name
      color       = replace(cfg.color, "#", "") # strip any leading '#'
      description = try(cfg.description, null)
    }
  ]

  # Map keyed by name for the non-authoritative mode
  normalized_labels_by_name = {
    for l in local.normalized_labels : l.name => l
  }
}

# Authoritative mode: use github_issue_labels
resource "github_issue_labels" "authoritative" {
  count = var.authoritative ? 1 : 0

  repository = var.repository

  dynamic "label" {
    for_each = local.normalized_labels
    content {
      name        = label.value.name
      color       = label.value.color
      description = label.value.description
    }
  }
}

# Non-authoritative mode: additive/update-only, one resource per label
resource "github_issue_label" "non_authoritative" {
  for_each = var.authoritative ? {} : local.normalized_labels_by_name

  repository  = var.repository
  name        = each.value.name
  color       = each.value.color
  description = each.value.description
}
