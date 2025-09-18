const helmet = require("helmet");

// Security middleware configuration
const securityConfig = (app) => {
  // Configure helmet with custom CSP for iframe embedding
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: [
            "'self'",
            "'unsafe-inline'",
            "https://fonts.googleapis.com",
          ],
          fontSrc: ["'self'", "https://fonts.gstatic.com"],
          imgSrc: [
            "'self'",
            "data:",
            "blob:",
            "http://localhost:5001",
            "https:",
          ],
          scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
          connectSrc: ["'self'", "http://localhost:5001", "https:"],
          frameSrc: [
            "'self'",
            "http://localhost:3000",
            "http://localhost:5001",
          ],
          frameAncestors:
            process.env.NODE_ENV === "production"
              ? ["'self'", process.env.FRONTEND_URL || "https://yourdomain.com"]
              : ["'self'", "http://localhost:3000", "http://localhost:5001"],
          objectSrc: ["'none'"],
          upgradeInsecureRequests:
            process.env.NODE_ENV === "production" ? [] : null,
        },
      },
      crossOriginEmbedderPolicy: false, // Allow iframe embedding
      crossOriginOpenerPolicy: false, // Allow iframe embedding
      crossOriginResourcePolicy: { policy: "cross-origin" }, // Allow cross-origin resources
    })
  );

  // Additional security headers for iframe embedding
  app.use((req, res, next) => {
    // Allow iframe embedding from frontend
    const allowedOrigins =
      process.env.NODE_ENV === "production"
        ? [process.env.FRONTEND_URL || "https://yourdomain.com"]
        : ["http://localhost:3000", "http://localhost:5001"];

    const origin = req.get("origin") || req.get("referer");
    const isAllowedOrigin = allowedOrigins.some(
      (allowed) => origin && origin.startsWith(allowed)
    );

    if (isAllowedOrigin || process.env.NODE_ENV === "development") {
      res.setHeader("X-Frame-Options", "ALLOWALL");
      res.setHeader(
        "Content-Security-Policy",
        `frame-ancestors 'self' ${allowedOrigins.join(" ")}`
      );
    }

    // Additional headers for document preview
    if (req.path.includes("/preview/") || req.path.includes("/uploads/")) {
      res.setHeader("X-Content-Type-Options", "nosniff");
      res.setHeader("Cache-Control", "public, max-age=3600");
    }

    next();
  });
};

module.exports = { securityConfig };
