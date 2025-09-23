#!/usr/bin/env bash
set -euo pipefail

# Paths
REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
BACKEND_DIR="$REPO_DIR/backend"
FRONTEND_DIR="$REPO_DIR/frontend"
WEB_ROOT="/var/www/nxzen"

# .env files
BACKEND_ENV_FILE="${REPO_DIR}/.env.backend"
FRONTEND_ENV_FILE="${REPO_DIR}/.env.frontend"

if [[ ! -f "$BACKEND_ENV_FILE" ]]; then
  echo "Missing .env.backend in repo root" >&2
  exit 1
fi

# Install deps
command -v pm2 >/dev/null || npm i -g pm2
sudo apt-get update -y && sudo apt-get install -y nginx

# Backend
cd "$BACKEND_DIR"
cp "$BACKEND_ENV_FILE" .env
npm ci --no-audit --no-fund
pm2 start server.js --name nxzen-backend || pm2 restart nxzen-backend
pm2 save

# Frontend
cd "$FRONTEND_DIR"
npm ci --no-audit --no-fund
npm run build
sudo mkdir -p "$WEB_ROOT"
sudo cp -r build/* "$WEB_ROOT"/

# Runtime config (frontend)
API_BASE=$(grep -E '^REACT_APP_API_BASE_URL=' "$FRONTEND_ENV_FILE" | cut -d= -f2- || true)
if [[ -z "$API_BASE" ]]; then API_BASE="http://localhost:5001/api"; fi
sudo bash -c "cat > '$WEB_ROOT/runtime-config.js' <<EOF
window.__RUNTIME_CONFIG__ = { REACT_APP_API_BASE_URL: '$API_BASE' };
EOF"

# Nginx
sudo tee /etc/nginx/sites-available/nxzen >/dev/null <<'NG'
server {
  listen 80;
  server_name _;

  root /var/www/nxzen;
  index index.html;

  location /runtime-config.js { add_header Cache-Control "no-store"; }

  location /api/ {
    proxy_pass http://127.0.0.1:5001/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  location / {
    try_files $uri /index.html;
  }
}
NG

sudo ln -sf /etc/nginx/sites-available/nxzen /etc/nginx/sites-enabled/nxzen
sudo nginx -t && sudo systemctl reload nginx

echo "Deployment completed. Frontend served from $WEB_ROOT, backend on :5001"
