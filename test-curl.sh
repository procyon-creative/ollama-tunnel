#!/bin/sh
# Test the ollama tunnel with API key auth.
# Reads OLLAMA_HOSTNAME and API_KEY from .env if present.
set -e

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

HOSTNAME="${OLLAMA_HOSTNAME:-ollama.example.com}"
KEY="${API_KEY:-sk-change-me}"

curl -s \
  -H "Authorization: Bearer ${KEY}" \
  -H "Content-Type: application/json" \
  "https://${HOSTNAME}/v1/chat/completions" \
  -d '{"model":"tinyllama","messages":[{"role":"user","content":"Say hello"}]}' | jq
