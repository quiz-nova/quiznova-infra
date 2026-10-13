# ==============================================================================
# Doppler Configuration
# ==============================================================================

variable "doppler_project" {
  type        = string
  description = "The Doppler project name"
  default     = "quiznova-infra"
}

variable "doppler_config" {
  type        = string
  description = "The Doppler environment config"
  default     = "prd"
}

# ==============================================================================
# Azure Configuration
# ==============================================================================

variable "azure_subscription_id" {
  type        = string
  description = "Primary Azure Subscription ID"
  default     = "83ab56f5-88ee-436d-87a5-994d3185bf00"
}

variable "azure_location" {
  type        = string
  description = "Primary Azure deployment region"
  default     = "swedencentral"
}

variable "resource_group_name" {
  type        = string
  description = "Primary Azure Resource Group name"
  default     = "quiznova-rg"
}

variable "storage_account_name" {
  type        = string
  description = "Primary Azure Storage Account name for state and storage"
  default     = "stquiznova"
}

# ==============================================================================
# GitHub Configuration (Static Identifiers)
# ==============================================================================

variable "github_owner" {
  type        = string
  description = "Target GitHub organization name"
  default     = "quiz-nova"
}

variable "github_organization_id" {
  type        = string
  description = "Target GitHub organization numeric ID"
  default     = "325215040"
}

variable "github_app_id" {
  type        = string
  description = "GitHub App numeric ID"
  default     = "5241495"
}

variable "github_app_installation_id" {
  type        = string
  description = "GitHub App organization installation ID"
  default     = "169355840"
}

variable "azure_admin_object_id" {
  type        = string
  description = "Object ID of the primary administrator for storage state access"
  default     = "0f9822ec-b88c-4077-aead-2a65d6b12ea2"
}

variable "github_app_pem_file" {
  type        = string
  description = "GitHub App Private Key PEM file content (injected via Doppler OIDC)"
  default     = null
  sensitive   = true
}

# ==============================================================================
# Datadog Observability Configuration
# ==============================================================================

variable "datadog_api_url" {
  type        = string
  description = "Datadog API URL endpoint"
  default     = "https://api.us5.datadoghq.com/"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key (injected via Doppler OIDC)"
  default     = null
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key (injected via Doppler OIDC)"
  default     = null
  sensitive   = true
}
