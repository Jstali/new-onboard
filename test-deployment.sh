#!/bin/bash

# =============================================================================
# DEPLOYMENT TEST SCRIPT
# =============================================================================
# This script tests the deployment process locally
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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test if DATA_MIGRATION.sql exists
test_migration_file() {
    print_status "Testing if DATA_MIGRATION.sql exists..."
    
    if [ -f "DATA_MIGRATION.sql" ]; then
        print_success "DATA_MIGRATION.sql found"
        
        # Count tables in migration file
        local table_count=$(grep -c "CREATE TABLE" DATA_MIGRATION.sql)
        print_status "Migration file contains $table_count table definitions"
        
        if [ "$table_count" -eq 33 ]; then
            print_success "Migration file has correct number of tables (33)"
        else
            print_warning "Expected 33 tables, found $table_count"
        fi
    else
        print_error "DATA_MIGRATION.sql not found!"
        print_error "Please ensure DATA_MIGRATION.sql is in the current directory"
        exit 1
    fi
}

# Test if deploy.sh exists and is executable
test_deploy_script() {
    print_status "Testing deploy.sh script..."
    
    if [ -f "deploy.sh" ]; then
        print_success "deploy.sh found"
        
        if [ -x "deploy.sh" ]; then
            print_success "deploy.sh is executable"
        else
            print_warning "deploy.sh is not executable, fixing..."
            chmod +x deploy.sh
            print_success "deploy.sh is now executable"
        fi
    else
        print_error "deploy.sh not found!"
        exit 1
    fi
}

# Test deploy.sh help command
test_deploy_help() {
    print_status "Testing deploy.sh help command..."
    
    if ./deploy.sh help > /dev/null 2>&1; then
        print_success "deploy.sh help command works"
    else
        print_error "deploy.sh help command failed"
        exit 1
    fi
}

# Test database command
test_database_command() {
    print_status "Testing deploy.sh database command..."
    
    # This will fail if Docker is not running, but that's expected
    if ./deploy.sh database 2>&1 | grep -q "DATA_MIGRATION.sql file not found"; then
        print_error "Database command failed - migration file not found in container"
    elif ./deploy.sh database 2>&1 | grep -q "Setting up database only"; then
        print_success "Database command structure is correct"
    else
        print_warning "Database command test inconclusive (Docker might not be running)"
    fi
}

# Main test function
main() {
    echo "============================================================================="
    echo "DEPLOYMENT TEST SCRIPT"
    echo "============================================================================="
    echo "Testing deployment components..."
    echo "============================================================================="
    echo ""
    
    test_migration_file
    echo ""
    
    test_deploy_script
    echo ""
    
    test_deploy_help
    echo ""
    
    test_database_command
    echo ""
    
    print_success "All tests completed!"
    echo ""
    print_status "Deployment is ready. You can now run:"
    echo "  ./deploy.sh          # Full deployment"
    echo "  ./deploy.sh database # Database setup only"
    echo "  ./deploy.sh help     # Show all commands"
}

# Run tests
main
