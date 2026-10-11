# ==============================================================================
# Datadog Synthetic Monitoring & Observability
# ==============================================================================

resource "datadog_synthetics_test" "api_healthcheck" {
  type    = "api"
  subtype = "http"
  name    = "QuizNova API Health Check (Production)"
  message = "QuizNova API health probe failed on {{endpoint.name}}! Please investigate container availability."
  tags    = ["service:quiznova-api", "env:prd"]

  request_definition {
    method = "GET"
    url    = "https://quiznova-api-prd.victorioussea-7d415837.swedencentral.azurecontainerapps.io/healthz"
  }

  request_headers = {
    Content-Type = "application/json"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  locations = ["aws:us-east-1", "aws:eu-central-1"]

  options_list {
    tick_every           = 300
    min_failure_duration = 0
    min_location_failed  = 1
    retry {
      count    = 2
      interval = 300
    }
  }

  # Paused by default so Azure Container Apps can freely scale to zero (min_replicas = 0)
  # without continuous HTTP probes waking up replicas and consuming Azure credits.
  status = "paused"
}

resource "datadog_monitor" "api_error_rate" {
  name               = "QuizNova API Elevated 5xx Error Rate"
  type               = "metric alert"
  message            = "QuizNova API 5xx error rate has exceeded 2% in {{env.name}}! Notify: @devops"
  tags               = ["service:quiznova-api", "env:prd"]
  escalation_message = "QuizNova API errors still elevated after 15 minutes."

  query = "sum(last_5m):sum:trace.aspnet_core.request.errors{service:quiznova-api,env:prd}.as_count() / sum:trace.aspnet_core.request.hits{service:quiznova-api,env:prd}.as_count() > 0.02"

  monitor_thresholds {
    critical = 0.02
    warning  = 0.01
  }

  notify_no_data    = false
  renotify_interval = 60
}
