# 🚀 Onboard Project - Ready to Run!

## Quick Start (3 Steps)

### 1. Database Setup

```bash
./setup-database.sh
```

### 2. Install Dependencies

```bash
# Backend
cd backend && npm install

# Frontend
cd ../frontend && npm install
```

### 3. Start Application

```bash
# Backend (Terminal 1)
cd backend && npm start

# Frontend (Terminal 2)
cd frontend && npm start
```

## 🔄 For Existing Databases

If you already have an Onboard database with data:

```bash
# Run data migration to update your existing database
./run-migration.sh
```

This will preserve all your existing data while adding the new features and structure.

**That's it!** 🎉

## Access the Application

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:5001

## Login Credentials

| Role    | Email             | Password    |
| ------- | ----------------- | ----------- |
| HR      | hr@nxzen.com      | password123 |
| Admin   | admin@nxzen.com   | password123 |
| Manager | manager@nxzen.com | password123 |

## What's Included

✅ Complete database with 33 tables and sample data  
✅ All user roles and permissions  
✅ Sample employees and documents  
✅ Leave management system  
✅ Attendance tracking  
✅ Document upload system  
✅ Manager-employee relationships  
✅ Expense management system  
✅ PNC monitoring functions  
✅ Complete HR workflow

## Files Created for You

- `COMPLETE_DATABASE_SETUP.sql` - Complete database schema + data
- `setup-database.sh` - Automated setup script
- `DATA_MIGRATION.sql` - Data migration script for existing databases (33 tables)
- `run-migration.sh` - Automated migration runner
- `verify-migration.sh` - Migration verification script
- `SETUP_GUIDE.md` - Detailed setup instructions
- `MIGRATION_GUIDE.md` - Data migration guide
- `config.env` - Environment configuration (auto-generated)

## Need Help?

Check `SETUP_GUIDE.md` for detailed instructions and troubleshooting.

**Happy coding!** 🚀
