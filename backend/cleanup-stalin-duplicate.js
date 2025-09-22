#!/usr/bin/env node

/**
 * Cleanup Stalin Duplicate Entry
 *
 * This script removes Stalin J from the employee_master table
 * since he should only be in onboarded_employees until company email assignment
 */

const { Pool } = require("pg");

// Database configuration
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "onboardd",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "Stali",
});

async function cleanupStalinDuplicate() {
  const client = await pool.connect();

  try {
    console.log("🧹 Cleaning up Stalin duplicate entry...\n");

    // Step 1: Check current state
    console.log("📊 Current State:");

    const stalinMaster = await client.query(`
      SELECT employee_id, employee_name, email, company_email, status 
      FROM employee_master 
      WHERE employee_name ILIKE '%stalin%'
    `);

    const stalinOnboarded = await client.query(`
      SELECT oe.id, u.email, u.first_name, u.last_name, oe.status
      FROM onboarded_employees oe
      JOIN users u ON oe.user_id = u.id
      WHERE u.first_name ILIKE '%stalin%' OR u.last_name ILIKE '%stalin%'
    `);

    console.log(
      `  - Stalin in Master Table: ${stalinMaster.rows.length} entries`
    );
    if (stalinMaster.rows.length > 0) {
      stalinMaster.rows.forEach((emp) => {
        console.log(
          `    - ${emp.employee_name} (ID: ${
            emp.employee_id
          }) - Company Email: ${emp.company_email || "None"}`
        );
      });
    }

    console.log(
      `  - Stalin in Onboarded: ${stalinOnboarded.rows.length} entries`
    );
    if (stalinOnboarded.rows.length > 0) {
      stalinOnboarded.rows.forEach((emp) => {
        console.log(
          `    - ${emp.first_name} ${emp.last_name} (${emp.email}) - Status: ${emp.status}`
        );
      });
    }

    // Step 2: Remove Stalin from master table (since he shouldn't be there yet)
    if (stalinMaster.rows.length > 0) {
      console.log("\n🗑️  Removing Stalin from Employee Master table...");

      const deleteResult = await client.query(`
        DELETE FROM employee_master 
        WHERE employee_name ILIKE '%stalin%'
      `);

      console.log(
        `✅ Removed ${deleteResult.rowCount} Stalin entries from master table`
      );
    } else {
      console.log("\n✅ Stalin not found in master table - no cleanup needed");
    }

    // Step 3: Verify final state
    console.log("\n📊 Final State:");

    const finalMaster = await client.query(`
      SELECT employee_id, employee_name, email, company_email, status 
      FROM employee_master 
      WHERE employee_name ILIKE '%stalin%'
    `);

    const finalOnboarded = await client.query(`
      SELECT oe.id, u.email, u.first_name, u.last_name, oe.status
      FROM onboarded_employees oe
      JOIN users u ON oe.user_id = u.id
      WHERE u.first_name ILIKE '%stalin%' OR u.last_name ILIKE '%stalin%'
    `);

    console.log(
      `  - Stalin in Master Table: ${finalMaster.rows.length} entries`
    );
    console.log(
      `  - Stalin in Onboarded: ${finalOnboarded.rows.length} entries`
    );

    if (finalMaster.rows.length === 0 && finalOnboarded.rows.length > 0) {
      console.log(
        "\n✅ Cleanup successful! Stalin is now only in Onboarded Employees table"
      );
      console.log(
        "   He will appear in Master Table only after company email assignment"
      );
    } else if (finalMaster.rows.length > 0) {
      console.log(
        "\n⚠️  Stalin still in Master Table - cleanup may have failed"
      );
    } else {
      console.log("\n⚠️  Stalin not found in either table");
    }
  } catch (error) {
    console.error("❌ Cleanup failed:", error);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    await cleanupStalinDuplicate();
    console.log("\n🎉 Stalin duplicate cleanup completed!");
  } catch (error) {
    console.error("💥 Cleanup failed:", error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { cleanupStalinDuplicate };
