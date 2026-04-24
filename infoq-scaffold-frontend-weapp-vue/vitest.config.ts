import { resolve } from 'node:path';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  resolve: {
    alias: {
      '@': resolve(__dirname, './src')
    }
  },
  test: {
    name: 'infoq-scaffold-frontend-weapp-vue-unit',
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/setup.ts'],
    include: ['tests/**/*.test.ts'],
    exclude: ['node_modules', 'dist', 'coverage'],
    mockReset: true,
    clearMocks: true,
    restoreMocks: true,
    css: false,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      reportsDirectory: './coverage',
      lines: 100,
      branches: 100,
      functions: 100,
      statements: 100,
      include: [
        'src/api/**/*.ts',
        'src/utils/{auth,crypto,env,errors,helpers,permissions,rsa,theme}.ts',
        'src/store/session.ts'
      ],
      exclude: ['src/api/types.ts']
    }
  }
});
