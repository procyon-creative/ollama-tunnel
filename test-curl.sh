#!/bin/sh
# Test the ollama tunnel. Reads credentials from access-credentials.json.
set -e

HOSTNAME="${OLLAMA_HOSTNAME:-ollama.example.com}"
CREDS="./access-credentials.json"

if [ -f "$CREDS" ]; then
  CLIENT_ID=$(jq -r '.client_id' "$CREDS")
  CLIENT_SECRET=$(jq -r '.client_secret' "$CREDS")
  AUTH_HEADERS="-H CF-Access-Client-Id:${CLIENT_ID} -H CF-Access-Client-Secret:${CLIENT_SECRET}"
else
  AUTH_HEADERS=""
fi

curl -s \
  ${AUTH_HEADERS} \
  -H "Content-Type: application/json" \
  "https://${HOSTNAME}/v1/chat/completions" \
  -d '{"model":"tinyllama","messages":[{"role":"user","content":"Say hello"}]}' | jq
