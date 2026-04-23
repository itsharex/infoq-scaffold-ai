# Setup Baseline (infoq-scaffold-frontend-react)

## Required Files

- `vite.config.ts`
- `tests/setup.ts`
- `tests/helpers/renderWithRouter.tsx`
- `tests/**/*.test.ts`
- `tests/**/*.test.tsx`

## vite.config.ts Essentials

- `test.environment: 'jsdom'`
- `test.setupFiles: ['./tests/setup.ts']`
- `test.globals: true`
- `test.include: ['tests/**/*.test.ts', 'tests/**/*.test.tsx']`
- `test.css: false`
- `test.mockReset`, `test.clearMocks`, and `test.restoreMocks` enabled
- Alias: `@ -> ./src`

## setup.ts Essentials

- Load `@testing-library/jest-dom/vitest`
- Define memory `localStorage` and `sessionStorage` at top-level before app modules read them
- Polyfill `window.matchMedia`
- Provide `ResizeObserver`
- Keep `window.getComputedStyle` callable in jsdom
- Load `@/lang` once so i18n-dependent components render deterministically

## package.json Scripts

```json
{
  "test": "vitest --run",
  "test:watch": "vitest",
  "test:coverage": "vitest --run --coverage",
  "lint:fix": "eslint --fix .",
  "build:prod": "vite build --mode production"
}
```
