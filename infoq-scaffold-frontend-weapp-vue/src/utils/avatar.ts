import { mobileEnv } from '@/utils/env';

const isAbsoluteUrl = (value: string) => /^https?:\/\//i.test(value);

const isDirectAvatarSource = (value: string) =>
  isAbsoluteUrl(value)
  || value.startsWith('//')
  || value.startsWith('data:')
  || value.startsWith('blob:')
  || value.startsWith('wxfile://');

const trimTrailingSlash = (value: string) => value.replace(/\/+$/, '');

const getRuntimeBaseApi = () => (mobileEnv.taroEnv === 'h5' ? mobileEnv.baseApi : mobileEnv.miniBaseApi);

const resolveAvatarOrigin = () => {
  if (mobileEnv.apiOrigin) {
    return trimTrailingSlash(mobileEnv.apiOrigin);
  }
  const runtimeBaseApi = getRuntimeBaseApi();
  if (!isAbsoluteUrl(runtimeBaseApi)) {
    return '';
  }
  try {
    return new URL(runtimeBaseApi).origin;
  } catch {
    return '';
  }
};

export const resolveAvatarUrl = (avatar?: string) => {
  const source = avatar?.trim() || '';
  if (!source) {
    return '';
  }
  if (isDirectAvatarSource(source)) {
    return source.startsWith('//') ? `https:${source}` : source;
  }
  const origin = resolveAvatarOrigin();
  if (!origin) {
    return source;
  }
  const normalizedPath = source.startsWith('/') ? source : `/${source}`;
  return `${origin}${normalizedPath}`;
};
