# github-actions-variables

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
| [github_actions_variable.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_repository"></a> [repository](#input\_repository) | GitHub repository name (without owner), e.g. "gh-leinardi-iac" | `string` | n/a | yes |
| <a name="input_variables"></a> [variables](#input\_variables) | Map of repository-level GitHub Actions variable name -> value.<br/><br/>Names are normalized to uppercase (GitHub does this server-side anyway).<br/>Values are plain strings; multiline values are supported via HCL heredoc:<br/><br/>    variables = {<br/>      SINGLE\_LINE = "value"<br/>      MULTI\_LINE  = <<-EOV<br/>        line one<br/>        line two<br/>      EOV<br/>    }<br/><br/>Never put secrets here: this configuration is committed to a public repository. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 table-format -->
