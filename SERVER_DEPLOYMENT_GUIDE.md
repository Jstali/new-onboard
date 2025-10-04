# 🚀 NXZEN HRMS Server Deployment Guide

## 📋 Overview

This guide provides step-by-step instructions for deploying the NXZEN Employee Management System to a production server using Docker containers.

## 🎯 Prerequisites

### System Requirements
- **OS**: Ubuntu 20.04 LTS or newer
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: Minimum 20GB free space
- **CPU**: 2+ cores
- **Network**: Public IP with ports 2035 and 2036 accessible

### Software Requirements
- Docker Engine 20.10+
- Docker Compose 2.0+
- Git
- curl
- sudo privileges

## 🔧 Server Setup

### 1. Install Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 2. Create Application Directory

```bash
# Create project directory
sudo mkdir -p /opt/nxzen
sudo chown $USER:$USER /opt/nxzen
cd /opt/nxzen

# Clone repository
git clone https://github.com/Jstali/new-onboard.git .
git checkout shibin
```

### 3. Setup Environment

```bash
# Copy server environment file
cp server.env .env

# Create data directories
sudo mkdir -p /opt/nxzen/data/{postgres,redis,uploads,logs,backups,prometheus}
sudo chown -R $USER:$USER /opt/nxzen/data

# Create backup directory
sudo mkdir -p /opt/nxzen/backups
sudo chown $USER:$USER /opt/nxzen/backups
```

## 🚀 Deployment

### Option 1: Automated Deployment (Recommended)

```bash
# Make deployment script executable
chmod +x scripts/deploy-server.sh

# Deploy application
./scripts/deploy-server.sh deploy
```

### Option 2: Manual Deployment

```bash
# Build and start services
docker-compose -f docker-compose.production.yml up -d --build

# Check service status
docker-compose -f docker-compose.production.yml ps

# View logs
docker-compose -f docker-compose.production.yml logs -f
```

## 🔍 Verification

### Health Checks

```bash
# Backend health check
curl -f http://localhost:2035/api/health

# Frontend health check
curl -f http://localhost:2036/health

# Check container status
docker-compose -f docker-compose.production.yml ps
```

### Application Access

- **Frontend**: http://149.102.158.71:2036
- **Backend API**: http://149.102.158.71:2035/api
- **Health Check**: http://149.102.158.71:2036/health

## 📊 Monitoring

### Container Status
```bash
# View running containers
docker ps

# View resource usage
docker stats

# View logs
docker-compose -f docker-compose.production.yml logs -f
```

### Application Logs
```bash
# Backend logs
docker-compose -f docker-compose.production.yml logs -f backend

# Frontend logs
docker-compose -f docker-compose.production.yml logs -f frontend

# Database logs
docker-compose -f docker-compose.production.yml logs -f postgres
```

## 🔄 Management Commands

### Deployment Script Commands

```bash
# Deploy application
./scripts/deploy-server.sh deploy

# Show status
./scripts/deploy-server.sh status

# View logs
./scripts/deploy-server.sh logs

# Rollback deployment
./scripts/deploy-server.sh rollback

# Clean up old images
./scripts/deploy-server.sh cleanup

# Show help
./scripts/deploy-server.sh help
```

### Docker Compose Commands

```bash
# Start services
docker-compose -f docker-compose.production.yml up -d

# Stop services
docker-compose -f docker-compose.production.yml down

# Restart services
docker-compose -f docker-compose.production.yml restart

# Rebuild and start
docker-compose -f docker-compose.production.yml up -d --build

# View logs
docker-compose -f docker-compose.production.yml logs -f
```

## 💾 Backup and Restore

### Database Backup
```bash
# Manual backup
docker-compose -f docker-compose.production.yml exec postgres pg_dump -U nxzen_user nxzen_hrms_prod > backup-$(date +%Y%m%d-%H%M%S).sql

# Automated backup (runs daily at 2 AM)
# Configured in docker-compose.production.yml
```

