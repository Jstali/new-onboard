#!/bin/bash

# =============================================================================
# DATABASE SETUP SCRIPT
# =============================================================================
# This script creates all required database tables and inserts default data
# Uses environment variables for database connection
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

# Load environment variables
if [ -f "../backend/config.env" ]; then
    source ../backend/config.env
    print_status "Loaded environment variables from config.env"
else
    print_warning "config.env not found, using default values"
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
echo "DATABASE SETUP SCRIPT"
echo "============================================================================="
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "============================================================================="

# Check if PostgreSQL is running
print_status "Checking PostgreSQL connection..."
if ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER > /dev/null 2>&1; then
    print_error "PostgreSQL is not running or not accessible!"
    print_error "Please make sure PostgreSQL is installed and running."
    exit 1
fi
print_success "PostgreSQL is running"

# Check if database exists
print_status "Checking if database '$DB_NAME' exists..."
if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_warning "Database '$DB_NAME' already exists!"
    read -p "Do you want to drop and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Dropping existing database..."
        psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;"
        print_success "Database dropped"
    else
        print_warning "Skipping database creation. Using existing database."
        SKIP_CREATE=true
    fi
fi

# Create database if it doesn't exist or was dropped
if [ "$SKIP_CREATE" != true ]; then
    print_status "Creating database '$DB_NAME'..."
    if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "CREATE DATABASE $DB_NAME;"; then
        print_success "Database '$DB_NAME' created successfully"
    else
        print_error "Failed to create database '$DB_NAME'"
        exit 1
    fi
fi

# Run the SQL setup file
print_status "Setting up database schema and data..."
if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f ../backend/COMPLETE_DATABASE_SETUP.sql; then
    print_success "Database schema and data setup completed successfully!"
else
    print_error "Failed to setup database schema and data"
    exit 1
fi

# Verify setup
print_status "Verifying database setup..."
TABLE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
USER_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users;" | tr -d ' ')

print_success "Database verification completed:"
echo "   📋 Tables created: $TABLE_COUNT"
echo "   👥 Users: $USER_COUNT"

# Insert default HR login credentials if not exists
print_status "Ensuring default HR credentials exist..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
INSERT INTO users (email, password, role, first_name, last_name, created_at, updated_at)
SELECT 'hr@nxzen.com', '\$2a\$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'hr', 'HR', 'Admin', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'hr@nxzen.com');
" > /dev/null 2>&1

print_success "Default HR credentials ensured"

echo ""
print_success "Database setup completed successfully! 🎉"
echo "============================================================================="
echo "Default login credentials:"
echo "  HR: hr@nxzen.com / password123"
echo "============================================================================="
