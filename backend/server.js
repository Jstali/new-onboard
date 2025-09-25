const express = require("express");
const cors = require("cors");
const rateLimit = require("express-rate-limit");
const { securityConfig } = require("./middleware/security");
const fs = require("fs");
const dotenv = require("dotenv");
if (fs.existsSync(".env")) {
  dotenv.config({ path: "./.env" });
} else {
  dotenv.config({ path: "./config.env" });
}

const authRoutes = require("./routes/auth");
const hrRoutes = require("./routes/hr");
const hrConfigRoutes = require("./routes/hrConfig");
const employeeRoutes = require("./routes/employee");
const attendanceRoutes = require("./routes/attendance");
const leaveRoutes = require("./routes/leave");
const documentsRoutes = require("./routes/documents");
const expensesRoutes = require("./routes/expenses");
const managerRoutes = require("./routes/manager");
const adpPayrollRoutes = require("./routes/adpPayroll");
const employeesCombinedRoutes = require("./routes/employeesCombined");
const employeePayrollRoutes = require("./routes/employeePayroll");
const { connectDB } = require("./config/database");

const app = express();
const PORT = process.env.PORT || 5001;

// Security middleware with iframe support
securityConfig(app);

// Rate limiting - Much more lenient for development
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: process.env.NODE_ENV === "production" ? 100 : 10000, // Much higher limit for development
  message: "Too many requests from this IP, please try again later.",
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Don't count successful requests
  skipFailedRequests: false, // Count failed requests
});
app.use(limiter);

// CORS configuration via env (no localhost hardcoding)
// Set CORS_ORIGIN as a comma-separated list, or leave empty to allow same-origin requests
const allowedOriginsEnv = (process.env.CORS_ORIGIN || process.env.FRONTEND_URL || "")
  .split(",")
  .map((o) => o.trim())
  .filter(Boolean);

const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (mobile apps, curl) and same-origin
    if (!origin) return callback(null, true);
    if (allowedOriginsEnv.length === 0) return callback(null, true);
    if (allowedOriginsEnv.some((o) => origin.startsWith(o))) return callback(null, true);
    return callback(new Error("Not allowed by CORS"));
  },
  credentials: false,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH", "HEAD"],
  allowedHeaders: [
    "Content-Type",
    "Authorization",
    "X-Requested-With",
    "Accept",
    "Origin",
    "Access-Control-Request-Method",
    "Access-Control-Request-Headers",
  ],
  exposedHeaders: ["Authorization"],
  optionsSuccessStatus: 200,
  preflightContinue: false,
};

app.use(cors(corsOptions));

// Handle preflight requests
app.options("*", cors());

// Additional CORS headers for all responses
app.use((req, res, next) => {
  const allowedOrigins = allowedOriginsEnv;

  const origin = req.get("origin") || req.get("referer");
  const isAllowedOrigin =
    allowedOrigins.length === 0 ||
    allowedOrigins.some((allowed) => origin && origin.startsWith(allowed));

  if (isAllowedOrigin || process.env.NODE_ENV === "development") {
    res.header("Access-Control-Allow-Origin", origin || "*");
  }

  res.header(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, OPTIONS, PATCH, HEAD"
  );
  res.header(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization, X-Requested-With, Accept, Origin"
  );
  res.header("Access-Control-Allow-Credentials", "false");
  res.header("Access-Control-Max-Age", "86400"); // 24 hours
  next();
});

// Body parsing middleware
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`🔍 ${req.method} ${req.path} - ${new Date().toISOString()}`);
  if (req.path.includes("document-collection")) {
    console.log(`🔍 Document collection request: ${req.method} ${req.path}`);
    console.log(`🔍 Request body:`, req.body);
    console.log(`🔍 Request params:`, req.params);
  }
  next();
});

// Static files with proper MIME types
app.use(
  "/uploads",
  express.static("uploads", {
    setHeaders: (res, path) => {
      // Set proper MIME types for PDF files
      if (path.endsWith(".pdf")) {
        res.setHeader("Content-Type", "application/pdf");
      }
      // Set proper MIME types for image files
      else if (path.match(/\.(jpg|jpeg|png|gif|bmp|webp)$/i)) {
        const ext = path.split(".").pop().toLowerCase();
        const mimeTypes = {
          jpg: "image/jpeg",
          jpeg: "image/jpeg",
          png: "image/png",
          gif: "image/gif",
          bmp: "image/bmp",
          webp: "image/webp",
        };
        res.setHeader(
          "Content-Type",
          mimeTypes[ext] || "application/octet-stream"
        );
      }
      // Set proper MIME types for other common file types
      else if (path.endsWith(".docx")) {
        res.setHeader(
          "Content-Type",
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        );
      } else if (path.endsWith(".doc")) {
        res.setHeader("Content-Type", "application/msword");
      } else if (path.endsWith(".xlsx")) {
        res.setHeader(
          "Content-Type",
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );
      } else if (path.endsWith(".txt")) {
        res.setHeader("Content-Type", "text/plain");
      }
    },
  })
);

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/hr", hrRoutes);
app.use("/api/hr-config", hrConfigRoutes);
app.use("/api/employee", employeeRoutes);
app.use("/api/attendance", attendanceRoutes);
app.use("/api/manager", managerRoutes);
app.use("/api/leave", leaveRoutes);
app.use("/api/documents", documentsRoutes);
app.use("/api/expenses", expensesRoutes);
app.use("/api/adp-payroll", adpPayrollRoutes);
app.use("/api/employees-combined", employeesCombinedRoutes);
app.use("/api/employee-payroll", employeePayrollRoutes);

// Health check
app.get("/api/health", (req, res) => {
  res.json({ status: "OK", message: "Server is running" });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error("❌ Global error handler caught:", err.message);
  console.error("❌ Error stack:", err.stack);
  console.error("❌ Request path:", req.path);
  console.error("❌ Request method:", req.method);
  console.error("❌ Request headers:", req.headers);
  res.status(500).json({
    error: "Something went wrong!",
    message:
      process.env.NODE_ENV === "development"
        ? err.message
        : "Internal server error",
  });
});

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({ error: "Route not found" });
});

// Start server
const startServer = async () => {
  try {
    // Connect to database
    await connectDB();
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📧 Email configured for: ${process.env.EMAIL_USER}`);
    });
  } catch (error) {
    console.error("❌ Failed to start server:", error);
    process.exit(1);
  }
};

startServer();
