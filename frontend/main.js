import { createApp } from "vue";
import App from "./App.vue";
import axios from "axios";

// Base URL for API (runtime config, fallback to /api)
axios.defaults.baseURL = window._env_?.BACKEND_URL ?? "/api";

// Set up Axios interceptor globally
axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("authToken");
    if (token) {
      config.headers = config.headers || {};
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

createApp(App).mount("#app");
