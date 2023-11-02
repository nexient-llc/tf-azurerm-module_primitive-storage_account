locals {
  static_website = var.static_website != null ? toset([var.static_website]) : toset([])
  default_tags = {
    provisioner = "Terraform"
  }

  tags = merge(local.default_tags, var.tags)
}
