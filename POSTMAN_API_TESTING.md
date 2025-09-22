# Postman API Testing Guide

## Environment Setup

### Base URLs
- **Backend API**: `http://localhost:5001/api`
- **Frontend**: `http://localhost:3001`

### Environment Variables
Create a Postman environment with these variables:
```
base_url: http://localhost:5001/api
frontend_url: http://localhost:3001
hr_email: hr@nxzen.com
hr_password: hr123
manager_email: manager@nxzen.com
manager_password: password
```

---

## 1. Authentication APIs

### 1.1 Login
**Method**: `POST`  
**URL**: `{{base_url}}/auth/login`  
**Headers**: `Content-Type: application/json`

**Body** (JSON):
```json
{
  "email": "{{hr_email}}",
  "password": "{{hr_password}}"
}
```

**Expected Response**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "hr@nxzen.com",
    "role": "hr",
    "first_name": "HR",
    "last_name": "Manager"
  }
}
```

**Test Script**:
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has token", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.token).to.exist;
    pm.environment.set("auth_token", jsonData.token);
});
```

### 1.2 Get Current User
**Method**: `GET`  
**URL**: `{{base_url}}/auth/me`  
**Headers**: `Authorization: Bearer {{auth_token}}`

**Expected Response**:
```json
{
  "id": 1,
  "email": "hr@nxzen.com",
  "role": "hr",
  "first_name": "HR",
  "last_name": "Manager"
}
```

### 1.3 Logout
**Method**: `POST`  
**URL**: `{{base_url}}/auth/logout`  
**Headers**: `Authorization: Bearer {{auth_token}}`

---

## 2. HR Employee Management APIs

### 2.1 Create Employee
**Method**: `POST`  
**URL**: `{{base_url}}/hr/employees`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "name": "Test Employee",
  "email": "test.employee@example.com",
  "type": "Full-Time",
  "doj": "2025-01-15"
}
```

**Expected Response**:
```json
{
  "message": "Employee added successfully - will appear in master table after company email assignment",
  "employee": {
    "id": 123,
    "email": "test.employee@example.com",
    "name": "Test Employee",
    "type": "Full-Time",
    "doj": "2025-01-15T00:00:00.000Z",
    "tempPassword": "abc123"
  }
}
```

**Test Script**:
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Employee created successfully", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.message).to.include("successfully");
    pm.environment.set("employee_id", jsonData.employee.id);
});
```

### 2.2 Get All Employees
**Method**: `GET`  
**URL**: `{{base_url}}/hr/employees`  
**Headers**: `Authorization: Bearer {{auth_token}}`

**Expected Response**:
```json
{
  "employees": [
    {
      "id": 1,
      "employee_id": "123456",
      "employee_name": "John Doe",
      "email": "john.doe@example.com",
      "company_email": "john.doe@nxzen.com",
      "type": "Full-Time",
      "status": "active"
    }
  ]
}
```

### 2.3 Get Employee Master Table
**Method**: `GET`  
**URL**: `{{base_url}}/hr/master`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 2.4 Get Onboarded Employees
**Method**: `GET`  
**URL**: `{{base_url}}/hr/onboarded`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 2.5 Assign Company Email
**Method**: `PUT`  
**URL**: `{{base_url}}/hr/onboarded/{{employee_id}}/assign`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "name": "Test Employee",
  "companyEmail": "test.employee@nxzen.com",
  "manager": "Luthen S"
}
```

**Expected Response**:
```json
{
  "message": "Employee details assigned and moved to master table successfully",
  "employee": {
    "employeeId": "789012",
    "companyEmail": "test.employee@nxzen.com",
    "name": "Test Employee",
    "manager": "Luthen S"
  }
}
```

### 2.6 Delete Employee
**Method**: `DELETE`  
**URL**: `{{base_url}}/hr/employees/{{employee_id}}`  
**Headers**: `Authorization: Bearer {{auth_token}}`

---

## 3. Leave Management APIs

### 3.1 Submit Leave Request
**Method**: `POST`  
**URL**: `{{base_url}}/leave/request`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "leave_type": "casual",
  "from_date": "2025-02-01",
  "to_date": "2025-02-03",
  "reason": "Personal work"
}
```

### 3.2 Get Leave Requests
**Method**: `GET`  
**URL**: `{{base_url}}/leave/requests`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 3.3 Approve/Reject Leave
**Method**: `PUT`  
**URL**: `{{base_url}}/leave/{{leave_id}}/approve`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "action": "approve",
  "notes": "Approved by manager"
}
```

---

## 4. Expense Management APIs

### 4.1 Submit Expense Request
**Method**: `POST`  
**URL**: `{{base_url}}/expenses/submit`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "expense_category": "travel",
  "expense_type": "transportation",
  "amount": 150.00,
  "currency": "USD",
  "description": "Taxi fare to client meeting",
  "expense_date": "2025-01-15"
}
```

