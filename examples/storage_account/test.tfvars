resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  storage_account = {
    name       = "sa"
    max_length = 24
  }
}
instance_env              = 0
instance_resource         = 0
logical_product_family    = "launch"
logical_product_service   = "storage"
class_env                 = "gotest"
location                  = "eastus"
account_tier              = "Standard"
account_replication_type  = "LRS"
enable_https_traffic_only = true
