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
  # Template objects used at creation-time
  default_template = {
    owner                = var.github_owner
    repository           = github_repository.default_template.name
    include_all_branches = false
  }

}

module "repo_awtrix_controller" {
  source = "../../modules/github-repo-stack"

  repo_name = "awtrix-controller"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_ddwrt_r7000" {
  source = "../../modules/github-repo-stack"

  repo_name  = "ddwrt-r7000"
  visibility = "private"
  template   = local.default_template

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_runhold" {
  source = "../../modules/github-repo-stack"

  repo_name  = "runhold"
  visibility = "private"
  template   = local.default_template

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_dotfiles" {
  source = "../../modules/github-repo-stack"

  repo_name  = "dotfiles"
  visibility = "private"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_gh_leinardi_iac" {
  source = "../../modules/github-repo-stack"

  repo_name   = "gh-leinardi-iac"
  description = "OpenTofu-managed GitHub repositories, templates, and rulesets for the leinardi account"
  topics      = ["opentofu", "automation"]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_gh_reusable_workflows" {
  source = "../../modules/github-repo-stack"

  repo_name   = "gh-reusable-workflows"
  description = "Reusable GitHub Actions workflows for my projects."
  topics      = ["github-actions", "reusable-workflows", "ci"]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_gha_pre_commit_reviewdog_actions" {
  source = "../../modules/github-repo-stack"

  repo_name   = "gha-pre-commit-reviewdog-actions"
  description = "Monorepo for GitHub Actions that run pre-commit hooks and comment results on PRs using reviewdog."
  topics = [
    "github-actions",
    "pre-commit",
    "reviewdog",
    "actionlint",
    "ansible-lint",
    "hooks",
    "markdownlint-cli2",
    "mypy",
    "prettier",
    "rain-format",
    "ruff",
    "shellcheck",
    "sqlfluff",
    "tofu-docs",
    "tofu-fmt",
    "tofu-tflint",
    "tofu-trivy",
    "yamllint",
  ]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_gotilert" {
  source = "../../modules/github-repo-stack"

  repo_name   = "gotilert"
  description = "A small Gotify-compatible HTTP shim that forwards messages to Alertmanager."
  topics      = ["alertmanager", "gotify", "monitoring"]
  template    = local.default_template

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_homelab" {
  source = "../../modules/github-repo-stack"

  repo_name  = "homelab"
  visibility = "private"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_jdinstaller_macos" {
  source = "../../modules/github-repo-stack"

  repo_name   = "JDInstaller-macOS"
  description = "An Ansible playbook to automate the setup of macOS personalizations."
  topics      = ["ansible", "macos", "automation"]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_kotlin_awtrix_light" {
  source = "../../modules/github-repo-stack"

  repo_name = "kotlin-awtrix-light"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_make_common" {
  source = "../../modules/github-repo-stack"

  repo_name   = "make-common"
  description = "Shared Makefile snippets and reusable tasks."
  topics      = ["makefile", "automation", "tooling"]
  template    = local.default_template

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_opencode_review_loop" {
  source = "../../modules/github-repo-stack"

  repo_name  = "opencode-review-loop"
  visibility = "private"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_opencode_swap" {
  source = "../../modules/github-repo-stack"

  repo_name  = "opencode-swap"
  topics     = ["opencode", "openai"]
  visibility = "private"

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_snapmaker_u1" {
  source = "../../modules/github-repo-stack"

  repo_name  = "snapmaker-u1"
  topics     = ["snapmaker", "u1", "3d-printing"]
  visibility = "private"
  template   = local.default_template

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_swarm_device_access" {
  source = "../../modules/github-repo-stack"

  repo_name   = "swarm-device-access"
  description = "Linux daemon that enables GPU, USB, and other /dev device passthrough for Docker Swarm services by injecting cgroup device-allow rules for bind-mounted devices."
  topics      = ["docker-swarm", "device-passthrough", "cgroups", "ebpf"]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}

module "repo_swarm_scheduler_exporter" {
  source = "../../modules/github-repo-stack"

  repo_name   = "swarm-scheduler-exporter"
  description = "Prometheus exporter for Docker Swarm focused on task state visibility, accurate desired replicas, and operability at scale."
  topics      = ["prometheus", "docker-swarm", "exporter", "monitoring"]

  enable_rulesets_on_private = var.enable_rulesets_on_private
}
