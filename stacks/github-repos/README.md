# github-repos

<!-- markdownlint-disable MD034 MD060 -->
<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.8.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_repo_labels"></a> [repo\_labels](#module\_repo\_labels) | ../../modules/github-labels | n/a |
| <a name="module_repositories"></a> [repositories](#module\_repositories) | ../../modules/github-repositories | n/a |

## Resources

| Name | Type |
|------|------|
| [github_repository.default_template](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_ruleset.default_branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_ruleset.immutable_tags](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub owner (user or org) this stack manages | `string` | `"leinardi"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
