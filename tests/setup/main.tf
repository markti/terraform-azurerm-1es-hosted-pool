resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {

  name     = "rg-${random_string.suffix.result}"
  location = var.location

}


resource "azurerm_user_assigned_identity" "main" {

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "mi-${random_string.suffix.result}"

}

resource "azurerm_virtual_network" "main" {

  name                = "vnet-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.address_space]

}
