locals {
  static_website = var.static_website != null ? toset([var.static_website]) : toset([])
}