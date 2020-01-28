provider "azurerm" {
  version = "~> 1.30.0"
}

provider "azuread" {
  version = "~> 0.3.0"
}

provider "random" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 2.1"
}

terraform {
  required_version = ">= 0.12"
}