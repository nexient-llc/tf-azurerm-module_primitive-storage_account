// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  access_tier               = var.access_tier
  account_kind              = var.account_kind

  dynamic "static_website" {
    for_each = local.static_website
    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  dynamic "blob_properties" {
    # Valid only for account_kind = BlockBlobStorage or StorageV2
    for_each = ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled       = var.blob_versioning_enabled
      change_feed_enabled      = var.blob_change_feed_enabled
      last_access_time_enabled = var.blob_last_access_time_enabled

      dynamic "container_delete_retention_policy" {
        for_each = (var.blob_container_delete_retention_policy == 0 ? [] : [1])
        content {
          days = var.blob_container_delete_retention_policy
        }
      }

      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_policy == 0 ? [] : [1])
        content {
          days = var.blob_delete_retention_policy
        }
      }

      dynamic "cors_rule" {
        for_each = (var.blob_cors_rule == null ? {} : var.blob_cors_rule)
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }


  tags = local.tags
}

resource "azurerm_storage_container" "storage_containers" {
  for_each             = var.storage_containers
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name

  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_share" "storage_shares" {
  for_each             = var.storage_shares
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = each.value.quota
}

resource "azurerm_storage_queue" "storage_queues" {
  for_each             = var.storage_queues
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.storage_account.name
}
