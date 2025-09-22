# NXZEN HR Employee Onboarding System - Database Setup Guide

This guide will help you set up the complete database for the NXZEN HR Employee Onboarding System.

## Prerequisites

Before running the setup, ensure you have the following installed:

1. **PostgreSQL** (version 12 or higher)
2. **Node.js** (version 16 or higher)
3. **npm** (comes with Node.js)

### Installing PostgreSQL

#### On macOS (using Homebrew):

```bash
brew install postgresql
brew services start postgresql
```

#### On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### On Windows:

Download and install from [PostgreSQL Official Website](https://www.postgresql.org/download/windows/)

## Quick Setup (Recommended)

1. **Clone or download the project**
2. **Navigate to the project directory**
3. **Run the automated setup script**:
   ```bash
   ./setup-database.sh
   ```

The script will:

- Check PostgreSQL connection
- Create the database
- Run all migrations
- Create sample data
- Verify the installation

## Manual Setup

If you prefer to set up manually or the automated script doesn't work:

### Step 1: Create Database

```bash
# Connect to PostgreSQL
psql -h localhost -U postgres -d postgres

# Create database
CREATE DATABASE onboardd;

# Exit psql
\q
```

### Step 2: Run Migration

```bash
# Run the complete migration
psql -h localhost -U postgres -d onboardd -f backend/migrations/000CompleteDatabaseSetup.sql
```

### Step 3: Verify Installation

```bash
# Check if tables were created
psql -h localhost -U postgres -d onboardd -c "\dt"
```

## Database Structure

The migration creates the following main tables:

### Core Tables

- `users` - User authentication and profiles
- `employee_master` - Final employee records
- `employee_forms` - Onboarding form submissions
- `onboarded_employees` - Intermediate approval stage
- `managers` - Manager information

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

- `pnc_monitoring_reports` - Monthly monitoring reports

## Sample Data

The setup creates sample users:

- **HR Admin**: `hr@nxzen.com` (password: `password`)
- **Manager**: `manager@nxzen.com` (password: `password`)

## Environment Configuration

After database setup, update your `.env` file:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onboardd
DB_USER=postgres
DB_PASSWORD=your_postgres_password

# JWT Configuration
JWT_SECRET=your_jwt_secret_here

# Server Configuration
PORT=5001
NODE_ENV=development
```

## Starting the Application

1. **Install dependencies**:

   ```bash
   # Backend
   cd backend
   npm install

   # Frontend
   cd ../frontend
   npm install
   ```

2. **Start the backend**:

   ```bash
   cd backend
   npm start
   ```

3. **Start the frontend** (in a new terminal):

   ```bash
   cd frontend
   npm start
   ```

4. **Access the application**:
   - Frontend: http://localhost:3001
   - Backend API: http://localhost:5001

## Troubleshooting

### Common Issues

1. **PostgreSQL connection failed**:

   - Ensure PostgreSQL is running
   - Check if the user has proper permissions
   - Verify the connection details

2. **Permission denied on setup script**:

   ```bash
   chmod +x setup-database.sh
   ```

3. **Migration fails**:

   - Check PostgreSQL logs
   - Ensure the database exists
   - Verify user permissions

4. **Tables not created**:
   - Check if the migration file exists
   - Verify the database connection
   - Look for error messages in the output

### Getting Help

If you encounter issues:

1. Check the PostgreSQL logs
2. Verify all prerequisites are installed
3. Ensure proper permissions
4. Check the migration file exists and is readable

## Database Features

The database includes:

- **Complete HR Management**: Employee lifecycle from onboarding to offboarding
- **Document Management**: Upload and track required documents
- **Attendance System**: Track daily attendance and work hours
- **Leave Management**: Handle leave requests and balances
- **Expense Management**: Process expense claims
- **ADP Payroll Integration**: Complete payroll data structure
- **P&C Monitoring**: Generate monthly reports
- **Role-based Access**: Different access levels for employees, managers, and HR
- **Audit Trails**: Track all changes and updates
- **Performance Optimized**: Proper indexes and constraints

## Security Notes

- Change default passwords after setup
- Use strong JWT secrets in production
- Regularly backup the database
- Keep PostgreSQL updated
- Use environment variables for sensitive data

## Support

If you need help with the setup, please check:

1. This documentation
2. PostgreSQL documentation
3. The project's main README file

---

**Happy coding! 🚀**
