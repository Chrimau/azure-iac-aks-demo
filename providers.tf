terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "5ea4692a-e549-4c08-b65c-66d42bae99ef"
  tenant_id       = "352d74ed-5e7b-471d-8ceb-7f0cbc9fa4bd"
}
