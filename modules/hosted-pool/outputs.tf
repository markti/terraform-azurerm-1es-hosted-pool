output "identity_pool" {
  value = azurerm_user_assigned_identity.hostedpool.id
}
output "identity_client_id" {
  value = azurerm_user_assigned_identity.hostedpool.client_id
}