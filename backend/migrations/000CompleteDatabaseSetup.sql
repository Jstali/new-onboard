-- =============================================================================
-- COMPLETE DATABASE SETUP MIGRATION
-- =============================================================================
-- Description: Complete database setup for NXZEN HR Employee Onboarding System
-- Created: 2025-01-17
-- Author: System
-- Version: 1.0
-- 
-- This migration combines all previous migrations into one comprehensive setup
-- Run this file to set up the complete database structure
-- =============================================================================

-- =============================================================================
-- CORE TABLES
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

-- Employee master table - Final employee records
CREATE TABLE IF NOT EXISTS employee_master (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(100) UNIQUE NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    email VARCHAR(255), -- Personal email
    company_email VARCHAR(255) UNIQUE,
    manager_id VARCHAR(100),
    manager_name VARCHAR(100),
    manager2_id VARCHAR(100),
    manager2_name VARCHAR(100),
    manager3_id VARCHAR(100),
    manager3_name VARCHAR(100),
    type VARCHAR(50) NOT NULL CHECK (type IN ('Intern', 'Contract', 'Full-Time', 'Manager')),
    role VARCHAR(100),
    doj DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'terminated')),
    department VARCHAR(100),
    designation VARCHAR(100),
    salary_band VARCHAR(50),
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employee_master_name_email_unique UNIQUE (employee_name, email)
);

-- Onboarded employees table - Intermediate approval stage
CREATE TABLE IF NOT EXISTS onboarded_employees (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    employee_id VARCHAR(100),
    company_email VARCHAR(255),
    manager_id VARCHAR(100),
    manager_name VARCHAR(100),
    employee_type VARCHAR(50) DEFAULT 'Full-Time',
    assigned_by INTEGER REFERENCES users(id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending_assignment' CHECK (status IN ('pending_assignment', 'assigned', 'completed')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Managers table
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

-- =============================================================================
-- DOCUMENT MANAGEMENT TABLES
-- =============================================================================

-- Document templates
CREATE TABLE IF NOT EXISTS document_templates (
    id SERIAL PRIMARY KEY,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50),
    is_required BOOLEAN DEFAULT false,
    allow_multiple BOOLEAN DEFAULT false
);

-- Document collection
CREATE TABLE IF NOT EXISTS document_collection (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    employee_name VARCHAR(255),
    emp_id VARCHAR(100),
    department VARCHAR(100),
    join_date DATE,
    due_date DATE,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    uploaded_file_url TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee documents
CREATE TABLE IF NOT EXISTS employee_documents (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    document_category VARCHAR(50) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    is_required BOOLEAN DEFAULT false,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resend_count INTEGER DEFAULT 0,
    last_resend_date TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending'
);

-- =============================================================================
-- ATTENDANCE SYSTEM TABLES
-- =============================================================================

-- Manager-Employee Mapping table
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

-- Attendance table
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

-- Attendance settings
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

-- Leave types
CREATE TABLE IF NOT EXISTS leave_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    max_days_per_year INTEGER DEFAULT 0,
    carry_forward BOOLEAN DEFAULT false,
    is_paid BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leave requests
CREATE TABLE IF NOT EXISTS leave_requests (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    leave_type VARCHAR(50) NOT NULL CHECK (leave_type IN ('casual', 'sick', 'annual', 'maternity', 'paternity', 'comp_off')),
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    total_leave_days INTEGER NOT NULL,
    reason TEXT,
    status VARCHAR(50) DEFAULT 'Pending Manager Approval' CHECK (status IN ('Pending Manager Approval', 'Pending HR Approval', 'Manager Approved', 'HR Approved', 'rejected')),
    manager_id INTEGER REFERENCES users(id),
    managerApprovedAt TIMESTAMP,
    managerApprovalNotes TEXT,
    hr_id INTEGER REFERENCES users(id),
    hrApprovedAt TIMESTAMP,
    hr_comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    approval_notes TEXT
);

-- Leave balances
CREATE TABLE IF NOT EXISTS leave_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    leave_type VARCHAR(50) NOT NULL CHECK (leave_type IN ('casual', 'sick', 'annual', 'maternity', 'paternity', 'comp_off')),
    total_allocated INTEGER DEFAULT 0,
    leaves_taken INTEGER DEFAULT 0,
    leaves_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, year, leave_type)
);

