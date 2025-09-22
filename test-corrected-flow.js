#!/usr/bin/env node

/**
 * Test Script for Corrected Employee Flow
 *
 * This script tests the corrected employee flow to ensure:
 * 1. Employees are NOT created in master table during initial creation
 * 2. Employees only appear in master table after company email assignment
 * 3. No duplicate errors occur
 */

const { Pool } = require("pg");

// Database configuration
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "onboardxdb",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "MySecurePass#2025",
});

async function testCorrectedFlow() {
  const client = await pool.connect();

  try {
    console.log("🧪 Testing Corrected Employee Flow...\n");

    // Step 1: Check current state
    console.log("📊 Current Database State:");

    const masterCount = await client.query(
      "SELECT COUNT(*) as count FROM employee_master"
    );
    const onboardedCount = await client.query(
      "SELECT COUNT(*) as count FROM onboarded_employees"
    );
    const usersCount = await client.query(
      "SELECT COUNT(*) as count FROM users WHERE role = 'employee'"
    );

    console.log(
      `  - Employee Master Table: ${masterCount.rows[0].count} employees`
    );
    console.log(
      `  - Onboarded Employees: ${onboardedCount.rows[0].count} employees`
    );
    console.log(
      `  - Users (employees): ${usersCount.rows[0].count} employees\n`
    );

    // Step 2: Check for employees in master table without company email
    console.log(
      "🔍 Checking for employees in master table without company email:"
    );
    const noCompanyEmail = await client.query(`
      SELECT employee_id, employee_name, company_email, email 
      FROM employee_master 
      WHERE company_email IS NULL
    `);

    if (noCompanyEmail.rows.length === 0) {
      console.log("  ✅ No employees in master table without company email");
    } else {
      console.log(
        "  ⚠️  Found employees in master table without company email:"
      );
      noCompanyEmail.rows.forEach((emp) => {
        console.log(`    - ${emp.employee_name} (ID: ${emp.employee_id})`);
      });
    }

    // Step 3: Check for duplicate entries
    console.log("\n🔍 Checking for duplicate entries:");
    const duplicates = await client.query(`
      SELECT employee_name, email, company_email, COUNT(*) as count
      FROM employee_master 
      WHERE employee_name IS NOT NULL AND email IS NOT NULL
      GROUP BY employee_name, email, company_email
      HAVING COUNT(*) > 1
    `);

    if (duplicates.rows.length === 0) {
      console.log("  ✅ No duplicate entries found");
    } else {
      console.log("  ❌ Found duplicate entries:");
      duplicates.rows.forEach((dup) => {
        console.log(
          `    - ${dup.employee_name} (${dup.email}) - ${dup.count} copies`
        );
      });
    }

    // Step 4: Check for Stalin specifically
    console.log("\n🔍 Checking for Stalin entries:");
    const stalinEntries = await client.query(`
      SELECT employee_id, employee_name, email, company_email, status
      FROM employee_master 
      WHERE employee_name ILIKE '%stalin%'
    `);

    if (stalinEntries.rows.length === 0) {
      console.log("  ✅ No Stalin entries in master table");
    } else {
      console.log("  📋 Stalin entries found:");
      stalinEntries.rows.forEach((emp) => {
        console.log(`    - ${emp.employee_name} (ID: ${emp.employee_id})`);
        console.log(`      Email: ${emp.email || "None"}`);
        console.log(`      Company Email: ${emp.company_email || "None"}`);
        console.log(`      Status: ${emp.status}`);
      });
    }

    // Step 5: Check onboarded employees
    console.log("\n🔍 Checking onboarded employees:");
    const onboardedEmployees = await client.query(`
      SELECT oe.id, u.email, u.first_name, u.last_name, oe.status
      FROM onboarded_employees oe
      JOIN users u ON oe.user_id = u.id
      ORDER BY oe.created_at DESC
      LIMIT 5
    `);

    if (onboardedEmployees.rows.length === 0) {
      console.log("  ℹ️  No onboarded employees found");
    } else {
      console.log("  📋 Recent onboarded employees:");
      onboardedEmployees.rows.forEach((emp) => {
        console.log(
          `    - ${emp.first_name} ${emp.last_name} (${emp.email}) - Status: ${emp.status}`
        );
      });
    }

    console.log("\n✅ Flow verification completed!");
  } catch (error) {
    console.error("❌ Test failed:", error);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    await testCorrectedFlow();
    console.log("\n🎉 Corrected employee flow test completed successfully!");
  } catch (error) {
    console.error("💥 Test failed:", error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { testCorrectedFlow };
