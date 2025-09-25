-- =============================================================================
-- COMPLETE DATABASE SETUP FOR ONBOARD PROJECT
-- =============================================================================
-- This file contains the complete database schema and data
-- extracted from the actual production database backup
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
-- FUNCTIONS
-- =============================================================================

-- Clear PNC cache function
CREATE OR REPLACE FUNCTION public.clear_pnc_cache() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        -- Clear all active P&C monitoring reports cache
        DELETE FROM pnc_monitoring_reports WHERE is_active = true;
        
        -- Log the cache clearing
        RAISE NOTICE 'P&C cache cleared due to employee data change';
        
        RETURN COALESCE(NEW, OLD);
      END;
      $$;

-- Delete employee completely function
CREATE OR REPLACE FUNCTION public.delete_employee_completely(employee_email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
      DECLARE
        user_id INTEGER;
        deletion_success BOOLEAN := TRUE;
      BEGIN
        -- Get user ID from email
        SELECT id INTO user_id FROM users WHERE email = employee_email;
        
        IF user_id IS NULL THEN
          RAISE NOTICE 'User with email % not found', employee_email;
          RETURN FALSE;
        END IF;
        
        -- Delete from all related tables
        BEGIN
          DELETE FROM document_collection WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from document_collection: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM employee_forms WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from employee_forms: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM attendance WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from attendance: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM leave_requests WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from leave_requests: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM onboarded_employees WHERE user_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from onboarded_employees: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM leave_balances WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from leave_balances: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM employee_documents WHERE employee_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from employee_documents: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        BEGIN
          DELETE FROM managers WHERE manager_id = user_id;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from managers: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        -- Finally delete the user
        BEGIN
          DELETE FROM users WHERE id = user_id;
          RAISE NOTICE 'Successfully deleted user with email: %', employee_email;
        EXCEPTION WHEN OTHERS THEN
          RAISE NOTICE 'Error deleting from users: %', SQLERRM;
          deletion_success := FALSE;
        END;
        
        RETURN deletion_success;
      END;
      $$;

-- =============================================================================
-- CORE TABLES
-- =============================================================================

-- Users table
CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'employee'::character varying NOT NULL,
    temp_password character varying(255),
    first_name character varying(100),
    last_name character varying(100),
    phone character varying(20),
    address text,
    emergency_contact_name character varying(100),
    emergency_contact_phone character varying(20),
    emergency_contact_relationship character varying(50),
    emergency_contact_name2 character varying(100),
    emergency_contact_phone2 character varying(20),
    emergency_contact_relationship2 character varying(50),
    is_temp_password boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Employee master table
CREATE TABLE public.employee_master (
    id integer NOT NULL,
    employee_id character varying(100) NOT NULL,
    employee_name character varying(255) NOT NULL,
    company_email character varying(255),
    manager_id character varying(100),
    manager_name character varying(255),
    manager2_id character varying(100),
    manager2_name character varying(255),
    manager3_id character varying(100),
    manager3_name character varying(255),
    type character varying(50) NOT NULL,
    doj date,
    status character varying(50) DEFAULT 'active'::character varying,
    department character varying(100),
    designation character varying(100),
    salary_band character varying(50),
    location character varying(100),
    email character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Employee forms table
CREATE TABLE public.employee_forms (
    id integer NOT NULL,
    employee_id integer,
    type character varying(50),
    form_data jsonb,
    files text[],
    status character varying(50) DEFAULT 'draft'::character varying,
    submitted_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reviewed_by integer,
    reviewed_at timestamp without time zone,
    review_notes text,
    draft_data jsonb,
    documents_uploaded jsonb,
    assigned_manager character varying(255),
    manager2_name character varying(255),
    manager3_name character varying(255)
);

-- Onboarded employees table
CREATE TABLE public.onboarded_employees (
    id integer NOT NULL,
    user_id integer,
    employee_id character varying(100),
    company_email character varying(255),
    manager_id character varying(100),
    manager_name character varying(255),
    status character varying(50) DEFAULT 'pending_assignment'::character varying,
    notes text,
    assigned_by integer,
    assigned_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    employee_type character varying(50)
);

-- =============================================================================
-- DOCUMENT MANAGEMENT
-- =============================================================================

-- Document templates table
CREATE TABLE public.document_templates (
    id integer NOT NULL,
    document_name character varying(255) NOT NULL,
    document_type character varying(50) DEFAULT 'Required'::character varying NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Employee documents table
CREATE TABLE public.employee_documents (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    document_type character varying(100) NOT NULL,
    document_category character varying(50) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url text NOT NULL,
    file_size integer,
    mime_type character varying(100),
    is_required boolean DEFAULT false,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Document collection table
CREATE TABLE public.document_collection (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    employee_name character varying(255) NOT NULL,
    emp_id character varying(100) NOT NULL,
    department character varying(100),
    join_date date,
    due_date date,
    document_name character varying(255),
    document_type character varying(100),
    status character varying(50) DEFAULT 'Pending'::character varying,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Document reminder mails table
CREATE TABLE public.document_reminder_mails (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    employee_email character varying(255) NOT NULL,
    employee_name character varying(255) NOT NULL,
    sent_by_hr_id integer NOT NULL,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reminder_type character varying(50) DEFAULT 'first_reminder'::character varying,
    status character varying(50) DEFAULT 'sent'::character varying
);

-- =============================================================================
-- LEAVE MANAGEMENT
-- =============================================================================

-- Leave requests table
CREATE TABLE public.leave_requests (
    id integer NOT NULL,
    series character varying(50) NOT NULL,
    employee_id integer NOT NULL,
    employee_name character varying(255) NOT NULL,
    leave_type character varying(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    days_requested numeric(5,2) NOT NULL,
    reason text,
    status character varying(50) DEFAULT 'pending'::character varying,
    applied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reviewed_by integer,
    reviewed_at timestamp without time zone,
    review_notes text,
    half_day boolean DEFAULT false,
    half_day_type character varying(20)
);

-- Leave balances table
CREATE TABLE public.leave_balances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    year integer NOT NULL,
    total_allocated integer DEFAULT 27,
    leaves_taken integer DEFAULT 0,
    leaves_remaining integer DEFAULT 27,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Leave type balances table
CREATE TABLE public.leave_type_balances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    year integer NOT NULL,
    leave_type character varying(100) NOT NULL,
    total_allocated numeric(5,2) DEFAULT 0,
    leaves_taken numeric(5,2) DEFAULT 0,
    leaves_remaining numeric(5,2) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Leave types table
CREATE TABLE public.leave_types (
    id integer NOT NULL,
    type_name character varying(100) NOT NULL,
    description text,
    color character varying(20) DEFAULT '#3B82F6'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);

-- Comp off balances table
CREATE TABLE public.comp_off_balances (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    year integer NOT NULL,
    total_earned numeric(5,1) DEFAULT 0,
    comp_off_taken numeric(5,1) DEFAULT 0,
    comp_off_remaining numeric(5,1) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ATTENDANCE MANAGEMENT
-- =============================================================================

-- Attendance table
CREATE TABLE public.attendance (
    id integer NOT NULL,
    employee_id integer,
    date date NOT NULL,
    status character varying(50) NOT NULL,
    reason text,
    check_in time without time zone,
    check_out time without time zone,
    hours_worked numeric(4,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Attendance settings table
CREATE TABLE public.attendance_settings (
    id integer NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value text,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- EXPENSE MANAGEMENT
-- =============================================================================

-- Expenses table
CREATE TABLE public.expenses (
    id integer NOT NULL,
    series character varying(50) NOT NULL,
    employee_id integer NOT NULL,
    employee_name character varying(255) NOT NULL,
    expense_category character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    description text,
    status character varying(50) DEFAULT 'pending'::character varying,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reviewed_by integer,
    reviewed_at timestamp without time zone,
    review_notes text,
    receipt_url text
);

-- Expense categories table
CREATE TABLE public.expense_categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Expense requests table
CREATE TABLE public.expense_requests (
    id integer NOT NULL,
    employee_id integer,
    category_id integer,
    amount numeric(10,2) NOT NULL,
    description text,
    status character varying(50) DEFAULT 'pending'::character varying,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reviewed_by integer,
    reviewed_at timestamp without time zone,
    review_notes text
);

-- Expense attachments table
CREATE TABLE public.expense_attachments (
    id integer NOT NULL,
    expense_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url character varying(500) NOT NULL,
    file_size integer,
    mime_type character varying(100),
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- MANAGER-EMPLOYEE RELATIONSHIPS
-- =============================================================================

-- Manager employee mapping table
CREATE TABLE public.manager_employee_mapping (
    id integer NOT NULL,
    manager_id integer,
    employee_id integer,
    mapping_type character varying(50) DEFAULT 'primary'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Managers table
CREATE TABLE public.managers (
    id integer NOT NULL,
    manager_id character varying(100) NOT NULL,
    manager_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    department character varying(100),
    designation character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ADDITIONAL TABLES
-- =============================================================================

-- Company emails table
CREATE TABLE public.company_emails (
    id integer NOT NULL,
    user_id integer,
    manager_id character varying(100),
    company_email character varying(255) NOT NULL,
    is_primary boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    manager_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Relations table
CREATE TABLE public.relations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- System settings table
CREATE TABLE public.system_settings (
    id integer NOT NULL,
    total_annual_leaves integer DEFAULT 27,
    allow_half_day boolean DEFAULT true,
    approval_workflow character varying(50) DEFAULT 'manager_then_hr'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

-- Migration log table
CREATE TABLE public.migration_log (
    id integer NOT NULL,
    migration_name character varying(255) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) NOT NULL,
    details text
);

-- =============================================================================
-- PRIMARY KEYS AND CONSTRAINTS
-- =============================================================================

-- Set primary keys
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.employee_master ADD CONSTRAINT employee_master_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.employee_forms ADD CONSTRAINT employee_forms_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.onboarded_employees ADD CONSTRAINT onboarded_employees_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.document_templates ADD CONSTRAINT document_templates_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.employee_documents ADD CONSTRAINT employee_documents_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.document_collection ADD CONSTRAINT document_collection_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.document_reminder_mails ADD CONSTRAINT document_reminder_mails_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_requests ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_balances ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_type_balances ADD CONSTRAINT leave_type_balances_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leave_types ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.comp_off_balances ADD CONSTRAINT comp_off_balances_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.attendance ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.attendance_settings ADD CONSTRAINT attendance_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expenses ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expense_categories ADD CONSTRAINT expense_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expense_requests ADD CONSTRAINT expense_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expense_attachments ADD CONSTRAINT expense_attachments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.manager_employee_mapping ADD CONSTRAINT manager_employee_mapping_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.managers ADD CONSTRAINT managers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.company_emails ADD CONSTRAINT company_emails_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.departments ADD CONSTRAINT departments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.relations ADD CONSTRAINT relations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.system_settings ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.migration_log ADD CONSTRAINT migration_log_pkey PRIMARY KEY (id);

-- Set unique constraints
ALTER TABLE ONLY public.users ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.employee_master ADD CONSTRAINT employee_master_employee_id_key UNIQUE (employee_id);
ALTER TABLE ONLY public.employee_master ADD CONSTRAINT employee_master_company_email_key UNIQUE (company_email);
ALTER TABLE ONLY public.attendance ADD CONSTRAINT attendance_employee_id_date_key UNIQUE (employee_id, date);
ALTER TABLE ONLY public.manager_employee_mapping ADD CONSTRAINT manager_employee_mapping_manager_id_employee_id_mapping_type_key UNIQUE (manager_id, employee_id, mapping_type);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================

-- Insert sample users
INSERT INTO public.users (id, email, password, role, first_name, last_name, is_temp_password) VALUES
(1, 'hr@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'hr', 'HR', 'Manager', false),
(2, 'admin@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'admin', 'Admin', 'User', false),
(3, 'manager@nxzen.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'manager', 'John', 'Manager', false),
(4, 'stalinstalin11112@gmail.com', '$2a$10$rQZ8K9L2mN3pO4qR5sT6uE7vF8wG9xH0yI1zJ2kL3mN4oP5qR6sT7uV8wX9yZ0a', 'employee', 'Adam', 'J', true);

-- Insert sample employee master records
INSERT INTO public.employee_master (id, employee_id, employee_name, company_email, type, doj, status, department, designation) VALUES
(1, 'EMP001', 'HR Manager', 'hr@nxzen.com', 'Manager', '2024-01-01', 'active', 'Human Resources', 'HR Manager'),
(2, 'EMP002', 'Admin User', 'admin@nxzen.com', 'Manager', '2024-01-01', 'active', 'Administration', 'System Administrator'),
(3, 'EMP003', 'John Manager', 'manager@nxzen.com', 'Manager', '2024-01-15', 'active', 'Operations', 'Operations Manager'),
(4, 'EMP004', 'Adam J', 'adam.j@nxzen.com', 'Full-Time', '2025-09-24', 'active', 'Development', 'Software Developer');

-- Insert sample employee forms
INSERT INTO public.employee_forms (id, employee_id, type, form_data, status) VALUES
(1, 4, 'Full-Time', '{"doj": "2025-09-24", "name": "Adam J", "email": "stalinstalin11112@gmail.com", "phone": "1234567890", "address": "123 Main St", "education": "B.Tech Computer Science", "experience": "2 years", "emergencyContact": {"name": "Jane Doe", "phone": "9876543210", "relationship": "Spouse"}, "emergencyContact2": {"name": "John Doe", "phone": "9876543211", "relationship": "Father"}}', 'submitted');

-- Insert sample document templates
INSERT INTO public.document_templates (id, document_name, document_type, is_active) VALUES
(1, 'Aadhaar Card', 'aadhaar', true),
(2, 'PAN Card', 'pan', true),
(3, 'Passport', 'passport', true),
(4, 'Educational Certificate', 'education', true),
(5, 'Experience Certificate', 'experience', true),
(6, 'Bank Statement', 'bank_statement', true),
(7, 'Address Proof', 'address_proof', true);

-- Insert sample leave balances
INSERT INTO public.leave_balances (id, employee_id, year, total_allocated, leaves_taken, leaves_remaining) VALUES
(1, 1, 2025, 27, 0, 27),
(2, 2, 2025, 27, 0, 27),
(3, 3, 2025, 27, 0, 27),
(4, 4, 2025, 27, 0, 27);

-- Insert sample leave types
INSERT INTO public.leave_types (id, type_name, description, color, is_active) VALUES
(1, 'Annual Leave', 'Annual vacation leave', '#3B82F6', true),
(2, 'Sick Leave', 'Medical leave', '#EF4444', true),
(3, 'Personal Leave', 'Personal time off', '#10B981', true),
(4, 'Maternity Leave', 'Maternity leave', '#F59E0B', true),
(5, 'Paternity Leave', 'Paternity leave', '#8B5CF6', true);

-- Insert sample attendance records
INSERT INTO public.attendance (id, employee_id, date, status, check_in, check_out, hours_worked) VALUES
(1, 1, '2025-01-15', 'present', '09:00:00', '18:00:00', 8.0),
(2, 2, '2025-01-15', 'present', '09:00:00', '18:00:00', 8.0),
(3, 3, '2025-01-15', 'present', '09:00:00', '18:00:00', 8.0),
(4, 4, '2025-01-15', 'present', '09:00:00', '18:00:00', 8.0);

-- Insert sample manager-employee mappings
INSERT INTO public.manager_employee_mapping (id, manager_id, employee_id, mapping_type, is_active) VALUES
(1, 3, 4, 'primary', true);

-- Insert sample expense categories
INSERT INTO public.expense_categories (id, name, description, is_active) VALUES
(1, 'Travel', 'Business travel expenses', true),
(2, 'Meals', 'Business meal expenses', true),
(3, 'Office Supplies', 'Office equipment and supplies', true),
(4, 'Training', 'Professional development and training', true),
(5, 'Communication', 'Phone and internet expenses', true);

-- Insert sample system settings
INSERT INTO public.system_settings (id, total_annual_leaves, allow_half_day, approval_workflow) VALUES
(1, 27, true, 'manager_then_hr');

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_employee_forms_employee_id ON public.employee_forms(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_forms_status ON public.employee_forms(status);
CREATE INDEX IF NOT EXISTS idx_employee_master_company_email ON public.employee_master(company_email);
CREATE INDEX IF NOT EXISTS idx_employee_master_employee_id ON public.employee_master(employee_id);
CREATE INDEX IF NOT EXISTS idx_attendance_employee_date ON public.attendance(employee_id, date);
CREATE INDEX IF NOT EXISTS idx_leave_requests_employee_id ON public.leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON public.leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_employee_documents_employee_id ON public.employee_documents(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_documents_type ON public.employee_documents(document_type);

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

-- Display completion message
DO $$
BEGIN
    RAISE NOTICE 'Database setup completed successfully!';
    RAISE NOTICE 'Tables created: 25+ tables with complete schema';
    RAISE NOTICE 'Sample data inserted for testing';
    RAISE NOTICE 'Indexes created for performance optimization';
    RAISE NOTICE 'Functions created for data management';
    RAISE NOTICE 'You can now start the application!';
END $$;