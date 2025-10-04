#!/bin/bash

# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - DATABASE BACKUP SCRIPT
# =============================================================================
# Automated database backup with compression and retention
# =============================================================================

set -e  # Exit on any error

# Configuration
BACKUP_DIR="/backups"
DB_NAME="${POSTGRES_DB:-nxzen_hrms_prod}"
DB_USER="${POSTGRES_USER:-nxzen_user}"
DB_HOST="${DB_HOST:-postgres}"
DB_PORT="${DB_PORT:-5432}"
RETENTION_DAYS=30
COMPRESSION_LEVEL=9

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

# Function to create backup
create_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${BACKUP_DIR}/nxzen_backup_${timestamp}.sql"
    local compressed_file="${backup_file}.gz"
    
    print_status "Creating database backup..."
    print_status "Database: $DB_NAME"
    print_status "Host: $DB_HOST:$DB_PORT"
    print_status "Backup file: $backup_file"
    
    # Create backup
    pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
        --verbose \
        --no-password \
        --format=custom \
        --compress=9 \
        --file="$backup_file"
    
    # Compress backup
    print_status "Compressing backup..."
    gzip -$COMPRESSION_LEVEL "$backup_file"
    
    # Verify backup
    if [ -f "$compressed_file" ]; then
        local file_size=$(du -h "$compressed_file" | cut -f1)
        print_success "Backup created successfully: $compressed_file ($file_size)"
        
        # Create backup info file
        cat > "${compressed_file}.info" << EOF
Backup Information
=================
Database: $DB_NAME
Host: $DB_HOST:$DB_PORT
Created: $(date)
File: $compressed_file
Size: $file_size
Compression: gzip level $COMPRESSION_LEVEL
EOF
        
        return 0
    else
        print_error "Backup creation failed"
        return 1
    fi
}

# Function to cleanup old backups
cleanup_old_backups() {
    print_status "Cleaning up backups older than $RETENTION_DAYS days..."
    
    local deleted_count=0
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            rm -f "$file" "${file}.info"
            deleted_count=$((deleted_count + 1))
        fi
    done < <(find "$BACKUP_DIR" -name "nxzen_backup_*.sql.gz" -mtime +$RETENTION_DAYS -print0)
    
    if [ $deleted_count -gt 0 ]; then
        print_success "Cleaned up $deleted_count old backup(s)"
    else
        print_status "No old backups to clean up"
    fi
}

# Function to list backups
list_backups() {
    print_status "Available backups:"
    ls -lah "$BACKUP_DIR"/nxzen_backup_*.sql.gz 2>/dev/null | while read -r line; do
        echo "  $line"
    done
}

# Function to restore backup
restore_backup() {
    local backup_file="$1"
    
    if [ -z "$backup_file" ]; then
        print_error "Please specify backup file to restore"
        return 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi
    
    print_warning "This will restore the database from backup: $backup_file"
    print_warning "This action will REPLACE all current data!"
    read -p "Are you sure you want to continue? (yes/NO): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Restore cancelled"
        return 0
    fi
    
    print_status "Restoring database from backup..."
    
    # Decompress if needed
    if [[ "$backup_file" == *.gz ]]; then
        local temp_file="${backup_file%.gz}"
        gunzip -c "$backup_file" > "$temp_file"
        backup_file="$temp_file"
    fi
    
    # Restore database
    pg_restore -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
        --verbose \
        --no-password \
        --clean \
        --if-exists \
        "$backup_file"
    
    # Cleanup temp file
    if [ -f "${backup_file%.gz}" ] && [ "$backup_file" != "$1" ]; then
        rm -f "${backup_file%.gz}"
    fi
    
    print_success "Database restored successfully"
}

# Function to check disk space
check_disk_space() {
    local available_space=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    local required_space=1048576  # 1GB in KB
    
    if [ "$available_space" -lt "$required_space" ]; then
        print_warning "Low disk space: $(($available_space / 1024))MB available"
        print_warning "Consider cleaning up old backups"
        return 1
    fi
    
    return 0
}

# Main function
main() {
    print_status "Starting database backup process..."
    print_status "Timestamp: $(date)"
    
    # Check disk space
    if ! check_disk_space; then
        print_warning "Continuing with backup despite low disk space"
    fi
    
    # Create backup
    if create_backup; then
        # Cleanup old backups
        cleanup_old_backups
        
        # List current backups
        list_backups
        
        print_success "Backup process completed successfully"
    else
        print_error "Backup process failed"
        exit 1
    fi
}

# Handle script arguments
case "${1:-}" in
    "restore")
        restore_backup "$2"
        ;;
    "list")
        list_backups
        ;;
    "cleanup")
        cleanup_old_backups
        ;;
    "check")
        check_disk_space
        ;;
    *)
        main
        ;;
esac
