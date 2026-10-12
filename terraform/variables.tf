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

# ==============================================================================
# Datadog Observability Configuration
# ==============================================================================

variable "datadog_api_url" {
  type        = string
  description = "Datadog API URL endpoint"
  default     = "https://api.us5.datadoghq.com/"
}
