-- =============================================================================
-- DATA MIGRATION SCRIPT FOR ONBOARD PROJECT
-- =============================================================================
-- This script migrates data from existing database to the new structure
-- AND creates all missing tables to ensure complete database setup
-- 
-- Usage:
-- 1. Backup your existing database first
-- 2. Run this script on your existing database
-- 3. This will create missing tables and update existing data to match the new schema
-- =============================================================================

-- =============================================================================
-- TABLE CREATION SECTION
-- =============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- CORE AUTHENTICATION AND USER MANAGEMENT TABLES
-- =============================================================================

-- Users table - Core user authentication and basic info
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'employee' CHECK (role IN ('employee', 'manager', 'hr', 'admin')),
    temp_password VARCHAR(255),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relationship VARCHAR(50),
    emergency_contact_name2 VARCHAR(100),
    emergency_contact_phone2 VARCHAR(20),
    emergency_contact_relationship2 VARCHAR(50),
    is_temp_password BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee master table - Employee master data
CREATE TABLE IF NOT EXISTS employee_master (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(100) UNIQUE NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    company_email VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255),
    designation VARCHAR(100),
    department VARCHAR(100),
    doj DATE,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'terminated')),
    type VARCHAR(50) DEFAULT 'Full-Time' CHECK (type IN ('Full-Time', 'Part-Time', 'Contract', 'Intern')),
    manager_id VARCHAR(100),
    manager_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee forms table - Form submissions and document management
CREATE TABLE IF NOT EXISTS employee_forms (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('Intern', 'Contract', 'Full-Time', 'Manager')),
    form_data JSONB,
    files TEXT[],
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'approved', 'rejected')),
    submitted_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INTEGER REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT,
    draft_data JSONB,
    documents_uploaded JSONB,
    assigned_manager VARCHAR(255),
    manager2_name VARCHAR(255),
    manager3_name VARCHAR(255)
);

-- Onboarded employees table - Intermediate approval stage
CREATE TABLE IF NOT EXISTS onboarded_employees (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(100),
    name VARCHAR(255),
    email VARCHAR(255),
    designation VARCHAR(100),
    department VARCHAR(100),
    doj DATE,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Managers table - Manager information
CREATE TABLE IF NOT EXISTS managers (
    id SERIAL PRIMARY KEY,
    manager_id VARCHAR(100) UNIQUE NOT NULL,
    manager_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    department VARCHAR(100),
    designation VARCHAR(100),
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Manager-Employee Mapping table for attendance management
CREATE TABLE IF NOT EXISTS manager_employee_mapping (
    id SERIAL PRIMARY KEY,
    manager_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    mapping_type VARCHAR(50) DEFAULT 'primary' CHECK (mapping_type IN ('primary', 'secondary', 'tertiary')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(manager_id, employee_id, mapping_type)
);

-- Company emails table
CREATE TABLE IF NOT EXISTS company_emails (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_primary BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ATTENDANCE SYSTEM TABLES
-- =============================================================================

-- Attendance table for daily attendance records
CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('present', 'absent', 'wfh', 'leave', 'half_day', 'holiday')),
    check_in_time TIME,
    check_out_time TIME,
    clock_in_time TIME,
    clock_out_time TIME,
    total_hours DECIMAL(4,2),
    notes TEXT,
    reason TEXT,
    marked_by INTEGER REFERENCES users(id),
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INTEGER REFERENCES users(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, date)
);

-- Attendance settings table for configuration
CREATE TABLE IF NOT EXISTS attendance_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- LEAVE MANAGEMENT TABLES
-- =============================================================================

-- Leave types table
CREATE TABLE IF NOT EXISTS leave_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#6B7280',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leave requests table
CREATE TABLE IF NOT EXISTS leave_requests (
    id SERIAL PRIMARY KEY,
    series VARCHAR(50) NOT NULL,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    leave_type VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days DECIMAL(4,2) NOT NULL,
    reason TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leave balances table
CREATE TABLE IF NOT EXISTS leave_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    total_allocated INTEGER DEFAULT 0,
    leaves_taken INTEGER DEFAULT 0,
    leaves_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, year)
);

-- Leave type balances table
CREATE TABLE IF NOT EXISTS leave_type_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    leave_type VARCHAR(100) NOT NULL,
    total_allocated INTEGER DEFAULT 0,
    leaves_taken INTEGER DEFAULT 0,
    leaves_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, year, leave_type)
);

