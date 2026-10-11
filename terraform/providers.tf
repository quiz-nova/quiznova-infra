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

# The GitHub provider automatically detects:
# - GITHUB_OWNER
# - GITHUB_APP_ID
# - GITHUB_APP_INSTALLATION_ID
# - GITHUB_APP_PEM_FILE
# from environment variables injected by Doppler.
provider "github" {}

provider "azurerm" {
  features {}
  subscription_id                 = "83ab56f5-88ee-436d-87a5-994d3185bf00"
  resource_provider_registrations = "none"
}

provider "doppler" {}

data "doppler_secrets" "infra" {
  project = "quiznova-infra"
  config  = "prd"
}

provider "datadog" {
  api_key = data.doppler_secrets.infra.map.DATADOG_API_KEY
  app_key = data.doppler_secrets.infra.map.DATADOG_APP_KEY
  api_url = "https://api.us5.datadoghq.com/"
}
