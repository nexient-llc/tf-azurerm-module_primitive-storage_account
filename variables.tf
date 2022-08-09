variable "resource_group" {
  description = "target resource group resource mask"
  type = object({
    name     = string
    location = string
  })
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
  default     = "storageaccount"
}

variable "storage_account" {
  description = "storage account config"
  type = object({
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  })
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



