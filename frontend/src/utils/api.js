// =============================================================================
// API Utility Functions
// =============================================================================
// Centralized API configuration and helper functions
// =============================================================================

import axios from 'axios';

// =============================================================================
// API Configuration
// =============================================================================

// Get API base URL from environment variables
const getApiBaseUrl = () => {
  // Check for explicit API URL first
  if (process.env.REACT_APP_API_URL) {
    return process.env.REACT_APP_API_URL;
  }

  // For production, use production API URL
  if (process.env.NODE_ENV === "production") {
    return process.env.REACT_APP_PROD_API_URL || "http://149.102.158.71:2035/api";
  }

  // For development, use development API URL
  return process.env.REACT_APP_DEV_API_URL || "http://localhost:2035/api";
};

// Get base URL without /api suffix
const getBaseUrl = () => {
  const apiUrl = getApiBaseUrl();
  return apiUrl.replace('/api', '');
};

// =============================================================================
// API Configuration
// =============================================================================

const API_BASE_URL = getApiBaseUrl();
const BASE_URL = getBaseUrl();

// Configure axios defaults
axios.defaults.baseURL = API_BASE_URL;
axios.defaults.timeout = parseInt(process.env.REACT_APP_API_TIMEOUT) || 15000;

// =============================================================================
// API Helper Functions
// =============================================================================

/**
 * Get full API URL for an endpoint
 * @param {string} endpoint - API endpoint (e.g., '/attendance/my-attendance')
 * @returns {string} Full API URL
 */
export const getApiUrl = (endpoint) => {
  const cleanEndpoint = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;
  return `${API_BASE_URL}${cleanEndpoint}`;
};

/**
 * Get full URL for file access (without /api)
 * @param {string} path - File path (e.g., '/uploads/documents/file.pdf')
 * @returns {string} Full file URL
 */
export const getFileUrl = (path) => {
  const cleanPath = path.startsWith('/') ? path : `/${path}`;
  return `${BASE_URL}${cleanPath}`;
};

/**
 * Get document preview URL
 * @param {string} documentId - Document ID
 * @param {string} token - Authentication token
 * @returns {string} Document preview URL
 */
export const getDocumentPreviewUrl = (documentId, token) => {
  const baseUrl = getApiUrl(`/documents/preview/${documentId}`);
  return token ? `${baseUrl}?token=${token}` : baseUrl;
};

/**
 * Get document download URL
 * @param {string} documentId - Document ID
 * @param {string} token - Authentication token
 * @returns {string} Document download URL
 */
export const getDocumentDownloadUrl = (documentId, token) => {
  const baseUrl = getApiUrl(`/documents/download/${documentId}`);
  return token ? `${baseUrl}?token=${token}` : baseUrl;
};

/**
 * Get attachment URL for expenses
 * @param {string} attachmentPath - Attachment path
 * @returns {string} Full attachment URL
 */
export const getAttachmentUrl = (attachmentPath) => {
  if (!attachmentPath) return '';
  return getFileUrl(attachmentPath);
};

// =============================================================================
// API Request Helpers
// =============================================================================

/**
 * Create authenticated axios instance
 * @param {string} token - Authentication token
 * @returns {Object} Configured axios instance
 */
export const createAuthenticatedAxios = (token) => {
  const instance = axios.create({
    baseURL: API_BASE_URL,
    timeout: parseInt(process.env.REACT_APP_API_TIMEOUT) || 15000,
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  });

  return instance;
};

/**
 * Make authenticated API request
 * @param {string} endpoint - API endpoint
 * @param {Object} options - Request options
 * @param {string} token - Authentication token
 * @returns {Promise} API response
 */
export const makeAuthenticatedRequest = async (endpoint, options = {}, token) => {
  const url = getApiUrl(endpoint);
  const config = {
    ...options,
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      ...options.headers,
    },
  };

  return axios(url, config);
};

// =============================================================================
// Common API Endpoints
// =============================================================================

export const API_ENDPOINTS = {
  // Authentication
  LOGIN: '/auth/login',
  LOGOUT: '/auth/logout',
  REFRESH: '/auth/refresh',
  
  // Employee Management
  EMPLOYEES: '/hr/employees',
  EMPLOYEE_FORMS: '/hr/employee-forms',
  MASTER_MANAGERS: '/hr/master-managers',
  
  // Attendance
  MY_ATTENDANCE: '/attendance/my-attendance',
  ATTENDANCE_CALENDAR: '/attendance/calendar',
  ATTENDANCE_MARK: '/attendance/mark',
  ATTENDANCE_SETTINGS: '/attendance/settings',
  
  // Leave Management
  LEAVE_REQUESTS: '/leave/requests',
  MANAGER_LEAVE_REQUESTS: '/manager/leave-requests',
  LEAVE_BALANCE: '/leave/balance',
  
  // Document Management
  DOCUMENTS: '/documents',
  DOCUMENT_VALIDATION: '/documents/validation',
  DOCUMENT_UPLOAD: '/documents/upload',
  DOCUMENT_DOWNLOAD: '/documents/download',
  DOCUMENT_PREVIEW: '/documents/preview',
  DOCUMENT_COLLECTION: '/hr/document-collection',
  
  // Expense Management
  EXPENSES: '/expenses',
  EXPENSE_ANALYTICS: '/expenses/analytics',
  
  // Manager Functions
  MANAGER_EMPLOYEES: '/manager/employees',
  MANAGER_ATTENDANCE: '/manager/employee',
  
  // Health Check
  HEALTH: '/health',
  HEALTH_AUTH: '/health/auth',
};

// =============================================================================
// Configuration Constants
// =============================================================================

export const CONFIG = {
  API_BASE_URL,
  BASE_URL,
  TIMEOUT: parseInt(process.env.REACT_APP_API_TIMEOUT) || 15000,
  RETRY_ATTEMPTS: parseInt(process.env.REACT_APP_RETRY_ATTEMPTS) || 3,
  CACHE_DURATION: parseInt(process.env.REACT_APP_CACHE_DURATION) || 300000,
};

// =============================================================================
// Debug Information
// =============================================================================

if (process.env.REACT_APP_DEBUG === 'true' || process.env.NODE_ENV === 'development') {
  console.log('🔧 API Configuration:');
  console.log('🔧 API_BASE_URL:', API_BASE_URL);
  console.log('🔧 BASE_URL:', BASE_URL);
  console.log('🔧 TIMEOUT:', CONFIG.TIMEOUT);
  console.log('🔧 NODE_ENV:', process.env.NODE_ENV);
}

export default {
  getApiUrl,
  getFileUrl,
  getDocumentPreviewUrl,
  getDocumentDownloadUrl,
  getAttachmentUrl,
  createAuthenticatedAxios,
  makeAuthenticatedRequest,
  API_ENDPOINTS,
  CONFIG,
};
