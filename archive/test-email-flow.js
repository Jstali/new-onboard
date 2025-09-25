#!/usr/bin/env node

/**
 * Test Email Flow
 *
 * This script tests the complete email sending flow to identify
 * where the success message error is occurring
 */

const axios = require("axios");

async function testEmailFlow() {
  try {
    console.log("🧪 Testing Email Flow...\n");

    // First, let's get a valid token by logging in
    console.log("1️⃣ Logging in to get valid token...");
    const loginResponse = await axios.post(
      "http://localhost:5001/api/auth/login",
      {
        email: "hr@nxzen.com",
        password: "hr123",
      }
    );

    const token = loginResponse.data.token;
    console.log("✅ Login successful, token received");

    // Now test creating a new employee (which should send email)
    console.log("\n2️⃣ Testing employee creation with email...");
    const employeeData = {
      name: "Test User Email",
      email: "testuser@example.com",
      type: "Full-Time",
      doj: "2025-01-15",
    };

    console.log("📤 Sending employee creation request:", employeeData);

    const createResponse = await axios.post(
      "http://localhost:5001/api/hr/employees",
      employeeData,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      }
    );

    console.log("✅ Employee creation successful!");
    console.log("📋 Response:", createResponse.data);

    // Check if the employee was created in the database
    console.log("\n3️⃣ Verifying employee was created...");
    const verifyResponse = await axios.get(
      "http://localhost:5001/api/hr/employees",
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    const testEmployee = verifyResponse.data.employees.find(
      (emp) => emp.email === "testuser@example.com"
    );

    if (testEmployee) {
      console.log("✅ Employee found in database:", testEmployee);
    } else {
      console.log("❌ Employee not found in database");
    }

    // Clean up - delete the test employee
    console.log("\n4️⃣ Cleaning up test employee...");
    if (testEmployee) {
      try {
        await axios.delete(
          `http://localhost:5001/api/hr/employees/${testEmployee.id}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );
        console.log("✅ Test employee cleaned up");
      } catch (cleanupError) {
        console.log(
          "⚠️  Cleanup failed (non-critical):",
          cleanupError.response?.data
        );
      }
    }
  } catch (error) {
    console.error("❌ Test failed:");
    console.error("Status:", error.response?.status);
    console.error("Status Text:", error.response?.statusText);
    console.error("Error Data:", error.response?.data);
    console.error("Full Error:", error.message);

    // If it's a 500 error, let's check the server logs
    if (error.response?.status === 500) {
      console.log("\n🔍 This is a 500 error - checking server logs...");
      console.log(
        "Please check the server console for detailed error information."
      );
    }
  }
}

async function main() {
  try {
    await testEmailFlow();
  } catch (error) {
    console.error("💥 Test failed:", error);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { testEmailFlow };
