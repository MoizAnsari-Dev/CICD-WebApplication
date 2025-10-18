// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    host: '0.0.0.0',
    allowedHosts: [
      'localhost',
      '127.0.0.1',
      'aff5fafeb45554865b08a79ed48005da-318726999.us-east-1.elb.amazonaws.com' // ✅ no http://
    ]
  }
})
