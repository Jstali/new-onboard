# Database Migrations

This directory contains database migration files for the Onboard HR System.

## Migration Files

### 002_enhanced_employee_management.sql

**Purpose**: Adds enhanced employee management features including performance tracking, employee reviews, and advanced reporting capabilities.

**New Features Added**:

#### Performance Management
- **employee_performance_reviews**: Track employee performance reviews with ratings, goals, and feedback
- **performance_goals**: Set and track individual and team performance goals
- **performance_metrics**: Record and measure various performance metrics

#### Training & Development
- **training_programs**: Manage internal and external training programs
- **employee_training_records**: Track employee training completion and certifications
- **skills**: Define and manage skill categories
- **employee_skills**: Track employee skills and proficiency levels

#### Advanced Reporting
- **employee_reports**: Generate and schedule custom reports
- **dashboard_widgets**: Configurable dashboard widgets
- **user_dashboard_preferences**: User-specific dashboard customizations

#### Notification System
- **notifications**: User notifications and alerts
- **notification_templates**: Reusable notification templates

#### Audit & Compliance
- **audit_logs**: Track all database changes and user actions
- **compliance_requirements**: Define compliance requirements
- **employee_compliance_records**: Track employee compliance status

## Running Migrations

### Method 1: Using the Shell Script (Recommended)

```bash
# Navigate to the backend directory
cd backend

# Run a specific migration
./run-migration.sh 002_enhanced_employee_management.sql
```

### Method 2: Using Node.js Script

```bash
# Navigate to the backend directory
cd backend

# Run a specific migration
node scripts/runMigration.js 002_enhanced_employee_management.sql
```

### Method 3: Direct SQL Execution

```bash
# Using psql directly
psql -U postgres -d onboardd -f migrations/002_enhanced_employee_management.sql
```

## Migration Safety Features

- **Backup Warning**: Scripts warn you to backup your database before running
- **Duplicate Prevention**: Checks if migration has already been run
- **Error Logging**: All migration attempts are logged in the `migration_log` table
- **Data Validation**: Validates data integrity after migration
- **Rollback Information**: Provides information for manual rollback if needed

## Before Running Migrations

1. **Backup Your Database**: Always create a backup before running migrations
   ```bash
   pg_dump -U postgres -d onboardd > backup_before_migration_$(date +%Y%m%d_%H%M%S).sql
   ```

2. **Check Database Connection**: Ensure your database is running and accessible

3. **Verify Configuration**: Make sure `config.env` has correct database credentials

## After Running Migrations

1. **Verify Results**: Check the migration log table for success status
   ```sql
   SELECT * FROM migration_log WHERE migration_name = 'ENHANCED_EMPLOYEE_MANAGEMENT_MIGRATION';
   ```

2. **Test New Features**: Verify that new tables and features are working correctly

3. **Update Application Code**: Modify your application to use the new database features

## Migration Log

All migrations are logged in the `migration_log` table with the following information:
- Migration name
- Execution timestamp
- Status (STARTED, COMPLETED, FAILED)
- Details about what was done
- Error messages (if any)

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure the shell script is executable
   ```bash
   chmod +x run-migration.sh
   ```

2. **Database Connection Failed**: Check your `config.env` file and ensure the database is running

3. **Migration Already Run**: The script will ask if you want to run it again

4. **Missing Dependencies**: Run `npm install` in the backend directory

### Getting Help

If you encounter issues:
1. Check the migration log table for error details
2. Verify your database connection and permissions
3. Ensure all required dependencies are installed
4. Check the console output for specific error messages

## Creating New Migrations

When creating new migration files:

1. Use the naming convention: `XXX_descriptive_name.sql`
2. Include proper migration logging
3. Use `IF NOT EXISTS` clauses for safety
4. Include data validation
5. Add appropriate indexes for performance
6. Include sample data where appropriate
7. Update this README with migration details
