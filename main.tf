resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type
  tags                     = var.storage_account.tags
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
  quota                 = each.value.quota
}