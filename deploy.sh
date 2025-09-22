#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - DEPLOYMENT SCRIPT
# =============================================================================
# Production deployment script for server 149.102.158.71
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVER_IP="149.102.158.71"
APP_NAME="nxzen-hrms"
DOCKER_COMPOSE_FILE="docker-compose.prod.yml"
BACKUP_DIR="/opt/backups/nxzen-hrms"

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

# Function to check if running on correct server
check_server() {
    local current_ip=$(curl -s ifconfig.me)
    if [ "$current_ip" != "$SERVER_IP" ]; then
        print_warning "This script is designed for server $SERVER_IP"
        print_warning "Current server IP: $current_ip"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if DATA_MIGRATION.sql exists
    if [ ! -f "DATA_MIGRATION.sql" ]; then
        print_error "DATA_MIGRATION.sql file not found!"
        print_error "Please ensure DATA_MIGRATION.sql is in the current directory"
        print_error "This file is required to create all 33 database tables"
        exit 1
    fi
    
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ]; then
        print_warning "This script should be run as root or with sudo for proper permissions."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    print_success "Prerequisites check completed"
}

# Function to create backup
create_backup() {
    print_status "Creating backup of current deployment..."
    
    local backup_timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_path="$BACKUP_DIR/$backup_timestamp"
    
    mkdir -p "$backup_path"
    
    # Backup database
    if docker-compose -f $DOCKER_COMPOSE_FILE ps postgres | grep -q "Up"; then
        print_status "Backing up database..."
        docker-compose -f $DOCKER_COMPOSE_FILE exec -T postgres pg_dump -U nxzen_user nxzen_hrms_prod > "$backup_path/database.sql"
        print_success "Database backup created"
    fi
    
    # Backup uploads
    if [ -d "./backend/uploads" ]; then
        print_status "Backing up uploads..."
        cp -r ./backend/uploads "$backup_path/"
        print_success "Uploads backup created"
    fi
    
    # Backup configuration
    print_status "Backing up configuration..."
    cp docker-compose.prod.yml "$backup_path/"
    cp production.env "$backup_path/"
    print_success "Configuration backup created"
    
    print_success "Backup created at: $backup_path"
}

# Function to stop existing services
stop_services() {
    print_status "Stopping existing services..."
    
    if [ -f "$DOCKER_COMPOSE_FILE" ]; then
        docker-compose -f $DOCKER_COMPOSE_FILE down --remove-orphans
        print_success "Existing services stopped"
    else
        print_warning "No existing docker-compose file found"
    fi
}

# Function to clean up old images
cleanup_images() {
    print_status "Cleaning up old Docker images..."
    
    # Remove unused images
    docker image prune -f
    
    # Remove old versions of our images
    docker images | grep "$APP_NAME" | awk '{print $3}' | xargs -r docker rmi -f
    
    print_success "Docker images cleaned up"
}

# Function to build and start services
deploy_services() {
    print_status "Building and starting services..."
    
    # Build and start services
    docker-compose -f $DOCKER_COMPOSE_FILE up -d --build --force-recreate
    
    # Wait for services to be healthy
    print_status "Waiting for services to be healthy..."
    sleep 30
    
    # Check service health
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f $DOCKER_COMPOSE_FILE ps | grep -q "unhealthy"; then
            print_warning "Some services are still starting... (attempt $attempt/$max_attempts)"
            sleep 10
            ((attempt++))
        else
            print_success "All services are healthy"
            break
        fi
    done
    
    if [ $attempt -gt $max_attempts ]; then
        print_error "Services failed to become healthy within expected time"
        print_status "Checking service logs..."
        docker-compose -f $DOCKER_COMPOSE_FILE logs --tail=50
        exit 1
    fi
}

# Function to verify deployment
verify_deployment() {
    print_status "Verifying deployment..."
    
    # Check if services are running
    local services=("postgres" "redis" "backend" "frontend")
    for service in "${services[@]}"; do
        if docker-compose -f $DOCKER_COMPOSE_FILE ps $service | grep -q "Up"; then
            print_success "$service is running"
        else
            print_error "$service is not running"
            return 1
        fi
    done
    
    # Test API endpoint
    print_status "Testing API endpoint..."
    if curl -f -s http://localhost:2025/api/health > /dev/null; then
        print_success "API endpoint is responding"
    else
        print_error "API endpoint is not responding"
        return 1
    fi
    
    # Test frontend
    print_status "Testing frontend..."
    if curl -f -s http://localhost:2025/health > /dev/null; then
        print_success "Frontend is responding"
    else
        print_error "Frontend is not responding"
        return 1
    fi
    
    print_success "Deployment verification completed"
}

# Function to show deployment status
show_status() {
    print_status "Deployment Status:"
    echo ""
    docker-compose -f $DOCKER_COMPOSE_FILE ps
    echo ""
    print_status "Service URLs:"
    echo "  Frontend: http://$SERVER_IP:2025"
    echo "  API: http://$SERVER_IP:2025/api"
    echo "  Health Check: http://$SERVER_IP:2025/health"
    echo ""
    print_status "Logs can be viewed with:"
    echo "  docker-compose -f $DOCKER_COMPOSE_FILE logs -f [service_name]"
}

