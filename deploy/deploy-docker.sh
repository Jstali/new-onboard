#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="docker-compose.prod.yml"
REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
BACKEND_ENV_FILE="${REPO_DIR}/.env.backend"
FRONTEND_ENV_FILE="${REPO_DIR}/.env.frontend"

if [[ ! -f "$BACKEND_ENV_FILE" ]]; then
  echo "Missing .env.backend in repo root" >&2
  exit 1
fi

# Load envs
set -a
source "$BACKEND_ENV_FILE"
[[ -f "$FRONTEND_ENV_FILE" ]] && source "$FRONTEND_ENV_FILE" || true
set +a

# Generate runtime-config.js for frontend container bind-mount
RUNTIME_DIR="$REPO_DIR/runtime"
mkdir -p "$RUNTIME_DIR"
API_BASE="${REACT_APP_API_BASE_URL:-${BACKEND_URL:-http://localhost:5001/api}}"
cat > "$RUNTIME_DIR/runtime-config.js" <<EOF
window.__RUNTIME_CONFIG__ = {
  REACT_APP_API_BASE_URL: "${API_BASE}"
};
EOF

echo "Runtime config generated at $RUNTIME_DIR/runtime-config.js with API ${API_BASE}"

echo "Building and starting containers..."
cd "$REPO_DIR"
# Compose uses baked values. You can modify docker-compose.prod.yml to mount runtime-config.js if desired.
docker compose -f "$COMPOSE_FILE" up -d --build

echo "Docker deployment started. To view logs: docker compose -f $COMPOSE_FILE logs -f"
