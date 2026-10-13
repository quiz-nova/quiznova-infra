resource "github_repository" "quiznova_web" {
  name         = "quiznova-web"
  description  = "QuizNova Web Application"
  homepage_url = "quiznova.dev"
  visibility   = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

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
  name        = "quiznova-api"
  description = "QuizNova Backend API"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

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
  name        = "quiznova-infra"
  description = "Platform Infrastructure as Code for QuizNova organization managed via Terraform and GitHub App"
  visibility  = "public"

  has_issues   = true
  has_projects = true
  has_wiki     = true

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

# ==============================================================================
# GitHub Code Quality Enablement
# ==============================================================================

resource "terraform_data" "code_quality_api" {
  input = github_repository.quiznova_api.name

  provisioner "local-exec" {
    command = <<-EOT
      OWNER="${var.github_owner}"
      REPO="${github_repository.quiznova_api.name}"
      gh api --method PATCH \
        -H "Accept: application/vnd.github+json" \
        "/repos/$OWNER/$REPO/code-quality/setup" \
        -f state="configured"
    EOT
  }
}

resource "terraform_data" "code_quality_web" {
  input = github_repository.quiznova_web.name

  provisioner "local-exec" {
    command = <<-EOT
      OWNER="${var.github_owner}"
      REPO="${github_repository.quiznova_web.name}"
      gh api --method PATCH \
        -H "Accept: application/vnd.github+json" \
        "/repos/$OWNER/$REPO/code-quality/setup" \
        -f state="configured"
    EOT
  }
}

resource "terraform_data" "code_quality_infra" {
  input = github_repository.quiznova_infra.name

  provisioner "local-exec" {
    command = <<-EOT
      OWNER="${var.github_owner}"
      REPO="${github_repository.quiznova_infra.name}"
      gh api --method PATCH \
        -H "Accept: application/vnd.github+json" \
        "/repos/$OWNER/$REPO/code-quality/setup" \
        -f state="configured"
    EOT
  }
}


