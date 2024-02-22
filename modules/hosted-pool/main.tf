data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "hostedpool" {
  location = var.location
  name     = "rg-${var.name}"
}

resource "azurerm_user_assigned_identity" "hostedpool" {
  location            = var.location
  name                = "identity-${var.name}"
  resource_group_name = azurerm_resource_group.hostedpool.name
}

resource "azurerm_resource_provider_registration" "cloud_test" {
  name = "Microsoft.CloudTest"
}