resource "github_repository_environment" "api_dev" {
  repository  = github_repository.quiznova_api.name
  environment = "development"
}

resource "github_repository_environment" "api_stg" {
  repository  = github_repository.quiznova_api.name
  environment = "staging"
}

resource "github_repository_environment" "api_prd" {
  repository          = github_repository.quiznova_api.name
  environment         = "production"
  prevent_self_review = false

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "api_prd_main" {
  repository     = github_repository.quiznova_api.name
  environment    = github_repository_environment.api_prd.environment
  branch_pattern = "main"
}

resource "github_repository_environment" "web_dev" {
  repository  = github_repository.quiznova_web.name
  environment = "development"
}

resource "github_repository_environment" "web_stg" {
  repository  = github_repository.quiznova_web.name
  environment = "staging"
}

resource "github_repository_environment" "web_prd" {
  repository          = github_repository.quiznova_web.name
  environment         = "production"
  prevent_self_review = false

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "web_prd_main" {
  repository     = github_repository.quiznova_web.name
  environment    = github_repository_environment.web_prd.environment
  branch_pattern = "main"
}
