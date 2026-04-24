import { beforeEach, describe, expect, it, vi } from 'vitest';

const { mockLoadSession, mockHasPermission, mockStore } = vi.hoisted(() => {
  const store = {
    token: 'token-1',
    user: null as null | { userId: number },
    loadSession: vi.fn(),
    hasPermission: vi.fn()
  };

  return {
    mockLoadSession: store.loadSession,
    mockHasPermission: store.hasPermission,
    mockStore: store
  };
});

vi.mock('@/store/session', () => ({
  useSessionStore: () => mockStore
}));

import { ensurePermission } from '../../src/composables/use-auth-guard';
import { routes } from '../../src/utils/navigation';

describe('use-auth-guard', () => {
  beforeEach(() => {
    mockStore.token = 'token-1';
    mockStore.user = null;
    mockLoadSession.mockReset();
    mockHasPermission.mockReset();
    mockLoadSession.mockResolvedValue({
      user: { userId: 1, userName: 'admin' },
      roles: [],
      permissions: ['system:notice:query']
    });
  });

  it('should reLaunch to fallback route when the permission is missing', async () => {
    mockHasPermission.mockReturnValue(false);

    const allowed = await ensurePermission('system:notice:query', {
      fallbackRoute: routes.notices,
      failureMessage: '当前账号没有公告查询权限'
    });

    expect(allowed).toBe(false);
    expect(mockLoadSession).toHaveBeenCalledTimes(1);
    expect(mockHasPermission).toHaveBeenCalledWith('system:notice:query');
    expect(uni.showToast).toHaveBeenCalledWith({
      title: '当前账号没有公告查询权限',
      icon: 'none'
    });
    expect(uni.reLaunch).toHaveBeenCalledWith({ url: routes.notices });
  });

  it('should allow access when the permission is present', async () => {
    mockHasPermission.mockReturnValue(true);

    const allowed = await ensurePermission('system:notice:query', {
      fallbackRoute: routes.notices
    });

    expect(allowed).toBe(true);
    expect(mockLoadSession).toHaveBeenCalledTimes(1);
    expect(uni.showToast).not.toHaveBeenCalled();
    expect(uni.reLaunch).not.toHaveBeenCalled();
  });
});
