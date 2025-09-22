#!/bin/bash

# =============================================================================
# MIGRATION VERIFICATION SCRIPT
# =============================================================================
# This script verifies that the DATA_MIGRATION.sql creates all 33 tables
# 
# Usage: ./verify-migration.sh
# =============================================================================

echo "🔍 Verifying DATA_MIGRATION.sql table count..."

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

# Count tables in migration file
echo "🔍 Counting tables in DATA_MIGRATION.sql..."
MIGRATION_TABLE_COUNT=$(grep -c "CREATE TABLE" DATA_MIGRATION.sql)
print_info "Tables defined in migration file: $MIGRATION_TABLE_COUNT"

# Expected tables list
EXPECTED_TABLES=(
    "users" "employee_master" "employee_forms" "onboarded_employees"
    "managers" "manager_employee_mapping" "company_emails"
    "attendance" "attendance_settings"
    "leave_types" "leave_requests" "leave_balances" "leave_type_balances" "comp_off_balances"
    "expense_categories" "expense_requests" "expense_attachments" "expenses"
    "document_templates" "document_collection" "employee_documents" "document_reminder_mails" "documents"
    "departments" "relations" "system_settings" "migration_log"
    "adp_payroll" "employees_combined" "onboarding"
    "pnc_monitoring_breakdowns" "pnc_monitoring_reports" "recruitment_requisitions"
)

EXPECTED_COUNT=${#EXPECTED_TABLES[@]}
print_info "Expected table count: $EXPECTED_COUNT"

# Verify count matches
if [ "$MIGRATION_TABLE_COUNT" -eq "$EXPECTED_COUNT" ]; then
    print_status "Migration file has correct number of tables ($MIGRATION_TABLE_COUNT)"
else
    print_error "Migration file has $MIGRATION_TABLE_COUNT tables, expected $EXPECTED_COUNT"
    exit 1
fi

# Check if migration has been run
echo "🔍 Checking if migration has been run..."
MIGRATION_EXISTS=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM migration_log WHERE migration_name = 'DATA_MIGRATION_SCRIPT' AND status = 'COMPLETED';" 2>/dev/null | tr -d ' ')

if [ "$MIGRATION_EXISTS" -gt 0 ]; then
    print_status "Migration has been run successfully"
    
    # Count actual tables in database
    echo "🔍 Counting tables in database..."
    DB_TABLE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
    print_info "Tables in database: $DB_TABLE_COUNT"
    
    # Verify all expected tables exist
    echo "🔍 Verifying all expected tables exist..."
    MISSING_TABLES=()
    
    for table in "${EXPECTED_TABLES[@]}"; do
        if ! psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt $table" > /dev/null 2>&1; then
            MISSING_TABLES+=("$table")
        fi
    done
    
    if [ ${#MISSING_TABLES[@]} -eq 0 ]; then
        print_status "All expected tables exist in database"
    else
        print_error "Missing tables: ${MISSING_TABLES[*]}"
        exit 1
    fi
    
    # Show table list
    echo "📋 Database tables:"
    psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt" | tail -n +4 | head -n -2
    
else
    print_warning "Migration has not been run yet"
    print_info "Run './run-migration.sh' to execute the migration"
fi

echo ""
echo "🎉 Migration verification completed successfully!"
echo "📊 Summary:"
echo "   Migration file tables: $MIGRATION_TABLE_COUNT"
echo "   Expected tables: $EXPECTED_COUNT"
if [ "$MIGRATION_EXISTS" -gt 0 ]; then
    echo "   Database tables: $DB_TABLE_COUNT"
    echo "   All tables present: ✅"
fi
