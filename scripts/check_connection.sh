#!/bin/bash

# =============================================================================
# DATABASE CONNECTION CHECK SCRIPT
# =============================================================================
# This script verifies that the backend can connect to the database
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load environment variables
if [ -f "../backend/config.env" ]; then
    source ../backend/config.env
    print_status "Loaded environment variables from config.env"
else
    print_status "config.env not found, using default values"
    DB_HOST=${DB_HOST:-localhost}
    DB_PORT=${DB_PORT:-5432}
    DB_NAME=${DB_NAME:-onboardd}
    DB_USER=${DB_USER:-postgres}
    DB_PASS=${DB_PASSWORD:-postgres}
fi

# Override with environment variables if set
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-onboardd}
DB_USER=${DB_USER:-postgres}
DB_PASS=${DB_PASSWORD:-postgres}

echo "============================================================================="
echo "DATABASE CONNECTION CHECK"
echo "============================================================================="
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "============================================================================="

# Test 1: Check if PostgreSQL is running
print_status "Checking PostgreSQL service..."
if ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER > /dev/null 2>&1; then
    print_error "PostgreSQL is not running or not accessible!"
    print_error "Please make sure PostgreSQL is installed and running."
    echo "❌ DB Connection Failed"
    exit 1
fi
print_success "PostgreSQL service is running"

# Test 2: Check database connection
print_status "Testing database connection..."
if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1; then
    print_success "Database connection successful"
else
    print_error "Cannot connect to database '$DB_NAME'"
    print_error "Please check your database credentials and ensure the database exists"
    echo "❌ DB Connection Failed"
    exit 1
fi

# Test 3: Check if database has all required tables (33 tables from backup)
print_status "Checking all required tables..."
REQUIRED_TABLES=(
    "adp_payroll"
    "attendance"
    "attendance_settings"
    "comp_off_balances"
    "company_emails"
    "departments"
    "document_collection"
    "document_reminder_mails"
    "document_templates"
    "documents"
    "employee_documents"
    "employee_forms"
    "employee_master"
    "employees_combined"
    "expense_attachments"
    "expense_categories"
    "expense_requests"
    "expenses"
    "leave_balances"
    "leave_requests"
    "leave_type_balances"
    "leave_types"
    "manager_employee_mapping"
    "managers"
    "migration_log"
    "onboarded_employees"
    "onboarding"
    "pnc_monitoring_breakdowns"
    "pnc_monitoring_reports"
    "recruitment_requisitions"
    "relations"
    "system_settings"
    "users"
)
MISSING_TABLES=()
EXISTING_TABLES=()

for table in "${REQUIRED_TABLES[@]}"; do
    if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT 1 FROM information_schema.tables WHERE table_name='$table';" | grep -q 1; then
        print_success "Table '$table' exists"
        EXISTING_TABLES+=("$table")
    else
        print_error "Table '$table' is missing"
        MISSING_TABLES+=("$table")
    fi
done

print_status "Table verification summary:"
echo "   ✅ Existing tables: ${#EXISTING_TABLES[@]}/33"
echo "   ❌ Missing tables: ${#MISSING_TABLES[@]}/33"

if [ ${#MISSING_TABLES[@]} -gt 0 ]; then
    print_error "Missing required tables: ${MISSING_TABLES[*]}"
    print_error "Please run setup_db.sh to create the database schema"
    echo "❌ DB Connection Failed"
    exit 1
fi

# Test 4: Check if database has data in key tables
print_status "Checking database data..."
USER_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM users;" 2>/dev/null || echo "0")
EMPLOYEE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM employee_master;" 2>/dev/null || echo "0")
ATTENDANCE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM attendance;" 2>/dev/null || echo "0")
LEAVE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM leave_requests;" 2>/dev/null || echo "0")
DOCUMENT_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM document_templates;" 2>/dev/null || echo "0")

print_status "Database data summary:"
echo "   👥 Users: $USER_COUNT"
echo "   👤 Employees: $EMPLOYEE_COUNT"
echo "   📅 Attendance records: $ATTENDANCE_COUNT"
echo "   🏖️ Leave requests: $LEAVE_COUNT"
echo "   📄 Document templates: $DOCUMENT_COUNT"

if [ "$USER_COUNT" -gt 0 ]; then
    print_success "Database contains data"
else
    print_warning "Database appears to be empty (no users found)"
    print_warning "Consider running setup_db.sh to populate with default data"
fi

# Test 5: Check database indexes and functions
print_status "Checking database indexes..."
INDEX_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';" 2>/dev/null || echo "0")
print_success "Found $INDEX_COUNT indexes"

print_status "Checking database functions..."
FUNCTION_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';" 2>/dev/null || echo "0")
print_success "Found $FUNCTION_COUNT functions"

# Test 6: Test a simple query
print_status "Testing simple query..."
QUERY_RESULT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -tAc "SELECT 'Hello World' as test_message;" 2>/dev/null || echo "")
if [ "$QUERY_RESULT" = "Hello World" ]; then
    print_success "Query execution successful"
else
    print_error "Query execution failed"
    echo "❌ DB Connection Failed"
    exit 1
fi

echo ""
print_success "All database connection tests passed! 🎉"
echo "✅ DB Connected"
echo "============================================================================="
echo "Database is ready for use!"
echo "You can now start the application with: ./run_app.sh"
echo "============================================================================="

exit 0
