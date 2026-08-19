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
| <a name="module_repo_gha_pre_commit_reviewdog_actions"></a> [repo\_gha\_pre\_commit\_reviewdog\_actions](#module\_repo\_gha\_pre\_commit\_reviewdog\_actions) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_gotilert"></a> [repo\_gotilert](#module\_repo\_gotilert) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_homelab"></a> [repo\_homelab](#module\_repo\_homelab) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_jdinstaller_macos"></a> [repo\_jdinstaller\_macos](#module\_repo\_jdinstaller\_macos) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_kotlin_awtrix_light"></a> [repo\_kotlin\_awtrix\_light](#module\_repo\_kotlin\_awtrix\_light) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_make_common"></a> [repo\_make\_common](#module\_repo\_make\_common) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_opencode_review_loop"></a> [repo\_opencode\_review\_loop](#module\_repo\_opencode\_review\_loop) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_opencode_swap"></a> [repo\_opencode\_swap](#module\_repo\_opencode\_swap) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_runhold"></a> [repo\_runhold](#module\_repo\_runhold) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_snapmaker_u1"></a> [repo\_snapmaker\_u1](#module\_repo\_snapmaker\_u1) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_swarm_device_access"></a> [repo\_swarm\_device\_access](#module\_repo\_swarm\_device\_access) | ../../modules/github-repo-stack | n/a |
| <a name="module_repo_swarm_scheduler_exporter"></a> [repo\_swarm\_scheduler\_exporter](#module\_repo\_swarm\_scheduler\_exporter) | ../../modules/github-repo-stack | n/a |
| <a name="module_template_default_labels_wipe"></a> [template\_default\_labels\_wipe](#module\_template\_default\_labels\_wipe) | ../../modules/github-labels | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [github_repository.default_template](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_rulesets_on_private"></a> [enable\_rulesets\_on\_private](#input\_enable\_rulesets\_on\_private) | If false, rulesets only apply to public repos. | `bool` | `false` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub owner (user or org) this stack manages | `string` | `"leinardi"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
