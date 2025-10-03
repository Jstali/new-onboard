#!/bin/bash

# =============================================================================
# Migration Runner Script for Onboard HR System
# =============================================================================
# This script provides an easy way to run database migrations
# 
# Usage: ./run-migration.sh <migration-file>
# Example: ./run-migration.sh 002_enhanced_employee_management.sql
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

# Check if migration file is provided
if [ $# -eq 0 ]; then
    print_error "Please provide a migration file name"
    echo ""
    echo "Usage: $0 <migration-file>"
    echo ""
    echo "Available migrations:"
    if [ -d "migrations" ]; then
        ls -1 migrations/*.sql 2>/dev/null | sed 's/^/  - /' || echo "  No migration files found"
    else
        echo "  No migrations directory found"
    fi
    exit 1
fi

MIGRATION_FILE=$1

# Check if migration file exists
if [ ! -f "migrations/$MIGRATION_FILE" ]; then
    print_error "Migration file not found: migrations/$MIGRATION_FILE"
    exit 1
fi

print_status "Starting migration process..."
print_status "Migration file: $MIGRATION_FILE"
print_status "Company: ${COMPANY_NAME:-NXZEN}"
print_status "Environment: ${NODE_ENV:-development}"
print_status "Skip sample data: ${MIGRATION_SKIP_SAMPLE_DATA:-false}"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed or not in PATH"
    exit 1
fi

# Check if config.env exists
if [ ! -f "config.env" ]; then
    print_error "config.env file not found. Please ensure database configuration is set up."
    exit 1
fi

# Check if package.json exists (to ensure we're in the right directory)
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the backend directory."
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
fi

# Run the migration
print_status "Executing migration using Node.js script..."
node scripts/runMigration.js "$MIGRATION_FILE"

if [ $? -eq 0 ]; then
    print_success "Migration completed successfully!"
    echo ""
    print_status "Next steps:"
    echo "  1. Verify the migration results in your database"
    echo "  2. Test the new features in your application"
    echo "  3. Update your application code to use the new tables and features"
else
    print_error "Migration failed. Please check the error messages above."
    exit 1
fi
