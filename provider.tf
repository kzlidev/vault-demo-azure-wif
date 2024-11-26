# Specify the Terraform version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}
}