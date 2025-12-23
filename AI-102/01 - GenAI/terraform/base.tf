terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "cbc6173c-1b1b-401c-816d-31793b437dab"
}

# see https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/create-hub-terraform?tabs=azure-cli

resource "random_string" "uid" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "ai102-rg"
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                = "ai102sa${random_string.uid.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_user_assigned_identity" "umi" {
  name                = "ai102-mi"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_ai_services" "svc" {
  name                = "ai102-proj"                   # AI Services resource name
  location            = var.location                   # Location from the resource group
  resource_group_name = azurerm_resource_group.rg.name # Resource group name
  sku_name            = "S0"                           # Pricing SKU tier

  storage {
    storage_account_id = azurerm_storage_account.storage.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.umi.id
    ]
  }
}
