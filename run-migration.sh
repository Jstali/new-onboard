#!/bin/bash

# =============================================================================
# DATA MIGRATION RUNNER SCRIPT
# =============================================================================
# This script runs the data migration on an existing database
# 
# Prerequisites:
# 1. PostgreSQL must be installed and running
# 2. psql command must be available in PATH
# 3. Database must exist and be accessible
# =============================================================================

echo "🔄 Starting Data Migration Process..."
echo "====================================="

# Database configuration
DB_NAME="onboardd"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if PostgreSQL is running
echo "🔍 Checking PostgreSQL connection..."
if ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER > /dev/null 2>&1; then
    print_error "PostgreSQL is not running or not accessible!"
    print_error "Please make sure PostgreSQL is installed and running."
    exit 1
fi
print_status "PostgreSQL is running"

# Check if database exists
echo "🔍 Checking if database '$DB_NAME' exists..."
if ! psql -h $DB_HOST -p $DB_PORT -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_error "Database '$DB_NAME' does not exist!"
    print_error "Please create the database first or run the setup-database.sh script."
    exit 1
fi
print_status "Database '$DB_NAME' exists"

# Backup warning
print_warning "IMPORTANT: This will modify your existing database!"
print_warning "Make sure you have a backup before proceeding."
echo ""
read -p "Do you want to continue with the migration? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Migration cancelled by user"
    exit 0
fi

# Check if migration has already been run
echo "🔍 Checking if migration has already been run..."
MIGRATION_EXISTS=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM migration_log WHERE migration_name = 'DATA_MIGRATION_SCRIPT' AND status = 'COMPLETED';" 2>/dev/null | tr -d ' ')

if [ "$MIGRATION_EXISTS" -gt 0 ]; then
    print_warning "Migration has already been run on this database!"
    read -p "Do you want to run it again? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Migration skipped"
        exit 0
    fi
fi

# Run the migration
echo "🚀 Starting data migration..."
print_info "This may take a few minutes depending on your data size..."

if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f DATA_MIGRATION.sql; then
    print_status "Data migration completed successfully!"
else
    print_error "Data migration failed!"
    print_error "Check the error messages above for details."
    exit 1
fi

# Verify migration
echo "🔍 Verifying migration results..."
TABLE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
USER_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users;" | tr -d ' ')
EMPLOYEE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM employee_master;" | tr -d ' ')
FORM_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM employee_forms;" | tr -d ' ')

print_status "Migration verification completed:"
echo "   📋 Tables: $TABLE_COUNT"
echo "   👥 Users: $USER_COUNT"
echo "   👔 Employees: $EMPLOYEE_COUNT"
echo "   📝 Forms: $FORM_COUNT"

# Check for any issues
echo "🔍 Checking for potential issues..."
ISSUES=0

# Check for users without employee records
ORPHANED_USERS=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users u LEFT JOIN employee_master em ON u.email = em.company_email WHERE em.id IS NULL AND u.role = 'employee';" | tr -d ' ')
if [ "$ORPHANED_USERS" -gt 0 ]; then
    print_warning "Found $ORPHANED_USERS users without employee master records"
    ISSUES=$((ISSUES + 1))
fi

# Check for forms without DOJ
FORMS_WITHOUT_DOJ=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM employee_forms WHERE form_data->>'doj' IS NULL OR form_data->>'doj' = '';" | tr -d ' ')
if [ "$FORMS_WITHOUT_DOJ" -gt 0 ]; then
    print_warning "Found $FORMS_WITHOUT_DOJ forms without DOJ data"
    ISSUES=$((ISSUES + 1))
fi

if [ $ISSUES -eq 0 ]; then
    print_status "No issues found in the migrated data"
else
    print_warning "Found $ISSUES potential issues. Please review the warnings above."
fi

echo ""
echo "🎉 Data Migration Process Completed!"
echo "===================================="
echo ""
echo "Next steps:"
echo "1. Test your application to ensure everything works correctly"
echo "2. Check the migration_log table for detailed migration information"
echo "3. If you encounter any issues, restore from your backup and contact support"
echo ""
print_status "Migration completed successfully! 🚀"
