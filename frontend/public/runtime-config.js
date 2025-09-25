// This file is served statically and can be edited at deploy time
// without rebuilding the React app. The frontend reads these values
// from window.__RUNTIME_CONFIG__.

window.__RUNTIME_CONFIG__ = Object.assign(
  {
    // Fallbacks used by the app if env is not provided
    // Dev (CRA on 3001) → talk to backend on 5001; otherwise same-origin /api
    REACT_APP_API_BASE_URL:
      typeof window !== 'undefined' && window.location
        ? (window.location.port === '3001'
            ? 'http://localhost:5001/api'
            : window.location.origin.replace(/\/$/, '') + '/api')
        : '/api',
  },
  window.__RUNTIME_CONFIG__ || {}
);


