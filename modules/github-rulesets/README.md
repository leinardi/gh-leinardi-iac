# github-rulesets

<!-- markdownlint-disable MD034 MD060 -->
<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_ruleset.default_branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_ruleset.immutable_tags](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_branch_required_checks"></a> [default\_branch\_required\_checks](#input\_default\_branch\_required\_checks) | n/a | `list(string)` | `[]` | no |
| <a name="input_default_branch_ruleset_enabled"></a> [default\_branch\_ruleset\_enabled](#input\_default\_branch\_ruleset\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | If false, no rulesets are created. | `bool` | `true` | no |
| <a name="input_immutable_tags_ruleset_enabled"></a> [immutable\_tags\_ruleset\_enabled](#input\_immutable\_tags\_ruleset\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
