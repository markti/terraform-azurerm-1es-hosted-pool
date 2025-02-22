# we must use the AzAPI provider for the subnet because the azurerm_subnet does not recognize the serviceName "Microsoft.CloudTest/hostedPools"
resource "azapi_resource" "azdo" {

  type      = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
  name      = "snet-azdo"
  parent_id = var.vnet_id

  body = {
    properties = {
      addressPrefixes                   = [var.address_space]
      privateEndpointNetworkPolicies    = "Disabled"
      privateLinkServiceNetworkPolicies = "Disabled"
      delegations = [
        {
          name = "CloudTestDelegation"
          properties = {
            serviceName = "Microsoft.CloudTest/hostedPools"
          }
        }
      ]
    }
  }
}
