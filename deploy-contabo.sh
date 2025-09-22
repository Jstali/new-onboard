#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - CONTABO SERVER DEPLOYMENT
# =============================================================================
# Quick deployment script for Contabo server 149.102.158.71
# =============================================================================

set -e

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

# Function to check if running on Contabo server
check_server() {
    local current_ip=$(curl -s ifconfig.me 2>/dev/null || echo "unknown")
    if [ "$current_ip" != "$SERVER_IP" ]; then
        print_warning "This script is designed for Contabo server $SERVER_IP"
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
        print_status "Run: curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh"
        exit 1
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        print_status "Run: sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"
        exit 1
    fi
    
    # Check if DATA_MIGRATION.sql exists
    if [ ! -f "DATA_MIGRATION.sql" ]; then
        print_error "DATA_MIGRATION.sql file not found!"
        print_error "Please ensure DATA_MIGRATION.sql is in the current directory"
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

# Function to setup firewall
setup_firewall() {
    print_status "Setting up firewall..."
    
    # Check if ufw is installed
    if command -v ufw &> /dev/null; then
        # Allow required ports
        ufw allow 2025/tcp comment "NXZEN Frontend"
        ufw allow 2026/tcp comment "NXZEN Backend"
        ufw allow 22/tcp comment "SSH"
        
        # Enable firewall if not already enabled
        if ! ufw status | grep -q "Status: active"; then
            ufw --force enable
        fi
        
        print_success "Firewall configured"
    else
        print_warning "UFW not installed, skipping firewall setup"
    fi
}

# Function to create directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p /opt/nxzen-hrms/{logs,backups,ssl}
    mkdir -p /opt/nxzen-hrms/backend/{uploads,logs,backups}
    
    print_success "Directories created"
}

# Function to deploy application
deploy_application() {
    print_status "Deploying NXZEN Employee Management System..."
    
    # Stop existing services
    if [ -f "$DOCKER_COMPOSE_FILE" ]; then
        docker-compose -f $DOCKER_COMPOSE_FILE down --remove-orphans 2>/dev/null || true
    fi
    
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
    if curl -f -s http://localhost:2026/api/health > /dev/null; then
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
    print_status "Application URLs:"
    echo "  Frontend: http://$SERVER_IP:2025"
    echo "  API: http://$SERVER_IP:2026/api"
    echo "  Health Check: http://$SERVER_IP:2025/health"
    echo ""
    print_status "Default Login Credentials:"
    echo "  Admin: admin@nxzen.com / admin123"
    echo "  HR: hr@nxzen.com / hr123"
    echo "  Manager: manager@nxzen.com / manager123"
    echo ""
    print_status "Management Commands:"
    echo "  Status: ./deploy.sh status"
    echo "  Logs: ./deploy.sh logs [service_name]"
    echo "  Backup: ./deploy.sh backup"
    echo "  Restart: ./deploy.sh restart"
}

# Main deployment function
main() {
    echo "============================================================================="
    echo "NXZEN EMPLOYEE MANAGEMENT SYSTEM - CONTABO DEPLOYMENT"
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
    
    # Setup firewall
    setup_firewall
    
    # Create directories
    create_directories
    
    # Deploy application
    deploy_application
    
    # Verify deployment
    if verify_deployment; then
        print_success "Deployment completed successfully!"
        echo ""
        show_status
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

# Run main function
main
