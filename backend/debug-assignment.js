#!/usr/bin/env node

/**
 * Debug Assignment Process
 *
 * This script debugs the assignment process step by step
 * to identify where the 500 error is occurring
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

async function debugAssignment() {
  const client = await pool.connect();

  try {
    console.log("🔍 Debugging Assignment Process...\n");

    // Step 1: Check Stalin's onboarded employee record
    console.log("1️⃣ Checking Stalin's onboarded employee record:");
    const stalinOnboarded = await client.query(`
      SELECT oe.*, u.email as user_email, u.first_name, u.last_name
      FROM onboarded_employees oe
      JOIN users u ON oe.user_id = u.id
      WHERE u.first_name ILIKE '%stalin%' OR u.last_name ILIKE '%stalin%'
    `);

    if (stalinOnboarded.rows.length === 0) {
      console.log("❌ Stalin not found in onboarded employees");
      return;
    }

    const stalin = stalinOnboarded.rows[0];
    console.log("✅ Stalin found:", {
      id: stalin.id,
      user_id: stalin.user_id,
      user_email: stalin.user_email,
      first_name: stalin.first_name,
      last_name: stalin.last_name,
      status: stalin.status,
    });

    // Step 2: Check manager lookup
    console.log("\n2️⃣ Checking manager lookup for 'Luthen S':");
    const managerResult = await client.query(
      `
      SELECT em.employee_id as manager_id, em.employee_name as manager_name, u.id as user_id, u.email
      FROM employee_master em
      LEFT JOIN users u ON em.company_email = u.email 
      WHERE em.employee_name ILIKE $1 AND em.status = 'active' AND em.type = 'Manager'
    `,
      ["Luthen S"]
    );

    if (managerResult.rows.length === 0) {
      console.log("❌ Manager 'Luthen S' not found");
      return;
    }

    const managerInfo = managerResult.rows[0];
    console.log("✅ Manager found:", managerInfo);

    if (!managerInfo.user_id) {
      console.log("❌ Manager does not have a user account");
      return;
    }

    // Step 3: Test employee ID generation
    console.log("\n3️⃣ Testing employee ID generation:");
    const { generateEmployeeId } = require("./utils/employeeIdGenerator");
    const employeeId = await generateEmployeeId();
    console.log("✅ Generated Employee ID:", employeeId);

    // Step 4: Check for duplicates
    console.log("\n4️⃣ Checking for duplicates:");
    const name = "Stalin J";
    const companyEmail = "stalin@nxzen.com";
    const personalEmail = stalin.user_email;

    const existingEmployee = await client.query(
      "SELECT employee_id, employee_name, company_email, email FROM employee_master WHERE employee_name = $1 OR company_email = $2 OR email = $3",
      [name, companyEmail, personalEmail]
    );

    if (existingEmployee.rows.length > 0) {
      console.log("❌ Duplicate found:", existingEmployee.rows[0]);
      return;
    }
    console.log("✅ No duplicates found");

    // Step 5: Test the INSERT statement
    console.log("\n5️⃣ Testing INSERT statement:");
    try {
      await client.query("BEGIN");

      // Test the INSERT
      const insertResult = await client.query(
        `
        INSERT INTO employee_master (
          employee_id, employee_name, email, company_email, 
          manager_id, manager_name, 
          manager2_id, manager2_name, 
          manager3_id, manager3_name, 
          type, doj
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      `,
        [
          employeeId,
          name,
          personalEmail,
          companyEmail,
          managerInfo.manager_id,
          managerInfo.manager_name,
          null, // manager2_id
          null, // manager2_name
          null, // manager3_id
          null, // manager3_name
          "Full-Time",
          new Date().toISOString().split("T")[0], // today's date
        ]
      );

      console.log("✅ INSERT successful, row count:", insertResult.rowCount);

      // Rollback the transaction
      await client.query("ROLLBACK");
      console.log("✅ Transaction rolled back (test only)");
    } catch (insertError) {
      console.log("❌ INSERT failed:", insertError.message);
      console.log("❌ Error code:", insertError.code);
      console.log("❌ Error detail:", insertError.detail);
      await client.query("ROLLBACK");
    }

    console.log("\n🎉 Debug completed!");
  } catch (error) {
    console.error("❌ Debug failed:", error);
  } finally {
    client.release();
  }
}

async function main() {
  try {
    await debugAssignment();
  } catch (error) {
    console.error("💥 Debug failed:", error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { debugAssignment };
