# 🔄 Data Migration Guide

This guide explains how to migrate data from an existing Onboard database to the new complete structure.

## 📋 What is Data Migration?

Data migration is the process of updating your existing database to match the new complete schema while preserving all your current data. This includes:

- **Adding missing columns** to existing tables
- **Creating new tables** for enhanced functionality
- **Migrating data** to new structures
- **Validating data integrity** after migration
- **Creating indexes** for better performance

## 🚀 Quick Migration (Recommended)

### Automated Migration

```bash
# Run the automated migration script
./run-migration.sh
```

This script will:

- ✅ Check database connectivity
- ✅ Verify database exists
- ✅ Warn about data modification
- ✅ Run the migration automatically
- ✅ Validate results
- ✅ Report any issues

## 🔧 Manual Migration

If you prefer to run the migration manually:

### 1. Backup Your Database

```bash
# Create a backup before migration
pg_dump -U postgres -h localhost onboardd > backup_before_migration.sql
```

### 2. Run Migration Script

```bash
# Run the migration SQL file
psql -U postgres -d onboardd -f DATA_MIGRATION.sql
```

### 3. Verify Results

```bash
# Check migration status
psql -U postgres -d onboardd -c "SELECT * FROM migration_log WHERE migration_name = 'DATA_MIGRATION_SCRIPT';"
```

## 📊 What Gets Migrated?

### User Data

- ✅ Adds `is_temp_password` column
- ✅ Adds emergency contact fields
- ✅ Preserves all existing user data

### Employee Forms

- ✅ Ensures DOJ is stored in `form_data` JSON
- ✅ Migrates emergency contact data to JSON structure
- ✅ Preserves all form submissions

### Leave Management

- ✅ Creates `leave_types` table with standard types
- ✅ Creates `leave_type_balances` for detailed tracking
- ✅ Migrates existing leave data

### Document Management

- ✅ Creates `document_templates` with standard requirements
- ✅ Ensures document structure consistency
- ✅ Preserves all uploaded documents

### System Configuration

- ✅ Creates `system_settings` with defaults
- ✅ Creates `relations` table for emergency contacts
- ✅ Creates `expense_categories` for expense management
- ✅ Creates `attendance_settings` for attendance rules

### Data Cleanup

- ✅ Removes orphaned records
- ✅ Validates data integrity
- ✅ Creates performance indexes

## 🔍 Migration Validation

After migration, the script validates:

### Data Counts

- Total users
- Total employees
- Total forms
- Total documents
- Total leave requests
- Total attendance records
- Total expense records

### Data Integrity

- Users without employee records
- Forms without DOJ data
- Orphaned records
- Missing relationships

## ⚠️ Important Notes

### Before Migration

1. **Always backup your database** before running migration
2. **Test on a copy first** if possible
3. **Ensure PostgreSQL is running** and accessible
4. **Check disk space** for the migration process

### During Migration

1. **Don't interrupt the process** - let it complete
2. **Monitor the output** for any error messages
3. **Keep the terminal open** until completion

### After Migration

1. **Test your application** thoroughly
2. **Check the migration_log table** for details
3. **Verify all data** is accessible
4. **Report any issues** immediately

## 🛠️ Troubleshooting

### Common Issues

#### 1. Permission Denied

```bash
# Make sure you have proper permissions
sudo -u postgres psql -d onboardd -f DATA_MIGRATION.sql
```

#### 2. Database Connection Failed

```bash
# Check if PostgreSQL is running
sudo service postgresql status
sudo service postgresql start
```

#### 3. Migration Already Run

```bash
# Check migration status
psql -U postgres -d onboardd -c "SELECT * FROM migration_log;"

# Reset migration status if needed
psql -U postgres -d onboardd -c "DELETE FROM migration_log WHERE migration_name = 'DATA_MIGRATION_SCRIPT';"
```

#### 4. Data Validation Errors

```bash
# Check specific data issues
psql -U postgres -d onboardd -c "SELECT COUNT(*) FROM users WHERE email IS NULL;"
psql -U postgres -d onboardd -c "SELECT COUNT(*) FROM employee_forms WHERE form_data IS NULL;"
```

### Recovery Options

#### 1. Restore from Backup

```bash
# Stop application
# Drop current database
dropdb -U postgres onboardd

# Restore from backup
psql -U postgres -c "CREATE DATABASE onboardd;"
psql -U postgres -d onboardd -f backup_before_migration.sql
```

#### 2. Partial Rollback

```bash
# Check what was changed
psql -U postgres -d onboardd -c "SELECT * FROM migration_log ORDER BY executed_at DESC LIMIT 10;"

# Manually fix specific issues
# (Contact support for specific rollback procedures)
```

## 📈 Performance After Migration

### New Indexes Created

- `idx_users_email` - Faster user lookups
- `idx_employee_forms_employee_id` - Faster form queries
- `idx_attendance_employee_date` - Faster attendance queries
- `idx_leave_requests_employee_id` - Faster leave queries
- `idx_employee_documents_employee_id` - Faster document queries

### Expected Improvements

- ⚡ **Faster queries** due to new indexes
- 🔍 **Better data organization** with new tables
- 📊 **Enhanced reporting** capabilities
- 🛡️ **Better data integrity** with constraints

## 📞 Support

If you encounter issues during migration:

1. **Check the migration log**:

   ```sql
   SELECT * FROM migration_log WHERE migration_name = 'DATA_MIGRATION_SCRIPT';
   ```

2. **Verify database state**:

   ```sql
   SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';
   ```

3. **Check for errors**:

   ```sql
   SELECT * FROM migration_log WHERE status != 'COMPLETED';
   ```

4. **Contact support** with:
   - Migration log output
   - Error messages
   - Database version
   - Operating system

## 🎯 Success Criteria

Migration is successful when:

- ✅ All tables are created
- ✅ Data counts match expectations
- ✅ No orphaned records
- ✅ All indexes are created
- ✅ Application works correctly
- ✅ Migration log shows "COMPLETED" status

---

**Remember**: Always backup your data before running any migration! 🛡️
