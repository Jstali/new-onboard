#!/bin/bash

# =============================================================================
# DOCKER SETUP TEST SCRIPT
# =============================================================================
# Test the Docker configuration and environment setup
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Test 1: Check if .env file exists and has required variables
test_env_file() {
    print_status "Testing .env file..."
    
    if [ ! -f ".env" ]; then
        print_error ".env file not found"
        return 1
    fi
    
    # Load environment variables
    source .env
    
    # Check required variables
    required_vars=("DB_PASSWORD" "JWT_SECRET" "EMAIL_USER" "EMAIL_PASS")
    missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ] || [ "${!var}" = "your_secure_password_here" ] || [ "${!var}" = "your-super-secret-jwt-key-change-in-production" ] || [ "${!var}" = "your-email@gmail.com" ] || [ "${!var}" = "your-app-password" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        print_error "Missing or default values for: ${missing_vars[*]}"
        return 1
    fi
    
    print_success ".env file validation passed"
}

# Test 2: Check Docker and Docker Compose
test_docker() {
    print_status "Testing Docker installation..."
    
    if ! command -v docker >/dev/null 2>&1; then
        print_error "Docker is not installed"
        return 1
    fi
    
    if ! command -v docker-compose >/dev/null 2>&1; then
        print_error "Docker Compose is not installed"
        return 1
    fi
    
    print_success "Docker and Docker Compose are available"
}

# Test 3: Validate Docker Compose configuration
test_docker_compose() {
    print_status "Testing Docker Compose configuration..."
    
    if ! docker-compose --env-file .env config >/dev/null 2>&1; then
        print_error "Docker Compose configuration is invalid"
        docker-compose --env-file .env config
        return 1
    fi
    
    print_success "Docker Compose configuration is valid"
}

# Test 4: Check if required files exist
test_required_files() {
    print_status "Testing required files..."
    
    required_files=(
        "backend/Dockerfile"
        "frontend/Dockerfile"
        "docker-compose.yml"
        "nginx/nginx.conf"
        ".dockerignore"
        "scripts/deploy.sh"
        "scripts/substitute-env.sh"
    )
    
    missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "Missing required files: ${missing_files[*]}"
        return 1
    fi
    
    print_success "All required files exist"
}

# Test 5: Test environment variable substitution
test_env_substitution() {
    print_status "Testing environment variable substitution..."
    
    if [ ! -f "scripts/substitute-env.sh" ]; then
        print_error "Environment substitution script not found"
        return 1
    fi
    
    if ! ./scripts/substitute-env.sh >/dev/null 2>&1; then
        print_error "Environment variable substitution failed"
        return 1
    fi
    
    print_success "Environment variable substitution works"
}

# Test 6: Test Docker build (dry run)
test_docker_build() {
    print_status "Testing Docker build (dry run)..."
    
    # Test backend build
    if ! docker build -f backend/Dockerfile backend >/dev/null 2>&1; then
        print_error "Backend Docker build failed"
        return 1
    fi
    
    # Test frontend build
    if ! docker build -f frontend/Dockerfile frontend >/dev/null 2>&1; then
        print_error "Frontend Docker build failed"
        return 1
    fi
    
    print_success "Docker builds are working"
}

# Main test function
main() {
    echo "============================================================================="
    echo "DOCKER SETUP TEST"
    echo "============================================================================="
    echo ""
    
    tests=(
        "test_required_files"
        "test_docker"
        "test_env_file"
        "test_docker_compose"
        "test_env_substitution"
        "test_docker_build"
    )
    
    passed=0
    failed=0
    
    for test in "${tests[@]}"; do
        if $test; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    echo ""
    echo "============================================================================="
    echo "TEST RESULTS"
    echo "============================================================================="
    echo "✅ Passed: $passed"
    echo "❌ Failed: $failed"
    echo ""
    
    if [ $failed -eq 0 ]; then
        print_success "All tests passed! Docker setup is ready for deployment."
        echo ""
        echo "Next steps:"
        echo "1. Review and update .env file if needed"
        echo "2. Run: ./scripts/deploy.sh"
        echo "3. Access application at http://localhost:3001"
    else
        print_error "Some tests failed. Please fix the issues before deploying."
        exit 1
    fi
}

# Run main function
main "$@"
