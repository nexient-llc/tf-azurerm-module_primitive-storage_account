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

variable "resource_group_name" {
  description = "name of the resource group to create the resource"
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Resource Group and storage Account should exist. Changing this forces a new Resource Group and storage Account to be created."
  type        = string
}


variable "name" {
  description = "(Required) The Name which should be used for this storage account. Changing this forces a new storage account to be created."
  type        = string
}


variable "account_replication_type" {
  description = "Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (Standard or Premium)."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Storage Account."
  type        = map(string)
  default     = {}
}

variable "storage_containers" {
  description = "map of storage container configs, keyed polymorphically"
  type = map(object({
    name                  = string
    container_access_type = string
  }))
  default = {}
}

variable "storage_shares" {
  description = "map of storage file shares configs, keyed polymorphically"
  type = map(object({
    name  = string
    quota = number
  }))
  default = {}
}

variable "storage_queues" {
  description = "map of storage queue configs, keyed polymorphically"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "static_website" {
  description = "The static website details if the storage account needs to be used as a static website"
  type = object({
    index_document     = string
    error_404_document = string
  })
  default = null
}

variable "enable_https_traffic_only" {
  description = "Boolean flag that forces HTTPS traffic only"
  type        = bool
  default     = true
}

variable "access_tier" {
  description = "Choose between Hot or Cool"
  type        = string
  default     = "Hot"

  validation {
    condition     = (contains(["hot", "cool"], lower(var.access_tier)))
    error_message = "The account_tier must be either \"Hot\" or \"Cool\"."
  }

}

variable "account_kind" {
  description = "Defines the kind of account"
  type        = string
  default     = "StorageV2"
}

############## Blob related properties ##############

variable "blob_cors_rule" {
  description = "Blob cors rules"
  type = map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))

  default = null
}

variable "blob_delete_retention_policy" {
  description = "Number of days the blob should be retained. Set 0 to disable"
  type        = number
  default     = 0
}

variable "blob_versioning_enabled" {
  description = "Is blob versioning enabled for blob"
  type        = bool
  default     = false
}

variable "blob_change_feed_enabled" {
  description = "Is the blobl service properties for change feed enabled for blob"
  type        = bool
  default     = false
}

variable "blob_last_access_time_enabled" {
  description = "Is the last access time based tracking enabled"
  type        = bool
  default     = false
}

variable "blob_container_delete_retention_policy" {
  description = "Specify the number of days that the container should be retained. Set 0 to disable"
  type        = number
  default     = 0
}
