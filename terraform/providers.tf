terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "quiz-nova-resource-group"
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
