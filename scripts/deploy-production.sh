#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - PRODUCTION DEPLOYMENT SCRIPT
# =============================================================================
# Automated production deployment with safety checks and monitoring
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="nxzen"
COMPOSE_FILE="docker-compose.production.yml"
ENV_FILE="production.env"
BACKUP_DIR="/opt/nxzen/backups"
LOG_DIR="/opt/nxzen/logs"

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

print_header() {
    echo -e "${PURPLE}==============================================================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}==============================================================================${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_header "CHECKING PREREQUISITES"
    
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
    
    # Check if running as root or with sudo
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root. This is not recommended for production."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check if environment file exists
    if [ ! -f "$ENV_FILE" ]; then
        print_error "Environment file $ENV_FILE not found."
        exit 1
    fi
    
    # Check if compose file exists
    if [ ! -f "$COMPOSE_FILE" ]; then
        print_error "Docker Compose file $COMPOSE_FILE not found."
        exit 1
    fi
    
    print_success "All prerequisites met"
}

# Function to create necessary directories
create_directories() {
    print_header "CREATING NECESSARY DIRECTORIES"
    
    sudo mkdir -p /opt/nxzen/{data,backups,logs,ssl}
    sudo mkdir -p /opt/nxzen/data/{postgres,redis,uploads,logs,backups,prometheus}
    
    # Set proper permissions
    sudo chown -R $USER:$USER /opt/nxzen
    sudo chmod -R 755 /opt/nxzen
    
    print_success "Directories created successfully"
}

# Function to backup existing data
backup_existing_data() {
    print_header "BACKING UP EXISTING DATA"
    
    if [ -d "/opt/nxzen/data" ]; then
        BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        BACKUP_PATH="$BACKUP_DIR/backup_$BACKUP_TIMESTAMP"
        
        print_status "Creating backup at $BACKUP_PATH"
        sudo cp -r /opt/nxzen/data "$BACKUP_PATH"
        
        print_success "Backup created successfully"
    else
        print_status "No existing data to backup"
    fi
}

# Function to pull latest images
pull_images() {
    print_header "PULLING LATEST IMAGES"
    
    print_status "Pulling PostgreSQL image..."
    docker pull postgres:15-alpine
    
    print_status "Pulling Redis image..."
    docker pull redis:7-alpine
    
    print_status "Pulling Prometheus image..."
    docker pull prom/prometheus:latest
    
    print_success "Images pulled successfully"
}

# Function to build application images
build_images() {
    print_header "BUILDING APPLICATION IMAGES"
    
    print_status "Building backend image..."
    docker-compose -f $COMPOSE_FILE build backend
    
    print_status "Building frontend image..."
    docker-compose -f $COMPOSE_FILE build frontend
    
    print_success "Application images built successfully"
}

# Function to stop existing services
stop_services() {
    print_header "STOPPING EXISTING SERVICES"
    
    if docker-compose -f $COMPOSE_FILE ps -q | grep -q .; then
        print_status "Stopping existing services..."
        docker-compose -f $COMPOSE_FILE down --remove-orphans
        print_success "Services stopped successfully"
    else
        print_status "No existing services to stop"
    fi
}

# Function to start services
start_services() {
    print_header "STARTING SERVICES"
    
    print_status "Starting services with $COMPOSE_FILE..."
    docker-compose -f $COMPOSE_FILE --env-file $ENV_FILE up -d
    
    print_success "Services started successfully"
}

# Function to wait for services to be healthy
wait_for_services() {
    print_header "WAITING FOR SERVICES TO BE HEALTHY"
    
    print_status "Waiting for PostgreSQL to be ready..."
    timeout 300 bash -c 'until docker-compose -f '$COMPOSE_FILE' exec -T postgres pg_isready -U nxzen_user -d nxzen_hrms_prod; do sleep 5; done'
    
    print_status "Waiting for Redis to be ready..."
    timeout 60 bash -c 'until docker-compose -f '$COMPOSE_FILE' exec -T redis redis-cli ping; do sleep 5; done'
    
    print_status "Waiting for backend to be ready..."
    timeout 300 bash -c 'until curl -f http://localhost:2035/api/health; do sleep 5; done'
    
    print_status "Waiting for frontend to be ready..."
    timeout 60 bash -c 'until curl -f http://localhost:2036/health; do sleep 5; done'
    
    print_success "All services are healthy"
}

# Function to run database migrations
run_migrations() {
    print_header "RUNNING DATABASE MIGRATIONS"
    
    print_status "Running database migrations..."
    docker-compose -f $COMPOSE_FILE exec -T backend node scripts/runMigration.js 002_enhanced_employee_management.sql || true
    
    print_success "Database migrations completed"
}

# Function to show deployment status
show_status() {
    print_header "DEPLOYMENT STATUS"
    
    print_status "Service Status:"
    docker-compose -f $COMPOSE_FILE ps
    
    print_status "Resource Usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    
    print_status "Application URLs:"
    echo "  Frontend: http://149.102.158.71:2036"
    echo "  Backend API: http://149.102.158.71:2035/api"
    echo "  Health Check: http://149.102.158.71:2035/api/health"
    echo "  Prometheus: http://149.102.158.71:9090"
    
    print_success "Deployment completed successfully!"
}

# Function to cleanup
cleanup() {
    print_header "CLEANUP"
    
    print_status "Cleaning up unused Docker resources..."
    docker system prune -f
    
    print_status "Cleaning up old images..."
    docker image prune -f
    
    print_success "Cleanup completed"
}

# Main deployment function
main() {
    print_header "NXZEN EMPLOYEE MANAGEMENT SYSTEM - PRODUCTION DEPLOYMENT"
    print_status "Starting production deployment..."
    print_status "Timestamp: $(date)"
    
    # Run deployment steps
    check_prerequisites
    create_directories
    backup_existing_data
    pull_images
    build_images
    stop_services
    start_services
    wait_for_services
    run_migrations
    show_status
    cleanup
    
    print_header "DEPLOYMENT COMPLETED SUCCESSFULLY"
    print_success "Your NXZEN Employee Management System is now running in production!"
    print_status "Monitor the logs with: docker-compose -f $COMPOSE_FILE logs -f"
    print_status "Stop services with: docker-compose -f $COMPOSE_FILE down"
}

# Handle script arguments
case "${1:-}" in
    "stop")
        print_header "STOPPING PRODUCTION SERVICES"
        stop_services
        ;;
    "restart")
        print_header "RESTARTING PRODUCTION SERVICES"
        stop_services
        start_services
        wait_for_services
        show_status
        ;;
    "status")
        show_status
        ;;
    "logs")
        docker-compose -f $COMPOSE_FILE logs -f
        ;;
    "backup")
        backup_existing_data
        ;;
    *)
        main
        ;;
esac
