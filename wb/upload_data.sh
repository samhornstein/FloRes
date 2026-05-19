#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."

# Default to GCP environment
ENV="${1:-gcp}"

# Validate environment
if [[ ! "$ENV" =~ ^(gcp|wb)$ ]]; then
    echo "Error: Invalid environment '$ENV'. Must be 'gcp' or 'wb'"
    echo "Usage: $0 [gcp|wb]"
    exit 1
fi

# Source environment configuration
CONFIG_FILE="${SCRIPT_DIR}/config/${ENV}.env"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

if [[ -z "${GCS_BUCKET:-}" ]]; then
    echo "Error: GCS_BUCKET is not set. Check your ${ENV}.env configuration."
    exit 1
fi

DATA_DIR="${REPO_ROOT}/data"

echo "Uploading pipeline data to gs://${GCS_BUCKET}/data/..."
gcloud storage cp -r "${DATA_DIR}" "gs://${GCS_BUCKET}/"

echo ""
echo "Upload complete!"
echo "Uploaded to: gs://${GCS_BUCKET}/data/"
