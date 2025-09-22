# 🚀 Production Deployment Guide - Contabo Server

## 📋 Server Information

- **Server IP**: 149.102.158.71
- **Application**: NXZEN Employee Management System
- **Database**: PostgreSQL with 33 tables
- **Frontend**: React with Nginx
- **Backend**: Node.js with Express

## 🔧 Prerequisites

### Server Requirements

- Ubuntu 20.04+ or CentOS 8+
- Docker 20.10+
- Docker Compose 2.0+
- Minimum 4GB RAM
- Minimum 20GB storage

### Install Docker and Docker Compose

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

# Verify installation
docker --version
docker-compose --version
```

## 🚀 Deployment Steps

### 1. Upload Application Files

```bash
# Upload all files to server
scp -r /path/to/onboard root@149.102.158.71:/opt/nxzen-hrms/
```

### 2. Connect to Server

```bash
ssh root@149.102.158.71
cd /opt/nxzen-hrms
```

### 3. Set Permissions

```bash
# Make scripts executable
chmod +x deploy.sh
chmod +x run-migration.sh
chmod +x verify-migration.sh
chmod +x test-deployment.sh
```

### 4. Run Full Deployment

```bash
# Full deployment with all 33 tables
./deploy.sh
```

### 5. Verify Deployment

```bash
# Check deployment status
./deploy.sh status

# Check logs
./deploy.sh logs backend
./deploy.sh logs frontend
```

## 🌐 Access URLs

### Application URLs

- **Frontend**: http://149.102.158.71:2025
- **Backend API**: http://149.102.158.71:2026/api
- **Health Check**: http://149.102.158.71:2025/health

### Default Login Credentials

- **Admin**: admin@nxzen.com / admin123
- **HR**: hr@nxzen.com / hr123
- **Manager**: manager@nxzen.com / manager123

## 🔧 Configuration Files

### Database Configuration

- **Database**: nxzen_hrms_prod
- **User**: nxzen_user
- **Password**: NxzenSecurePass2025!
- **Host**: postgres (Docker internal)
- **Port**: 5432

### Redis Configuration

- **Host**: redis (Docker internal)
- **Port**: 6379
- **Password**: nxzen_redis_password_2024

### Application Ports

- **Frontend**: 2025 (HTTP)
- **Backend**: 2026 (HTTP)
- **PostgreSQL**: 5432 (localhost only)
- **Redis**: 6379 (localhost only)

## 📊 Database Tables (33 Total)

### Core Tables (7)

- users, employee_master, employee_forms, onboarded_employees
- managers, manager_employee_mapping, company_emails

### Attendance System (2)

- attendance, attendance_settings

### Leave Management (5)

- leave_types, leave_requests, leave_balances, leave_type_balances, comp_off_balances

### Expense Management (4)

- expense_categories, expense_requests, expense_attachments, expenses

### Document Management (5)

- document_templates, document_collection, employee_documents, document_reminder_mails, documents

### System Configuration (4)

- departments, relations, system_settings, migration_log

### Additional Business Tables (6)

- adp_payroll, employees_combined, onboarding
- pnc_monitoring_breakdowns, pnc_monitoring_reports, recruitment_requisitions

## 🛠️ Management Commands

### Deployment Commands

```bash
# Full deployment
./deploy.sh

# Database setup only
./deploy.sh database

# Stop services
./deploy.sh stop

# Start services
./deploy.sh start

# Restart services
./deploy.sh restart

# Show status
./deploy.sh status

# View logs
./deploy.sh logs [service_name]

# Cleanup images
./deploy.sh cleanup

# Create backup
./deploy.sh backup
```

### Database Commands

```bash
# Run migration only
./run-migration.sh

# Verify migration
./verify-migration.sh

# Test deployment
./test-deployment.sh
```

## 🔒 Security Configuration

### Firewall Setup

```bash
# Allow required ports
sudo ufw allow 2025/tcp  # Frontend
sudo ufw allow 2026/tcp  # Backend
sudo ufw allow 22/tcp    # SSH
sudo ufw enable
```

### SSL Configuration (Optional)

```bash
# Install Certbot
sudo apt install certbot

# Generate SSL certificate
sudo certbot certonly --standalone -d your-domain.com

# Update nginx configuration for SSL
# (Manual configuration required)
```

## 📈 Monitoring and Maintenance

### Health Checks

```bash
# Check all services
docker-compose -f docker-compose.prod.yml ps

# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Check resource usage
docker stats
```

### Backup Strategy

```bash
# Manual backup
./deploy.sh backup

# Automated backup (cron job)
# Add to crontab: 0 2 * * * /opt/nxzen-hrms/deploy.sh backup
```

### Log Management

```bash
# View application logs
docker-compose -f docker-compose.prod.yml logs backend
docker-compose -f docker-compose.prod.yml logs frontend

# Clean old logs
docker system prune -f
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Already in Use

```bash
# Check what's using the port
sudo netstat -tulpn | grep :2025
sudo netstat -tulpn | grep :2026

# Kill the process
sudo kill -9 <PID>
```

#### 2. Database Connection Issues

```bash
# Check database container
docker-compose -f docker-compose.prod.yml logs postgres

# Restart database
docker-compose -f docker-compose.prod.yml restart postgres
```

#### 3. Permission Issues

```bash
# Fix file permissions
sudo chown -R $USER:$USER /opt/nxzen-hrms
chmod -R 755 /opt/nxzen-hrms
```

#### 4. Memory Issues

```bash
# Check memory usage
free -h
docker stats

# Clean up Docker
docker system prune -a -f
```

### Log Locations

- **Application Logs**: `/opt/nxzen-hrms/logs/`
- **Docker Logs**: `docker-compose -f docker-compose.prod.yml logs`
- **System Logs**: `/var/log/syslog`

## 📞 Support

### Quick Commands

```bash
# Show help
./deploy.sh help

# Test deployment
./test-deployment.sh

# Verify migration
./verify-migration.sh
```

### Contact Information

- **Company**: NXZEN Technologies
- **Email**: hr@nxzen.com
- **Phone**: +1-555-0123

---

**Your NXZEN Employee Management System is now ready for production!** 🎉
