variable "location" {
  description = "(Required) The Azure Region where the Resource Group and storage Account should exist. Changing this forces a new Resource Group and storage Account to be created."
  type        = string
  default     = "EastUS"
}


variable "account_replication_type" {
  description = "Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "LRS"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Storage Account."
  type        = map(string)
  default     = {}
}

variable "account_kind" {
  description = "Defines the kind of account"
  type        = string
  default     = "StorageV2"
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

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "platform"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 90
    }
    storage_account = {
      name       = "sa"
      max_length = 10
    }
  }
}

variable "managed_by" {
  description = "(Optional) The ID of the resource that manages this resource group."
  type        = string
  default     = null

}
