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
          imgSrc: ["'self'", "data:", "blob:", "https:"],
          scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
          connectSrc: ["'self'", "https:"],
          frameSrc: ["'self'"],
          frameAncestors: ["'self'"],
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

  // Additional security headers for iframe embedding (env-driven)
  app.use((req, res, next) => {
    const allowedOrigins = (process.env.CORS_ORIGIN || process.env.FRONTEND_URL || "")
      .split(",")
      .map((o) => o.trim())
      .filter(Boolean);

    const origin = req.get("origin") || req.get("referer");
    const isAllowedOrigin = allowedOrigins.some(
      (allowed) => origin && origin.startsWith(allowed)
    );

    if (isAllowedOrigin || allowedOrigins.length === 0) {
      res.setHeader("X-Frame-Options", "ALLOWALL");
      if (allowedOrigins.length > 0) {
        res.setHeader(
          "Content-Security-Policy",
          `frame-ancestors 'self' ${allowedOrigins.join(" ")}`
        );
      }
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
