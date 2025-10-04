#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - SERVER DEPLOYMENT SCRIPT
# =============================================================================
# Production deployment script for server 149.102.158.71
# Features: Automated deployment, health checks, rollback, monitoring
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVER_IP="149.102.158.71"
BACKEND_PORT="2035"
FRONTEND_PORT="2036"
PROJECT_NAME="nxzen-hrms"
DOCKER_COMPOSE_FILE="docker-compose.production.yml"
BACKUP_DIR="/opt/nxzen/backups"
DATA_DIR="/opt/nxzen/data"
LOG_FILE="/var/log/nxzen-deploy.log"

# Functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

check_requirements() {
    log "Checking system requirements..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root. Please run as a regular user with sudo privileges."
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first."
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose is not installed. Please install Docker Compose first."
    fi
    
    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        error "Docker daemon is not running. Please start Docker service."
    fi
    
    success "System requirements check passed"
}

create_directories() {
    log "Creating necessary directories..."
    
    sudo mkdir -p "$DATA_DIR"/{postgres,redis,uploads,logs,backups,prometheus}
    sudo mkdir -p "$BACKUP_DIR"
    sudo mkdir -p "$(dirname "$LOG_FILE")"
    
    # Set proper permissions
    sudo chown -R "$USER:$USER" "$DATA_DIR" "$BACKUP_DIR"
    sudo chmod -R 755 "$DATA_DIR" "$BACKUP_DIR"
    
    success "Directories created successfully"
}

check_ports() {
    log "Checking port availability..."
    
    if ss -tuln | grep -q ":$BACKEND_PORT "; then
        warning "Port $BACKEND_PORT is already in use"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "Deployment cancelled"
        fi
    fi
    
    if ss -tuln | grep -q ":$FRONTEND_PORT "; then
        warning "Port $FRONTEND_PORT is already in use"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "Deployment cancelled"
        fi
    fi
    
    success "Port check completed"
}

backup_database() {
    log "Creating database backup..."
    
    local backup_file="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S).sql"
    
    if docker-compose -f "$DOCKER_COMPOSE_FILE" ps postgres | grep -q "Up"; then
        docker-compose -f "$DOCKER_COMPOSE_FILE" exec -T postgres pg_dump -U nxzen_user nxzen_hrms_prod > "$backup_file"
        success "Database backup created: $backup_file"
    else
        warning "PostgreSQL container is not running, skipping backup"
    fi
}

build_images() {
    log "Building Docker images..."
    
    # Build with build args
    export REACT_APP_BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    export REACT_APP_GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
    
    log "Build Date: $REACT_APP_BUILD_DATE"
    log "Git Commit: $REACT_APP_GIT_COMMIT"
    
    docker-compose -f "$DOCKER_COMPOSE_FILE" build --no-cache --parallel
    success "Docker images built successfully"
}

deploy_services() {
    log "Deploying services..."
    
    # Stop existing services
    docker-compose -f "$DOCKER_COMPOSE_FILE" down --remove-orphans
    
    # Start services
    docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
    
    success "Services deployed successfully"
}

wait_for_services() {
    log "Waiting for services to be healthy..."
    
    local max_attempts=60
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        log "Health check attempt $attempt/$max_attempts"
        
        # Check backend health
        if curl -f -s "http://localhost:$BACKEND_PORT/api/health" > /dev/null 2>&1; then
            success "Backend is healthy"
        else
            warning "Backend health check failed"
        fi
        
        # Check frontend health
        if curl -f -s "http://localhost:$FRONTEND_PORT/health" > /dev/null 2>&1; then
            success "Frontend is healthy"
            break
        else
            warning "Frontend health check failed"
        fi
        
        sleep 10
        ((attempt++))
    done
    
    if [[ $attempt -gt $max_attempts ]]; then
        error "Services failed to become healthy within the timeout period"
    fi
}

show_deployment_status() {
    log "Deployment Status:"
    echo
    echo "🌐 Application URLs:"
    echo "   Frontend: http://$SERVER_IP:$FRONTEND_PORT"
    echo "   Backend API: http://$SERVER_IP:$BACKEND_PORT/api"
    echo "   Health Check: http://$SERVER_IP:$FRONTEND_PORT/health"
    echo
    echo "📊 Container Status:"
    docker-compose -f "$DOCKER_COMPOSE_FILE" ps
    echo
    echo "📈 Resource Usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    echo
    echo "📝 Logs:"
    echo "   Application logs: docker-compose -f $DOCKER_COMPOSE_FILE logs -f"
    echo "   Deployment log: $LOG_FILE"
    echo
}

cleanup_old_images() {
    log "Cleaning up old Docker images..."
    
    # Remove dangling images
    docker image prune -f
    
    # Remove unused images older than 24 hours
    docker image prune -a -f --filter "until=24h"
    
    success "Cleanup completed"
}

rollback() {
    log "Rolling back to previous version..."
    
    # Stop current services
    docker-compose -f "$DOCKER_COMPOSE_FILE" down
    
    # Restore from latest backup
    local latest_backup=$(ls -t "$BACKUP_DIR"/backup-*.sql 2>/dev/null | head -n1)
    if [[ -n "$latest_backup" ]]; then
        log "Restoring database from: $latest_backup"
        docker-compose -f "$DOCKER_COMPOSE_FILE" up -d postgres
        sleep 30
        docker-compose -f "$DOCKER_COMPOSE_FILE" exec -T postgres psql -U nxzen_user -d nxzen_hrms_prod < "$latest_backup"
        success "Database rollback completed"
    else
        warning "No backup found for rollback"
    fi
    
    # Start services with previous images
    docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
    
    success "Rollback completed"
}

show_help() {
    echo "NXZEN HRMS Server Deployment Script"
    echo
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  deploy     Deploy the application (default)"
    echo "  rollback   Rollback to previous version"
    echo "  status     Show deployment status"
    echo "  logs       Show application logs"
    echo "  cleanup    Clean up old Docker images"
    echo "  help       Show this help message"
    echo
    echo "Environment Variables:"
    echo "  BACKEND_PORT    Backend port (default: 2035)"
    echo "  FRONTEND_PORT   Frontend port (default: 2036)"
    echo "  SERVER_IP       Server IP address (default: 149.102.158.71)"
    echo
}

show_logs() {
    log "Showing application logs..."
    docker-compose -f "$DOCKER_COMPOSE_FILE" logs -f --tail=100
}

show_status() {
    show_deployment_status
}

# Main execution
main() {
    local action="${1:-deploy}"
    
    case "$action" in
        "deploy")
            log "Starting deployment process..."
            check_requirements
            create_directories
            check_ports
            backup_database
            build_images
            deploy_services
            wait_for_services
            show_deployment_status
            success "Deployment completed successfully! 🚀"
            ;;
        "rollback")
            rollback
            ;;
        "status")
            show_status
            ;;
        "logs")
            show_logs
            ;;
        "cleanup")
            cleanup_old_images
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            error "Unknown action: $action. Use 'help' for available options."
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
