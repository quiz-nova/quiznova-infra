data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "state" {
  name                = "stquiznova"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "current_user_blob" {
  scope                = data.azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_container" "infra_tfstate" {
  name                  = "quiznova-infra-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "api_dev_tfstate" {
  name                  = "quiznova-api-dev-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "api_stg_tfstate" {
  name                  = "quiznova-api-stg-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "web_dev_tfstate" {
  name                  = "quiznova-web-dev-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "web_stg_tfstate" {
  name                  = "quiznova-web-stg-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "api_prd_tfstate" {
  name                  = "quiznova-api-prd-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "web_prd_tfstate" {
  name                  = "quiznova-web-prd-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
