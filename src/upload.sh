#!/usr/bin/env bash

set -euo pipefail

BUNDLE="${1:?bundle file required}"

if [[ -z "${CALLBACK_URL:-}" ]]; then
  echo "client_payload.callback_url is required" >&2
  exit 1
fi

#curl -fsSL -X POST "$CALLBACK_URL" \
#  -H "Authorization: Bearer ${UPLOAD_TOKEN}" \
#  -H "Content-Type: application/json" \
#  --data-binary @"$BUNDLE"
