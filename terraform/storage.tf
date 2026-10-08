data "azurerm_storage_account" "state" {
  name                = "stquiznova"
  resource_group_name = "quiz-nova-resource-group"
}

resource "azurerm_storage_container" "infra_tfstate" {
  name                  = "quiznova-infra-tfstate"
  storage_account_id    = data.azurerm_storage_account.state.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
