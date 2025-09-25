#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - DEPLOYMENT SCRIPT
# =============================================================================
# Complete deployment script with environment-based configuration
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Docker is installed
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check if Docker Compose is installed
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if .env file exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from .env.example..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_warning "Please update .env file with your actual values before continuing."
            print_warning "Edit .env file and run this script again."
            exit 1
        else
            print_error ".env.example file not found. Cannot create .env file."
            exit 1
        fi
    fi
    
    print_success "Prerequisites check passed"
}

# Function to validate environment variables
validate_env() {
    print_status "Validating environment variables..."
    
    # Load environment variables
    source .env
    
    # Required variables
    required_vars=(
        "DB_PASSWORD"
        "JWT_SECRET"
        "EMAIL_USER"
        "EMAIL_PASS"
    )
    
    missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ] || [ "${!var}" = "your_secure_password_here" ] || [ "${!var}" = "your-super-secret-jwt-key-change-in-production" ] || [ "${!var}" = "your-email@gmail.com" ] || [ "${!var}" = "your-app-password" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        print_error "Please update the following environment variables in .env:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        exit 1
    fi
    
    print_success "Environment variables validation passed"
}

# Function to build and start services
deploy() {
    print_status "Starting deployment..."
    
    # Substitute environment variables in nginx config
    print_status "Substituting environment variables in nginx configuration..."
    ./scripts/substitute-env.sh
    
    # Build and start services
    print_status "Building and starting Docker containers..."
    docker-compose --env-file .env up -d --build
    
    print_success "Deployment completed!"
}

# Function to check service health
check_health() {
    print_status "Checking service health..."
    
    # Wait for services to start
    print_status "Waiting for services to start (30 seconds)..."
    sleep 30
    
    # Check if containers are running
    if docker-compose ps | grep -q "Up"; then
        print_success "Services are running"
        
        # Show service status
        print_status "Service status:"
        docker-compose ps
        
        # Show logs
        print_status "Recent logs:"
        docker-compose logs --tail=20
        
    else
        print_error "Some services failed to start"
        print_status "Checking logs for errors:"
        docker-compose logs
        exit 1
    fi
}

# Function to show access information
show_access_info() {
    print_status "Access Information:"
    echo ""
    echo "🌐 Frontend: http://localhost:${FRONTEND_PORT:-3001}"
    echo "🔧 Backend API: http://localhost:${BACKEND_PORT:-5001}/api"
    echo "🗄️  Database: localhost:${DB_PORT:-5432}"
    echo ""
    echo "📊 Health Checks:"
    echo "  - Frontend: http://localhost:${FRONTEND_PORT:-3001}/health"
    echo "  - Backend: http://localhost:${BACKEND_PORT:-5001}/api/health"
    echo ""
    echo "🔍 Monitoring (if enabled):"
    echo "  - Prometheus: http://localhost:${PROMETHEUS_PORT:-9090}"
    echo "  - Grafana: http://localhost:${GRAFANA_PORT:-3001}"
    echo ""
    echo "📝 Useful Commands:"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Stop services: docker-compose down"
    echo "  - Restart services: docker-compose restart"
    echo "  - Update services: docker-compose up -d --build"
    echo ""
}

# Function to run database migrations
run_migrations() {
    print_status "Running database migrations..."
    
    # Wait for database to be ready
    print_status "Waiting for database to be ready..."
    sleep 10
    
    # Run migrations using the setup script
    if [ -f "scripts/setup_db.sh" ]; then
        print_status "Running database setup..."
        ./scripts/setup_db.sh
    else
        print_warning "Database setup script not found. Please run migrations manually."
    fi
}

# Main execution
main() {
    echo "============================================================================="
    echo "NXZEN EMPLOYEE MANAGEMENT SYSTEM - DEPLOYMENT"
    echo "============================================================================="
    echo ""
    
    # Parse command line arguments
    case "${1:-deploy}" in
        "deploy")
            check_prerequisites
            validate_env
            deploy
            run_migrations
            check_health
            show_access_info
            ;;
        "stop")
            print_status "Stopping services..."
            docker-compose down
            print_success "Services stopped"
            ;;
        "restart")
            print_status "Restarting services..."
            docker-compose restart
            print_success "Services restarted"
            ;;
        "logs")
            print_status "Showing logs..."
            docker-compose logs -f
            ;;
        "status")
            print_status "Service status:"
            docker-compose ps
            ;;
        "health")
            check_health
            ;;
        "update")
            print_status "Updating services..."
            docker-compose up -d --build
            print_success "Services updated"
            ;;
        *)
            echo "Usage: $0 {deploy|stop|restart|logs|status|health|update}"
            echo ""
            echo "Commands:"
            echo "  deploy   - Deploy the application (default)"
            echo "  stop     - Stop all services"
            echo "  restart  - Restart all services"
            echo "  logs     - Show logs"
            echo "  status   - Show service status"
            echo "  health   - Check service health"
            echo "  update   - Update services"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
