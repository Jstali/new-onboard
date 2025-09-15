-- Migration: 004_combine_employee_tables.sql
-- Description: Combine employee_master and adp_payroll tables into a single comprehensive table
-- Created: 2025-01-09
-- Author: System
-- Version: 4.0

-- =============================================================================
-- COMBINED EMPLOYEE TABLE - MERGED FROM EMPLOYEE_MASTER AND ADP_PAYROLL
-- =============================================================================

-- Create the new combined employee table
CREATE TABLE IF NOT EXISTS employees_combined (
    id SERIAL PRIMARY KEY,
    
    -- Core Employee Information (from employee_master)
    employee_id VARCHAR(100) UNIQUE NOT NULL,
    employee_name VARCHAR(255) NOT NULL,
    company_email VARCHAR(255) UNIQUE NOT NULL,
    
    -- Manager Information
    manager_id VARCHAR(100),
    manager_name VARCHAR(100),
    manager2_id VARCHAR(100),
    manager2_name VARCHAR(100),
    manager3_id VARCHAR(100),
    manager3_name VARCHAR(100),
    
    -- Employment Details
    type VARCHAR(50) NOT NULL CHECK (type IN ('Intern', 'Contract', 'Full-Time', 'Manager')),
    role VARCHAR(100),
    doj DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'terminated')),
    department VARCHAR(100),
    designation VARCHAR(100),
    salary_band VARCHAR(50),
    location VARCHAR(100),
    
    -- ADP Payroll Information
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
    
    -- LWF Information
    lwf_designation VARCHAR(255),
    lwf_relationship VARCHAR(255),
    lwf_id VARCHAR(50),
    professional_tax_group_description VARCHAR(255),
    pf_computational_group VARCHAR(255),
    
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
    
    -- International Worker Information
    iw_nationality VARCHAR(100),
    iw_city VARCHAR(100),
    iw_country VARCHAR(100),
    coc_issuing_authority VARCHAR(255),
    coc_issue_date DATE,
    coc_from_date DATE,
    coc_upto_date DATE,
    
    -- Bank Information
    bank_name VARCHAR(255),
    name_as_per_bank VARCHAR(255),
    account_no VARCHAR(50),
    bank_ifsc_code VARCHAR(20),
    payment_mode VARCHAR(50),
    
    -- PF and ESI Information
    pf_account_no VARCHAR(50),
    esi_account_no VARCHAR(50),
    esi_above_wage_limit BOOLEAN DEFAULT false,
    disability_status BOOLEAN DEFAULT false,
    already_member_in_pf BOOLEAN DEFAULT false,
    pf_opt_out BOOLEAN DEFAULT false,
    esi_opt_out BOOLEAN DEFAULT false,
    international_worker_status BOOLEAN DEFAULT false,
    relationship_for_pf VARCHAR(255),
    
    -- Additional Information
    qualification VARCHAR(255),
    driving_licence_number VARCHAR(50),
    driving_licence_valid_date DATE,
    pran_number VARCHAR(50),
    rehire BOOLEAN DEFAULT false,
    old_employee_id VARCHAR(100),
    is_non_payroll_employee BOOLEAN DEFAULT false,
    category_name VARCHAR(255),
    custom_master_name VARCHAR(255),
    custom_master_name2 VARCHAR(255),
    custom_master_name3 VARCHAR(255),
    
    -- Eligibility Information
    ot_eligibility BOOLEAN DEFAULT false,
    auto_shift_eligibility BOOLEAN DEFAULT false,
    mobile_user BOOLEAN DEFAULT false,
    web_punch BOOLEAN DEFAULT false,
    attendance_exception_eligibility BOOLEAN DEFAULT false,
    attendance_exception_type VARCHAR(255),
    
    -- System Fields
    is_draft BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    CONSTRAINT employees_combined_employee_id_unique UNIQUE (employee_id)
);

-- Create indexes for commonly queried fields
CREATE INDEX IF NOT EXISTS idx_employees_combined_employee_id ON employees_combined(employee_id);
CREATE INDEX IF NOT EXISTS idx_employees_combined_company_email ON employees_combined(company_email);
CREATE INDEX IF NOT EXISTS idx_employees_combined_is_draft ON employees_combined(is_draft);
CREATE INDEX IF NOT EXISTS idx_employees_combined_status ON employees_combined(status);
CREATE INDEX IF NOT EXISTS idx_employees_combined_department ON employees_combined(department);
CREATE INDEX IF NOT EXISTS idx_employees_combined_created_at ON employees_combined(created_at);

-- Add comments for documentation
COMMENT ON TABLE employees_combined IS 'Combined employee table merging employee_master and adp_payroll data';
COMMENT ON COLUMN employees_combined.employee_id IS 'Unique employee identifier';
COMMENT ON COLUMN employees_combined.is_draft IS 'Flag to indicate if employee data is in draft state';
COMMENT ON COLUMN employees_combined.esi_above_wage_limit IS 'Boolean flag for ESI wage limit status';
COMMENT ON COLUMN employees_combined.disability_status IS 'Boolean flag for disability status';
COMMENT ON COLUMN employees_combined.already_member_in_pf IS 'Boolean flag for existing PF membership';
COMMENT ON COLUMN employees_combined.international_worker_status IS 'Boolean flag for international worker status';
