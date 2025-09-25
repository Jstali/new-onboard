# Duplicate Employee Issue Fix

## Problem Description

When HR tries to add a new employee named "Stalin" (or any employee), duplicate entries were appearing in the Employee Master table before assigning a company email. This was happening due to:

1. **Race Condition**: Multiple rapid requests could pass initial validation before either was committed
2. **Incomplete Validation**: The system wasn't checking all possible duplicate scenarios
3. **Database Schema Issue**: `company_email` was marked as `NOT NULL` but set to `NULL` during initial creation

## Root Cause Analysis

### 1. Race Condition

- Two simultaneous requests to create "Stalin" could both pass the initial duplicate check
- Both would then create entries in the database
- This happened because the check and insert weren't atomic

### 2. Incomplete Validation

- Original query only checked: `employee_name = $1 OR email = $2`
- Didn't check `company_email = $2` for cases where email might be used as company email
- Missing comprehensive duplicate detection

### 3. Database Schema Issues

- `company_email` field was `NOT NULL` but set to `NULL` during initial creation
- No unique constraint on `employee_name + email` combination
- Multiple employees could have `NULL` company_email, allowing duplicates

## Solution Implemented

### 1. Enhanced Validation

```sql
-- Before
SELECT employee_id, employee_name, company_email FROM employee_master
WHERE employee_name = $1 OR email = $2

-- After
SELECT employee_id, employee_name, company_email, email FROM employee_master
WHERE employee_name = $1 OR email = $2 OR company_email = $2
```

### 2. Database Transaction

- Wrapped the entire employee creation process in a database transaction
- Added double-check for duplicates within the transaction
- Ensures atomicity and prevents race conditions

### 3. Database Schema Fixes

- Made `company_email` nullable: `VARCHAR(255) UNIQUE` (removed `NOT NULL`)
- Added unique constraint: `CONSTRAINT employee_master_name_email_unique UNIQUE (employee_name, email)`
- Added performance index: `idx_employee_master_name_email`

### 4. Migration Script

Created `005FixDuplicateEmployeeIssue.sql` that:

- Cleans up existing duplicates (keeps most recent)
- Applies schema changes
- Adds constraints and indexes

## Files Modified

1. **`backend/routes/hr.js`**

   - Enhanced duplicate checking query
   - Added database transaction wrapper
   - Improved error handling

2. **`backend/migrations/000CompleteDatabaseSetup.sql`**

   - Made `company_email` nullable
   - Added unique constraint on `employee_name + email`

3. **`backend/migrations/005FixDuplicateEmployeeIssue.sql`** (New)

   - Migration to fix existing database
   - Cleanup script for duplicates

4. **`fix-duplicate-employee-issue.js`** (New)
   - Script to run the migration
   - Test duplicate prevention

## How to Apply the Fix

### Option 1: Run the Migration Script

```bash
cd /Users/stalin_j/onboard/onboard
node fix-duplicate-employee-issue.js
```

### Option 2: Manual Database Update

```sql
-- Connect to your database and run:
\i backend/migrations/005FixDuplicateEmployeeIssue.sql
```

### Option 3: Restart Application

The code changes will take effect when you restart the backend server.

## Testing the Fix

1. **Test Duplicate Prevention**:

   - Try to create an employee with the same name and email twice
   - Second attempt should fail with proper error message

2. **Test Race Condition**:

   - Send multiple rapid requests to create the same employee
   - Only one should succeed, others should fail

3. **Verify Database**:
   - Check that no duplicate entries exist
   - Verify constraints are working

## Expected Behavior After Fix

✅ **Before Company Email Assignment**:

- Only one entry per employee name + email combination
- Proper error messages for duplicates
- No race condition issues

✅ **After Company Email Assignment**:

- Company email uniqueness enforced
- No conflicts with existing employees
- Clean data integrity

## Monitoring

After applying the fix, monitor:

- Employee creation success/failure rates
- Database constraint violations
- Error logs for duplicate attempts

The fix ensures data integrity while maintaining the existing workflow where employees are created first with personal emails, then assigned company emails later.
