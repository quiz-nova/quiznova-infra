resource "github_repository" "quiznova_web" {
  name         = "quiznova-web"
  description  = "QuizNova Web Application"
  homepage_url = "quiznova.dev"
  visibility   = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

  lifecycle {
    ignore_changes = [pages]
  }
}

resource "github_repository" "quiznova_api" {
  name        = "quiznova-api"
  description = "QuizNova Backend API"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true
}

resource "github_repository" "quiznova_infra" {
  name        = "quiznova-infra"
  description = "Platform Infrastructure as Code for QuizNova organization managed via Terraform and GitHub App"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true
}
