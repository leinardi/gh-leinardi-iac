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

# One-off refactor: opencode-review-loop was renamed to adversarial-review-loop.
#
# Both blocks are required. The first re-addresses the module call. The second follows the
# for_each key: modules/github-repo-stack keys local.repo_map by var.repo_name, so changing
# the name alone would plan a destroy-and-create of github_repository — i.e. delete the
# repository — rather than the in-place rename the provider is capable of.
#
# Delete this file once the rename has been applied.

moved {
  from = module.repo_opencode_review_loop
  to   = module.repo_adversarial_review_loop
}

moved {
  from = module.repo_adversarial_review_loop.module.repo.github_repository.this["opencode-review-loop"]
  to   = module.repo_adversarial_review_loop.module.repo.github_repository.this["adversarial-review-loop"]
}
