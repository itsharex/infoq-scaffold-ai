import { beforeEach, describe, expect, it, vi } from 'vitest';

const mobileEnvMock = vi.hoisted(() => ({
  taroEnv: 'weapp',
  baseApi: '/dev-api',
  miniBaseApi: '/mini-api',
  apiOrigin: 'https://api.example.com'
}));

vi.mock('@/utils/env', () => ({
  mobileEnv: mobileEnvMock
}));

import { resolveAvatarUrl } from '../../src/utils/avatar';

describe('avatar', () => {
  beforeEach(() => {
    mobileEnvMock.taroEnv = 'weapp';
    mobileEnvMock.baseApi = '/dev-api';
    mobileEnvMock.miniBaseApi = '/mini-api';
    mobileEnvMock.apiOrigin = 'https://api.example.com';
  });

  it('should return empty string for empty avatar value', () => {
    expect(resolveAvatarUrl('')).toBe('');
    expect(resolveAvatarUrl(undefined)).toBe('');
  });

  it('should keep direct avatar sources unchanged', () => {
    expect(resolveAvatarUrl('https://cdn.example.com/a.png')).toBe('https://cdn.example.com/a.png');
    expect(resolveAvatarUrl('data:image/png;base64,abc')).toBe('data:image/png;base64,abc');
    expect(resolveAvatarUrl('wxfile://tmp/avatar.png')).toBe('wxfile://tmp/avatar.png');
    expect(resolveAvatarUrl('//cdn.example.com/a.png')).toBe('https://cdn.example.com/a.png');
  });

  it('should resolve relative avatar path with api origin', () => {
    expect(resolveAvatarUrl('/profile/avatar/admin.png')).toBe('https://api.example.com/profile/avatar/admin.png');
    expect(resolveAvatarUrl('profile/avatar/admin.png')).toBe('https://api.example.com/profile/avatar/admin.png');
  });

  it('should fallback to runtime base api origin when api origin is missing', () => {
    mobileEnvMock.apiOrigin = '';
    mobileEnvMock.miniBaseApi = 'https://mini.example.com/mini-api';

    expect(resolveAvatarUrl('/profile/avatar/admin.png')).toBe('https://mini.example.com/profile/avatar/admin.png');
  });

  it('should return source value when no absolute origin can be resolved', () => {
    mobileEnvMock.apiOrigin = '';
    mobileEnvMock.miniBaseApi = '/mini-api';

    expect(resolveAvatarUrl('/profile/avatar/admin.png')).toBe('/profile/avatar/admin.png');
  });
});
