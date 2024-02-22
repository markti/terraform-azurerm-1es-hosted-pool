data "azurerm_subscription" "current" {}

resource "azurerm_user_assigned_identity" "hostedpool" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "identity-${var.name}"
}

resource "azurerm_resource_provider_registration" "cloud_test" {
  name = "Microsoft.CloudTest"
}