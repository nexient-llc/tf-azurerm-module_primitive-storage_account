output "storage_account" {
  description = "storage account resource"
  value       = azurerm_storage_account.storage_account
  sensitive   = true
}

output "storage_containers" {
  description = "storage container resource map"
  value       = azurerm_storage_container.storage_containers
}