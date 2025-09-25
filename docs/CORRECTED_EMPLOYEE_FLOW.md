# Corrected Employee Flow - Fix for Duplicate Issue

## Problem Summary

The original issue was that employees were appearing in the Employee Master table **before** company email assignment, which caused:

1. Duplicate entries when trying to assign company emails
2. Confusion in the workflow
3. Data integrity issues

## Root Cause

The employee creation process was incorrectly creating master table records immediately, when it should only create them during the company email assignment phase.

## Corrected Flow

### ✅ **NEW CORRECTED FLOW**

1. **HR Creates Employee** (`POST /api/hr/employees`)

   - Creates user in `users` table
   - Creates employee form in `employee_forms` table
   - **NO master table record created**
   - Employee appears in "Onboarded Employees" list

2. **Employee Completes Onboarding**

   - Employee fills out forms and uploads documents
   - Status remains "pending" in onboarded employees

3. **HR Assigns Company Email** (`PUT /api/hr/onboarded/:id/assign`)
   - **ONLY NOW** creates record in `employee_master` table
   - Assigns company email, managers, and other details
   - Employee moves from "Onboarded Employees" to "Employee Master Table"

### ❌ **OLD INCORRECT FLOW**

1. HR Creates Employee → **Immediately creates master table record** ❌
2. Employee appears in master table with no company email ❌
3. HR tries to assign company email → Gets "already exists" error ❌

## Changes Made

### 1. **Modified Employee Creation** (`backend/routes/hr.js`)

**Before:**

```javascript
// Create employee master record immediately
await pool.query(
  `INSERT INTO employee_master (
    employee_id, employee_name, email, company_email, type, doj, status,
    created_at, updated_at
  ) VALUES ($1, $2, $3, NULL, $4, $5, 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)`,
  [employeeId, name, email, type, doj]
);
```

**After:**

```javascript
// Note: Employee master record will be created only after company email assignment
console.log(
  "✅ Employee created successfully - will be added to master table after company email assignment"
);
```

### 2. **Enhanced Duplicate Checking in Assignment**

**Before:**

```sql
SELECT employee_id, employee_name, company_email FROM employee_master
WHERE employee_name = $1 OR company_email = $2
```

**After:**

```sql
SELECT employee_id, employee_name, company_email, email FROM employee_master
WHERE employee_name = $1 OR company_email = $2 OR email = $3
```

### 3. **Removed Unnecessary Master Table Checks**

- Removed master table duplicate checks during initial employee creation
- Only check `users` table for email uniqueness during creation
- Master table checks only happen during company email assignment

## Expected Behavior Now

### ✅ **Correct Workflow**

1. **HR adds "Stalin J"**:

   - ✅ Creates user account
   - ✅ Creates employee form
   - ✅ **Does NOT appear in Employee Master table**
   - ✅ Appears in "Onboarded Employees" list

2. **Employee completes onboarding**:

   - ✅ Fills out forms and uploads documents
   - ✅ Status remains "pending" in onboarded employees

3. **HR assigns company email "stalin@nxzen.com"**:
   - ✅ **NOW creates Employee Master table record**
   - ✅ Assigns managers and other details
   - ✅ Employee moves to "Employee Master Table"
   - ✅ No duplicate errors

### 🚫 **What Won't Happen Anymore**

- ❌ Employees won't appear in master table before company email assignment
- ❌ No more "Employee already exists in master table" errors
- ❌ No duplicate entries in master table

## Database Schema Updates

The database schema was also updated to support this flow:

1. **Made `company_email` nullable** in `employee_master` table
2. **Added unique constraint** on `employee_name + email` combination
3. **Created migration script** to clean up existing duplicates

## Testing the Fix

To test the corrected flow:

1. **Create a new employee**:

   ```bash
   POST /api/hr/employees
   {
     "email": "test@example.com",
     "name": "Test Employee",
     "type": "Full-Time",
     "doj": "2025-01-15"
   }
   ```

2. **Verify they don't appear in master table**:

   - Check Employee Master table - should not see the new employee
   - Check Onboarded Employees - should see the new employee

3. **Assign company email**:

   ```bash
   PUT /api/hr/onboarded/:id/assign
   {
     "name": "Test Employee",
     "companyEmail": "test@company.com",
     "manager": "Manager Name"
   }
   ```

4. **Verify they now appear in master table**:
   - Check Employee Master table - should now see the employee
   - Check Onboarded Employees - should no longer see them

## Migration Required

If you have existing data, run the migration script:

```bash
cd /Users/stalin_j/onboard/onboard
node fix-duplicate-employee-issue.js
```

This will:

- Clean up existing duplicate entries
- Apply database schema changes
- Ensure data integrity

## Summary

The corrected flow ensures that:

- ✅ Employees only appear in master table **after** company email assignment
- ✅ No duplicate entries are created
- ✅ Clean, logical workflow for HR
- ✅ Proper data integrity maintained

This fixes the original issue where "Stalin J" was appearing in the master table before company email assignment, causing the duplicate error when trying to assign the company email.