### 4.2 Get Expense Requests
**Method**: `GET`  
**URL**: `{{base_url}}/expenses/requests`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 4.3 Approve/Reject Expense
**Method**: `PUT`  
**URL**: `{{base_url}}/expenses/{{expense_id}}/approve`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "action": "approve",
  "notes": "Approved by manager"
}
```

---

## 5. Attendance APIs

### 5.1 Check In
**Method**: `POST`  
**URL**: `{{base_url}}/attendance/checkin`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "date": "2025-01-15",
  "check_in_time": "09:00:00"
}
```

### 5.2 Check Out
**Method**: `POST`  
**URL**: `{{base_url}}/attendance/checkout`  
**Headers**: 
- `Authorization: Bearer {{auth_token}}`
- `Content-Type: application/json`

**Body** (JSON):
```json
{
  "date": "2025-01-15",
  "check_out_time": "18:00:00"
}
```

### 5.3 Get Attendance Records
**Method**: `GET`  
**URL**: `{{base_url}}/attendance/records`  
**Headers**: `Authorization: Bearer {{auth_token}}`

---

## 6. Document Management APIs

### 6.1 Upload Document
**Method**: `POST`  
**URL**: `{{base_url}}/documents/upload`  
**Headers**: `Authorization: Bearer {{auth_token}}`

**Body** (form-data):
```
file: [select file]
document_type: passport
```

### 6.2 Get Documents
**Method**: `GET`  
**URL**: `{{base_url}}/documents`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 6.3 Download Document
**Method**: `GET`  
**URL**: `{{base_url}}/documents/{{document_id}}/download`  
**Headers**: `Authorization: Bearer {{auth_token}}`

---

## 7. Manager APIs

### 7.1 Get Manager Dashboard
**Method**: `GET`  
**URL**: `{{base_url}}/manager/dashboard`  
**Headers**: `Authorization: Bearer {{auth_token}}`

### 7.2 Get Team Members
**Method**: `GET`  
**URL**: `{{base_url}}/manager/team`  
**Headers**: `Authorization: Bearer {{auth_token}}`

---

## 8. Testing Workflow

### Step 1: Setup
1. Create Postman environment with variables
2. Import the collection
3. Set up authentication

### Step 2: Authentication Flow
1. Test login with valid credentials
2. Test login with invalid credentials
3. Test token validation
4. Test logout

### Step 3: HR Operations
1. Create new employee
2. Verify employee appears in onboarded list
3. Assign company email
4. Verify employee moves to master table
5. Test employee deletion

### Step 4: Leave Management
1. Submit leave request
2. Approve/reject leave request
3. Verify status updates

### Step 5: Expense Management
1. Submit expense request
2. Approve/reject expense
3. Verify status updates

### Step 6: Attendance
1. Check in/out
2. View attendance records
3. Test date filtering

### Step 7: Documents
1. Upload document
2. View documents
3. Download document

---

## 9. Error Testing

### Test Invalid Requests
1. **Missing Authentication**
   - Remove Authorization header
   - Expected: 401 Unauthorized

2. **Invalid Token**
   - Use expired or invalid token
   - Expected: 401 Unauthorized

3. **Missing Required Fields**
   - Send incomplete data
   - Expected: 400 Bad Request

4. **Invalid Data Types**
   - Send wrong data types
   - Expected: 400 Bad Request

5. **Duplicate Data**
   - Try to create duplicate records
   - Expected: 400 Bad Request

---

## 10. Performance Testing

### Load Testing
1. **Multiple Requests**
   - Send multiple requests simultaneously
   - Monitor response times

2. **Large Data Sets**
   - Test with large number of records
   - Check pagination performance

---

## 11. Collection Runner

### Automated Testing
1. **Setup Collection Runner**
   - Select collection
   - Set iterations
   - Configure delays

2. **Run Tests**
   - Execute all requests
   - Review results
   - Check for failures

---

## 12. Environment Management

### Different Environments
1. **Development**
   - base_url: http://localhost:5001/api
   - Use test data

2. **Staging**
   - base_url: https://staging-api.example.com/api
   - Use staging data

3. **Production**
   - base_url: https://api.example.com/api
   - Use production data

---

## Notes
- Always test with different user roles
- Use realistic test data
- Test both success and error scenarios
- Monitor response times
- Check for proper error messages
- Verify data consistency
- Test authentication and authorization
