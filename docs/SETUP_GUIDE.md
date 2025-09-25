# Onboard Project - Complete Setup Guide

This guide will help you set up the Onboard project on your local machine with all the necessary database setup and sample data.

## Prerequisites

Before you begin, make sure you have the following installed:

- **Node.js** (v14 or higher)
- **PostgreSQL** (v12 or higher)
- **Git** (to clone the repository)

## Quick Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd onboard
```

### 2. Database Setup (Automated)

Run the automated database setup script:

```bash
./setup-database.sh
```

This script will:

- Check if PostgreSQL is running
- Create the database `onboardd`
- Set up all tables and relationships
- Insert sample data
- Create a `config.env` file

### 3. Manual Database Setup (Alternative)

If you prefer to set up the database manually:

1. Create a PostgreSQL database named `onboardd`
2. Run the SQL file:

```bash
psql -U postgres -d onboardd -f COMPLETE_DATABASE_SETUP.sql
```

### 4. Configure Environment Variables

Update the `config.env` file with your actual credentials:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onboardd
DB_USER=postgres
DB_PASSWORD=your_actual_password

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h

# Email Configuration
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Server Configuration
PORT=5001
NODE_ENV=development
```

### 5. Install Dependencies

```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
```

### 6. Start the Application

```bash
# Start backend (from backend directory)
npm start

# Start frontend (from frontend directory)
npm start
```

The application will be available at:

- Frontend: http://localhost:3001
- Backend API: http://localhost:5001

## Default Login Credentials

The database comes with pre-configured users for testing:

| Role     | Email                       | Password    | Description                     |
| -------- | --------------------------- | ----------- | ------------------------------- |
| HR       | hr@nxzen.com                | password123 | HR Manager account              |
| Admin    | admin@nxzen.com             | password123 | System Administrator            |
| Manager  | manager@nxzen.com           | password123 | Operations Manager              |
| Employee | stalinstalin11112@gmail.com | password123 | Sample employee (temp password) |

## Database Structure

The database includes 25+ tables with complete functionality:

### Core Tables

- `users` - User authentication and basic info
- `employee_forms` - Employee onboarding forms
- `employee_master` - Final approved employee records
- `onboarded_employees` - Intermediate approval stage

### Document Management

- `document_templates` - Document requirements
- `employee_documents` - Uploaded documents
- `document_collection` - Document tracking
- `document_reminder_mails` - Document reminder system

### Leave Management

- `leave_requests` - Leave applications
- `leave_balances` - Employee leave balances
- `leave_type_balances` - Leave type specific balances
- `leave_types` - Available leave types
- `comp_off_balances` - Compensatory off balances

### Attendance & Expenses

- `attendance` - Daily attendance records
- `attendance_settings` - Attendance configuration
- `expenses` - Expense claims
- `expense_categories` - Expense categories
- `expense_requests` - Expense request workflow
- `expense_attachments` - Expense file attachments

### Management & Relationships

- `manager_employee_mapping` - Manager-employee relationships
- `managers` - Manager information
- `departments` - Department management
- `company_emails` - Company email assignments

### System & Configuration

- `system_settings` - System-wide settings
- `relations` - Emergency contact relationships
- `migration_log` - Database migration tracking

### Advanced Features

- `pnc_monitoring_reports` - P&C monitoring system
- `pnc_monitoring_breakdowns` - Detailed monitoring data
- `recruitment_requisitions` - Recruitment management
- `onboarding` - Onboarding workflow tracking

## Sample Data Included

The database comes with:

- 4 sample users (HR, Admin, Manager, Employee)
- Sample employee records with complete data
- Document templates for all requirements
- Sample leave balances and leave types
- Sample attendance records
- Manager-employee mappings
- Expense categories and system settings
- Complete HR workflow data
- PNC monitoring functions

## Troubleshooting

### Common Issues

1. **PostgreSQL not running**

   ```bash
   # Ubuntu/Debian
   sudo service postgresql start

   # macOS (with Homebrew)
   brew services start postgresql

   # Windows
   net start postgresql
   ```

2. **Permission denied error**

   - Make sure your PostgreSQL user has permission to create databases
   - You might need to run: `sudo -u postgres psql`

3. **Port already in use**

   - Change the PORT in config.env if 5001 is already in use
   - Update the frontend API calls if you change the backend port

4. **Email configuration**
   - For Gmail, use App Passwords instead of your regular password
   - Enable 2-factor authentication and generate an App Password

### Database Reset

If you need to reset the database:

```bash
psql -U postgres -c "DROP DATABASE IF EXISTS onboardd;"
./setup-database.sh
```

## Project Structure

```
onboard/
├── backend/                 # Backend API server
│   ├── routes/             # API routes
│   ├── config/             # Database configuration
│   ├── middleware/         # Authentication middleware
│   └── uploads/            # File uploads
├── frontend/               # React frontend
│   ├── src/
│   │   ├── components/     # React components
│   │   └── contexts/       # React contexts
│   └── public/             # Static files
├── COMPLETE_DATABASE_SETUP.sql  # Complete database schema
├── setup-database.sh       # Automated setup script
└── SETUP_GUIDE.md         # This file
```

## Features

The Onboard project includes:

- **Employee Onboarding**: Complete onboarding workflow
- **Document Management**: Upload and manage employee documents
- **Leave Management**: Leave requests and approvals
- **Attendance Tracking**: Daily attendance management
- **Expense Management**: Expense claims and approvals
- **Manager Dashboard**: Manager-specific views and actions
- **HR Dashboard**: HR management tools
- **Role-based Access**: Different access levels for different roles

## Support

If you encounter any issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Check the console logs for error messages
4. Ensure PostgreSQL is running and accessible

## Development

For development:

- Backend runs on port 5001
- Frontend runs on port 3001
- Database runs on default PostgreSQL port 5432
- Hot reload is enabled for both frontend and backend

Happy coding! 🚀
