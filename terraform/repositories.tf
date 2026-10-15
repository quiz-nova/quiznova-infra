resource "github_repository" "quiznova_web" {
  name         = "quiznova-web"
  description  = "QuizNova Single Page Application built with Angular 21 and PrimeNG"
  homepage_url = var.homepage_url
  visibility   = "public"

  topics = [
    "quiznova",
    "angular",
    "typescript",
    "primeng",
    "datadog-rum",
    "spa"
  ]

  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true
  allow_squash_merge     = true
  allow_merge_commit     = false
  allow_rebase_merge     = false

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  lifecycle {
    ignore_changes = [pages]
  }
}

resource "github_repository_vulnerability_alerts" "quiznova_web" {
  repository = github_repository.quiznova_web.name
}

resource "github_repository_dependabot_security_updates" "quiznova_web" {
  repository = github_repository.quiznova_web.name
  enabled    = true
  depends_on = [github_repository_vulnerability_alerts.quiznova_web]
}

resource "github_repository" "quiznova_api" {
  name         = "quiznova-api"
  description  = "QuizNova Backend API built with .NET 10, ASP.NET Core Clean Architecture, MongoDB, and PostgreSQL"
  homepage_url = var.homepage_url
  visibility   = "public"

  topics = [
    "quiznova",
    "dotnet",
    "csharp",
    "aspnetcore",
    "clean-architecture",
    "mongodb",
    "postgresql",
    "opentelemetry",
    "datadog",
    "azure-container-apps"
  ]

  has_issues   = true
  has_projects = false
  has_wiki     = true

  delete_branch_on_merge = true
  allow_squash_merge     = true
  allow_merge_commit     = false
  allow_rebase_merge     = false

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_repository_vulnerability_alerts" "quiznova_api" {
  repository = github_repository.quiznova_api.name
}

resource "github_repository_dependabot_security_updates" "quiznova_api" {
  repository = github_repository.quiznova_api.name
  enabled    = true
  depends_on = [github_repository_vulnerability_alerts.quiznova_api]
}

resource "github_repository" "quiznova_infra" {
  name         = "quiznova-infra"
  description  = "Infrastructure as Code for QuizNova GitHub organization repositories, environments, Doppler secrets, and platform automation"
  homepage_url = var.homepage_url
  visibility   = "public"

  topics = [
    "quiznova",
    "github-management",
    "infrastructure-as-code",
    "terraform",
    "github-app",
    "doppler",
    "github-actions",
    "localstack"
  ]

  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true
  allow_squash_merge     = true
  allow_merge_commit     = false
  allow_rebase_merge     = false

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_repository_vulnerability_alerts" "quiznova_infra" {
  repository = github_repository.quiznova_infra.name
}

resource "github_repository_dependabot_security_updates" "quiznova_infra" {
  repository = github_repository.quiznova_infra.name
  enabled    = true
  depends_on = [github_repository_vulnerability_alerts.quiznova_infra]
}
