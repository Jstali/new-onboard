# 🚀 Contabo Server Deployment - Complete Setup

## 📋 Server Configuration

- **Server IP**: 149.102.158.71
- **Application**: NXZEN Employee Management System
- **Database**: PostgreSQL with 33 tables
- **Frontend**: React with Nginx (Port 2025)
- **Backend**: Node.js with Express (Port 2026)

## 🔧 Files Updated for Production

### 1. **Backend Configuration**

- ✅ `backend/production.env` - Updated database credentials and URLs
- ✅ `backend/Dockerfile` - Updated port to 2026
- ✅ Database name: `nxzen_hrms_prod`
- ✅ Database user: `nxzen_user`
- ✅ Database password: `NxzenSecurePass2025!`

### 2. **Frontend Configuration**

- ✅ `frontend/production.env` - Created production environment file
- ✅ `frontend/Dockerfile` - Updated to use production environment
- ✅ `frontend/nginx.conf` - Updated for Contabo server URLs
- ✅ API URL: `http://149.102.158.71:2026/api`

### 3. **Docker Configuration**

- ✅ `docker-compose.prod.yml` - Updated database credentials and URLs
- ✅ `DATA_MIGRATION.sql` - Integrated for automatic table creation
- ✅ All 33 tables will be created automatically

### 4. **Deployment Scripts**

- ✅ `deploy.sh` - Updated with database setup
- ✅ `deploy-contabo.sh` - New Contabo-specific deployment script
- ✅ `PRODUCTION_DEPLOYMENT_GUIDE.md` - Complete deployment guide

## 🚀 Quick Deployment Commands

### Option 1: Full Deployment (Recommended)

```bash
# Upload files to server
scp -r /path/to/onboard root@149.102.158.71:/opt/nxzen-hrms/

# Connect to server
ssh root@149.102.158.71
cd /opt/nxzen-hrms

# Run deployment
./deploy-contabo.sh
```

### Option 2: Standard Deployment

```bash
# Upload files to server
scp -r /path/to/onboard root@149.102.158.71:/opt/nxzen-hrms/

# Connect to server
ssh root@149.102.158.71
cd /opt/nxzen-hrms

# Make scripts executable
chmod +x deploy.sh run-migration.sh verify-migration.sh

# Run deployment
./deploy.sh
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

## 📊 Database Configuration

### Database Details

- **Database Name**: nxzen_hrms_prod
- **Username**: nxzen_user
- **Password**: NxzenSecurePass2025!
- **Host**: postgres (Docker internal)
- **Port**: 5432

### Tables Created (33 Total)

- **Core Tables**: users, employee_master, employee_forms, onboarded_employees, managers, manager_employee_mapping, company_emails
- **Attendance**: attendance, attendance_settings
- **Leave Management**: leave_types, leave_requests, leave_balances, leave_type_balances, comp_off_balances
- **Expense Management**: expense_categories, expense_requests, expense_attachments, expenses
- **Document Management**: document_templates, document_collection, employee_documents, document_reminder_mails, documents
- **System Configuration**: departments, relations, system_settings, migration_log
- **Business Tables**: adp_payroll, employees_combined, onboarding, pnc_monitoring_breakdowns, pnc_monitoring_reports, recruitment_requisitions

## 🔒 Security Features

### Firewall Configuration

- Port 2025 (Frontend) - Open
- Port 2026 (Backend) - Open
- Port 22 (SSH) - Open
- Port 5432 (PostgreSQL) - Localhost only
- Port 6379 (Redis) - Localhost only

### Security Headers

- X-Frame-Options: SAMEORIGIN
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Content-Security-Policy: Configured for Contabo server

## 🛠️ Management Commands

### Deployment Management

```bash
# Check status
./deploy.sh status

# View logs
./deploy.sh logs backend
./deploy.sh logs frontend

# Restart services
./deploy.sh restart

# Create backup
./deploy.sh backup

# Database only
./deploy.sh database
```

### Database Management

```bash
# Run migration
./run-migration.sh

# Verify migration
./verify-migration.sh

# Test deployment
./test-deployment.sh
```

## 📈 Monitoring

### Health Checks

- **Frontend**: http://149.102.158.71:2025/health
- **Backend**: http://149.102.158.71:2026/api/health
- **Database**: Automatic health checks in Docker

### Log Locations

- **Application Logs**: `/opt/nxzen-hrms/logs/`
- **Docker Logs**: `docker-compose -f docker-compose.prod.yml logs`
- **System Logs**: `/var/log/syslog`

## 🚨 Troubleshooting

### Common Issues

1. **Port conflicts**: Check with `sudo netstat -tulpn | grep :2025`
2. **Database issues**: Check with `docker-compose -f docker-compose.prod.yml logs postgres`
3. **Permission issues**: Run `sudo chown -R $USER:$USER /opt/nxzen-hrms`
4. **Memory issues**: Check with `free -h` and `docker stats`

### Quick Fixes

```bash
# Restart all services
./deploy.sh restart

# Check service status
docker-compose -f docker-compose.prod.yml ps

# View recent logs
docker-compose -f docker-compose.prod.yml logs --tail=100

# Clean up Docker
docker system prune -f
```

## ✅ Production Ready Features

### Performance Optimizations

- ✅ Multi-stage Docker builds
- ✅ Nginx with gzip compression
- ✅ Redis for session management
- ✅ Database connection pooling
- ✅ Resource limits and reservations

### Security Features

- ✅ Non-root user execution
- ✅ Security headers
- ✅ Rate limiting
- ✅ CORS configuration
- ✅ Input validation

### Monitoring Features

- ✅ Health checks
- ✅ Logging
- ✅ Backup system
- ✅ Error handling
- ✅ Performance metrics

---

**Your NXZEN Employee Management System is now production-ready for Contabo server 149.102.158.71!** 🎉

**Next Steps:**

1. Upload files to server
2. Run `./deploy-contabo.sh`
3. Access application at http://149.102.158.71:2025
4. Login with default credentials
5. Start using the system!
