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
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    doppler = {
      source  = "dopplerhq/doppler"
      version = "~> 1.13.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.53.0"
    }
  }
}

provider "doppler" {}

data "doppler_secrets" "infra" {
  project = var.doppler_project
  config  = var.doppler_config
}

provider "github" {
  owner = var.github_owner

  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = data.doppler_secrets.infra.map.GITHUB_APP_PEM_FILE
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.azure_subscription_id
  resource_provider_registrations = "none"
}

provider "datadog" {
  api_key = data.doppler_secrets.infra.map.DATADOG_API_KEY
  app_key = data.doppler_secrets.infra.map.DATADOG_APP_KEY
  api_url = var.datadog_api_url
}
