#!/bin/bash

# =============================================================================
# APPLICATION RUNNER SCRIPT
# =============================================================================
# This script starts both backend and frontend servers
# Backend runs on port 5001, Frontend on port 3001
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

# Configuration
BACKEND_PORT=5001
FRONTEND_PORT=3001
BACKEND_DIR="../backend"
FRONTEND_DIR="../frontend"

echo "============================================================================="
echo "APPLICATION RUNNER SCRIPT"
echo "============================================================================="
echo "Backend Port: $BACKEND_PORT"
echo "Frontend Port: $FRONTEND_PORT"
echo "============================================================================="

# Check if Node.js is installed
print_status "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed or not in PATH"
    print_error "Please install Node.js from https://nodejs.org/"
    exit 1
fi
print_success "Node.js is installed"

# Check if required directories exist
if [ ! -d "$BACKEND_DIR" ]; then
    print_error "Backend directory not found: $BACKEND_DIR"
    exit 1
fi

if [ ! -d "$FRONTEND_DIR" ]; then
    print_error "Frontend directory not found: $FRONTEND_DIR"
    exit 1
fi

# Check if node_modules exist
if [ ! -d "$BACKEND_DIR/node_modules" ]; then
    print_error "Backend dependencies not installed"
    print_error "Please run: cd $BACKEND_DIR && npm install"
    exit 1
fi

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
    print_error "Frontend dependencies not installed"
    print_error "Please run: cd $FRONTEND_DIR && npm install"
    exit 1
fi

# Function to cleanup processes on exit
cleanup() {
    print_status "Stopping application servers..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null || true
        print_status "Backend server stopped"
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null || true
        print_status "Frontend server stopped"
    fi
    print_success "Application stopped"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Start backend server
print_status "Starting backend server on port $BACKEND_PORT..."
cd $BACKEND_DIR

# Set environment variables for backend
export PORT=$BACKEND_PORT
export NODE_ENV=development

# Start backend in background
npm start > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
cd - > /dev/null

# Wait for backend to start
print_status "Waiting for backend to start..."
sleep 3

# Check if backend is running
if kill -0 $BACKEND_PID 2>/dev/null; then
    print_success "Backend server started (PID: $BACKEND_PID)"
else
    print_error "Failed to start backend server"
    exit 1
fi

# Start frontend server
print_status "Starting frontend server on port $FRONTEND_PORT..."
cd $FRONTEND_DIR

# Set environment variables for frontend
export PORT=$FRONTEND_PORT
export REACT_APP_API_URL=http://localhost:$BACKEND_PORT/api

# Start frontend in background
npm start > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
cd - > /dev/null

# Wait for frontend to start
print_status "Waiting for frontend to start..."
sleep 5

# Check if frontend is running
if kill -0 $FRONTEND_PID 2>/dev/null; then
    print_success "Frontend server started (PID: $FRONTEND_PID)"
else
    print_error "Failed to start frontend server"
    cleanup
    exit 1
fi

# Create logs directory if it doesn't exist
mkdir -p ../logs

echo ""
print_success "Application started successfully! 🎉"
echo "============================================================================="
echo "Backend Server: http://localhost:$BACKEND_PORT"
echo "Frontend Application: http://localhost:$FRONTEND_PORT"
echo "Backend Logs: ../logs/backend.log"
echo "Frontend Logs: ../logs/frontend.log"
echo "============================================================================="
echo ""
echo "Test Credentials:"
echo "- HR: hr@nxzen.com / password123"
echo ""
echo "Press Ctrl+C to stop the application"
echo ""

# Monitor the processes
while true; do
    # Check if backend is still running
    if ! kill -0 $BACKEND_PID 2>/dev/null; then
        print_error "Backend server stopped unexpectedly"
        cleanup
        exit 1
    fi
    
    # Check if frontend is still running
    if ! kill -0 $FRONTEND_PID 2>/dev/null; then
        print_error "Frontend server stopped unexpectedly"
        cleanup
        exit 1
    fi
    
    sleep 1
done
