#!/usr/bin/env bash
# ==============================================================================
# QuizNova - LocalStack Azure Terraform Runner
# Executes Terraform plans/applies safely against LocalStack without touching
# real Azure cloud state or incurring cloud costs.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration & Target Defaults
ACTION="${1:-plan}"
TARGET_DIR="terraform"
EXTRA_ARGS=()

shift || true

# Check if next argument is a directory or path
if [[ $# -gt 0 && -d "$REPO_ROOT/$1" ]]; then
  TARGET_DIR="$1"
  shift
elif [[ $# -gt 0 && "$1" != -* && -d "$1" ]]; then
  TARGET_DIR="$1"
  shift
fi

EXTRA_ARGS=("$@")

TARGET_PATH="$REPO_ROOT/$TARGET_DIR"
if [[ ! -d "$TARGET_PATH" && -d "$TARGET_DIR" ]]; then
  TARGET_PATH="$(cd "$TARGET_DIR" && pwd)"
fi

if [[ ! -d "$TARGET_PATH" ]]; then
  echo "Error: Directory '$TARGET_PATH' does not exist."
  echo "Usage: $0 [plan|apply|destroy|init] [path/to/terraform/dir] [extra_terraform_flags...]"
  exit 1
fi

# Auto-detect Doppler project and configuration based on target
if [[ "$TARGET_PATH" == *"api"* ]]; then
  DOPPLER_PROJECT="${DOPPLER_PROJECT:-quiznova-api}"
  DOPPLER_CONFIG="${DOPPLER_CONFIG:-dev}"
elif [[ "$TARGET_PATH" == *"web"* ]]; then
  DOPPLER_PROJECT="${DOPPLER_PROJECT:-quiznova-web}"
  DOPPLER_CONFIG="${DOPPLER_CONFIG:-dev}"
else
  DOPPLER_PROJECT="${DOPPLER_PROJECT:-quiznova-infra}"
  DOPPLER_CONFIG="${DOPPLER_CONFIG:-prd}"
fi

echo "=================================================================="
echo " QuizNova LocalStack Azure Terraform Runner"
echo " Target Directory : $TARGET_PATH"
echo " Action           : $ACTION ${EXTRA_ARGS[*]:-}"
echo " Doppler Project  : $DOPPLER_PROJECT"
echo " Doppler Config   : $DOPPLER_CONFIG"
echo " LocalStack Host  : azure.localhost.localstack.cloud:4566"
echo "=================================================================="

# Ensure LocalStack Azure environment variables are set
export ARM_METADATA_HOSTNAME="azure.localhost.localstack.cloud:4566"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"

# Auto-inject Doppler CLI token so Doppler Terraform provider authenticates
if [[ -z "${DOPPLER_TOKEN:-}" ]]; then
  export DOPPLER_TOKEN="$(doppler configure get token --plain 2>/dev/null || true)"
fi

# Ensure isolated LocalStack Azure CLI profile is configured and used
LSTK_AZ_CONFIG="$HOME/.config/lstk/azure"
if [[ ! -d "$LSTK_AZ_CONFIG" ]] && command -v lstk &>/dev/null; then
  echo "==> Configuring isolated LocalStack Azure CLI profile..."
  lstk setup azure || true
fi
export AZURE_CONFIG_DIR="$LSTK_AZ_CONFIG"

# Keep LocalStack's Terraform working data (backend config, providers) outside
# the target's .terraform/ directory. The real .terraform/ stays initialized
# against the azurerm backend, so running real terraform afterwards is safe.
TF_SLUG="$(printf '%s' "$TARGET_PATH" | sed 's|^/||; s|/|_|g')"
export TF_DATA_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/quiznova-localstack/$TF_SLUG"
mkdir -p "$TF_DATA_DIR"

# Create localstack_override.tf in the target directory and always remove it on
# exit (success, failure, or Ctrl+C) so it never leaks into real runs.
OVERRIDE_FILE="$TARGET_PATH/localstack_override.tf"
cleanup_override() {
  rm -f "$OVERRIDE_FILE"
}
trap cleanup_override EXIT
cat << 'EOF' > "$OVERRIDE_FILE"
# ------------------------------------------------------------------------------
# LOCALSTACK LOCAL OVERRIDE (AUTOMATICALLY GENERATED - DO NOT COMMIT TO GIT)
# ------------------------------------------------------------------------------
terraform {
  backend "local" {
    path = "localstack.tfstate"
  }
}

provider "azurerm" {
  features {}
  metadata_host                   = "azure.localhost.localstack.cloud:4566"
  subscription_id                 = "00000000-0000-0000-0000-000000000000"
  resource_provider_registrations = "none"
}
EOF

cd "$TARGET_PATH"

# Initialize the isolated LocalStack data dir on first run or explicit init
if [[ "$ACTION" == "init" || ! -f "$TF_DATA_DIR/terraform.tfstate" ]]; then
  echo "==> Initializing Terraform with LocalStack local backend ($TF_DATA_DIR)..."
  terraform init -reconfigure -input=false
fi

if [[ "$ACTION" == "init" ]]; then
  echo "==> Initialization complete."
  exit 0
fi

# Execute action with Doppler secrets injection
echo "==> Executing 'terraform $ACTION' via Doppler..."
if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  doppler run --project "$DOPPLER_PROJECT" --config "$DOPPLER_CONFIG" -- terraform "$ACTION" "${EXTRA_ARGS[@]}"
else
  doppler run --project "$DOPPLER_PROJECT" --config "$DOPPLER_CONFIG" -- terraform "$ACTION"
fi