-- =============================================================================
-- EXPENSE MANAGEMENT TABLES
-- =============================================================================

-- Expense categories
CREATE TABLE IF NOT EXISTS expense_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expense requests
CREATE TABLE IF NOT EXISTS expense_requests (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES expense_categories(id),
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    expense_date DATE NOT NULL,
    receipt_url TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'reimbursed')),
    approved_by INTEGER REFERENCES users(id),
    approved_at TIMESTAMP,
    approval_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ADP PAYROLL INTEGRATION TABLE
-- =============================================================================

CREATE TABLE IF NOT EXISTS adp_payroll (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(100) UNIQUE NOT NULL REFERENCES employee_master(employee_id) ON DELETE CASCADE,
    
    -- Basic Information
    name_prefix VARCHAR(10),
    employee_full_name VARCHAR(255),
    given_or_first_name VARCHAR(100),
    middle_name VARCHAR(100),
    last_name VARCHAR(100),
    joining_date DATE,
    payroll_starting_month DATE,
    dob DATE,
    aadhar VARCHAR(12),
    name_as_per_aadhar VARCHAR(255),
    designation_description VARCHAR(255),
    email VARCHAR(255),
    alternate_email VARCHAR(255),
    pan VARCHAR(10),
    name_as_per_pan VARCHAR(255),
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    department_description VARCHAR(255),
    work_location VARCHAR(255),
    labour_state_description VARCHAR(255),
    
    -- Contact Information
    mobile_number VARCHAR(15),
    phone_number1 VARCHAR(15),
    phone_number2 VARCHAR(15),
    
    -- Address Information
    address1 TEXT,
    address2 TEXT,
    address3 TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),
    country VARCHAR(100),
    nationality VARCHAR(100),
    
    -- Banking Information
    bank_name VARCHAR(255),
    name_as_per_bank VARCHAR(255),
    account_no VARCHAR(50),
    bank_ifsc_code VARCHAR(15),
    payment_mode VARCHAR(50),
    
    -- PF/ESI Information
    pf_account_no VARCHAR(50),
    esi_account_no VARCHAR(50),
    esi_above_wage_limit BOOLEAN DEFAULT false,
    uan VARCHAR(20),
    branch_description VARCHAR(255),
    enrollment_id VARCHAR(50),
    manager_employee_id VARCHAR(100),
    tax_regime VARCHAR(50),
    
    -- Family Information
    father_name VARCHAR(255),
    mother_name VARCHAR(255),
    spouse_name VARCHAR(255),
    marital_status VARCHAR(20) CHECK (marital_status IN ('Single', 'Married', 'Divorced', 'Widowed')),
    number_of_children INTEGER DEFAULT 0,
    
    -- Employment Information
    employment_type VARCHAR(50),
    grade_description VARCHAR(255),
    cadre_description VARCHAR(255),
    payment_description VARCHAR(255),
    attendance_description VARCHAR(255),
    workplace_description VARCHAR(255),
    band VARCHAR(50),
    level VARCHAR(50),
    work_cost_center VARCHAR(100),
    
    -- System Fields
    is_draft BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT adp_payroll_employee_id_unique UNIQUE (employee_id)
);

-- =============================================================================
-- P&C MONITORING TABLES
-- =============================================================================

