#!/bin/sh
set -e

# Start ollama server in background
ollama serve &

# Wait for it to be ready
echo "Waiting for ollama to start..."
until ollama list >/dev/null 2>&1; do
  sleep 1
done

# Pull the model if not already present
echo "Ensuring model '${OLLAMA_MODEL}' is available..."
ollama pull "${OLLAMA_MODEL}"

echo "Ollama ready with model: ${OLLAMA_MODEL}"

# Keep the server running
wait
