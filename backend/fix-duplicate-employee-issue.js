#!/usr/bin/env node

/**
 * Fix Duplicate Employee Issue Script
 *
 * This script fixes the duplicate employee issue by:
 * 1. Running the database migration
 * 2. Cleaning up existing duplicates
 * 3. Testing the fix
 */

const { Pool } = require("pg");
const fs = require("fs");
const path = require("path");

// Database configuration
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "onboardd",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "Stali",
});

async function runMigration() {
  const client = await pool.connect();

  try {
    console.log("🔍 Starting duplicate employee fix migration...");

    // Read the migration file
    const migrationPath = path.join(
      __dirname,
      "migrations/005FixDuplicateEmployeeIssue.sql"
    );
    const migrationSQL = fs.readFileSync(migrationPath, "utf8");

    // Execute the migration
    await client.query(migrationSQL);

    console.log("✅ Migration completed successfully");

    // Verify the fix by checking for duplicates
    const duplicateCheck = await client.query(`
      SELECT employee_name, email, COUNT(*) as count
      FROM employee_master 
      WHERE employee_name IS NOT NULL AND email IS NOT NULL
      GROUP BY employee_name, email
      HAVING COUNT(*) > 1
    `);

    if (duplicateCheck.rows.length === 0) {
      console.log("✅ No duplicates found - fix successful");
    } else {
      console.log("⚠️  Still found duplicates:", duplicateCheck.rows);
    }

    // Show current employee count
    const employeeCount = await client.query(
      "SELECT COUNT(*) as count FROM employee_master"
    );
    console.log(
      `📊 Total employees in master table: ${employeeCount.rows[0].count}`
    );
  } catch (error) {
    console.error("❌ Migration failed:", error);
    throw error;
  } finally {
    client.release();
  }
}

async function testDuplicatePrevention() {
  console.log("\n🧪 Testing duplicate prevention...");

  const testData = {
    email: "test.duplicate@example.com",
    name: "Test Duplicate",
    type: "Full-Time",
    doj: new Date().toISOString().split("T")[0],
  };

  try {
    // Try to create the same employee twice
    console.log("Creating first employee...");
    const response1 = await fetch("http://localhost:5001/api/hr/employees", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer your-test-token", // You'll need to get a real token
      },
      body: JSON.stringify(testData),
    });

    console.log("First creation result:", response1.status);

    // Try to create the same employee again
    console.log("Attempting to create duplicate...");
    const response2 = await fetch("http://localhost:5001/api/hr/employees", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer your-test-token",
      },
      body: JSON.stringify(testData),
    });

    console.log("Duplicate creation result:", response2.status);

    if (response2.status === 400) {
      console.log("✅ Duplicate prevention working correctly");
    } else {
      console.log("❌ Duplicate prevention not working");
    }
  } catch (error) {
    console.log(
      "⚠️  Could not test API (server might not be running):",
      error.message
    );
  }
}

async function main() {
  try {
    await runMigration();
    await testDuplicatePrevention();
    console.log("\n🎉 Duplicate employee issue fix completed!");
  } catch (error) {
    console.error("💥 Fix failed:", error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { runMigration, testDuplicatePrevention };