-- P&C Monthly Monitoring Reports
CREATE TABLE IF NOT EXISTS pnc_monitoring_reports (
    id SERIAL PRIMARY KEY,
    report_month VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    report_year INTEGER NOT NULL,
    report_month_number INTEGER NOT NULL,
    
    -- Statistics
    total_headcount INTEGER DEFAULT 0,
    total_contractors INTEGER DEFAULT 0,
    total_leavers INTEGER DEFAULT 0,
    future_joiners INTEGER DEFAULT 0,
    total_vacancies INTEGER DEFAULT 0,
    
    -- Demographics
    average_age DECIMAL(5,2) DEFAULT 0,
    average_tenure DECIMAL(5,2) DEFAULT 0,
    disability_percentage DECIMAL(5,2) DEFAULT 0,
    attrition_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Report metadata
    report_data JSONB, -- Store complete report data
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    generated_by INTEGER REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    
    -- Indexes and constraints
    CONSTRAINT unique_month_report UNIQUE (report_month),
    CONSTRAINT valid_month_format CHECK (report_month ~ '^\d{4}-\d{2}$'),
    CONSTRAINT valid_year CHECK (report_year >= 2020 AND report_year <= 2050),
    CONSTRAINT valid_month_number CHECK (report_month_number >= 1 AND report_month_number <= 12)
);

-- =============================================================================
-- SYSTEM CONFIGURATION TABLES
-- =============================================================================

-- Departments
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    manager_id INTEGER REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System settings
CREATE TABLE IF NOT EXISTS system_settings (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(category, setting_key)
);

-- Migration tracking
CREATE TABLE IF NOT EXISTS migration_log (
    id SERIAL PRIMARY KEY,
    migration_name VARCHAR(255) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'completed',
    error_message TEXT
);

