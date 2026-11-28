// 임시: 질문 내역 검증용. 검증 뒤 삭제한다.
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
export default defineConfig({ plugins: [react(), tailwindcss()], server: { port: 5199, strictPort: true, proxy: { '/api': 'http://localhost:8081' } } })
