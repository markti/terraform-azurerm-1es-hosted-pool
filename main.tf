resource "azurerm_resource_provider_registration" "cloud_test" {
  name = "Microsoft.CloudTest"
}

resource "azapi_resource" "image" {
  type                      = "Microsoft.CloudTest/images@2020-05-07"
  name                      = "image-${var.name}"
  parent_id                 = var.resource_group_id
  location                  = var.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      imageType  = "SharedImageGallery"
      resourceId = var.vm_image_id
    }
  })
}

# We must use the AzAPI provider because this resource is not yet supported by the azurerm provider
resource "azapi_resource" "hosted_pool" {
  type                      = "Microsoft.CloudTest/hostedpools@2020-05-07"
  name                      = "pool-${var.name}"
  parent_id                 = var.resource_group_id
  location                  = var.location
  schema_validation_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  body = jsonencode({
    properties = {
      organization = "https://dev.azure.com/${var.azdo_organization}"
      sku = {
        name = var.vm_size
        tier = "Standard"
      }
      images = [
        {
          imageName            = "image-${var.name}"
          poolBufferPercentage = "100"
        }
      ]
      vmProviderProperties = {
        VssAdminPermissions = "CreatorOnly"
      }
      maxPoolSize = var.pool_size
      agentProfile = {
        type = "Stateless"
        resourcePredictions = [
          # sunday
          {
            "00:00:00" : 0
          },
          # monday
          {
            # 2 instances at 7AM EST (12PM GMT)
            "12:00:00" : 2
          },
          # tuesday
          {
            # 0 instances at 9PM EST (1AM GMT)
            "01:00:00" : 0,
            # 2 instances at 7AM EST (12PM GMT)
            "12:00:00" : 2
          },
          # wednesday
          {
            # 0 instances at 9PM EST (1AM GMT)
            "01:00:00" : 0,
            # 2 instances at 7AM EST (12PM GMT)
            "12:00:00" : 2
          },
          # thursday
          {
            # 0 instances at 9PM EST (1AM GMT)
            "01:00:00" : 0,
            # 2 instances at 7AM EST (12PM GMT)
            "12:00:00" : 2
          },
          # friday
          {
            # 0 instances at 9PM EST (1AM GMT)
            "01:00:00" : 0,
            # 2 instances at 7AM EST (12PM GMT)
            "12:00:00" : 2
          },
          # saturday
          {
            # 0 instances at 7:50PM EST (12:50AM GMT)
            "00:50:00" : 0
          }
        ]
      }
      networkProfile = {
        subnetId = azapi_resource.azdo.id
      }
    }
  })

  # REQUIREMENTS
  # ============
  # 1. the CloudTest resource provider must be registered
  # 2. the Virtual Machine Image to use for the Hosted Pool must exist
  depends_on = [
    azurerm_resource_provider_registration.cloud_test,
    azapi_resource.image
  ]
}