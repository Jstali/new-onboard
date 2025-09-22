-- =============================================================================
-- FIX DUPLICATE EMPLOYEE ISSUE
-- =============================================================================
-- This migration fixes the duplicate employee issue by:
-- 1. Making company_email nullable (it was incorrectly set as NOT NULL)
-- 2. Adding a unique constraint on employee_name + email combination
-- 3. Cleaning up any existing duplicate entries
-- =============================================================================

-- First, let's identify and clean up any existing duplicates
-- This will keep the most recent entry for each duplicate
WITH duplicates AS (
  SELECT 
    id,
    employee_name,
    email,
    ROW_NUMBER() OVER (
      PARTITION BY employee_name, email 
      ORDER BY created_at DESC
    ) as rn
  FROM employee_master
  WHERE employee_name IS NOT NULL AND email IS NOT NULL
)
DELETE FROM employee_master 
WHERE id IN (
  SELECT id FROM duplicates WHERE rn > 1
);

-- Make company_email nullable (it was incorrectly set as NOT NULL)
ALTER TABLE employee_master ALTER COLUMN company_email DROP NOT NULL;

-- Add unique constraint on employee_name + email combination
-- This will prevent future duplicates
ALTER TABLE employee_master 
ADD CONSTRAINT employee_master_name_email_unique 
UNIQUE (employee_name, email);

-- Add index for better performance on duplicate checks
CREATE INDEX IF NOT EXISTS idx_employee_master_name_email 
ON employee_master (employee_name, email);

-- Log the changes
INSERT INTO migration_log (migration_name, applied_at, description) 
VALUES (
  '005FixDuplicateEmployeeIssue', 
  CURRENT_TIMESTAMP, 
  'Fixed duplicate employee issue by making company_email nullable and adding unique constraint on employee_name + email'
);
