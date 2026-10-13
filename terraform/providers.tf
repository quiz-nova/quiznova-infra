terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "quiznova-rg"
    storage_account_name = "stquiznova"
    container_name       = "quiznova-infra-tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.53.0"
    }
  }
}

provider "azuread" {}

provider "github" {
  owner = var.github_owner

  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.github_app_pem_file
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.azure_subscription_id
  resource_provider_registrations = "none"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}