# Function to setup database
setup_database() {
    print_status "Setting up database with all 33 tables..."
    
    # Wait for PostgreSQL to be ready
    print_status "Waiting for PostgreSQL to be ready..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f $DOCKER_COMPOSE_FILE exec -T postgres pg_isready -U nxzen_user -d nxzen_hrms_prod > /dev/null 2>&1; then
            print_success "PostgreSQL is ready"
            break
        else
            print_warning "Waiting for PostgreSQL... (attempt $attempt/$max_attempts)"
            sleep 5
            ((attempt++))
        fi
    done
    
    if [ $attempt -gt $max_attempts ]; then
        print_error "PostgreSQL failed to become ready within expected time"
        return 1
    fi
    
    # Check if DATA_MIGRATION.sql exists
    if [ ! -f "DATA_MIGRATION.sql" ]; then
        print_error "DATA_MIGRATION.sql file not found!"
        print_error "Please ensure DATA_MIGRATION.sql is in the current directory"
        return 1
    fi
    
    # Run the migration script
    print_status "Running database migration to create all 33 tables..."
    if docker-compose -f $DOCKER_COMPOSE_FILE exec -T postgres psql -U nxzen_user -d nxzen_hrms_prod -f /tmp/DATA_MIGRATION.sql; then
        print_success "Database migration completed successfully"
        print_success "All 33 tables have been created"
    else
        print_error "Database migration failed"
        print_status "Checking migration logs..."
        docker-compose -f $DOCKER_COMPOSE_FILE exec -T postgres psql -U nxzen_user -d nxzen_hrms_prod -c "SELECT * FROM migration_log ORDER BY executed_at DESC LIMIT 5;"
        return 1
    fi
    
    # Verify table count
    print_status "Verifying table creation..."
    local table_count=$(docker-compose -f $DOCKER_COMPOSE_FILE exec -T postgres psql -U nxzen_user -d nxzen_hrms_prod -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
    
    if [ "$table_count" -ge 33 ]; then
        print_success "Database setup completed with $table_count tables"
    else
        print_warning "Expected at least 33 tables, found $table_count"
        print_status "This might be normal if some tables already existed"
    fi
}

# Function to copy migration file to container
copy_migration_file() {
    print_status "Copying DATA_MIGRATION.sql to PostgreSQL container..."
    
    if [ -f "DATA_MIGRATION.sql" ]; then
        docker-compose -f $DOCKER_COMPOSE_FILE cp DATA_MIGRATION.sql postgres:/tmp/DATA_MIGRATION.sql
        print_success "Migration file copied to container"
    else
        print_error "DATA_MIGRATION.sql file not found!"
        print_error "Please ensure DATA_MIGRATION.sql is in the current directory"
        return 1
    fi
}

# Function to setup SSL (optional)
setup_ssl() {
    read -p "Do you want to setup SSL certificates? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "SSL setup would require:"
        echo "  1. SSL certificates in ./nginx/ssl/"
        echo "  2. Update nginx configuration"
        echo "  3. Update docker-compose to use SSL profile"
        echo ""
        print_warning "SSL setup is not automated in this script"
        print_warning "Please configure SSL certificates manually"
    fi
}

# Main deployment function
main() {
    echo "============================================================================="
    echo "NXZEN EMPLOYEE MANAGEMENT SYSTEM - PRODUCTION DEPLOYMENT"
    echo "============================================================================="
    echo "Server: $SERVER_IP"
    echo "Application: $APP_NAME"
    echo "Database: PostgreSQL with 33 tables"
    echo "============================================================================="
    echo ""
    
    # Check if we're on the right server
    check_server
    
    # Check prerequisites
    check_prerequisites
    
    # Create backup
    create_backup
    
    # Stop existing services
    stop_services
    
    # Clean up old images
    cleanup_images
    
    # Deploy services
    deploy_services
    
    # Copy migration file to container
    copy_migration_file
    
    # Setup database with all 33 tables
    setup_database
    
    # Verify deployment
    if verify_deployment; then
        print_success "Deployment completed successfully!"
        echo ""
        show_status
        echo ""
        setup_ssl
        echo ""
        print_success "Your NXZEN Employee Management System is now live!"
        print_status "Access your application at: http://$SERVER_IP:2025"
    else
        print_error "Deployment verification failed"
        print_status "Checking logs for troubleshooting..."
        docker-compose -f $DOCKER_COMPOSE_FILE logs --tail=100
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  (no args)  - Full deployment with database setup"
    echo "  backup     - Create backup of current deployment"
    echo "  stop       - Stop all services"
    echo "  start      - Start services (without database setup)"
    echo "  restart    - Restart services (without database setup)"
    echo "  database   - Setup database only (create all 33 tables)"
    echo "  status     - Show deployment status"
    echo "  logs       - Show service logs"
    echo "  cleanup    - Clean up Docker images"
    echo "  help       - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Full deployment"
    echo "  $0 database          # Setup database only"
    echo "  $0 logs backend      # Show backend logs"
    echo "  $0 status            # Show service status"
}

# Handle script arguments
case "${1:-}" in
    "backup")
        create_backup
        ;;
    "stop")
        stop_services
        ;;
    "start")
        deploy_services
        ;;
    "restart")
        stop_services
        deploy_services
        ;;
    "database")
        print_status "Setting up database only..."
        copy_migration_file
        setup_database
        print_success "Database setup completed!"
        ;;
    "status")
        show_status
        ;;
    "logs")
        docker-compose -f $DOCKER_COMPOSE_FILE logs -f "${2:-}"
        ;;
    "cleanup")
        cleanup_images
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        main
        ;;
esac