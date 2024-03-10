# tf-azurerm-module_primitive-storage_account (Azure Storage Account)

## Overview

This terraform module will install storage account in the Azure portal. User can also create containers and file shares by passing in appropriate input variables.

## Pre-Commit hooks
[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly
- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below
```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.
- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```
- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitgnore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target
- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.95.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.storage_containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_queue.storage_queues](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) | resource |
| [azurerm_storage_share.storage_shares](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | target resource group resource mask | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name | `string` | `"storageaccount"` | no |
| <a name="input_location"></a> [location](#input\_location) | target resource group resource mask | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | value of the account\_tier | `string` | `"Standard"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | value of the account\_replication\_type | `string` | `"LRS"` | no |
| <a name="input_storage_containers"></a> [storage\_containers](#input\_storage\_containers) | map of storage container configs, keyed polymorphically | <pre>map(object({<br>    name                  = string<br>    container_access_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_storage_shares"></a> [storage\_shares](#input\_storage\_shares) | map of storage file shares configs, keyed polymorphically | <pre>map(object({<br>    name  = string<br>    quota = number<br>  }))</pre> | `{}` | no |
| <a name="input_storage_queues"></a> [storage\_queues](#input\_storage\_queues) | map of storage queue configs, keyed polymorphically | <pre>map(object({<br>    name = string<br>  }))</pre> | `{}` | no |
| <a name="input_static_website"></a> [static\_website](#input\_static\_website) | The static website details if the storage account needs to be used as a static website | <pre>object({<br>    index_document     = string<br>    error_404_document = string<br>  })</pre> | `null` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Boolean flag that forces HTTPS traffic only | `bool` | `true` | no |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Choose between Hot or Cool | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the kind of account | `string` | `"StorageV2"` | no |
| <a name="input_blob_cors_rule"></a> [blob\_cors\_rule](#input\_blob\_cors\_rule) | Blob cors rules | <pre>map(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | `null` | no |
| <a name="input_blob_delete_retention_policy"></a> [blob\_delete\_retention\_policy](#input\_blob\_delete\_retention\_policy) | Number of days the blob should be retained. Set 0 to disable | `number` | `0` | no |
| <a name="input_blob_versioning_enabled"></a> [blob\_versioning\_enabled](#input\_blob\_versioning\_enabled) | Is blob versioning enabled for blob | `bool` | `false` | no |
| <a name="input_blob_change_feed_enabled"></a> [blob\_change\_feed\_enabled](#input\_blob\_change\_feed\_enabled) | Is the blobl service properties for change feed enabled for blob | `bool` | `false` | no |
| <a name="input_blob_last_access_time_enabled"></a> [blob\_last\_access\_time\_enabled](#input\_blob\_last\_access\_time\_enabled) | Is the last access time based tracking enabled | `bool` | `false` | no |
| <a name="input_blob_container_delete_retention_policy"></a> [blob\_container\_delete\_retention\_policy](#input\_blob\_container\_delete\_retention\_policy) | Specify the number of days that the container should be retained. Set 0 to disable | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_account"></a> [storage\_account](#output\_storage\_account) | storage account resource |
| <a name="output_storage_containers"></a> [storage\_containers](#output\_storage\_containers) | storage container resource map |
| <a name="output_storage_queues"></a> [storage\_queues](#output\_storage\_queues) | storage queues resource map |
| <a name="output_storage_shares"></a> [storage\_shares](#output\_storage\_shares) | storage share resource map |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
