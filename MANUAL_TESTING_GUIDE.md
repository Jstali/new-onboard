# Manual Testing Guide for HR Employee Onboarding & Attendance Management

## Prerequisites
- Backend server running on `http://localhost:5001`
- Frontend application running on `http://localhost:3001`
- Database (PostgreSQL) running on `localhost:5432`

## Default Login Credentials
- **HR Admin**: `hr@nxzen.com` / `hr123`
- **Manager**: `manager@nxzen.com` / `password`
- **Employee**: Use any created employee credentials

---

## 1. Authentication Testing

### 1.1 Login Testing
**URL**: `http://localhost:3001/login`

**Test Cases**:
1. **Valid HR Login**
   - Email: `hr@nxzen.com`
   - Password: `hr123`
   - Expected: Redirect to HR Dashboard

2. **Valid Manager Login**
   - Email: `manager@nxzen.com`
   - Password: `password`
   - Expected: Redirect to Manager Dashboard

3. **Invalid Credentials**
   - Email: `wrong@email.com`
   - Password: `wrongpassword`
   - Expected: Error message "Invalid credentials"

4. **Empty Fields**
   - Leave email/password empty
   - Expected: Validation error messages

### 1.2 Logout Testing
**Steps**:
1. Login with valid credentials
2. Click "Logout" button
3. Expected: Redirect to login page, session cleared

---

## 2. HR Dashboard Testing

### 2.1 Dashboard Access
**URL**: `http://localhost:3001/hr`

**Test Cases**:
1. **Direct Access Without Login**
   - Navigate to `/hr` without logging in
   - Expected: Redirect to login page

2. **Access with HR Role**
   - Login as HR and navigate to `/hr`
   - Expected: HR Dashboard loads successfully

3. **Access with Non-HR Role**
   - Login as manager and navigate to `/hr`
   - Expected: Access denied or redirect

### 2.2 Navigation Testing
**Test Cases**:
1. **Sidebar Navigation**
   - Click each menu item in the sidebar
   - Expected: Correct page loads for each item

2. **Breadcrumb Navigation**
   - Navigate through different sections
   - Expected: Breadcrumbs update correctly

---

## 3. Employee Management Testing

### 3.1 Add New Employee
**URL**: `http://localhost:3001/hr` → Click "Add Employee"

**Test Cases**:
1. **Valid Employee Creation**
   - First Name: `John`
   - Last Name: `Doe`
   - Email: `john.doe@example.com`
   - Type: `Full-Time`
   - Date of Joining: `2025-01-15`
   - Expected: Success message, employee appears in "Onboarded Employees"

2. **Duplicate Email**
   - Use same email as existing employee
   - Expected: Error message "Email already exists"

3. **Invalid Email Format**
   - Email: `invalid-email`
   - Expected: Validation error

4. **Missing Required Fields**
   - Leave required fields empty
   - Expected: Validation errors

5. **Email Sending Test**
   - Create employee with valid data
   - Expected: Email sent successfully, success message displayed

### 3.2 Employee Master Table
**URL**: `http://localhost:3001/hr` → "Employee Master"

**Test Cases**:
1. **View Employee Master Table**
   - Navigate to Employee Master section
   - Expected: Table displays all employees with company emails

2. **Search Functionality**
   - Use search box to find specific employee
   - Expected: Table filters correctly

3. **Export Functions**
   - Test Excel export
   - Test CSV export
   - Expected: Files download successfully

### 3.3 Onboarded Employees
**URL**: `http://localhost:3001/hr` → "Onboarded Employees"

**Test Cases**:
1. **View Onboarded Employees**
   - Navigate to Onboarded Employees section
   - Expected: List shows employees pending company email assignment

2. **Assign Company Email**
   - Click "Assign Details" for an employee
   - Fill in company email and manager details
   - Expected: Employee moves to Master table, success message

3. **Duplicate Assignment Prevention**
   - Try to assign same company email twice
   - Expected: Error message about duplicate

---

## 4. Employee Forms Testing

### 4.1 Form Submission
**URL**: `http://localhost:3001/onboarding` (as employee)

