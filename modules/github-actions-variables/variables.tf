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

variable "variables" {
  description = <<EOT
Map of repository-level GitHub Actions variable name -> value.

Names are normalized to uppercase (GitHub does this server-side anyway).
Values are plain strings; multiline values are supported via HCL heredoc:

    variables = {
      SINGLE_LINE = "value"
      MULTI_LINE  = <<-EOV
        line one
        line two
      EOV
    }

Never put secrets here: this configuration is committed to a public repository.
EOT
  type        = map(string)
}
