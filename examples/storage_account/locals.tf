locals {
  storage_account_name = module.resource_names["storage_account"].recommended_per_length_restriction
  resource_group_name  = module.resource_names["resource_group"].standard
}
