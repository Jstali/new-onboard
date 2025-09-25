# 🚀 NXZEN HR Employee Onboarding System - Quick Start Guide

## What You Get

A complete HR Employee Onboarding System with:

- ✅ **Employee Management** - Full lifecycle from onboarding to offboarding
- ✅ **Document Management** - Upload and track required documents
- ✅ **Attendance System** - Track daily attendance and work hours
- ✅ **Leave Management** - Handle leave requests and balances
- ✅ **Expense Management** - Process expense claims
- ✅ **ADP Payroll Integration** - Complete payroll data structure
- ✅ **P&C Monitoring** - Generate monthly reports
- ✅ **Role-based Access** - Different access levels for employees, managers, and HR

## Prerequisites

1. **PostgreSQL** (version 12 or higher)
2. **Node.js** (version 16 or higher)
3. **npm** (comes with Node.js)

## 🎯 Super Quick Setup (3 Commands)

```bash
# 1. Install all dependencies
npm run install-all

# 2. Set up the database (creates all tables, indexes, and sample data)
npm run setup-db

# 3. Start the application
npm run dev
```

That's it! Your application will be running at:

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:5001

## 🔧 Manual Setup (If Needed)

### Step 1: Install Dependencies

```bash
npm run install-all
```

### Step 2: Set Up Database

```bash
# Option A: Use the automated script
./setup-database.sh

# Option B: Manual database setup
psql -h localhost -U postgres -d postgres -c "CREATE DATABASE onboardd;"
psql -h localhost -U postgres -d onboardd -f backend/migrations/000CompleteDatabaseSetup.sql
```

### Step 3: Start the Application

```bash
npm run dev
```

## 🧪 Test Your Setup

```bash
# Test if the database is properly set up
npm run test-db
```

## 🔑 Default Login Credentials

- **HR Admin**: `hr@nxzen.com` / `password`
- **Manager**: `manager@nxzen.com` / `password`

## 📁 Project Structure

```
onboard/
├── backend/                 # Node.js/Express backend
│   ├── migrations/          # Database migrations
│   ├── routes/             # API routes
│   └── server.js           # Main server file
├── frontend/               # React frontend
│   ├── src/
│   │   ├── components/     # React components
│   │   └── contexts/       # React contexts
│   └── public/             # Static files
├── setup-database.sh       # Database setup script
├── test-database.sh        # Database test script
└── package.json            # Project configuration
```

## 🗄️ Database Features

The system includes **25+ tables** with:

### Core Tables

- `users` - User authentication and profiles
- `employee_master` - Final employee records
- `employee_forms` - Onboarding form submissions
- `onboarded_employees` - Intermediate approval stage

### Document Management

- `document_templates` - Document type definitions
- `document_collection` - Document requirements tracking
- `employee_documents` - Uploaded documents

### Attendance System

- `attendance` - Daily attendance records
- `attendance_settings` - System configuration
- `manager_employee_mapping` - Manager-employee relationships

### Leave Management

- `leave_types` - Leave type definitions
- `leave_requests` - Leave applications
- `leave_balances` - Employee leave balances

### Expense Management

- `expense_categories` - Expense type definitions
- `expense_requests` - Expense claims

### ADP Payroll Integration

- `adp_payroll` - Complete payroll data structure

### P&C Monitoring

- `pnc_monitoring_reports` - Monthly reports

## 🚨 Troubleshooting

### Common Issues

1. **PostgreSQL not running**:

   ```bash
   # macOS
   brew services start postgresql

   # Ubuntu/Debian
   sudo systemctl start postgresql
   ```

2. **Permission denied on scripts**:

   ```bash
   chmod +x setup-database.sh test-database.sh
   ```

3. **Database connection failed**:

   - Check if PostgreSQL is running
   - Verify connection details in `.env` file
   - Ensure user has proper permissions

4. **Port already in use**:
   - Change ports in `.env` file
   - Kill existing processes: `lsof -ti:3001,5001 | xargs kill -9`

### Getting Help

1. Check the logs in the terminal
2. Verify all prerequisites are installed
3. Run `npm run test-db` to check database setup
4. Check the detailed documentation in `DATABASE_SETUP_FOR_FRIEND.md`

## 🎉 What's Next?

1. **Explore the Application**:

   - Login as HR admin
   - Create employee forms
   - Upload documents
   - Test attendance tracking

2. **Customize**:

   - Update company settings
   - Modify document templates
   - Configure leave types
   - Set up expense categories

3. **Add Real Data**:
   - Create actual employees
   - Upload real documents
   - Configure managers and departments

## 📚 Available Scripts

```bash
npm run dev              # Start both frontend and backend
npm run server           # Start only backend
npm run client           # Start only frontend
npm run setup-db         # Set up database
npm run test-db          # Test database setup
npm run install-all      # Install all dependencies
npm run build            # Build frontend for production
```

## 🔒 Security Notes

- Change default passwords after setup
- Use strong JWT secrets in production
- Regularly backup the database
- Keep PostgreSQL updated

---

**Happy coding! 🚀**

_This system combines all 5 migration files into one comprehensive setup that your friend can run easily._
