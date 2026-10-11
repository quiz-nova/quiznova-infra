# ==============================================================================
# Datadog Observability & Alerting
# ==============================================================================
#
# Cold-Start Resilience:
# - new_group_delay = 300: Silences alerts for 5 minutes when a new replica boots up,
#   giving cold starts ample time for ASP.NET Core DB migrations, EF connection
#   pooling, and internal cache warm-up before monitoring begins.
# - last_10m evaluation window: Smooths out brief startup latency and transient blips.
# - require_full_window = true: Requires a full window of telemetry before evaluating.
# - notify_no_data = false: Suppresses false alerts when replicas scale down to zero.
# - evaluation_delay = 60: Buffers OTLP trace batching to prevent false spikes.
# ==============================================================================

resource "datadog_monitor" "api_error_rate" {
  name               = "QuizNova API Elevated 5xx Error Rate"
  type               = "metric alert"
  message            = "QuizNova API 5xx error rate has exceeded 5% in {{env.name}}! Notify: @devops"
  tags               = ["service:quiznova-api", "env:prd"]
  escalation_message = "QuizNova API errors still elevated after 15 minutes."

  query = "sum(last_10m):sum:trace.aspnet_core.request.errors{service:quiznova-api,env:prd} by {env}.as_count() / sum:trace.aspnet_core.request.hits{service:quiznova-api,env:prd} by {env}.as_count() > 0.05"

  monitor_thresholds {
    critical = 0.05
    warning  = 0.02
  }

  evaluation_delay    = 60
  new_group_delay     = 300
  require_full_window = true
  notify_no_data      = false
  renotify_interval   = 60
}
