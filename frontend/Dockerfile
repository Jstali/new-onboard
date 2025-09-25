# =============================================================================
# NXZEN EMPLOYEE MANAGEMENT SYSTEM - FRONTEND DOCKERFILE
# =============================================================================
# Multi-stage build for production optimization with environment-based configuration
# =============================================================================

# Stage 1: Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps --silent

# Copy source code
COPY . .

# Create environment file for build with proper API URL
ARG REACT_APP_API_URL=http://149.102.158.71:5001/api
RUN echo "REACT_APP_API_URL=${REACT_APP_API_URL}" > .env.production

# Build the application
RUN npm run build

# Stage 2: Production stage with Nginx
FROM nginx:alpine AS production

# Install curl for health checks
RUN apk add --no-cache curl

# Create nginx user and set permissions
RUN adduser -S nxzen -u 1001 -G nginx

# Copy built application from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Create nginx directories
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run && \
    chown -R nxzen:nginx /var/cache/nginx /var/log/nginx /var/run

# Set proper permissions
RUN chown -R nxzen:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Switch to non-root user
USER nxzen

# Expose port (will be overridden by environment variable)
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]