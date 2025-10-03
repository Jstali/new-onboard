# Environment Variables Configuration Guide

This guide explains how to configure the migration system using environment variables instead of hardcoded values.

## 📋 Overview

All hardcoded values in the migration files have been replaced with environment variables to make the system more flexible and configurable across different environments.

## 🔧 Environment Variables Added

### Migration Configuration
- `MIGRATION_SKIP_SAMPLE_DATA` - Skip sample data insertion (default: false)
- `MIGRATION_BACKUP_BEFORE_RUN` - Show backup warning before migration (default: true)
- `MIGRATION_VALIDATE_AFTER_RUN` - Validate data after migration (default: true)

### Company Configuration
- `COMPANY_NAME` - Company name (default: NXZEN)
- `COMPANY_EMAIL_DOMAIN` - Company email domain (default: nxzen.com)
- `HR_DEPARTMENT_EMAIL` - HR department email (default: hr@nxzen.com)
- `DEFAULT_ANNUAL_LEAVES` - Default annual leave days (default: 27)

### Training Configuration
- `DEFAULT_TRAINING_PROVIDER` - Default training provider (default: HR Department)
- `LEADERSHIP_TRAINING_COST` - Leadership training cost (default: 2500.00)
- `AGILE_TRAINING_COST` - Agile training cost (default: 800.00)
- `SECURITY_TRAINING_PROVIDER` - Security training provider (default: Security Training Co.)
- `LEADERSHIP_TRAINING_PROVIDER` - Leadership training provider (default: Leadership Institute)
- `AGILE_TRAINING_PROVIDER` - Agile training provider (default: Agile Consultants)

### Notification Configuration
- `NOTIFICATION_FROM_EMAIL` - Notification sender email (default: noreply@nxzen.com)
- `NOTIFICATION_FROM_NAME` - Notification sender name (default: NXZEN HR System)

### Dashboard Configuration
- `DEFAULT_DASHBOARD_THEME` - Default dashboard theme (default: light)
- `DEFAULT_WIDGET_SIZE` - Default widget size (default: 4x3)

### Compliance Configuration
- `COMPLIANCE_DEFAULT_FREQUENCY` - Default compliance frequency (default: annual)
- `COMPLIANCE_DEFAULT_ROLE` - Default compliance role (default: employee)

## 📁 Files Updated

### Environment Files
- `backend/config.env` - Development environment variables
- `production.env` - Production environment variables

### Migration Files
- `backend/migrations/002_enhanced_employee_management.sql` - Updated to use environment variables
- `backend/scripts/runMigration.js` - Added environment variable processing
- `backend/run-migration.sh` - Updated to display environment information

## 🚀 Usage Examples

### Development Environment
```bash
# Set environment variables in config.env
COMPANY_NAME=MyCompany
COMPANY_EMAIL_DOMAIN=mycompany.com
HR_DEPARTMENT_EMAIL=hr@mycompany.com
MIGRATION_SKIP_SAMPLE_DATA=false

# Run migration
./run-migration.sh 002_enhanced_employee_management.sql
```

### Production Environment
```bash
# Set environment variables in production.env
COMPANY_NAME=ProductionCorp
COMPANY_EMAIL_DOMAIN=productioncorp.com
HR_DEPARTMENT_EMAIL=hr@productioncorp.com
MIGRATION_SKIP_SAMPLE_DATA=true

# Run migration
node scripts/runMigration.js 002_enhanced_employee_management.sql
```

### Skip Sample Data
```bash
# Set to skip sample data insertion
export MIGRATION_SKIP_SAMPLE_DATA=true
./run-migration.sh 002_enhanced_employee_management.sql
```

## 🔄 Environment Variable Processing

The migration system processes environment variables in the following way:

1. **SQL File Processing**: Environment variables are replaced in SQL files using `${VARIABLE_NAME}` syntax
2. **Default Values**: If an environment variable is not set, default values are used
3. **Conditional Logic**: Sample data insertion can be skipped based on `MIGRATION_SKIP_SAMPLE_DATA`
4. **Validation**: All environment variables are validated before migration execution

## 📊 Sample Data Control

The `MIGRATION_SKIP_SAMPLE_DATA` environment variable controls whether sample data is inserted:

- `false` (default): Insert sample data for testing and development
- `true`: Skip sample data insertion for production environments

### Sample Data Includes:
- Skills (JavaScript, React, Node.js, etc.)
- Training programs (Orientation, Leadership, Security, etc.)
- Notification templates (Leave approval, Expense approval, etc.)
- Compliance requirements (Code of conduct, Safety training, etc.)
- Dashboard widgets (Attendance summary, Leave balance, etc.)

## 🛠️ Customization

### Adding New Environment Variables

1. **Add to .env files**:
   ```bash
   # In config.env and production.env
   NEW_VARIABLE_NAME=default_value
   ```

2. **Update runMigration.js**:
   ```javascript
   const envVars = {
     // ... existing variables
     'NEW_VARIABLE_NAME': process.env.NEW_VARIABLE_NAME || 'default_value'
   };
   ```

3. **Use in SQL files**:
   ```sql
   -- Use ${NEW_VARIABLE_NAME} in your SQL
   INSERT INTO table (column) VALUES ('${NEW_VARIABLE_NAME}');
   ```

### Modifying Default Values

To change default values, update the `replaceEnvironmentVariables` function in `runMigration.js`:

```javascript
const envVars = {
  'COMPANY_NAME': process.env.COMPANY_NAME || 'YourNewDefault',
  // ... other variables
};
```

## 🔍 Troubleshooting

### Common Issues

1. **Environment variables not loaded**:
   - Ensure `.env` file is in the correct location
   - Check file permissions
   - Verify variable names match exactly

2. **Sample data not skipped**:
   - Check `MIGRATION_SKIP_SAMPLE_DATA` value (must be 'true')
   - Ensure environment variable is loaded before migration

3. **Default values not working**:
   - Check the `replaceEnvironmentVariables` function
   - Verify variable names in SQL files match environment variable names

### Debug Mode

To debug environment variable processing:

```bash
# Enable debug logging
export DEBUG_MIGRATION=true
./run-migration.sh 002_enhanced_employee_management.sql
```

## 📝 Best Practices

1. **Use descriptive variable names**: Make variable names clear and self-explanatory
2. **Set appropriate defaults**: Always provide sensible default values
3. **Document variables**: Keep this guide updated when adding new variables
4. **Test thoroughly**: Test migrations with different environment variable combinations
5. **Version control**: Keep sensitive values out of version control (use .env.example files)

## 🔐 Security Considerations

- Never commit sensitive values to version control
- Use different values for development and production
- Consider using secret management systems for production
- Regularly rotate sensitive values like passwords and API keys

## 📚 Related Documentation

- [Migration README](README.md) - General migration documentation
- [Database Setup Guide](../docs/DATABASE_SETUP_README.md) - Database setup instructions
- [Deployment Guide](../docs/DEPLOYMENT_README.md) - Deployment instructions
