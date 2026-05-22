#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."

# Source Workbench environment configuration
CONFIG_FILE="${SCRIPT_DIR}/config/wb.env"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    echo "Create it from the template: cp ${SCRIPT_DIR}/config/wb.env.template ${CONFIG_FILE}"
    exit 1
fi

source "$CONFIG_FILE"

if [[ -z "${GCS_BUCKET:-}" ]]; then
    echo "Error: GCS_BUCKET is not set. Check your wb.env configuration."
    exit 1
fi

PARAMS_FILE="${REPO_ROOT}/params_google_batch.yaml"
if [[ ! -f "$PARAMS_FILE" ]]; then
    echo "Error: Params file not found: $PARAMS_FILE"
    exit 1
fi

echo "Uploading params file to gs://${GCS_BUCKET}/..."
gsutil cp "$PARAMS_FILE" "gs://${GCS_BUCKET}/params_google_batch.yaml"

echo ""
echo "Upload complete!"
echo "Uploaded to: gs://${GCS_BUCKET}/params_google_batch.yaml"
