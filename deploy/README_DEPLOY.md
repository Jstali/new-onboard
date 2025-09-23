# Deployment Guide (Docker and Bare-metal)

## 1) Prepare environment files

Create two files and edit values:

- `.env.backend` (copy of backend env)
- `.env.frontend` (React runtime config)

Example `.env.backend`:

```
PORT=5001
NODE_ENV=production
FRONTEND_URL=http://your-domain
BACKEND_URL=http://your-domain/api
CORS_ORIGIN=http://your-domain
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onboardd
DB_USER=postgres
DB_PASSWORD=change_me
JWT_SECRET=change_me_super_secret
JWT_EXPIRES_IN=24h
EMAIL_USER=your-email@example.com
EMAIL_PASS=your-app-password
```

Example `.env.frontend` (runtime, no rebuild needed):

```
REACT_APP_API_BASE_URL=http://your-domain/api
```

## 2) Docker deployment

```
# 1. Copy repo to server and cd
# 2. Create env files above
# 3. Start containers
docker compose -f docker-compose.prod.yml up -d --build
```

## 3) Bare-metal (PM2 + Nginx)

```
# Backend
cd backend
cp ../.env.backend .env
npm ci
pm2 start server.js --name nxzen-backend
pm2 save

# Frontend
cd ../frontend
npm ci
npm run build
sudo cp -r build /var/www/nxzen

# Runtime config (can change without rebuild)
echo "window.__RUNTIME_CONFIG__ = { REACT_APP_API_BASE_URL: 'http://your-domain/api' };" | sudo tee /var/www/nxzen/runtime-config.js

# Nginx
sudo tee /etc/nginx/sites-available/nxzen <<'NG'
server {
  listen 80;
  server_name your-domain;

  root /var/www/nxzen;
  index index.html;

  location /runtime-config.js {
    add_header Cache-Control "no-store";
  }

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
```

## 4) Update API without rebuild

Edit `/var/www/nxzen/runtime-config.js` and change `REACT_APP_API_BASE_URL`. Refresh the browser.
