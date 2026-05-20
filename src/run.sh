#!/usr/bin/env bash

set -euo pipefail

CONTEXT=$(cat /tmp/diff.patch)

mkdir -p /tmp/output

if [ "$AGENT" = "cursor" ]; then
  if [ -z "${CURSOR_API_KEY:-}" ]; then
    echo "CURSOR_API_KEY is required when agent is cursor (set repo/org secret and pass to this action)." >&2
    exit 1
  fi

  agent -p --output-format json \
    "$(printf '%s\n\n--- Git diff ---\n%s' "$PROMPT" "$CONTEXT")" \
    > /tmp/output/result.json

elif [ "$AGENT" = "anthropic" ]; then
  if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "ANTHROPIC_API_KEY is required when agent is anthropic (set repo/org secret)." >&2
    exit 1
  fi

  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "content-type: application/json" \
    -d "{
      \"model\": \"claude-3\",
      \"messages\": [{
        \"role\": \"user\",
        \"content\": \"$PROMPT\n\n$CONTEXT\"
      }]
    }" > /tmp/output/result.json

else
  echo "Unknown agent \"${AGENT:-}\" (expected cursor or anthropic)." >&2
  exit 1
fi
