import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    // 개발 서버에서 /api 요청을 스프링 백엔드로 넘긴다.
    proxy: {
      '/api': 'http://localhost:8080',
    },
  },
})