**Test Cases**:
1. **Complete Form Submission**
   - Fill all required fields
   - Upload required documents
   - Submit form
   - Expected: Success message, form appears in HR dashboard

2. **Incomplete Form**
   - Leave required fields empty
   - Expected: Validation errors

3. **Document Upload**
   - Upload valid documents (PDF, images)
   - Expected: Files upload successfully

4. **Invalid Document Types**
   - Upload unsupported file types
   - Expected: Error message

### 4.2 Form Approval
**URL**: `http://localhost:3001/hr` → "Employee Forms"

**Test Cases**:
1. **Approve Form**
   - Click "Approve" on a pending form
   - Expected: Employee moves to onboarded list

2. **Reject Form**
   - Click "Reject" on a form
   - Expected: Form marked as rejected

---

## 5. Leave Management Testing

### 5.1 Employee Leave Request
**URL**: `http://localhost:3001/employee/leave` (as employee)

**Test Cases**:
1. **Submit Leave Request**
   - Select leave type, dates, reason
   - Submit request
   - Expected: Request appears in manager's dashboard

2. **Invalid Date Range**
   - Select past dates or invalid range
   - Expected: Validation error

3. **Exceed Leave Balance**
   - Request more days than available
   - Expected: Warning or error message

### 5.2 Manager Leave Approval
**URL**: `http://localhost:3001/manager/leave-requests` (as manager)

**Test Cases**:
1. **Approve Leave Request**
   - Click "Approve" on a request
   - Expected: Status changes to approved

2. **Reject Leave Request**
   - Click "Reject" with reason
   - Expected: Status changes to rejected

3. **Email Notifications**
   - Approve/reject request
   - Expected: Employee receives email notification

### 5.3 HR Leave Management
**URL**: `http://localhost:3001/hr/leave-management`

**Test Cases**:
1. **View All Leave Requests**
   - Navigate to leave management
   - Expected: All requests displayed

2. **Filter and Search**
   - Use filters to find specific requests
   - Expected: Results filter correctly

---

## 6. Expense Management Testing

### 6.1 Employee Expense Submission
**URL**: `http://localhost:3001/employee/expenses` (as employee)

**Test Cases**:
1. **Submit Expense Request**
   - Fill expense details, upload receipt
   - Submit request
   - Expected: Request appears in manager's dashboard

2. **Invalid Amount**
   - Enter negative or zero amount
   - Expected: Validation error

3. **Missing Receipt**
   - Submit without required receipt
   - Expected: Validation error

### 6.2 Manager Expense Approval
**URL**: `http://localhost:3001/manager/expense-requests` (as manager)

**Test Cases**:
1. **Approve Expense**
   - Review and approve expense
   - Expected: Status changes to approved

2. **Reject Expense**
   - Reject with reason
   - Expected: Status changes to rejected

---

## 7. Attendance Management Testing

### 7.1 Employee Attendance
**URL**: `http://localhost:3001/employee/attendance` (as employee)

**Test Cases**:
1. **Mark Attendance**
   - Click "Check In" and "Check Out"
   - Expected: Attendance recorded

2. **View Attendance History**
   - Navigate to attendance history
   - Expected: Past records displayed

3. **Invalid Time Entry**
   - Try to check out before check in
   - Expected: Validation error

### 7.2 Manager Attendance View
**URL**: `http://localhost:3001/manager/attendance` (as manager)

**Test Cases**:
1. **View Team Attendance**
   - Navigate to attendance section
   - Expected: Team members' attendance displayed

2. **Filter by Date/Employee**
   - Use filters to view specific data
   - Expected: Results filter correctly

---

## 8. Document Management Testing

### 8.1 Document Upload
**URL**: `http://localhost:3001/employee/documents` (as employee)

**Test Cases**:
1. **Upload Required Documents**
   - Upload all required document types
   - Expected: Documents appear in list

2. **Document Preview**
   - Click on uploaded document
   - Expected: Document opens in viewer

3. **Document Deletion**
   - Delete uploaded document
   - Expected: Document removed from list

### 8.2 HR Document Review
**URL**: `http://localhost:3001/hr/documents`

**Test Cases**:
1. **View All Documents**
   - Navigate to document management
   - Expected: All employee documents displayed

