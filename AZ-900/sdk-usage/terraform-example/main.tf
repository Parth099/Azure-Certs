# 
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
#

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }

}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf"
  location = "East US"
}


resource "azurerm_storage_account" "example" {
  name                     = "storageaccountfrom1tf000"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard" #default
  account_replication_type = "GRS"
  access_tier              = "Hot" #default

  tags = {
    environment = "learning-azure"
  }
}
