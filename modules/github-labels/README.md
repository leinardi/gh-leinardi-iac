# github-repositories

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
| <a name="provider_github"></a> [github](#provider\_github) | 6.8.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_issue_label.non_authoritative](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_issue_labels.authoritative](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authoritative"></a> [authoritative](#input\_authoritative) | Whether to manage labels in an authoritative way.<br/><br/>- true: authoritative sync using github\_issue\_labels, labels not defined here<br/>        will be deleted from the repository.<br/>- false: non-destructive, only creates/updates labels defined here,<br/>                   leaves other labels on the repo untouched (github\_issue\_label). | `bool` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of label name -> { color, description } | <pre>map(object({<br/>    # 6-char hex; can be with or without leading '#'<br/>    color       = string<br/>    description = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | GitHub repository name (without owner), e.g. "gh-leinardi-iac" | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