2. **Document Status Update**
   - Mark documents as verified/rejected
   - Expected: Status updates correctly

---

## 9. Error Handling Testing

### 9.1 Network Error Simulation
**Test Cases**:
1. **Server Disconnection**
   - Stop backend server during operation
   - Expected: Graceful error handling

2. **Database Connection Issues**
   - Simulate database unavailability
   - Expected: Appropriate error messages

### 9.2 Input Validation Testing
**Test Cases**:
1. **SQL Injection Attempts**
   - Enter malicious SQL in input fields
   - Expected: Input sanitized, no errors

2. **XSS Attempts**
   - Enter script tags in text fields
   - Expected: Scripts not executed

---

## 10. Performance Testing

### 10.1 Load Testing
**Test Cases**:
1. **Multiple Concurrent Users**
   - Open multiple browser tabs/windows
   - Perform operations simultaneously
   - Expected: System handles load gracefully

2. **Large Data Sets**
   - Create many employees/records
   - Test pagination and search
   - Expected: Performance remains acceptable

---

## 11. Browser Compatibility Testing

### 11.1 Cross-Browser Testing
**Test Cases**:
1. **Chrome**
   - Test all major functionality
   - Expected: All features work correctly

2. **Firefox**
   - Test all major functionality
   - Expected: All features work correctly

3. **Safari**
   - Test all major functionality
   - Expected: All features work correctly

4. **Edge**
   - Test all major functionality
   - Expected: All features work correctly

---

## 12. Mobile Responsiveness Testing

### 12.1 Mobile Device Testing
**Test Cases**:
1. **Mobile View**
   - Access application on mobile device
   - Expected: Responsive design works

2. **Touch Interactions**
   - Test touch gestures and interactions
   - Expected: All features accessible

---

## 13. Security Testing

### 13.1 Authentication Security
**Test Cases**:
1. **Session Timeout**
   - Leave application idle for extended period
   - Expected: Automatic logout

2. **Token Expiration**
   - Use expired tokens
   - Expected: Redirect to login

### 13.2 Authorization Testing
**Test Cases**:
1. **Role-Based Access**
   - Try to access HR features as employee
   - Expected: Access denied

2. **Direct URL Access**
   - Try to access restricted URLs directly
   - Expected: Redirect to appropriate page

---

## 14. Data Integrity Testing

### 14.1 Data Consistency
**Test Cases**:
1. **Employee Data Sync**
   - Create employee, check all related tables
   - Expected: Data consistent across tables

2. **Cascade Deletes**
   - Delete employee, check related records
   - Expected: Related records cleaned up

---

## 15. Email Functionality Testing

### 15.1 Email Notifications
**Test Cases**:
1. **Onboarding Emails**
   - Create new employee
   - Expected: Welcome email sent

2. **Leave Approval Emails**
   - Approve/reject leave request
   - Expected: Notification email sent

3. **Password Reset Emails**
   - Request password reset
   - Expected: Reset email sent

---

## Testing Checklist

### Pre-Testing Setup
- [ ] Backend server running on port 5001
- [ ] Frontend application running on port 3001
- [ ] Database connected and accessible
- [ ] Email service configured
- [ ] Test data prepared

### Critical Path Testing
- [ ] User authentication flow
- [ ] Employee creation and onboarding
- [ ] Leave request and approval process
- [ ] Expense submission and approval
- [ ] Document upload and management
- [ ] Attendance tracking

### Error Scenarios
- [ ] Invalid login attempts
- [ ] Network connectivity issues
- [ ] Database connection problems
- [ ] File upload errors
- [ ] Email sending failures

### Performance Checks
- [ ] Page load times acceptable
- [ ] Database queries optimized
- [ ] File uploads work smoothly
- [ ] Search functionality responsive

### Security Validations
- [ ] Authentication required for all protected routes
- [ ] Role-based access control working
- [ ] Input validation preventing malicious data
- [ ] Session management secure

---

## Notes
- Test with different user roles (HR, Manager, Employee)
- Use realistic test data
- Document any bugs or issues found
- Test both positive and negative scenarios
- Verify all error messages are user-friendly
- Check that all success messages display correctly
