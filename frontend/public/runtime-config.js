// This file is served statically and can be edited at deploy time
// without rebuilding the React app. The frontend reads these values
// from window.__RUNTIME_CONFIG__.

window.__RUNTIME_CONFIG__ = Object.assign(
  {
    // Fallbacks used by the app if env is not provided
    REACT_APP_API_BASE_URL: "http://localhost:5001/api",
  },
  window.__RUNTIME_CONFIG__ || {}
);


