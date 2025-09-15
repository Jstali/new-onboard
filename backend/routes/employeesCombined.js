const express = require("express");
const { pool } = require("../config/database");
const { authenticateToken } = require("../middleware/auth");
const router = express.Router();

// Get all employees with combined data
router.get("/", authenticateToken, async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      search,
      department,
      status,
      isDraft,
    } = req.query;
    const offset = (page - 1) * limit;

    let query = `
      SELECT 
        id, employee_id, employee_name, company_email, 
        manager_id, manager_name, type, role, doj, status, 
        department, designation, salary_band, location,
        employee_full_name, email, alternate_email, mobile_number,
        phone_number1, phone_number2, address1, city, state, 
        pincode, country, nationality, bank_name, account_no,
        bank_ifsc_code, payment_mode, pf_account_no, esi_account_no,
        is_draft, created_at, updated_at
      FROM employees_combined
      WHERE 1=1
    `;

    const queryParams = [];
    let paramCount = 0;

    if (search) {
      paramCount++;
      query += ` AND (employee_name ILIKE $${paramCount} OR employee_id ILIKE $${paramCount} OR company_email ILIKE $${paramCount})`;
      queryParams.push(`%${search}%`);
    }

    if (department) {
      paramCount++;
      query += ` AND department = $${paramCount}`;
      queryParams.push(department);
    }

    if (status) {
      paramCount++;
      query += ` AND status = $${paramCount}`;
      queryParams.push(status);
    }

    if (isDraft !== undefined) {
      paramCount++;
      query += ` AND is_draft = $${paramCount}`;
      queryParams.push(isDraft === "true");
    }

    query += ` ORDER BY created_at DESC LIMIT $${paramCount + 1} OFFSET $${
      paramCount + 2
    }`;
    queryParams.push(parseInt(limit), offset);

    const result = await pool.query(query, queryParams);

    // Get total count for pagination
    let countQuery = `SELECT COUNT(*) FROM employees_combined WHERE 1=1`;
    const countParams = [];
    let countParamCount = 0;

    if (search) {
      countParamCount++;
      countQuery += ` AND (employee_name ILIKE $${countParamCount} OR employee_id ILIKE $${countParamCount} OR company_email ILIKE $${countParamCount})`;
      countParams.push(`%${search}%`);
    }

    if (department) {
      countParamCount++;
      countQuery += ` AND department = $${countParamCount}`;
      countParams.push(department);
    }

    if (status) {
      countParamCount++;
      countQuery += ` AND status = $${countParamCount}`;
      countParams.push(status);
    }

    if (isDraft !== undefined) {
      countParamCount++;
      countQuery += ` AND is_draft = $${countParamCount}`;
      countParams.push(isDraft === "true");
    }

    const countResult = await pool.query(countQuery, countParams);
    const total = parseInt(countResult.rows[0].count);
    const pages = Math.ceil(total / limit);

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages,
      },
    });
  } catch (error) {
    console.error("Error fetching employees:", error);
    res
      .status(500)
      .json({ success: false, error: "Failed to fetch employees." });
  }
});

// Get statistics overview
router.get("/stats/overview", authenticateToken, async (req, res) => {
  try {
    const stats = await pool.query(`
      SELECT 
        COUNT(*) as total,
        COUNT(CASE WHEN status = 'active' THEN 1 END) as active,
        COUNT(CASE WHEN is_draft = true THEN 1 END) as draft,
        COUNT(DISTINCT department) as department_count
      FROM employees_combined
    `);

    const departments = await pool.query(`
      SELECT department, COUNT(*) as count 
      FROM employees_combined 
      WHERE department IS NOT NULL 
      GROUP BY department 
      ORDER BY count DESC
    `);

    res.json({
      success: true,
      data: {
        total: parseInt(stats.rows[0].total),
        active: parseInt(stats.rows[0].active),
        draft: parseInt(stats.rows[0].draft),
        departments: departments.rows,
      },
    });
  } catch (error) {
    console.error("Error fetching stats:", error);
    res
      .status(500)
      .json({ success: false, error: "Failed to fetch statistics." });
  }
});

module.exports = router;
