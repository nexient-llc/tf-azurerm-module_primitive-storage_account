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
  default  = {}
}

variable "storage_shares" {
  description = "map of storage file shares configs, keyed polymorphically"
  type = map(object({
    name                    = string
    quota                   = number
  }))
  default  = {}
}