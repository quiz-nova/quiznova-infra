#!/usr/bin/env bash
# ==============================================================================
# QuizNova - LocalStack Cloud Pod / Snapshot Synchronizer
# Uses LocalStack Pro Cloud Pods to sync and restore base state across machines
# without saving any state or secrets into Git.
# ==============================================================================
set -euo pipefail

CMD="${1:-help}"
POD_NAME="${2:-quiznova-localstack-base}"

if ! command -v lstk &>/dev/null; then
  echo "Error: 'lstk' CLI is not found on PATH. Please install lstk."
  exit 1
fi

case "$CMD" in
  save)
    echo "==> Saving LocalStack emulator state to Cloud Pod: pod:$POD_NAME..."
    if ! lstk snapshot save "pod:$POD_NAME"; then
      echo ""
      echo "Note: Snapshot & Cloud Pod support for the Azure emulator is currently in"
      echo "early preview and not yet enabled on the server-side container endpoint."
      echo "For multi-machine sync, run './scripts/localstack-tf.sh apply <target>'"
      echo "to spin up your environment declaratively from Doppler in ~20 seconds."
    else
      echo "==> Successfully saved snapshot: pod:$POD_NAME"
    fi
    ;;
  load)
    echo "==> Loading LocalStack emulator state from Cloud Pod: pod:$POD_NAME..."
    if ! lstk snapshot load "pod:$POD_NAME"; then
      echo ""
      echo "Note: Cloud Pod loading for Azure emulator is pending GA release."
      echo "Use './scripts/localstack-tf.sh apply <target>' to reconstruct state."
    else
      echo "==> Successfully restored snapshot: pod:$POD_NAME"
    fi
    ;;
  list)
    echo "==> Listing available snapshots..."
    lstk snapshot list
    ;;
  help|*)
    echo "QuizNova LocalStack Snapshot Manager"
    echo "Usage: $0 [save|load|list] [optional_pod_name]"
    echo ""
    echo "Commands:"
    echo "  save [name]   Save current running LocalStack state to Cloud Pod (default: quiznova-localstack-base)"
    echo "  load [name]   Restore LocalStack state from Cloud Pod"
    echo "  list          List available snapshots in LocalStack workspace"
    ;;
esac
