-- =============================================================================
-- COMPLETE DATABASE SETUP FOR ONBOARD PROJECT
-- =============================================================================
-- This file contains the complete database schema and sample data
-- for the Onboard project. Use this to set up the database from scratch.
-- 
-- Instructions:
-- 1. Create a PostgreSQL database named 'onboardd'
-- 2. Run this SQL file in that database
-- 3. Update the config.env file with your database credentials
-- 4. Run the application
-- =============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- CORE AUTHENTICATION AND USER MANAGEMENT
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

-- Employee forms table - Form submissions and document management
CREATE TABLE IF NOT EXISTS employee_forms (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('Intern', 'Contract', 'Full-Time', 'Manager')),
    form_data JSONB,
    files TEXT[],
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'approved', 'rejected', 'submitted')),
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
    employee_id VARCHAR(20),
    company_email VARCHAR(255),
    manager_id VARCHAR(20),
    manager_name VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending_assignment',
    notes TEXT,
    assigned_by INTEGER REFERENCES users(id),
    assigned_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_type VARCHAR(50)
);

-- Employee master table - Final approved employee records
CREATE TABLE IF NOT EXISTS employee_master (
    id SERIAL PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    company_email VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255),
    type VARCHAR(50) NOT NULL CHECK (type IN ('Intern', 'Contract', 'Full-Time', 'Manager')),
    doj DATE,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'terminated')),
    department VARCHAR(100),
    designation VARCHAR(100),
    salary_band VARCHAR(50),
    location VARCHAR(100),
    manager_id VARCHAR(20),
    manager_name VARCHAR(255),
    manager2_id VARCHAR(20),
    manager2_name VARCHAR(255),
    manager3_id VARCHAR(20),
    manager3_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- DOCUMENT MANAGEMENT
-- =============================================================================

