# storage_account

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ../.. | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/nexient-llc/tf-azurerm-module_primitive-resource_group.git | 0.2.1 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/nexient-llc/tf-module-resource_name.git | 1.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-module-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  },<br>  "storage_account": {<br>    "max_length": 24,<br>    "name": "sa"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"network"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
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

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
