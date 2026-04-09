#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ensure services are running
if ! docker compose -f "$COMPOSE_DIR/docker-compose.yml" ps --status running ollama 2>/dev/null | grep -q ollama; then
  echo "Starting ollama-tunnel services..." >&2
  docker compose -f "$COMPOSE_DIR/docker-compose.yml" up -d 2>&1 | grep -v "Pulling\|Downloading" >&2
  # Wait for health check
  echo "Waiting for ollama to be ready..." >&2
  docker compose -f "$COMPOSE_DIR/docker-compose.yml" exec ollama sh -c 'until ollama list >/dev/null 2>&1; do sleep 1; done' 2>/dev/null
fi

# Pass all arguments through to ollama inside the container
docker compose -f "$COMPOSE_DIR/docker-compose.yml" exec ollama ollama "$@"