-- Compensatory off balances table
CREATE TABLE IF NOT EXISTS comp_off_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    total_earned INTEGER DEFAULT 0,
    comp_off_taken INTEGER DEFAULT 0,
    comp_off_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, year)
);

-- =============================================================================
-- EXPENSE MANAGEMENT TABLES
-- =============================================================================

-- Expense categories table
CREATE TABLE IF NOT EXISTS expense_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expense requests table
CREATE TABLE IF NOT EXISTS expense_requests (
    id SERIAL PRIMARY KEY,
    series VARCHAR(50) NOT NULL,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    expense_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'paid')),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expense attachments table
CREATE TABLE IF NOT EXISTS expense_attachments (
    id SERIAL PRIMARY KEY,
    expense_id INTEGER REFERENCES expense_requests(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expenses table (legacy)
CREATE TABLE IF NOT EXISTS expenses (
    id SERIAL PRIMARY KEY,
    series VARCHAR(50) NOT NULL,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    expense_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'paid')),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- DOCUMENT MANAGEMENT TABLES
-- =============================================================================

-- Document templates table
CREATE TABLE IF NOT EXISTS document_templates (
    id SERIAL PRIMARY KEY,
    document_name VARCHAR(255) UNIQUE NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    is_required BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Document collection table
CREATE TABLE IF NOT EXISTS document_collection (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT false,
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP
);

-- Employee documents table
CREATE TABLE IF NOT EXISTS employee_documents (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    document_category VARCHAR(50) DEFAULT 'general',
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    is_required BOOLEAN DEFAULT false,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT false,
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Document reminder mails table
CREATE TABLE IF NOT EXISTS document_reminder_mails (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    reminder_sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reminder_type VARCHAR(50) DEFAULT 'first',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Documents table (legacy)
CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT false,
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP
);

-- =============================================================================
-- SYSTEM CONFIGURATION TABLES
-- =============================================================================

-- Departments table
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    manager_id INTEGER REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relations table
CREATE TABLE IF NOT EXISTS relations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System settings table
CREATE TABLE IF NOT EXISTS system_settings (
    id SERIAL PRIMARY KEY,
    total_annual_leaves INTEGER DEFAULT 27,
    allow_half_day BOOLEAN DEFAULT true,
    approval_workflow VARCHAR(50) DEFAULT 'manager_then_hr',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Migration log table
CREATE TABLE IF NOT EXISTS migration_log (
    id SERIAL PRIMARY KEY,
    migration_name VARCHAR(255) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'completed',
    details TEXT,
    error_message TEXT
);

-- =============================================================================
-- ADDITIONAL BUSINESS TABLES
-- =============================================================================

-- ADP Payroll integration table
CREATE TABLE IF NOT EXISTS adp_payroll (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    adp_employee_id VARCHAR(100) UNIQUE NOT NULL,
    payroll_data JSONB,
    last_sync_at TIMESTAMP,
    sync_status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees combined view/table for unified employee data
CREATE TABLE IF NOT EXISTS employees_combined (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(100) UNIQUE NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    company_email VARCHAR(255),
    designation VARCHAR(100),
    department VARCHAR(100),
    doj DATE,
    status VARCHAR(50) DEFAULT 'active',
    type VARCHAR(50) DEFAULT 'Full-Time',
    manager_id VARCHAR(100),
    manager_name VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Onboarding process tracking table
CREATE TABLE IF NOT EXISTS onboarding (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    onboarding_stage VARCHAR(100) NOT NULL,
    stage_status VARCHAR(50) DEFAULT 'pending',
    stage_data JSONB,
    completed_at TIMESTAMP,
    assigned_to INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PNC Monitoring breakdowns table
CREATE TABLE IF NOT EXISTS pnc_monitoring_breakdowns (
    id SERIAL PRIMARY KEY,
    report_id INTEGER NOT NULL,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    percentage DECIMAL(5,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PNC Monitoring reports table
CREATE TABLE IF NOT EXISTS pnc_monitoring_reports (
    id SERIAL PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,
    report_type VARCHAR(100) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'draft',
    generated_by INTEGER REFERENCES users(id),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recruitment requisitions table
CREATE TABLE IF NOT EXISTS recruitment_requisitions (
    id SERIAL PRIMARY KEY,
    requisition_number VARCHAR(100) UNIQUE NOT NULL,
    position_title VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    reporting_manager VARCHAR(255),
    job_description TEXT,
    requirements TEXT,
    experience_level VARCHAR(50),
    salary_range_min DECIMAL(10,2),
    salary_range_max DECIMAL(10,2),
    urgency VARCHAR(50) DEFAULT 'normal',
    status VARCHAR(50) DEFAULT 'open',
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    closed_at TIMESTAMP
);

-- =============================================================================
-- MIGRATION LOGGING
-- =============================================================================

-- Create migration log entry
INSERT INTO migration_log (migration_name, executed_at, status, details)
VALUES ('DATA_MIGRATION_SCRIPT', CURRENT_TIMESTAMP, 'STARTED', 'Starting data migration process');

-- =============================================================================
-- USER DATA MIGRATION
-- =============================================================================

-- Update users table with missing columns if they don't exist
DO $$
BEGIN
    -- Add is_temp_password column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'is_temp_password') THEN
        ALTER TABLE users ADD COLUMN is_temp_password boolean DEFAULT false;
        RAISE NOTICE 'Added is_temp_password column to users table';
    END IF;
    
    -- Add emergency contact columns if they don't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'emergency_contact_name') THEN
        ALTER TABLE users ADD COLUMN emergency_contact_name character varying(100);
        ALTER TABLE users ADD COLUMN emergency_contact_phone character varying(20);
        ALTER TABLE users ADD COLUMN emergency_contact_relationship character varying(50);
        ALTER TABLE users ADD COLUMN emergency_contact_name2 character varying(100);
        ALTER TABLE users ADD COLUMN emergency_contact_phone2 character varying(20);
        ALTER TABLE users ADD COLUMN emergency_contact_relationship2 character varying(50);
        RAISE NOTICE 'Added emergency contact columns to users table';
    END IF;
END $$;

-- =============================================================================
-- EMPLOYEE FORMS DATA MIGRATION
-- =============================================================================

-- Update employee_forms to ensure DOJ is properly stored in form_data
UPDATE employee_forms 
SET form_data = COALESCE(form_data, '{}'::jsonb) || 
    CASE 
        WHEN form_data->>'doj' IS NULL AND form_data->>'doj' != '' 
        THEN '{"doj": "' || COALESCE(em.doj::text, '') || '"}'::jsonb
        ELSE '{}'::jsonb
    END
FROM employee_master em
WHERE employee_forms.employee_id = em.id 
  AND (form_data->>'doj' IS NULL OR form_data->>'doj' = '');

-- Update employee_forms with missing emergency contact data
UPDATE employee_forms 
SET form_data = COALESCE(form_data, '{}'::jsonb) || 
    jsonb_build_object(
        'emergencyContact', 
        jsonb_build_object(
            'name', COALESCE(u.emergency_contact_name, ''),
            'phone', COALESCE(u.emergency_contact_phone, ''),
            'relationship', COALESCE(u.emergency_contact_relationship, '')
        ),
        'emergencyContact2',
        jsonb_build_object(
            'name', COALESCE(u.emergency_contact_name2, ''),
            'phone', COALESCE(u.emergency_contact_phone2, ''),
            'relationship', COALESCE(u.emergency_contact_relationship2, '')
        )
    )
FROM users u
WHERE employee_forms.employee_id = u.id 
  AND (form_data->'emergencyContact' IS NULL OR form_data->'emergencyContact' = '{}'::jsonb);

-- =============================================================================
-- LEAVE MANAGEMENT DATA MIGRATION
-- =============================================================================

-- Create leave_types if they don't exist
INSERT INTO leave_types (type_name, description, color, is_active)
SELECT DISTINCT 
    leave_type as type_name,
    'Migrated leave type' as description,
    CASE 
        WHEN leave_type ILIKE '%annual%' THEN '#3B82F6'
        WHEN leave_type ILIKE '%sick%' THEN '#EF4444'
        WHEN leave_type ILIKE '%personal%' THEN '#10B981'
        WHEN leave_type ILIKE '%maternity%' THEN '#F59E0B'
        WHEN leave_type ILIKE '%paternity%' THEN '#8B5CF6'
        ELSE '#6B7280'
    END as color,
    true as is_active
FROM leave_requests
WHERE leave_type IS NOT NULL
ON CONFLICT (type_name) DO NOTHING;

-- Create leave_type_balances for existing leave_balances
INSERT INTO leave_type_balances (employee_id, year, leave_type, total_allocated, leaves_taken, leaves_remaining)
SELECT 
    lb.employee_id,
    lb.year,
    'Annual Leave' as leave_type,
    lb.total_allocated,
    lb.leaves_taken,
    lb.leaves_remaining
FROM leave_balances lb
WHERE NOT EXISTS (
    SELECT 1 FROM leave_type_balances ltb 
    WHERE ltb.employee_id = lb.employee_id 
    AND ltb.year = lb.year 
    AND ltb.leave_type = 'Annual Leave'
);

-- =============================================================================
-- DOCUMENT MANAGEMENT DATA MIGRATION
-- =============================================================================

-- Create document_templates if they don't exist
INSERT INTO document_templates (document_name, document_type, is_active)
VALUES 
    ('Aadhaar Card', 'aadhaar', true),
    ('PAN Card', 'pan', true),
    ('Passport', 'passport', true),
    ('Educational Certificate', 'education', true),
    ('Experience Certificate', 'experience', true),
    ('Bank Statement', 'bank_statement', true),
    ('Address Proof', 'address_proof', true),
    ('Driving License', 'driving_license', true),
    ('Voter ID', 'voter_id', true),
    ('Birth Certificate', 'birth_certificate', true)
ON CONFLICT (document_name) DO NOTHING;

-- =============================================================================
-- EXPENSE MANAGEMENT DATA MIGRATION
-- =============================================================================

-- Create expense_categories if they don't exist
INSERT INTO expense_categories (name, description, is_active)
VALUES 
    ('Travel', 'Business travel expenses', true),
    ('Meals', 'Business meal expenses', true),
    ('Office Supplies', 'Office equipment and supplies', true),
    ('Training', 'Professional development and training', true),
    ('Communication', 'Phone and internet expenses', true),
    ('Transportation', 'Local transportation costs', true),
    ('Accommodation', 'Hotel and accommodation expenses', true),
    ('Entertainment', 'Client entertainment expenses', true),
    ('Equipment', 'Office equipment and hardware', true),
    ('Software', 'Software licenses and subscriptions', true)
ON CONFLICT (name) DO NOTHING;

-- =============================================================================
-- ATTENDANCE DATA MIGRATION
-- =============================================================================

-- Create attendance_settings if they don't exist
INSERT INTO attendance_settings (setting_key, setting_value, description)
VALUES 
    ('work_hours_per_day', '8', 'Standard working hours per day'),
    ('half_day_hours', '4', 'Hours required for half day'),
    ('late_coming_tolerance', '15', 'Late coming tolerance in minutes'),
    ('early_going_tolerance', '15', 'Early going tolerance in minutes'),
    ('weekend_work_allowed', 'false', 'Whether weekend work is allowed'),
    ('overtime_allowed', 'true', 'Whether overtime is allowed')
ON CONFLICT (setting_key) DO NOTHING;

-- =============================================================================
-- SYSTEM SETTINGS MIGRATION
-- =============================================================================

-- Create system_settings if they don't exist
INSERT INTO system_settings (total_annual_leaves, allow_half_day, approval_workflow)
VALUES (27, true, 'manager_then_hr')
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- RELATIONS DATA MIGRATION
-- =============================================================================

-- Create relations if they don't exist
INSERT INTO relations (name, is_active)
VALUES 
    ('Spouse', true),
    ('Father', true),
    ('Mother', true),
    ('Brother', true),
    ('Sister', true),
    ('Son', true),
    ('Daughter', true),
    ('Friend', true),
    ('Colleague', true),
    ('Other', true)
ON CONFLICT (name) DO NOTHING;

-- =============================================================================
-- DATA CLEANUP AND VALIDATION
-- =============================================================================

-- Clean up orphaned records
DELETE FROM employee_documents 
WHERE employee_id NOT IN (SELECT id FROM users);

DELETE FROM leave_requests 
WHERE employee_id NOT IN (SELECT id FROM users);

DELETE FROM leave_balances 
WHERE employee_id NOT IN (SELECT id FROM users);

DELETE FROM attendance 
WHERE employee_id NOT IN (SELECT id FROM users);

DELETE FROM expenses 
WHERE employee_id NOT IN (SELECT id FROM users);

-- Update employee_master with missing data
UPDATE employee_master 
SET status = 'active' 
WHERE status IS NULL;

UPDATE employee_master 
SET type = 'Full-Time' 
WHERE type IS NULL;

-- =============================================================================
-- INDEX CREATION FOR PERFORMANCE
-- =============================================================================

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_employee_forms_employee_id ON employee_forms(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_forms_status ON employee_forms(status);
CREATE INDEX IF NOT EXISTS idx_employee_master_company_email ON employee_master(company_email);
CREATE INDEX IF NOT EXISTS idx_employee_master_employee_id ON employee_master(employee_id);
CREATE INDEX IF NOT EXISTS idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX IF NOT EXISTS idx_leave_requests_employee_id ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_employee_documents_employee_id ON employee_documents(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_documents_type ON employee_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_expenses_employee_id ON expenses(employee_id);
CREATE INDEX IF NOT EXISTS idx_expenses_status ON expenses(status);

-- =============================================================================
-- DATA VALIDATION
-- =============================================================================

-- Validate data integrity
DO $$
DECLARE
    table_count INTEGER;
    user_count INTEGER;
    employee_count INTEGER;
    form_count INTEGER;
    document_count INTEGER;
    leave_count INTEGER;
    attendance_count INTEGER;
    expense_count INTEGER;
    manager_count INTEGER;
    department_count INTEGER;
BEGIN
    -- Count total tables
    SELECT COUNT(*) INTO table_count FROM information_schema.tables WHERE table_schema = 'public';
    
    -- Count records
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO employee_count FROM employee_master;
    SELECT COUNT(*) INTO form_count FROM employee_forms;
    SELECT COUNT(*) INTO document_count FROM employee_documents;
    SELECT COUNT(*) INTO leave_count FROM leave_requests;
    SELECT COUNT(*) INTO attendance_count FROM attendance;
    SELECT COUNT(*) INTO expense_count FROM expenses;
    SELECT COUNT(*) INTO manager_count FROM managers;
    SELECT COUNT(*) INTO department_count FROM departments;
    
    -- Log validation results
    RAISE NOTICE '========================================';
    RAISE NOTICE 'DATA MIGRATION VALIDATION RESULTS';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Total Tables Created: %', table_count;
    RAISE NOTICE 'Users: %', user_count;
    RAISE NOTICE 'Employees: %', employee_count;
    RAISE NOTICE 'Forms: %', form_count;
    RAISE NOTICE 'Documents: %', document_count;
    RAISE NOTICE 'Leave Requests: %', leave_count;
    RAISE NOTICE 'Attendance Records: %', attendance_count;
    RAISE NOTICE 'Expense Records: %', expense_count;
    RAISE NOTICE 'Managers: %', manager_count;
    RAISE NOTICE 'Departments: %', department_count;
    RAISE NOTICE '========================================';
    
    -- Check for data consistency
    IF user_count = 0 THEN
        RAISE WARNING 'No users found in database';
    END IF;
    
    IF employee_count = 0 THEN
        RAISE WARNING 'No employees found in master table';
    END IF;
    
    -- Verify all expected tables exist
    IF table_count < 33 THEN
        RAISE WARNING 'Expected at least 33 tables, found only %', table_count;
    ELSE
        RAISE NOTICE 'All expected tables have been created successfully';
    END IF;
    
    RAISE NOTICE 'Data migration validation completed successfully';
END $$;

-- =============================================================================
-- MIGRATION COMPLETION
-- =============================================================================

-- Update migration log
UPDATE migration_log 
SET status = 'COMPLETED', 
    details = 'Data migration completed successfully. All tables updated with proper structure and sample data.'
WHERE migration_name = 'DATA_MIGRATION_SCRIPT';

-- Final success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'DATA MIGRATION COMPLETED SUCCESSFULLY!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'All data has been migrated and validated.';
    RAISE NOTICE 'Your database is now ready for use.';
    RAISE NOTICE '========================================';
END $$;
