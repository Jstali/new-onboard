#!/usr/bin/env node

/**
 * Test Assignment API
 *
 * This script tests the assignment API directly to reproduce the 500 error
 */

const axios = require("axios");

async function testAssignmentAPI() {
  try {
    console.log("🧪 Testing Assignment API...\n");

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

    // Now test the assignment API
    console.log("\n2️⃣ Testing assignment API...");
    const assignmentData = {
      name: "Stalin J",
      companyEmail: "stalin@nxzen.com",
      manager: "Luthen S",
    };

    console.log("📤 Sending assignment request:", assignmentData);

    const assignmentResponse = await axios.put(
      "http://localhost:5001/api/hr/onboarded/39/assign",
      assignmentData,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      }
    );

    console.log("✅ Assignment successful:", assignmentResponse.data);
  } catch (error) {
    console.error("❌ Assignment failed:");
    console.error("Status:", error.response?.status);
    console.error("Status Text:", error.response?.statusText);
    console.error("Error Data:", error.response?.data);
    console.error("Full Error:", error.message);
  }
}

async function main() {
  try {
    await testAssignmentAPI();
  } catch (error) {
    console.error("💥 Test failed:", error);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { testAssignmentAPI };
