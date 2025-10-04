# NXZEN Employee Management System - Production Deployment Guide

This guide provides comprehensive instructions for deploying the NXZEN Employee Management System to production.

## 📋 Overview

The production deployment includes:
- **Backend API**: Node.js/Express server with PostgreSQL
- **Frontend**: React application served by Nginx
- **Database**: PostgreSQL with automated backups
- **Cache**: Redis for sessions and caching
- **Monitoring**: Prometheus for metrics collection
- **Security**: Non-root containers, health checks, rate limiting

## 🚀 Quick Start

### Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 4GB+ RAM
- 20GB+ disk space
- Ubuntu 20.04+ or similar Linux distribution

### One-Command Deployment

```bash
# Clone the repository
git clone <repository-url>
cd onboard

# Run production deployment
./scripts/deploy-production.sh
```

## 📁 Production Files

### Docker Files
- `backend/Dockerfile.prod` - Optimized backend container
- `frontend/Dockerfile.prod` - Optimized frontend container with Nginx
- `docker-compose.production.yml` - Production orchestration

### Configuration Files
- `production.env` - Production environment variables
- `frontend/nginx.prod.conf` - Nginx configuration
- `monitoring/prometheus.yml` - Monitoring configuration

### Scripts
- `scripts/deploy-production.sh` - Main deployment script
- `scripts/backup.sh` - Database backup script

## 🔧 Configuration

### Environment Variables

Key production environment variables in `production.env`:

```bash
# Database Configuration
POSTGRES_DB=nxzen_hrms_prod
POSTGRES_USER=nxzen_user
POSTGRES_PASSWORD=NxzenSecurePass2025!

# Server Configuration
SERVER_IP=149.102.158.71
BACKEND_PORT=2035
FRONTEND_PORT=2036

# Security
JWT_SECRET=nxzen_jwt_secret_key_production_2024_secure
CORS_ORIGIN=http://149.102.158.71:2036,https://nxzen.com

# Email Configuration
EMAIL_USER=noreply@nxzen.com
EMAIL_PASS=nxzen_email_password_2024
```

### Customization

1. **Update Server IP**: Change `SERVER_IP` in `production.env`
2. **Update CORS Origins**: Add your domains to `CORS_ORIGIN`
3. **Update Email Settings**: Configure SMTP settings
4. **Update Database Credentials**: Change passwords and usernames

## 🚀 Deployment Steps

### 1. Prepare Server

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login to apply Docker group changes
```

### 2. Deploy Application

```bash
# Clone repository
git clone <repository-url>
cd onboard

# Make scripts executable
chmod +x scripts/*.sh

# Run deployment
./scripts/deploy-production.sh
```

### 3. Verify Deployment

```bash
# Check service status
./scripts/deploy-production.sh status

# Check logs
./scripts/deploy-production.sh logs

# Test endpoints
curl http://149.102.158.71:2036/health
curl http://149.102.158.71:2035/api/health
```

## 📊 Monitoring

### Service Health Checks

All services include health checks:
- **PostgreSQL**: `pg_isready` check
- **Redis**: `redis-cli ping` check
- **Backend**: HTTP health endpoint
- **Frontend**: HTTP health endpoint

### Prometheus Metrics

Access Prometheus at `http://149.102.158.71:9090` to view:
- System metrics (CPU, memory, disk)
- Database performance
- Application metrics
- Container health

### Log Monitoring

```bash
# View all logs
docker-compose -f docker-compose.production.yml logs -f

# View specific service logs
docker-compose -f docker-compose.production.yml logs -f backend
docker-compose -f docker-compose.production.yml logs -f frontend
```

## 💾 Backup & Recovery

### Automated Backups

The system includes automated daily backups:
- Database backups stored in `/opt/nxzen/data/backups`
- 30-day retention policy
- Compressed backups for space efficiency

### Manual Backup

```bash
# Create manual backup
docker-compose -f docker-compose.production.yml exec backup /backup.sh

# List available backups
docker-compose -f docker-compose.production.yml exec backup /backup.sh list
```

### Restore from Backup

```bash
# Restore from specific backup
docker-compose -f docker-compose.production.yml exec backup /backup.sh restore /backups/nxzen_backup_20241201_120000.sql.gz
```

## 🔒 Security Features

### Container Security
- Non-root user execution
- Read-only filesystems where possible
- Resource limits and reservations
- Health checks for all services

### Network Security
- Services only accessible from localhost
- Internal Docker network communication
- CORS configuration for frontend

### Application Security
- JWT token authentication
- Rate limiting on API endpoints
- Input validation and sanitization
- Security headers in Nginx

## 🛠️ Maintenance

### Service Management

```bash
# Stop services
./scripts/deploy-production.sh stop

# Restart services
./scripts/deploy-production.sh restart

# View status
./scripts/deploy-production.sh status
```

### Updates

```bash
# Pull latest changes
git pull origin main

# Rebuild and deploy
./scripts/deploy-production.sh
```

### Database Migrations

```bash
# Run migrations
docker-compose -f docker-compose.production.yml exec backend node scripts/runMigration.js migration_file.sql
```

## 📈 Performance Optimization

### Resource Allocation

Default resource limits:
- **PostgreSQL**: 2GB RAM, 1 CPU
- **Redis**: 512MB RAM, 0.5 CPU
- **Backend**: 2GB RAM, 2 CPU
- **Frontend**: 1GB RAM, 1 CPU

### Scaling

To scale services:

```bash
# Scale backend instances
docker-compose -f docker-compose.production.yml up -d --scale backend=3

# Scale frontend instances
docker-compose -f docker-compose.production.yml up -d --scale frontend=2
```

## 🚨 Troubleshooting

### Common Issues

1. **Services not starting**:
   ```bash
   # Check logs
   docker-compose -f docker-compose.production.yml logs
   
   # Check resource usage
   docker stats
   ```

2. **Database connection issues**:
   ```bash
   # Check PostgreSQL logs
   docker-compose -f docker-compose.production.yml logs postgres
   
   # Test connection
   docker-compose -f docker-compose.production.yml exec postgres pg_isready -U nxzen_user
   ```

3. **Frontend not loading**:
   ```bash
   # Check Nginx logs
   docker-compose -f docker-compose.production.yml logs frontend
   
   # Test Nginx
   curl -I http://localhost:2036
   ```

### Health Checks

```bash
# Check all service health
docker-compose -f docker-compose.production.yml ps

# Check specific service
docker-compose -f docker-compose.production.yml exec backend curl -f http://localhost:2035/api/health
```

## 📞 Support

For production support:
- Check logs first: `./scripts/deploy-production.sh logs`
- Review monitoring: `http://149.102.158.71:9090`
- Contact development team

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)

---

**Note**: This is a production deployment guide. Always test changes in a staging environment before applying to production.
