-- Migration: 005_add_personal_email_to_employee_master.sql
-- Description: Add personal email field to employee_master table
-- Created: 2025-01-17
-- Author: System
-- Version: 5.0

-- Add personal email field to employee_master table
ALTER TABLE employee_master 
ADD COLUMN IF NOT EXISTS email VARCHAR(255);

-- Update existing records to populate personal email from users table
UPDATE employee_master 
SET email = u.email
FROM users u 
WHERE u.email = employee_master.company_email;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_employee_master_email ON employee_master(email);

-- Log the migration
INSERT INTO migration_log (migration_name, status) 
VALUES ('005_add_personal_email_to_employee_master', 'completed');
