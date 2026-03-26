# Mock Patterns

## 1) Login API module mock

```ts
vi.mock('@/api/login', () => ({
  getCodeImg: vi.fn().mockResolvedValue({
    data: {
      captchaEnabled: true,
      uuid: 'uuid-1',
      img: 'abc'
    }
  })
}));
```

## 2) Zustand store baseline

```ts
beforeEach(() => {
  useUserStore.setState({
    token: '',
    roles: [],
    permissions: []
  });
  usePermissionStore.setState({
    routes: [],
    sidebarRouters: []
  });
});
```

## 3) Router wrapper helper

```ts
import { renderWithRouter } from '../helpers/renderWithRouter';

renderWithRouter(<CachePage />, '/monitor/cache');
```

## 4) Auth guard verification with `MemoryRouter`

```ts
render(
  <MemoryRouter initialEntries={['/system/user']}>
    <Routes>
      <Route path="/login" element={<div>Login Page</div>} />
      <Route
        path="*"
        element={
          <AuthGuard>
            <div>Protected</div>
          </AuthGuard>
        }
      />
    </Routes>
  </MemoryRouter>
);
```

## 5) Request adapter override without network

```ts
(service.defaults as { adapter: unknown }).adapter = async (config: InternalAxiosRequestConfig) =>
  createResponse(config, {
    code: 200,
    data: { ok: true }
  });
```

## 6) Fullscreen API exact stub

```ts
Object.defineProperty(document, 'fullscreenElement', {
  configurable: true,
  value: null
});
Object.defineProperty(document.documentElement, 'requestFullscreen', {
  configurable: true,
  value: vi.fn()
});
Object.defineProperty(document, 'exitFullscreen', {
  configurable: true,
  value: vi.fn()
});
```

## 7) ResizeObserver override for chart pages

```ts
class ResizeObserverMock {
  observe() {}
  unobserve() {}
  disconnect() {}
}

globalThis.ResizeObserver = ResizeObserverMock as unknown as typeof ResizeObserver;
```

## 8) Page-level component stub pattern

```ts
vi.mock('@/components/Pagination', () => ({
  default: () => <div data-testid="pagination-stub" />
}));

vi.mock('@/components/RightToolbar', () => ({
  default: () => <button type="button">toolbar-stub</button>
}));
```
