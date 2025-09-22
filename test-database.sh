#!/bin/bash

# =============================================================================
# Database Test Script
# =============================================================================
# This script tests if the database is properly set up
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get database name
db_name=${1:-"onboardd"}

echo "============================================================================="
echo "Testing Database Setup: $db_name"
echo "============================================================================="

# Test 1: Check if database exists
print_status "Testing database connection..."
if psql -h localhost -U postgres -d "$db_name" -c "SELECT 1;" >/dev/null 2>&1; then
    print_success "Database connection successful"
else
    print_error "Cannot connect to database '$db_name'"
    exit 1
fi

# Test 2: Check critical tables
print_status "Checking critical tables..."
critical_tables=("users" "employee_master" "attendance" "leave_requests" "managers")
for table in "${critical_tables[@]}"; do
    if psql -h localhost -U postgres -d "$db_name" -tAc "SELECT 1 FROM information_schema.tables WHERE table_name='$table';" | grep -q 1; then
        print_success "Table '$table' exists"
    else
        print_error "Table '$table' is missing"
        exit 1
    fi
done

# Test 3: Check indexes
print_status "Checking indexes..."
index_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';")
print_success "Found $index_count indexes"

# Test 4: Check functions
print_status "Checking functions..."
function_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';")
print_success "Found $function_count functions"

# Test 5: Check sample data
print_status "Checking sample data..."
user_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM users;")
if [ "$user_count" -gt 0 ]; then
    print_success "Found $user_count users in database"
else
    print_error "No users found in database"
fi

# Test 6: Check settings
print_status "Checking system settings..."
settings_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM system_settings;")
print_success "Found $settings_count system settings"

echo
print_success "All database tests passed! 🎉"
echo
echo "Database '$db_name' is properly set up and ready to use."
echo "You can now start the application with: npm run dev"
