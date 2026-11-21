locals {
  protected_branches = {
    quiznova-api = {
      repository     = github_repository.quiznova_api.name
      required_check = "Backend Build"
    }
    quiznova-web = {
      repository     = github_repository.quiznova_web.name
      required_check = "Frontend Build, Test & Quality"
    }
    quiznova-infra = {
      repository     = github_repository.quiznova_infra.name
      required_check = "Validate Configuration"
    }
  }
}

resource "github_repository_ruleset" "main" {
  for_each = local.protected_branches

  name        = "main-protection"
  repository  = each.value.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  # Repository admin role
  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_id    = tonumber(var.github_app_id)
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      allowed_merge_methods             = ["squash"]
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 0
      required_review_thread_resolution = false
    }

    required_status_checks {
      strict_required_status_checks_policy = false

      required_check {
        context = each.value.required_check
      }
    }
  }
}
