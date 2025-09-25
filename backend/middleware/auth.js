const jwt = require("jsonwebtoken");
const { pool } = require("../config/database");

const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
      return res.status(401).json({ error: "Access token required" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("🔍 JWT decoded payload:", decoded);

    // Get user from database with temp_password check
    const result = await pool.query(
      "SELECT id, email, role, temp_password FROM users WHERE id = $1",
      [decoded.userId]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: "Invalid token" });
    }

    const user = result.rows[0];
    console.log("🔍 User from database:", user);

    // Check if user still has temporary password
    if (user.temp_password) {
      return res.status(403).json({
        error: "Password change required",
        requiresPasswordReset: true,
        message:
          "Please change your temporary password before accessing the application",
      });
    }

    req.user = {
      userId: user.id,
      email: user.email,
      role: user.role,
    };
    console.log("🔍 Set req.user:", req.user);
    next();
  } catch (error) {
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({ error: "Token expired" });
    }
    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({ error: "Invalid token" });
    }
    return res.status(500).json({ error: "Authentication failed" });
  }
};

const requireRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: "Authentication required" });
    }

    console.log(
      `🔍 Role check - User ID: ${req.user.userId}, Role: ${
        req.user.role
      }, Required roles: ${roles.join(", ")}`
    );

    if (!roles.includes(req.user.role)) {
      console.log(
        `❌ Access denied - User role '${
          req.user.role
        }' not in required roles: ${roles.join(", ")}`
      );
      return res.status(403).json({ error: "Insufficient permissions" });
    }

    console.log(
      `✅ Access granted - User role '${req.user.role}' has required permissions`
    );
    next();
  };
};

const requireHR = requireRole(["hr"]);
const requireEmployee = requireRole(["employee"]);
const requireManager = requireRole(["manager"]);

module.exports = {
  authenticateToken,
  requireRole,
  requireHR,
  requireEmployee,
  requireManager,
};
