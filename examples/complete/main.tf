resource "random_integer" "priority" {
  min = 10000
  max = 50000
}


module "resource_group" {
  source = "git::https://github.com/nexient-llc/tf-azurerm-module-resource_group.git?ref=0.2.0"

  name       = local.resource_group_name
  location   = var.location
  tags       = local.tags
  managed_by = var.managed_by
}

module "storage_account" {
  depends_on               = [module.resource_group]
  source                   = "../../"
  name                     = local.name
  resource_group_name      = module.resource_group.name
  location                 = var.location
  tags                     = local.tags
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type
  account_tier             = var.account_tier
  access_tier              = var.access_tier
}
