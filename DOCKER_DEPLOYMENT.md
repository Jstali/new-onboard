# 🐳 NXZEN Employee Management System - Docker Deployment

Complete Docker-based deployment with environment-based configuration for maximum flexibility.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Environment Configuration](#environment-configuration)
- [Deployment Options](#deployment-options)
- [Service Management](#service-management)
- [Troubleshooting](#troubleshooting)
- [Production Considerations](#production-considerations)

## 🚀 Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- Git
- 4GB+ RAM available
- 10GB+ disk space

## ⚡ Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd onboard
cp .env.example .env
```

### 2. Configure Environment

Edit `.env` file with your values:

```bash
nano .env
```

**Required changes:**

- `DB_PASSWORD` - Set a secure database password
- `JWT_SECRET` - Set a secure JWT secret
- `EMAIL_USER` - Your email for notifications
- `EMAIL_PASS` - Your email app password

### 3. Deploy

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Deploy the application
./scripts/deploy.sh
```

### 4. Access Application

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:5001/api
- **Database**: localhost:5432

## 🔧 Environment Configuration

### Core Variables

| Variable        | Description       | Default      | Required |
| --------------- | ----------------- | ------------ | -------- |
| `SERVER_IP`     | Server IP address | `0.0.0.0`    | No       |
| `NODE_ENV`      | Environment mode  | `production` | No       |
| `FRONTEND_PORT` | Frontend port     | `3001`       | No       |
| `BACKEND_PORT`  | Backend port      | `5001`       | No       |
| `DB_HOST`       | Database host     | `postgres`   | No       |
| `DB_PORT`       | Database port     | `5432`       | No       |
| `DB_NAME`       | Database name     | `onboardd`   | No       |
| `DB_USER`       | Database user     | `postgres`   | No       |
| `DB_PASSWORD`   | Database password | -            | **Yes**  |
| `JWT_SECRET`    | JWT secret key    | -            | **Yes**  |
| `EMAIL_USER`    | Email username    | -            | **Yes**  |
| `EMAIL_PASS`    | Email password    | -            | **Yes**  |

### Optional Variables

| Variable         | Description    | Default                                       |
| ---------------- | -------------- | --------------------------------------------- |
| `REDIS_HOST`     | Redis host     | `redis`                                       |
| `REDIS_PORT`     | Redis port     | `6379`                                        |
| `REDIS_PASSWORD` | Redis password | -                                             |
| `CORS_ORIGIN`    | CORS origins   | `http://localhost:3001,http://localhost:5001` |
| `FRONTEND_URL`   | Frontend URL   | `http://localhost:3001`                       |
| `BACKEND_URL`    | Backend URL    | `http://localhost:5001/api`                   |

## 🚀 Deployment Options

### Basic Deployment (Frontend + Backend + Database)

```bash
./scripts/deploy.sh
```

### With Redis (Caching)

```bash
# Enable Redis in docker-compose
docker-compose --env-file .env up -d --build --profile redis
```

### With Nginx Reverse Proxy

```bash
# Enable Nginx reverse proxy
docker-compose --env-file .env up -d --build --profile nginx
```

### With Monitoring (Prometheus + Grafana)

```bash
# Enable monitoring stack
docker-compose --env-file .env up -d --build --profile monitoring
```

### With Database Backups

```bash
# Enable automated backups
docker-compose --env-file .env up -d --build --profile backup
```

## 🛠️ Service Management

### Available Commands

```bash
# Deploy application
./scripts/deploy.sh deploy

# Stop all services
./scripts/deploy.sh stop

# Restart services
./scripts/deploy.sh restart

# View logs
./scripts/deploy.sh logs

# Check status
./scripts/deploy.sh status

# Check health
./scripts/deploy.sh health

# Update services
./scripts/deploy.sh update
```

### Manual Docker Compose Commands

```bash
# Start services
docker-compose --env-file .env up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and start
docker-compose --env-file .env up -d --build

# Scale services
docker-compose --env-file .env up -d --scale backend=2
```

## 🔍 Health Checks

### Service Health Endpoints

- **Frontend**: http://localhost:3001/health
- **Backend**: http://localhost:5001/api/health
- **Database**: `docker-compose exec postgres pg_isready`

### Health Check Commands

```bash
# Check all services
./scripts/deploy.sh health

# Check specific service
docker-compose ps backend
docker-compose ps frontend
docker-compose ps postgres

# View service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres
```

## 🗄️ Database Management

### Run Migrations

```bash
# Using setup script
./scripts/setup_db.sh

# Manual migration
docker-compose exec backend npm run migrate
```

### Database Backup

```bash
# Create backup
docker-compose exec postgres pg_dump -U postgres onboardd > backup.sql

# Restore backup
docker-compose exec -T postgres psql -U postgres onboardd < backup.sql
```

### Database Access

```bash
# Connect to database
docker-compose exec postgres psql -U postgres -d onboardd

# View database status
docker-compose exec postgres pg_isready -U postgres
```

## 🔧 Configuration Changes

### Changing Ports

1. Update `.env` file:

   ```bash
   FRONTEND_PORT=8080
   BACKEND_PORT=9000
   ```

2. Restart services:
   ```bash
   ./scripts/deploy.sh restart
   ```

### Changing Database Settings

1. Update `.env` file:

   ```bash
   DB_NAME=my_database
   DB_USER=my_user
   DB_PASSWORD=my_password
   ```

2. Recreate database:
   ```bash
   docker-compose down -v
   ./scripts/deploy.sh
   ```

### Adding New Environment Variables

1. Add to `.env` file
2. Update `docker-compose.yml` environment section
3. Update `backend/Dockerfile` if needed
4. Restart services

## 🐛 Troubleshooting

### Common Issues

#### Services Won't Start

```bash
# Check logs
docker-compose logs

# Check resource usage
docker stats

# Restart with clean state
docker-compose down -v
docker system prune -f
./scripts/deploy.sh
```

#### Database Connection Issues

```bash
# Check database status
docker-compose exec postgres pg_isready

# Check database logs
docker-compose logs postgres

# Reset database
docker-compose down -v
docker volume rm onboard_postgres_data
./scripts/deploy.sh
```

#### Frontend Not Loading

```bash
# Check frontend logs
docker-compose logs frontend

# Check nginx configuration
docker-compose exec frontend nginx -t

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

#### Backend API Issues

```bash
# Check backend logs
docker-compose logs backend

# Test API directly
curl http://localhost:5001/api/health

# Check environment variables
docker-compose exec backend env | grep DB_
```

### Log Analysis

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres

# Follow logs in real-time
docker-compose logs -f backend

# View last 100 lines
docker-compose logs --tail=100 backend
```

### Resource Monitoring

```bash
# Check container resource usage
docker stats

# Check disk usage
docker system df

# Clean up unused resources
docker system prune -f
```

## 🏭 Production Considerations

### Security

1. **Change default passwords** in `.env`
2. **Use strong JWT secrets**
3. **Enable HTTPS** with SSL certificates
4. **Configure firewall** rules
5. **Regular security updates**

### Performance

1. **Resource allocation**:

   ```yaml
   deploy:
     resources:
       limits:
         memory: 1G
         cpus: "0.5"
   ```

2. **Database optimization**:

   - Configure PostgreSQL settings
   - Use connection pooling
   - Regular VACUUM and ANALYZE

3. **Caching**:
   - Enable Redis for session storage
   - Use CDN for static assets

### Monitoring

1. **Enable monitoring stack**:

   ```bash
   docker-compose --env-file .env up -d --profile monitoring
   ```

2. **Set up alerts** in Grafana
3. **Monitor logs** with ELK stack
4. **Health check endpoints**

### Backup Strategy

1. **Database backups**:

   ```bash
   # Automated daily backups
   docker-compose --env-file .env up -d --profile backup
   ```

2. **File backups**:

   - Backup uploads directory
   - Backup configuration files

3. **Disaster recovery**:
   - Test restore procedures
   - Document recovery steps

### Scaling

1. **Horizontal scaling**:

   ```bash
   docker-compose --env-file .env up -d --scale backend=3
   ```

2. **Load balancing** with Nginx
3. **Database clustering** for high availability

## 📞 Support

For issues and questions:

1. Check the [troubleshooting section](#troubleshooting)
2. Review logs: `docker-compose logs`
3. Check service status: `./scripts/deploy.sh status`
4. Verify environment configuration

## 🔄 Updates

To update the application:

```bash
# Pull latest changes
git pull

# Update and restart
./scripts/deploy.sh update

# Or manually
docker-compose --env-file .env up -d --build
```

---

**Happy Deploying! 🚀**