-- Relations/lookup table
CREATE TABLE IF NOT EXISTS relations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Core table indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_employee_forms_employee_id ON employee_forms(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_forms_status ON employee_forms(status);
CREATE INDEX IF NOT EXISTS idx_employee_master_company_email ON employee_master(company_email);
CREATE INDEX IF NOT EXISTS idx_employee_master_email ON employee_master(email);
CREATE INDEX IF NOT EXISTS idx_employee_master_status ON employee_master(status);

-- Document indexes
CREATE INDEX IF NOT EXISTS idx_employee_documents_employee_id ON employee_documents(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_documents_type ON employee_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_employee_documents_category ON employee_documents(document_category);

-- Attendance indexes
CREATE INDEX IF NOT EXISTS idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_attendance_status ON attendance(status);
CREATE INDEX IF NOT EXISTS idx_manager_employee_mapping_manager ON manager_employee_mapping(manager_id);
CREATE INDEX IF NOT EXISTS idx_manager_employee_mapping_employee ON manager_employee_mapping(employee_id);

-- Leave indexes
CREATE INDEX IF NOT EXISTS idx_leave_requests_employee_id ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_leave_balances_employee_year ON leave_balances(employee_id, year);

-- Expense indexes
CREATE INDEX IF NOT EXISTS idx_expense_requests_employee_id ON expense_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_expense_requests_status ON expense_requests(status);

-- ADP Payroll indexes
CREATE INDEX IF NOT EXISTS idx_adp_payroll_employee_id ON adp_payroll(employee_id);
CREATE INDEX IF NOT EXISTS idx_adp_payroll_is_draft ON adp_payroll(is_draft);

-- P&C Monitoring indexes
CREATE INDEX IF NOT EXISTS idx_pnc_reports_month ON pnc_monitoring_reports(report_month);
CREATE INDEX IF NOT EXISTS idx_pnc_reports_year_month ON pnc_monitoring_reports(report_year, report_month_number);

-- =============================================================================
-- DEFAULT DATA INSERTION
-- =============================================================================

-- Insert default attendance settings
INSERT INTO attendance_settings (setting_key, setting_value, description) VALUES
('allow_edit_past_days', 'true', 'Allow employees to edit attendance for past days'),
('max_edit_days', '7', 'Maximum number of days in the past that can be edited'),
('require_check_in_time', 'false', 'Require check-in time when marking attendance'),
('require_check_out_time', 'false', 'Require check-out time when marking attendance'),
('default_work_hours', '8', 'Default work hours per day'),
('week_start_day', 'monday', 'First day of the work week'),
('timezone', 'UTC', 'Default timezone for attendance records'),
('auto_approve_attendance', 'true', 'Automatically approve attendance submissions'),
('notification_enabled', 'true', 'Enable attendance notifications'),
('late_threshold_minutes', '15', 'Minutes after which attendance is marked as late')
ON CONFLICT (setting_key) DO NOTHING;

-- Insert default leave types (only if table has the correct structure)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leave_types' AND column_name = 'name') THEN
        INSERT INTO leave_types (name, description, max_days_per_year, carry_forward, is_paid) VALUES
        ('Annual Leave', 'Annual vacation leave', 21, true, true),
        ('Sick Leave', 'Medical leave', 12, false, true),
        ('Personal Leave', 'Personal time off', 5, false, true),
        ('Maternity Leave', 'Maternity leave', 180, false, true),
        ('Paternity Leave', 'Paternity leave', 15, false, true),
        ('Emergency Leave', 'Emergency situations', 3, false, true)
        ON CONFLICT (name) DO NOTHING;
    END IF;
END $$;

-- Insert default expense categories
INSERT INTO expense_categories (name, description) VALUES
('Travel', 'Travel and transportation expenses'),
('Meals', 'Business meal expenses'),
('Office Supplies', 'Office supplies and equipment'),
('Training', 'Training and development expenses'),
('Communication', 'Phone and internet expenses'),
('Others', 'Miscellaneous expenses')
ON CONFLICT (name) DO NOTHING;

-- Insert default relations
INSERT INTO relations (name) VALUES
('Father'), ('Mother'), ('Spouse'), ('Sibling'), ('Child'), ('Friend'), ('Other')
ON CONFLICT (name) DO NOTHING;

-- Insert system settings (only if table has the correct structure)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'system_settings' AND column_name = 'category') THEN
        INSERT INTO system_settings (category, setting_key, setting_value, description) VALUES
        ('company', 'name', 'NXZEN Technologies', 'Company name'),
        ('company', 'address', 'Your Company Address', 'Company address'),
        ('company', 'email', 'hr@nxzen.com', 'Company email'),
        ('leave', 'casual_leave_per_year', '12', 'Annual casual leave allocation'),
        ('leave', 'sick_leave_per_year', '12', 'Annual sick leave allocation'),
        ('leave', 'annual_leave_per_year', '21', 'Annual leave allocation'),
        ('attendance', 'office_start_time', '09:00', 'Office start time'),
        ('attendance', 'office_end_time', '18:00', 'Office end time'),
        ('expense', 'max_amount_without_approval', '5000', 'Maximum expense amount without approval')
        ON CONFLICT (category, setting_key) DO NOTHING;
    END IF;
END $$;

-- =============================================================================
-- FUNCTIONS AND STORED PROCEDURES
-- =============================================================================

-- Drop existing function to prevent parameter conflicts
DROP FUNCTION IF EXISTS manually_add_employee(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR) CASCADE;

-- Function to manually add employee with employment type
CREATE OR REPLACE FUNCTION manually_add_employee(
    p_email VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_role VARCHAR,
    p_employment_type VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    user_id INTEGER;
    employee_id_val VARCHAR;
BEGIN
    -- Insert into users table
    INSERT INTO users (email, first_name, last_name, role, password)
    VALUES (p_email, p_first_name, p_last_name, p_role, '$2b$10$defaulthash')
    RETURNING id INTO user_id;
    
    -- Generate employee ID
    employee_id_val := 'EMP' || LPAD(user_id::TEXT, 6, '0');
    
    -- Insert into employee_forms table with employment type
    INSERT INTO employee_forms (employee_id, type, status)
    VALUES (user_id, p_employment_type, 'pending');
    
    RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- Function to get attendance statistics
CREATE OR REPLACE FUNCTION get_attendance_stats(
    p_employee_id INTEGER,
    p_start_date DATE,
    p_end_date DATE
) RETURNS TABLE(
    total_days INTEGER,
    present_days INTEGER,
    wfh_days INTEGER,
    leave_days INTEGER,
    absent_days INTEGER,
    half_day_days INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_days,
        COUNT(CASE WHEN status = 'present' THEN 1 END)::INTEGER as present_days,
        COUNT(CASE WHEN status = 'wfh' THEN 1 END)::INTEGER as wfh_days,
        COUNT(CASE WHEN status = 'leave' THEN 1 END)::INTEGER as leave_days,
        COUNT(CASE WHEN status = 'absent' THEN 1 END)::INTEGER as absent_days,
        COUNT(CASE WHEN status = 'half_day' THEN 1 END)::INTEGER as half_day_days
    FROM attendance 
    WHERE employee_id = p_employee_id 
        AND date BETWEEN p_start_date AND p_end_date;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate leave balance
CREATE OR REPLACE FUNCTION update_leave_balance(
    p_employee_id INTEGER,
    p_year INTEGER,
    p_leave_type VARCHAR
) RETURNS VOID AS $$
DECLARE
    total_allocated INTEGER;
    leaves_taken INTEGER;
BEGIN
    -- Get total allocated leaves based on leave type
    SELECT 
        CASE 
            WHEN p_leave_type = 'casual' THEN 12
            WHEN p_leave_type = 'sick' THEN 12
            WHEN p_leave_type = 'annual' THEN 21
            ELSE 0
        END INTO total_allocated;
    
    -- Calculate leaves taken
    SELECT COALESCE(SUM(total_leave_days), 0) INTO leaves_taken
    FROM leave_requests 
    WHERE employee_id = p_employee_id 
        AND leave_type = p_leave_type
        AND EXTRACT(YEAR FROM from_date) = p_year
        AND status = 'approved';
    
    -- Insert or update leave balance
    INSERT INTO leave_balances (employee_id, year, leave_type, total_allocated, leaves_taken, leaves_remaining)
    VALUES (p_employee_id, p_year, p_leave_type, total_allocated, leaves_taken, total_allocated - leaves_taken)
    ON CONFLICT (employee_id, year, leave_type) 
    DO UPDATE SET 
        total_allocated = EXCLUDED.total_allocated,
        leaves_taken = EXCLUDED.leaves_taken,
        leaves_remaining = EXCLUDED.leaves_remaining,
        updated_at = CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =============================================================================

-- Trigger to update leave balance when leave request is approved
CREATE OR REPLACE FUNCTION trigger_update_leave_balance()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'approved' AND (OLD.status IS NULL OR OLD.status != 'approved') THEN
        PERFORM update_leave_balance(NEW.employee_id, EXTRACT(YEAR FROM NEW.from_date)::INTEGER, NEW.leave_type);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger if it doesn't already exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'leave_balance_update_trigger') THEN
        CREATE TRIGGER leave_balance_update_trigger
            AFTER UPDATE ON leave_requests
            FOR EACH ROW
            EXECUTE FUNCTION trigger_update_leave_balance();
    END IF;
END $$;

-- =============================================================================
-- MIGRATION COMPLETION
-- =============================================================================

-- Log migration completion
INSERT INTO migration_log (migration_name, status) 
VALUES ('000_complete_database_setup', 'completed');

-- Verify critical tables exist
DO $$
DECLARE
    table_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO table_count
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
        AND table_name IN ('users', 'employee_master', 'attendance', 'leave_requests', 'managers');
    
    IF table_count = 5 THEN
        RAISE NOTICE 'Migration completed successfully - all critical tables created';
    ELSE
        RAISE EXCEPTION 'Migration failed - not all critical tables were created';
    END IF;
END $$;

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

SELECT 'Complete Database Setup Migration completed successfully at ' || CURRENT_TIMESTAMP as migration_status;
