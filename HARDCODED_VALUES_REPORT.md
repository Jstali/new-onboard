# Hardcoded Values Audit Report

## Summary
This report identifies all hardcoded values found in the application that should be moved to environment variables for better configuration management.

## Critical Issues Found

### 1. Frontend Template Literal Syntax Error
**File:** `frontend/src/components/AttendancePortal.js:63`
```javascript
// ❌ INCORRECT - Missing backticks
"${process.env.REACT_APP_API_URL || 'http://localhost:2035/api'}/attendance/mark"

// ✅ SHOULD BE:
`${process.env.REACT_APP_API_URL || 'http://localhost:2035/api'}/attendance/mark`
```

### 2. Backend Email Templates - Hardcoded URLs
**File:** `backend/utils/mailer.js`
- Line 167: `http://localhost:2035/api/leave/approve/`
- Line 171: `http://localhost:2035/api/leave/approve/`
- Line 207: `http://localhost:2035/api/leave/approve/`
- Line 213: `http://localhost:2035/api/leave/approve/`
- Line 301: `http://localhost:2036/hr/leave-management`
- Line 447: `http://localhost:2035/api/expenses/approve/`
- Line 468: `http://localhost:2035/api/expenses/approve/`
- Line 472: `http://localhost:2035/api/expenses/approve/`
- Line 535: `http://localhost:2036/hr/expense-management`

### 3. Backend Routes - Hardcoded URLs
**File:** `backend/routes/leave.js`
- Line 963: `http://localhost:2036/manager/leave-requests`
- Line 988: `http://localhost:2036/manager/leave-requests`
- Line 1027: `http://localhost:2036/manager/leave-requests`
- Line 1070: `http://localhost:2036/login`

**File:** `backend/routes/hr.js`
- Line 5203: `process.env.FRONTEND_URL || "http://localhost:2036"`

**File:** `backend/routes/documents.js`
- Line 533: `"http://localhost:2036"`
- Line 534: `"http://localhost:2035"`
- Line 535: `"http://localhost:2036"`

### 4. Frontend Components - Hardcoded Fallback URLs
**File:** `frontend/src/components/AttendancePortal.js`
- Line 35: `'http://localhost:2035/api'`
- Line 63: `'http://localhost:2035/api'` (with syntax error)

**File:** `frontend/src/components/EmployeeExpenseHistory.js`
- Line 272: `'http://localhost:2035'`

### 5. Email Configuration - Hardcoded SMTP Settings
**File:** `backend/production.env`
- Line 35: `SMTP_HOST=smtp.gmail.com`
- Line 36: `SMTP_PORT=587`
- Line 38: `SMTP_USER=noreply@nxzen.com`
- Line 39: `SMTP_PASS=nxzen_email_password_2024`

### 6. Database Configuration - Hardcoded Host
**File:** `backend/production.env`
- Line 9: `DB_HOST=postgres`
- Line 10: `DB_PORT=5432`

## Recommendations

### Immediate Fixes Required:

1. **Fix Template Literal Syntax Error**
   - Fix the missing backticks in `AttendancePortal.js:63`

2. **Create Environment Variables for Email Templates**
   ```env
   # Add to backend environment files
   BACKEND_BASE_URL=http://localhost:2035
   FRONTEND_BASE_URL=http://localhost:2036
   API_BASE_URL=http://localhost:2035/api
   ```

3. **Update Email Templates**
   - Replace all hardcoded URLs with environment variables
   - Use `${process.env.BACKEND_BASE_URL}/api/leave/approve/`
   - Use `${process.env.FRONTEND_BASE_URL}/manager/leave-requests`

4. **Update Frontend Fallback URLs**
   - Ensure all fallback URLs use environment variables consistently

### Environment Variables to Add:

```env
# Backend
BACKEND_BASE_URL=http://localhost:2035
FRONTEND_BASE_URL=http://localhost:2036
API_BASE_URL=http://localhost:2035/api

# Frontend
REACT_APP_BACKEND_URL=http://localhost:2035
REACT_APP_FRONTEND_URL=http://localhost:2036
```

## Files That Need Updates:

1. `frontend/src/components/AttendancePortal.js` - Fix syntax error
2. `backend/utils/mailer.js` - Replace hardcoded URLs
3. `backend/routes/leave.js` - Replace hardcoded URLs
4. `backend/routes/hr.js` - Replace hardcoded URLs
5. `backend/routes/documents.js` - Replace hardcoded URLs
6. `frontend/src/components/EmployeeExpenseHistory.js` - Replace hardcoded URLs
7. All environment files - Add new variables

## Priority Level: HIGH
These hardcoded values will cause issues in production deployment and should be addressed immediately.
