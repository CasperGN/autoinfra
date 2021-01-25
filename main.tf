# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup"
  location = var.location
}

resource "azurerm_marketplace_agreement" "cloud-infrastructure-services" {
  publisher = var.dc_settings["publisher"]
  offer     = var.dc_settings["offer"]
  plan      = "hourly"
}
