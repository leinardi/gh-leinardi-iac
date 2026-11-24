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

# One-off import: herdquay's release environment already had a "main" branch policy (id 64197354),
# created by hand before the environment was managed here. Creating a policy whose name exists
# returns no id, so the apply recorded "herdquay:release:0", every refresh got a 404 for it and
# dropped it, and every plan proposed the create again. An import is skipped while its address is
# in the state, so the broken entry is removed first (tofu state rm, by hand).
#
# Delete this block once the import has been applied.

import {
  to = module.repo_herdquay.module.environments.github_repository_environment_deployment_policy.this["release/branch/main"]
  id = "herdquay:release:64197354"
}


# One-off imports: the github-pages environments of gx52 and repo-docs-toolkit and their "main"
# branch policies (ids 67771746 and 67771742) were created by GitHub when Pages was enabled, before
# the environments were managed here. Creating a policy whose name exists breaks the state (see
# herdquay above), so all four are imported.
#
# Delete these blocks once the import has been applied.

import {
  to = module.repo_gx52.module.environments.github_repository_environment.this["github-pages"]
  id = "gx52:github-pages"
}

import {
  to = module.repo_gx52.module.environments.github_repository_environment_deployment_policy.this["github-pages/branch/main"]
  id = "gx52:github-pages:67771746"
}

import {
  to = module.repo_repo_docs_toolkit.module.environments.github_repository_environment.this["github-pages"]
  id = "repo-docs-toolkit:github-pages"
}

import {
  to = module.repo_repo_docs_toolkit.module.environments.github_repository_environment_deployment_policy.this["github-pages/branch/main"]
  id = "repo-docs-toolkit:github-pages:67771742"
}
