terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "25a58ceb-2570-42e2-9d35-00b46979c51a"
  features {}
}