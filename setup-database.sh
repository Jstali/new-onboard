#!/bin/bash

# =============================================================================
# DATABASE SETUP SCRIPT FOR ONBOARD PROJECT
# =============================================================================
# This script sets up the complete database for the Onboard project
# 
# Prerequisites:
# 1. PostgreSQL must be installed and running
# 2. psql command must be available in PATH
# 3. User must have permission to create databases
# =============================================================================

echo "🚀 Starting Onboard Project Database Setup..."
echo "=============================================="

# Database configuration
DB_NAME="onboardd"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if PostgreSQL is running
echo "🔍 Checking PostgreSQL connection..."
if ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER > /dev/null 2>&1; then
    print_error "PostgreSQL is not running or not accessible!"
    print_error "Please make sure PostgreSQL is installed and running."
    print_error "Try: sudo service postgresql start"
    exit 1
fi
print_status "PostgreSQL is running"

# Check if database exists
echo "🔍 Checking if database '$DB_NAME' exists..."
if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_warning "Database '$DB_NAME' already exists!"
    read -p "Do you want to drop and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Dropping existing database..."
        psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;"
        print_status "Database dropped"
    else
        print_warning "Skipping database creation. Using existing database."
        SKIP_CREATE=true
    fi
fi

# Create database if it doesn't exist or was dropped
if [ "$SKIP_CREATE" != true ]; then
    echo "🏗️  Creating database '$DB_NAME'..."
    if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "CREATE DATABASE $DB_NAME;"; then
        print_status "Database '$DB_NAME' created successfully"
    else
        print_error "Failed to create database '$DB_NAME'"
        exit 1
    fi
fi

# Run the SQL setup file
echo "📊 Setting up database schema and data..."
if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f COMPLETE_DATABASE_SETUP.sql; then
    print_status "Database schema and data setup completed successfully!"
else
    print_error "Failed to setup database schema and data"
    exit 1
fi

# Verify setup
echo "🔍 Verifying database setup..."
TABLE_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
USER_COUNT=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users;" | tr -d ' ')

print_status "Database verification completed:"
echo "   📋 Tables created: $TABLE_COUNT"
echo "   👥 Sample users: $USER_COUNT"

# Create config.env file
echo "📝 Creating config.env file..."
cat > config.env << EOF
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onboardd
DB_USER=postgres
DB_PASSWORD=your_password_here

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=24h

# Email Configuration
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password

# Server Configuration
PORT=5001
NODE_ENV=development
EOF

print_status "config.env file created"
print_warning "Please update the config.env file with your actual database password and email credentials"

echo ""
echo "🎉 Database setup completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update config.env with your database password and email credentials"
echo "2. Install Node.js dependencies: npm install"
echo "3. Start the backend: cd backend && npm start"
echo "4. Start the frontend: cd frontend && npm start"
echo ""
echo "Default login credentials:"
echo "  HR: hr@nxzen.com / password123"
echo "  Admin: admin@nxzen.com / password123"
echo "  Manager: manager@nxzen.com / password123"
echo ""
print_status "Setup complete! Happy coding! 🚀"