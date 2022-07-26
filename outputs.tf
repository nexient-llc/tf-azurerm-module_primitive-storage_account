output "storage_account" {
  description = "storage account resource"
  value       = azurerm_storage_account.storage_account
  sensitive   = true
}

output "storage_containers" {
  description = "storage container resource map"
  value       = azurerm_storage_container.storage_containers
}

output "storage_queues" {
  description = "storage queues resource map"
  value       = try(azurerm_storage_queue.storage_queues, null)
}

output "storage_shares" {
  description = "storage share resource map"
  value       = try(azurerm_storage_share.storage_shares, null)
}