-- Document templates table
CREATE TABLE IF NOT EXISTS document_templates (
    id SERIAL PRIMARY KEY,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(100) NOT NULL,
    document_category VARCHAR(100) NOT NULL,
    is_required BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee documents table
CREATE TABLE IF NOT EXISTS employee_documents (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    document_type VARCHAR(100) NOT NULL,
    document_category VARCHAR(100) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    is_required BOOLEAN DEFAULT false,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Document collection table
CREATE TABLE IF NOT EXISTS document_collection (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    employee_name VARCHAR(255),
    emp_id VARCHAR(20),
    department VARCHAR(100),
    join_date DATE,
    due_date DATE,
    document_name VARCHAR(255),
    document_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- LEAVE MANAGEMENT
-- =============================================================================

-- Leave requests table
CREATE TABLE IF NOT EXISTS leave_requests (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INTEGER NOT NULL,
    reason TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INTEGER REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT
);

-- Leave balances table
CREATE TABLE IF NOT EXISTS leave_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    leave_type VARCHAR(50) NOT NULL,
    total_allocated INTEGER DEFAULT 0,
    leaves_taken INTEGER DEFAULT 0,
    leaves_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comp off balances table
CREATE TABLE IF NOT EXISTS comp_off_balances (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    total_allocated INTEGER DEFAULT 0,
    comp_off_taken INTEGER DEFAULT 0,
    comp_off_remaining INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ATTENDANCE MANAGEMENT
-- =============================================================================

-- Attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    hours_worked DECIMAL(4,2),
    status VARCHAR(50) DEFAULT 'present' CHECK (status IN ('present', 'absent', 'half_day', 'leave')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, date)
);

-- =============================================================================
-- EXPENSE MANAGEMENT
-- =============================================================================

-- Expenses table
CREATE TABLE IF NOT EXISTS expenses (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    expense_type VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    receipt_url TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INTEGER REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT
);

-- =============================================================================
-- MANAGER-EMPLOYEE RELATIONSHIPS
-- =============================================================================

-- Manager employee mapping table
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

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================

-- Insert sample users
INSERT INTO users (email, password, role, first_name, last_name, is_temp_password) VALUES
('hr@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'hr', 'HR', 'Manager', false),
('admin@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'admin', 'Admin', 'User', false),
('manager@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'manager', 'John', 'Manager', false),
('stalinstalin11112@gmail.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'employee', 'Adam', 'J', true);

-- Insert sample employee master records
INSERT INTO employee_master (employee_id, employee_name, company_email, type, doj, status, department, designation) VALUES
('EMP001', 'HR Manager', 'hr@nxzen.com', 'Manager', '2024-01-01', 'active', 'Human Resources', 'HR Manager'),
('EMP002', 'Admin User', 'admin@nxzen.com', 'Manager', '2024-01-01', 'active', 'Administration', 'System Administrator'),
('EMP003', 'John Manager', 'manager@nxzen.com', 'Manager', '2024-01-15', 'active', 'Operations', 'Operations Manager'),
('EMP004', 'Adam J', 'adam.j@nxzen.com', 'Full-Time', '2025-09-24', 'active', 'Development', 'Software Developer');

-- Insert sample employee forms
INSERT INTO employee_forms (employee_id, type, form_data, status) VALUES
(4, 'Full-Time', '{"doj": "2025-09-24", "name": "Adam J", "email": "stalinstalin11112@gmail.com", "phone": "1234567890", "address": "123 Main St", "education": "B.Tech Computer Science", "experience": "2 years", "emergencyContact": {"name": "Jane Doe", "phone": "9876543210", "relationship": "Spouse"}, "emergencyContact2": {"name": "John Doe", "phone": "9876543211", "relationship": "Father"}}', 'submitted');

-- Insert sample document templates
INSERT INTO document_templates (document_name, document_type, document_category, is_required, is_active) VALUES
('Aadhaar Card', 'aadhaar', 'identity', true, true),
('PAN Card', 'pan', 'identity', true, true),
('Passport', 'passport', 'identity', false, true),
('Educational Certificate', 'education', 'education', true, true),
('Experience Certificate', 'experience', 'employment', false, true),
('Bank Statement', 'bank_statement', 'financial', true, true),
('Address Proof', 'address_proof', 'identity', true, true);

-- Insert sample leave balances
INSERT INTO leave_balances (employee_id, year, leave_type, total_allocated, leaves_taken, leaves_remaining) VALUES
(1, 2025, 'Annual Leave', 27, 0, 27),
(2, 2025, 'Annual Leave', 27, 0, 27),
(3, 2025, 'Annual Leave', 27, 0, 27),
(4, 2025, 'Annual Leave', 27, 0, 27);

-- Insert sample attendance records
INSERT INTO attendance (employee_id, date, check_in, check_out, hours_worked, status) VALUES
(1, '2025-01-15', '09:00:00', '18:00:00', 8.0, 'present'),
(2, '2025-01-15', '09:00:00', '18:00:00', 8.0, 'present'),
(3, '2025-01-15', '09:00:00', '18:00:00', 8.0, 'present'),
(4, '2025-01-15', '09:00:00', '18:00:00', 8.0, 'present');

-- Insert sample manager-employee mappings
INSERT INTO manager_employee_mapping (manager_id, employee_id, mapping_type, is_active) VALUES
(3, 4, 'primary', true);

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Create indexes for better performance
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

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

-- Display completion message
DO $$
BEGIN
    RAISE NOTICE 'Database setup completed successfully!';
    RAISE NOTICE 'Tables created: users, employee_forms, onboarded_employees, employee_master, document_templates, employee_documents, document_collection, leave_requests, leave_balances, comp_off_balances, attendance, expenses, manager_employee_mapping';
    RAISE NOTICE 'Sample data inserted for testing';
    RAISE NOTICE 'Indexes created for performance optimization';
    RAISE NOTICE 'You can now start the application!';
END $$;
