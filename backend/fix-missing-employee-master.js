const { pool } = require("./config/database");
const { generateEmployeeId } = require("./utils/employeeIdGenerator");

async function fixMissingEmployeeMasterRecords() {
  try {
    console.log("🔍 Finding employees without employee_master records...");

    // Get all employees without employee_master records
    const result = await pool.query(`
      SELECT u.id, u.email, u.first_name, u.last_name, u.role 
      FROM users u 
      LEFT JOIN employee_master em ON u.email = em.company_email 
      WHERE u.role = 'employee' AND em.company_email IS NULL
    `);

    console.log(
      `Found ${result.rows.length} employees without employee_master records`
    );

    for (const user of result.rows) {
      try {
        const employeeId = await generateEmployeeId();
        const fullName =
          `${user.first_name || ""} ${user.last_name || ""}`.trim() ||
          "Unknown Employee";

        await pool.query(
          `
          INSERT INTO employee_master (
            employee_id, employee_name, company_email, type, doj, status,
            created_at, updated_at
          ) VALUES ($1, $2, $3, 'Full-Time', CURRENT_DATE, 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        `,
          [employeeId, fullName, user.email]
        );

        console.log(
          `✅ Created employee_master record for ${user.email} with ID: ${employeeId}`
        );
      } catch (error) {
        console.error(
          `❌ Error creating employee_master record for ${user.email}:`,
          error.message
        );
      }
    }

    console.log("✅ Fix completed!");
  } catch (error) {
    console.error("❌ Error fixing missing employee_master records:", error);
  } finally {
    await pool.end();
  }
}

fixMissingEmployeeMasterRecords();
