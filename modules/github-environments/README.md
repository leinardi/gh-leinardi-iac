# github-environments

Deployment environments of one repository, with their deployment branch and tag
policies, reviewers and wait timer.

<!-- markdownlint-disable MD034 MD060 table-format -->
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

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_environment_deployment_policy.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment_deployment_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_environments"></a> [environments](#input\_environments) | Map of deployment environment name -> settings. Every setting is optional:<br/><br/>- deployment\_branches / deployment\_tags: the only branch and tag name<br/>  patterns (fnmatch, e.g. "main", "release/*", "v*") that may deploy to the<br/>  environment. A workflow job running from any other ref is refused before it<br/>  starts, and never sees the environment's secrets.<br/>- protected\_branches: allow only branches with branch protection instead of<br/>  patterns; cannot be combined with them.<br/>- With none of the three, any branch or tag may deploy (GitHub's default).<br/>- reviewer\_users / reviewer\_teams: numeric user and team IDs, up to six in<br/>  total, one of whom must approve each deployment; prevent\_self\_review stops<br/>  the person who triggered it from approving it. None: no approval.<br/>- wait\_timer: minutes (0-43200) to wait before a deployment starts.<br/>- can\_admins\_bypass: whether repository admins may bypass these rules.<br/>  Defaults to false, unlike GitHub, so a rule holds for everyone.<br/><br/>Example, a release job that runs unattended but only from main:<br/><br/>    environments = {<br/>      release = { deployment\_branches = ["main"] }<br/>    } | <pre>map(object({<br/>    deployment_branches = optional(list(string), [])<br/>    deployment_tags     = optional(list(string), [])<br/>    protected_branches  = optional(bool, false)<br/>    reviewer_users      = optional(list(number), [])<br/>    reviewer_teams      = optional(list(number), [])<br/>    prevent_self_review = optional(bool, false)<br/>    wait_timer          = optional(number, 0)<br/>    can_admins_bypass   = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | GitHub repository name (without owner), e.g. "gh-leinardi-iac" | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 table-format -->
