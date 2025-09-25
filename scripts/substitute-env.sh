#!/bin/bash

# =============================================================================
# ENVIRONMENT VARIABLE SUBSTITUTION SCRIPT
# =============================================================================
# This script substitutes environment variables in configuration files
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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to substitute environment variables in a file
substitute_env() {
    local file_path="$1"
    local output_path="$2"
    
    if [ ! -f "$file_path" ]; then
        print_error "File not found: $file_path"
        return 1
    fi
    
    print_status "Substituting environment variables in $file_path"
    
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_path")"
    
    # Substitute environment variables
    envsubst < "$file_path" > "$output_path"
    
    print_success "Created $output_path with environment substitution"
}

# Main execution
main() {
    print_status "Starting environment variable substitution..."
    
    # Load environment variables from .env if it exists
    if [ -f ".env" ]; then
        print_status "Loading environment variables from .env"
        set -a
        source .env
        set +a
    else
        print_status "No .env file found, using system environment variables"
    fi
    
    # Substitute nginx configuration
    if [ -f "nginx/nginx.conf" ]; then
        substitute_env "nginx/nginx.conf" "nginx/nginx.conf.substituted"
    else
        print_error "nginx/nginx.conf not found"
        exit 1
    fi
    
    print_success "Environment variable substitution completed!"
}

# Run main function
main "$@"
