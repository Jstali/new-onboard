# 🔧 Environment Configuration Guide

## Overview

The NXZEN Employee Management System now uses a centralized environment configuration system that eliminates hardcoded values and provides flexible configuration management across all environments.

## 📁 Configuration Files

### Main Configuration Files
- `backend/main.env` - Primary environment configuration for backend
- `frontend/main.env` - Primary environment configuration for frontend
- `backend/env.example` - Backend environment template
- `frontend/env.example` - Frontend environment template

### Legacy Files (Still Supported)
- `backend/config.env` - Development configuration
- `backend/production.env` - Production configuration
- `frontend/production.env` - Frontend production configuration

## 🚀 Quick Start

### 1. Backend Setup
```bash
cd backend
cp env.example .env
# Edit .env with your configuration
npm start
```

### 2. Frontend Setup
```bash
cd frontend
cp env.example .env
# Edit .env with your configuration
npm start
```

## 📋 Environment Variables

### Backend Configuration

#### Application Settings
```env
NODE_ENV=development
APP_NAME=NXZEN Employee Management System
APP_VERSION=1.0.0
```

#### Server Configuration
```env
BACKEND_HOST=localhost
BACKEND_PORT=2035
BACKEND_URL=http://localhost:2035
FRONTEND_HOST=localhost
FRONTEND_PORT=2036
FRONTEND_URL=http://localhost:2036
```

#### Database Configuration
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onboardd
DB_USER=postgres
DB_PASSWORD=postgres
```

#### CORS Configuration
```env
CORS_ORIGIN=http://localhost:2036,http://127.0.0.1:2036
PROD_CORS_ORIGIN=http://your-domain.com,https://your-domain.com
```

#### JWT Configuration
```env
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=7d
```

### Frontend Configuration

#### API Configuration
```env
REACT_APP_API_URL=http://localhost:2035/api
REACT_APP_BASE_URL=http://localhost:2036
REACT_APP_DEV_API_URL=http://localhost:2035/api
REACT_APP_PROD_API_URL=http://your-server:2035/api
```

#### Company Configuration
```env
REACT_APP_COMPANY_NAME=Your Company Name
REACT_APP_COMPANY_EMAIL=hr@yourdomain.com
REACT_APP_COMPANY_PHONE=+1-555-0123
```

#### Feature Flags
```env
REACT_APP_ENABLE_EMAIL_NOTIFICATIONS=true
REACT_APP_ENABLE_FILE_UPLOADS=true
REACT_APP_ENABLE_ATTENDANCE_TRACKING=true
```

## 🔄 Configuration Priority

### Backend Priority Order
1. `main.env` (Primary configuration)
2. `production.env` (Production overrides)
3. `config.env` (Development overrides)

### Frontend Priority Order
1. `main.env` (Primary configuration)
2. `production.env` (Production overrides)
3. System environment variables

## 🐳 Docker Configuration

### Backend Docker
The backend Dockerfile now copies `main.env` and `production.env` files:
```dockerfile
COPY main.env .env
COPY production.env .env.production
```

### Frontend Docker
The frontend Dockerfile includes environment loading:
```dockerfile
COPY main.env .env
```

## 🛠️ Development Workflow

### 1. Local Development
```bash
# Backend
cd backend
cp env.example .env
# Edit .env for local development
npm start

# Frontend
cd frontend
cp env.example .env
# Edit .env for local development
npm start
```

### 2. Production Deployment
```bash
# Update production.env files
# Deploy with Docker
./scripts/deploy-production.sh
```

## 🔧 Customization

### Adding New Environment Variables

1. **Backend**: Add to `backend/main.env` and `backend/env.example`
2. **Frontend**: Add to `frontend/main.env` and `frontend/env.example`
3. **Update code**: Use `process.env.VARIABLE_NAME` in your code

### Example: Adding a New Feature Flag
```env
# In main.env
ENABLE_NEW_FEATURE=true
REACT_APP_ENABLE_NEW_FEATURE=true
```

```javascript
// In your code
if (process.env.ENABLE_NEW_FEATURE === 'true') {
  // Feature code
}
```

## 🚨 Security Best Practices

### 1. Never Commit Sensitive Data
- Add `.env` to `.gitignore`
- Use `env.example` for templates
- Store secrets in secure vaults

### 2. Environment-Specific Secrets
```env
# Development
JWT_SECRET=dev_secret_key
DB_PASSWORD=dev_password

# Production
PROD_JWT_SECRET=production_secret_key
PROD_DB_PASSWORD=production_password
```

### 3. Validation
Always validate required environment variables:
```javascript
const requiredVars = ['JWT_SECRET', 'DB_HOST', 'DB_PASSWORD'];
requiredVars.forEach(varName => {
  if (!process.env[varName]) {
    throw new Error(`Missing required environment variable: ${varName}`);
  }
});
```

## 📊 Monitoring

### Environment Status Logging
The system logs environment configuration on startup:
```
🔧 Environment Configuration:
🔧 NODE_ENV: development
🔧 JWT_SECRET: ✅ Set
🔧 DB_HOST: localhost
🔧 PORT: 2035
```

### Health Checks
Environment variables are validated during health checks:
- `/api/health` - Basic health check
- `/api/health/auth` - Authentication health check

## 🔄 Migration from Hardcoded Values

### Before (Hardcoded)
```javascript
const apiUrl = "http://localhost:2035/api";
const corsOrigin = "http://localhost:2036";
```

### After (Environment Variables)
```javascript
const apiUrl = process.env.REACT_APP_API_URL || "http://localhost:2035/api";
const corsOrigin = process.env.CORS_ORIGIN || "http://localhost:2035";
```

## 🆘 Troubleshooting

### Common Issues

1. **Environment variables not loading**
   - Check file path: `main.env` should be in the correct directory
   - Verify syntax: No spaces around `=` in environment files
   - Check file permissions

2. **Frontend build fails**
   - Ensure `load-env.js` is executable: `chmod +x load-env.js`
   - Check `main.env` syntax
   - Verify all required variables are set

3. **Backend startup fails**
   - Check database connection variables
   - Verify JWT secret is set
   - Check port availability

### Debug Commands
```bash
# Check environment variables
node -e "require('dotenv').config({path: './main.env'}); console.log(process.env)"

# Test backend configuration
cd backend && node -e "require('./server.js')"

# Test frontend build
cd frontend && npm run build
```

## 📚 Additional Resources

- [Environment Variables Best Practices](https://12factor.net/config)
- [Docker Environment Variables](https://docs.docker.com/compose/environment-variables/)
- [React Environment Variables](https://create-react-app.dev/docs/adding-custom-environment-variables/)

---

**Note**: This configuration system provides maximum flexibility while maintaining security and ease of use. Always test your configuration in a development environment before deploying to production.
