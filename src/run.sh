#!/usr/bin/env bash

set -euo pipefail

CONTEXT=$(cat /tmp/diff.patch)

mkdir -p /tmp/output

if [ "$AGENT" = "cursor" ]; then
  cursor-agent run \
    --input "$CONTEXT" \
    --prompt "$PROMPT" \
    --format json \
    > /tmp/output/result.json

elif [ "$AGENT" = "anthropic" ]; then
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
fi
