# ==============================================================================
# Doppler Workplace Automation & Project Permissions
# ==============================================================================

# Service Account for GitHub Actions OIDC Authentication
resource "doppler_service_account" "github_actions" {
  name           = "github-actions-sa"
  workplace_role = "no_access"
}

# Project Member: quiznova-api
resource "doppler_project_member_service_account" "api" {
  project              = "quiznova-api"
  service_account_slug = doppler_service_account.github_actions.slug
  role                 = "collaborator"
  environments         = ["dev", "stg", "prd"]
}

# Project Member: quiznova-web
resource "doppler_project_member_service_account" "web" {
  project              = "quiznova-web"
  service_account_slug = doppler_service_account.github_actions.slug
  role                 = "collaborator"
  environments         = ["dev", "stg", "prd"]
}

# Project Member: quiznova-infra
resource "doppler_project_member_service_account" "infra" {
  project              = "quiznova-infra"
  service_account_slug = doppler_service_account.github_actions.slug
  role                 = "collaborator"
  environments         = ["dev", "stg", "prd"]
}

# Declarative import for existing Doppler service account
import {
  to = doppler_service_account.github_actions
  id = "c1fb068e-3eb4-466c-90b9-898f1aa9893e"
}
