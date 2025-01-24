provider "azurerm" {
  features {
  }
}
provider "azapi" {
}

run "arrange" {

  module {
    source = "./tests/setup"
  }

  variables {
    location      = "westus3"
    address_space = "10.0.0.0/24"
  }
}

run "act" {

  command = plan

  module {
    source = "./"
  }

  variables {
    name                = "${run.arrange.random_string}-core"
    azdo_organization   = "https://dev.azure.com/Tinderholt"
    resource_group_name = run.arrange.resource_group_name
    resource_group_id   = run.arrange.resource_group_id
    location            = run.arrange.location
    vnet_id             = run.arrange.virtual_network_id
    address_space       = run.arrange.virtual_network_address_space
    vm_size             = "Standard_D2s_v3"
    vm_image_id         = "Foo"
    pool_size           = 10
    identity_id         = run.arrange.identity_id
  }

}
