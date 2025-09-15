const express = require("express");
const { pool } = require("../config/database");
const { authenticateToken, requireEmployee } = require("../middleware/auth");
const router = express.Router();

// Get current employee's payroll details
router.get(
  "/my-payroll",
  authenticateToken,
  requireEmployee,
  async (req, res) => {
    try {
      const employeeId = req.user.userId;
      const userEmail = req.user.email;

      // Fetch employee details from employees_combined table
      const result = await pool.query(
        `SELECT 
         employee_id, employee_name, company_email, doj as joining_date, 
         payroll_starting_month, designation, department, work_location, salary_band,
         type as employee_type, status, is_draft,
         manager_name, manager2_name, manager3_name
       FROM employees_combined 
       WHERE id = $1 OR company_email = $2`,
        [employeeId, userEmail]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          error: "Payroll details not found for this employee.",
        });
      }

      res.json({ success: true, data: result.rows[0] });
    } catch (error) {
      console.error("Error fetching employee payroll details:", error);
      res
        .status(500)
        .json({ success: false, error: "Failed to fetch payroll details." });
    }
  }
);

// Get employee payroll details by ID (for HR)
router.get("/:employeeId", authenticateToken, async (req, res) => {
  try {
    const { employeeId } = req.params;
    const userRole = req.user.role;

    // Only HR can access other employees' payroll details
    if (userRole !== "hr") {
      return res
        .status(403)
        .json({ success: false, error: "Access denied. HR role required." });
    }

    // Fetch employee details from employees_combined table
    const result = await pool.query(
      `SELECT 
         employee_id, employee_name, company_email, doj as joining_date, 
         payroll_starting_month, designation, department, work_location, salary_band,
         type as employee_type, status, is_draft,
         manager_name, manager2_name, manager3_name
       FROM employees_combined 
       WHERE employee_id = $1`,
      [employeeId]
    );

    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ success: false, error: "Employee not found." });
    }

    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error("Error fetching employee payroll details:", error);
    res
      .status(500)
      .json({ success: false, error: "Failed to fetch payroll details." });
  }
});

module.exports = router;
