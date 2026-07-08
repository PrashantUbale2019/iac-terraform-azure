# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  cloud {
    
    organization = "prashant-ubale-terraform-org"

    workspaces {
      name = "iac-terraform-azure"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "iac-terraform-rg" {
  name     = var.resource_group_name
  location = "westus2"
  tags = {
    environment = "dev - iac-terraform with azure"
    team        = "devops"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "iac-terraform-vnet" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.iac-terraform-rg.name
}

