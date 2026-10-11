#!/usr/bin/env bash
# Pull the latest image and (re)start it as a long-running service on the host.
# Run this on the server. Idempotent — safe to re-run after each deploy.
#
# Usage:
#   ./run.sh             # uses :latest
#   ./run.sh v1.2.3      # pins a specific tag

set -euo pipefail

IMAGE="awmanoj/home"
TAG="${1:-latest}"
NAME="home"
HOST_PORT="${HOST_PORT:-8090}"

echo ">> Pulling $IMAGE:$TAG"
docker pull "$IMAGE:$TAG"

echo ">> Replacing container '$NAME'"
docker rm -f "$NAME" >/dev/null 2>&1 || true

docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  -p "127.0.0.1:${HOST_PORT}:80" \
  "$IMAGE:$TAG"

echo ">> Running on http://127.0.0.1:${HOST_PORT} — point Caddy's reg32.dev block at it"
docker ps --filter "name=^${NAME}$"
