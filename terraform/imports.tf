import {
  to = azurerm_role_assignment.current_user_blob
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/providers/Microsoft.Authorization/roleAssignments/fc635fdc-31b6-4c42-92d0-719783d9948a"
}

import {
  to = azurerm_storage_container.infra_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-infra-tfstate"
}

import {
  to = azurerm_storage_container.api_dev_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-api-dev-tfstate"
}

import {
  to = azurerm_storage_container.api_stg_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-api-stg-tfstate"
}

import {
  to = azurerm_storage_container.api_prd_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-api-prd-tfstate"
}

import {
  to = azurerm_storage_container.web_dev_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-web-dev-tfstate"
}

import {
  to = azurerm_storage_container.web_stg_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-web-stg-tfstate"
}

import {
  to = azurerm_storage_container.web_prd_tfstate
  id = "/subscriptions/83ab56f5-88ee-436d-87a5-994d3185bf00/resourceGroups/quiznova-rg/providers/Microsoft.Storage/storageAccounts/stquiznova/blobServices/default/containers/quiznova-web-prd-tfstate"
}
