output "resource_group_id" {
  value = azurerm_resource_group.main.id
}
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
output "location" {
  value = azurerm_resource_group.main.location
}
output "random_string" {
  value = random_string.suffix.result
}
output "identity_id" {
  value = azurerm_user_assigned_identity.main.id
}
output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}
output "virtual_network_address_space" {
  value = var.address_space
}