### Database Restore
```bash
# Restore from backup
docker-compose -f docker-compose.production.yml exec -T postgres psql -U nxzen_user -d nxzen_hrms_prod < backup-file.sql
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Check port usage
sudo ss -tuln | grep :2035
sudo ss -tuln | grep :2036

# Kill process using port
sudo fuser -k 2035/tcp
sudo fuser -k 2036/tcp
```

#### 2. Container Won't Start
```bash
# Check container logs
docker-compose -f docker-compose.production.yml logs container_name

# Check container status
docker-compose -f docker-compose.production.yml ps

# Restart specific container
docker-compose -f docker-compose.production.yml restart container_name
```

#### 3. Database Connection Issues
```bash
# Check database logs
docker-compose -f docker-compose.production.yml logs postgres

# Test database connection
docker-compose -f docker-compose.production.yml exec postgres pg_isready -U nxzen_user
```

#### 4. Permission Issues
```bash
# Fix directory permissions
sudo chown -R $USER:$USER /opt/nxzen/data
sudo chmod -R 755 /opt/nxzen/data
```

### Log Locations

- **Application Logs**: `/opt/nxzen/data/logs/`
- **Deployment Logs**: `/var/log/nxzen-deploy.log`
- **Container Logs**: `docker-compose logs`

## 🔒 Security Considerations

### Firewall Configuration
```bash
# Allow required ports
sudo ufw allow 2035/tcp
sudo ufw allow 2036/tcp
sudo ufw allow 22/tcp  # SSH
sudo ufw enable
```

### SSL/TLS Setup (Optional)
```bash
# Generate SSL certificates (using Let's Encrypt)
sudo apt install certbot
sudo certbot certonly --standalone -d your-domain.com

# Update nginx configuration to use SSL
# See nginx.prod.conf for SSL configuration
```

### Regular Updates
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Docker images
docker-compose -f docker-compose.production.yml pull
docker-compose -f docker-compose.production.yml up -d
```

## 📈 Performance Optimization

### Resource Limits
The Docker Compose configuration includes resource limits for optimal performance:

- **Backend**: 2GB RAM, 2 CPU cores
- **Frontend**: 1GB RAM, 1 CPU core
- **Database**: 2GB RAM, 1 CPU core
- **Redis**: 512MB RAM, 0.5 CPU cores

### Monitoring
```bash
# Install monitoring tools
sudo apt install htop iotop

# Monitor resource usage
htop
iotop
docker stats
```

## 🆘 Support

### Getting Help

1. **Check Logs**: Always check application and container logs first
2. **Health Checks**: Verify all health check endpoints are responding
3. **Resource Usage**: Monitor CPU, memory, and disk usage
4. **Network**: Ensure ports are accessible and firewall rules are correct

### Contact Information

- **Technical Support**: [Your Support Email]
- **Documentation**: [Your Documentation URL]
- **Issues**: [Your Issue Tracker URL]

## 📝 Maintenance

### Regular Tasks

1. **Daily**: Monitor application health and logs
2. **Weekly**: Review resource usage and performance
3. **Monthly**: Update system packages and Docker images
4. **Quarterly**: Review and rotate security credentials

### Update Procedure

```bash
# Pull latest changes
git pull origin shibin

# Deploy updates
./scripts/deploy-server.sh deploy

# Verify deployment
./scripts/deploy-server.sh status
```

---

## ✅ Deployment Checklist

- [ ] Server requirements met
- [ ] Docker and Docker Compose installed
- [ ] Application directory created
- [ ] Environment file configured
- [ ] Data directories created with proper permissions
- [ ] Application deployed successfully
- [ ] Health checks passing
- [ ] Firewall configured
- [ ] Backup strategy implemented
- [ ] Monitoring setup
- [ ] SSL/TLS configured (if required)
- [ ] Documentation updated

**🎉 Congratulations! Your NXZEN HRMS is now deployed and ready for production use!**
