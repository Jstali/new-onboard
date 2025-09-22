#!/bin/bash

# =============================================================================
# NXZEN HR Employee Onboarding System - Database Setup Script
# =============================================================================
# This script sets up the complete database for the NXZEN HR system
# Run this script to create all tables, indexes, and default data
# =============================================================================

set -e  # Exit on any error

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check PostgreSQL connection
check_postgres_connection() {
    print_status "Checking PostgreSQL connection..."
    
    if ! command_exists psql; then
        print_error "PostgreSQL client (psql) is not installed. Please install PostgreSQL first."
        exit 1
    fi
    
    # Test connection
    if ! psql -h localhost -U postgres -d postgres -c "SELECT 1;" >/dev/null 2>&1; then
        print_error "Cannot connect to PostgreSQL. Please ensure PostgreSQL is running and accessible."
        print_error "Make sure you can connect with: psql -h localhost -U postgres -d postgres"
        exit 1
    fi
    
    print_success "PostgreSQL connection successful"
}

# Function to create database
create_database() {
    local db_name=${1:-"onboardd"}
    
    print_status "Creating database: $db_name"
    
    # Check if database exists
    if psql -h localhost -U postgres -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$db_name';" | grep -q 1; then
        print_warning "Database '$db_name' already exists"
        read -p "Do you want to drop and recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Dropping existing database..."
            psql -h localhost -U postgres -d postgres -c "DROP DATABASE IF EXISTS $db_name;"
            print_status "Creating new database..."
            psql -h localhost -U postgres -d postgres -c "CREATE DATABASE $db_name;"
        else
            print_status "Using existing database: $db_name"
        fi
    else
        print_status "Creating new database: $db_name"
        psql -h localhost -U postgres -d postgres -c "CREATE DATABASE $db_name;"
    fi
    
    print_success "Database '$db_name' is ready"
}

# Function to run migration
run_migration() {
    local db_name=${1:-"onboardd"}
    local migration_file="backend/migrations/000CompleteDatabaseSetup.sql"
    
    print_status "Running database migration..."
    
    if [ ! -f "$migration_file" ]; then
        print_error "Migration file not found: $migration_file"
        print_error "Please ensure you're running this script from the project root directory"
        exit 1
    fi
    
    print_status "Executing migration: $migration_file"
    if psql -h localhost -U postgres -d "$db_name" -f "$migration_file"; then
        print_success "Migration completed successfully"
    else
        print_error "Migration failed. Please check the error messages above."
        exit 1
    fi
}

# Function to verify installation
verify_installation() {
    local db_name=${1:-"onboardd"}
    
    print_status "Verifying database installation..."
    
    # Check if critical tables exist
    local table_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('users', 'employee_master', 'attendance', 'leave_requests', 'managers');")
    
    if [ "$table_count" -eq 5 ]; then
        print_success "All critical tables created successfully"
    else
        print_error "Some critical tables are missing. Expected 5, found $table_count"
        exit 1
    fi
    
    # Check if indexes exist
    local index_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public';")
    print_success "Created $index_count indexes"
    
    # Check if functions exist
    local function_count=$(psql -h localhost -U postgres -d "$db_name" -tAc "SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public' AND routine_type = 'FUNCTION';")
    print_success "Created $function_count functions"
    
    print_success "Database verification completed successfully"
}

# Function to create sample data
create_sample_data() {
    local db_name=${1:-"onboardd"}
    
    print_status "Creating sample data..."
    
    # Create sample HR user
    psql -h localhost -U postgres -d "$db_name" -c "
        INSERT INTO users (email, password, role, first_name, last_name) 
        VALUES ('hr@nxzen.com', '\$2b\$10\$defaulthash', 'hr', 'HR', 'Admin')
        ON CONFLICT (email) DO NOTHING;
    "
    
    # Create sample manager
    psql -h localhost -U postgres -d "$db_name" -c "
        INSERT INTO users (email, password, role, first_name, last_name) 
        VALUES ('manager@nxzen.com', '\$2b\$10\$defaulthash', 'manager', 'Test', 'Manager')
        ON CONFLICT (email) DO NOTHING;
    "
    
    print_success "Sample data created successfully"
}

# Function to display connection information
display_connection_info() {
    local db_name=${1:-"onboardd"}
    
    echo
    print_success "Database setup completed successfully!"
    echo
    echo "============================================================================="
    echo "CONNECTION INFORMATION"
    echo "============================================================================="
    echo "Database Name: $db_name"
    echo "Host: localhost"
    echo "Port: 5432"
    echo "Username: postgres"
    echo
    echo "To connect to the database:"
    echo "psql -h localhost -U postgres -d $db_name"
    echo
    echo "Sample users created:"
    echo "- HR Admin: hr@nxzen.com"
    echo "- Manager: manager@nxzen.com"
    echo "Default password for both: password"
    echo
    echo "============================================================================="
    echo "NEXT STEPS"
    echo "============================================================================="
    echo "1. Update your .env file with the database connection details"
    echo "2. Start the backend server: cd backend && npm start"
    echo "3. Start the frontend server: cd frontend && npm start"
    echo "4. Access the application at http://localhost:3001"
    echo "============================================================================="
}

# Main execution
main() {
    echo "============================================================================="
    echo "NXZEN HR Employee Onboarding System - Database Setup"
    echo "============================================================================="
    echo
    
    # Get database name
    read -p "Enter database name (default: onboardd): " db_name
    db_name=${db_name:-"onboardd"}
    
    echo
    print_status "Starting database setup for: $db_name"
    echo
    
    # Check prerequisites
    check_postgres_connection
    
    # Create database
    create_database "$db_name"
    
    # Run migration
    run_migration "$db_name"
    
    # Verify installation
    verify_installation "$db_name"
    
    # Create sample data
    create_sample_data "$db_name"
    
    # Display connection information
    display_connection_info "$db_name"
}

# Run main function
main "$@"
