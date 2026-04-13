# github-repos

<!-- markdownlint-disable MD034 MD060 -->
<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.6 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_github"></a> [github](#provider\_github) | 6.11.1 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_repo_awtrix_controller"></a> [repo\_awtrix\_controller](#module\_repo\_awtrix\_controller) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_ddwrt_r7000"></a> [repo\_ddwrt\_r7000](#module\_repo\_ddwrt\_r7000) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_dotfiles"></a> [repo\_dotfiles](#module\_repo\_dotfiles) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gh_leinardi_iac"></a> [repo\_gh\_leinardi\_iac](#module\_repo\_gh\_leinardi\_iac) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gh_reusable_workflows"></a> [repo\_gh\_reusable\_workflows](#module\_repo\_gh\_reusable\_workflows) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_actionlint_reviewdog"></a> [repo\_gha\_pre\_commit\_actionlint\_reviewdog](#module\_repo\_gha\_pre\_commit\_actionlint\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_ansible_lint_reviewdog"></a> [repo\_gha\_pre\_commit\_ansible\_lint\_reviewdog](#module\_repo\_gha\_pre\_commit\_ansible\_lint\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_hooks_reviewdog"></a> [repo\_gha\_pre\_commit\_hooks\_reviewdog](#module\_repo\_gha\_pre\_commit\_hooks\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_markdownlint_cli2_reviewdog"></a> [repo\_gha\_pre\_commit\_markdownlint\_cli2\_reviewdog](#module\_repo\_gha\_pre\_commit\_markdownlint\_cli2\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_mypy_reviewdog"></a> [repo\_gha\_pre\_commit\_mypy\_reviewdog](#module\_repo\_gha\_pre\_commit\_mypy\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_prettier_reviewdog"></a> [repo\_gha\_pre\_commit\_prettier\_reviewdog](#module\_repo\_gha\_pre\_commit\_prettier\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_rain_format_reviewdog"></a> [repo\_gha\_pre\_commit\_rain\_format\_reviewdog](#module\_repo\_gha\_pre\_commit\_rain\_format\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_ruff_reviewdog"></a> [repo\_gha\_pre\_commit\_ruff\_reviewdog](#module\_repo\_gha\_pre\_commit\_ruff\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_shellcheck_reviewdog"></a> [repo\_gha\_pre\_commit\_shellcheck\_reviewdog](#module\_repo\_gha\_pre\_commit\_shellcheck\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_sqlfluff_reviewdog"></a> [repo\_gha\_pre\_commit\_sqlfluff\_reviewdog](#module\_repo\_gha\_pre\_commit\_sqlfluff\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_tofu_docs_reviewdog"></a> [repo\_gha\_pre\_commit\_tofu\_docs\_reviewdog](#module\_repo\_gha\_pre\_commit\_tofu\_docs\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_tofu_fmt_reviewdog"></a> [repo\_gha\_pre\_commit\_tofu\_fmt\_reviewdog](#module\_repo\_gha\_pre\_commit\_tofu\_fmt\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_tofu_tflint_reviewdog"></a> [repo\_gha\_pre\_commit\_tofu\_tflint\_reviewdog](#module\_repo\_gha\_pre\_commit\_tofu\_tflint\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_tofu_trivy_reviewdog"></a> [repo\_gha\_pre\_commit\_tofu\_trivy\_reviewdog](#module\_repo\_gha\_pre\_commit\_tofu\_trivy\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gha_pre_commit_yamllint_reviewdog"></a> [repo\_gha\_pre\_commit\_yamllint\_reviewdog](#module\_repo\_gha\_pre\_commit\_yamllint\_reviewdog) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gotilert"></a> [repo\_gotilert](#module\_repo\_gotilert) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_homelab"></a> [repo\_homelab](#module\_repo\_homelab) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_jdinstaller_macos"></a> [repo\_jdinstaller\_macos](#module\_repo\_jdinstaller\_macos) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_kotlin_awtrix_light"></a> [repo\_kotlin\_awtrix\_light](#module\_repo\_kotlin\_awtrix\_light) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_make_common"></a> [repo\_make\_common](#module\_repo\_make\_common) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_snapmaker_u1"></a> [repo\_snapmaker\_u1](#module\_repo\_snapmaker\_u1) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_swarm_scheduler_exporter"></a> [repo\_swarm\_scheduler\_exporter](#module\_repo\_swarm\_scheduler\_exporter) | ../../modules/github-repo-stack | n/a |
| <a name="module_template_default_labels_wipe"></a> [template\_default\_labels\_wipe](#module\_template\_default\_labels\_wipe) | ../../modules/github-labels | n/a |
| <a name="module_template_pre_commit_reviewdog_labels_wipe"></a> [template\_pre\_commit\_reviewdog\_labels\_wipe](#module\_template\_pre\_commit\_reviewdog\_labels\_wipe) | ../../modules/github-labels | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [github_repository.default_template](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository.pre_commit_reviewdog_template](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_rulesets_on_private"></a> [enable\_rulesets\_on\_private](#input\_enable\_rulesets\_on\_private) | If false, rulesets only apply to public repos. | `bool` | `false` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub owner (user or org) this stack manages | `string` | `"leinardi"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
