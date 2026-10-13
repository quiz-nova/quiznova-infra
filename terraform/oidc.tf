# ==============================================================================
# Azure OIDC Authentication for quiznova-infra GitHub Actions
# ==============================================================================

resource "azuread_application" "infra" {
  display_name = "github-actions-quiznova-infra"
}

resource "azuread_service_principal" "infra" {
  client_id = azuread_application.infra.client_id
}

locals {
  github_oidc_issuer = "https://token.actions.githubusercontent.com"
  azuread_token_aud  = "api://AzureADTokenExchange"
  # GitHub Actions immutable subject format: repo:<OWNER>@<OWNER-ID>/<REPO>@<REPO-ID>
  infra_repo_subject = "repo:${var.github_owner}@${var.github_organization_id}/${github_repository.quiznova_infra.name}@${github_repository.quiznova_infra.repo_id}"
}

resource "azuread_application_federated_identity_credential" "infra_main" {
  application_id = azuread_application.infra.id
  display_name   = "github-actions-quiznova-infra-main"
  description    = "Federated credential for quiznova-infra main branch deployment"
  audiences      = [local.azuread_token_aud]
  issuer         = local.github_oidc_issuer
  subject        = "${local.infra_repo_subject}:ref:refs/heads/main"
}

resource "azuread_application_federated_identity_credential" "infra_pr" {
  application_id = azuread_application.infra.id
  display_name   = "github-actions-quiznova-infra-pr"
  description    = "Federated credential for quiznova-infra pull requests"
  audiences      = [local.azuread_token_aud]
  issuer         = local.github_oidc_issuer
  subject        = "${local.infra_repo_subject}:pull_request"
}

# Role assignment for Azure Resource Group
resource "azurerm_role_assignment" "infra_rg_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.infra.object_id
}

# Role assignment for Terraform State Storage Account
resource "azurerm_role_assignment" "infra_state_blob" {
  scope                = data.azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.infra.object_id
}

# Repository Secrets on quiznova-infra
resource "github_actions_secret" "infra_azure_client_id" {
  repository  = github_repository.quiznova_infra.name
  secret_name = "AZURE_CLIENT_ID"
  value       = azuread_application.infra.client_id
}

resource "github_actions_secret" "infra_azure_tenant_id" {
  repository  = github_repository.quiznova_infra.name
  secret_name = "AZURE_TENANT_ID"
  value       = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_secret" "infra_azure_subscription_id" {
  repository  = github_repository.quiznova_infra.name
  secret_name = "AZURE_SUBSCRIPTION_ID"
  value       = var.azure_subscription_id
}
