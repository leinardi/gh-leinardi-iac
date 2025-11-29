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
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repos"></a> [repos](#input\_repos) | Map of repository configurations | <pre>map(object({<br/>    allow_auto_merge       = optional(bool)<br/>    allow_merge_commit     = optional(bool)<br/>    allow_rebase_merge     = optional(bool)<br/>    allow_squash_merge     = optional(bool)<br/>    allow_update_branch    = optional(bool)<br/>    archive_on_destroy     = optional(bool)<br/>    archived               = optional(bool)<br/>    auto_init              = optional(bool)<br/>    delete_branch_on_merge = optional(bool)<br/>    description            = optional(string)<br/>    has_issues             = optional(bool)<br/>    has_projects           = optional(bool)<br/>    has_wiki               = optional(bool)<br/>    homepage_url           = optional(string)<br/>    is_template            = optional(bool)<br/>    license_template       = optional(string)<br/>    name                   = string<br/>    topics                 = optional(list(string))<br/>    visibility             = string<br/>    vulnerability_alerts   = optional(bool)<br/><br/>    # Optional template repo used to create this repository.<br/>    # If omitted, the repo is created normally (no template).<br/>    template = optional(object({<br/>      owner                = string<br/>      repository           = string<br/>      include_all_branches = optional(bool)<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- markdownlint-enable MD034 MD060 -->
