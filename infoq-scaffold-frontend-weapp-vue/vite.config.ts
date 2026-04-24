import { fileURLToPath, URL } from 'node:url';
import { defineConfig, loadEnv } from 'vite';
import Uni from '@uni-helper/plugin-uni';

const isTruthy = (value: string) => ['true', '1', 'yes', 'on'].includes(value.trim().toLowerCase());

const hasValue = (value: string) => value.trim().length > 0;

const isAbsoluteUrl = (value: string) => /^https?:\/\//i.test(value.trim());

const validateBuildEnv = (compileEnv: Record<string, string>) => {
  const missing: string[] = [];
  const miniBaseApi = compileEnv.TARO_APP_MINI_BASE_API || '';
  const apiOrigin = compileEnv.TARO_APP_API_ORIGIN || '';

  if (!isAbsoluteUrl(miniBaseApi) && !hasValue(apiOrigin)) {
    missing.push('TARO_APP_API_ORIGIN（当 TARO_APP_MINI_BASE_API 不是绝对 URL 时必须配置）');
  }

  if (!hasValue(compileEnv.TARO_APP_CLIENT_ID || '')) {
    missing.push('TARO_APP_CLIENT_ID');
  }

  if (isTruthy(compileEnv.TARO_APP_ENCRYPT || '')) {
    if (!hasValue(compileEnv.TARO_APP_RSA_PUBLIC_KEY || '')) {
      missing.push('TARO_APP_RSA_PUBLIC_KEY（开启 TARO_APP_ENCRYPT 时必填）');
    }
    if (!hasValue(compileEnv.TARO_APP_RSA_PRIVATE_KEY || '')) {
      missing.push('TARO_APP_RSA_PRIVATE_KEY（开启 TARO_APP_ENCRYPT 时必填）');
    }
  }

  if (missing.length > 0) {
    throw new Error(
      `[infoq-weapp-vue] 构建环境变量校验失败：\n- ${missing.join('\n- ')}`
    );
  }
};

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  const compileTimeMobileEnv = {
    TARO_APP_TITLE: env.TARO_APP_TITLE ?? process.env.TARO_APP_TITLE ?? '',
    TARO_APP_COPYRIGHT: env.TARO_APP_COPYRIGHT ?? process.env.TARO_APP_COPYRIGHT ?? '',
    TARO_APP_BASE_API: env.TARO_APP_BASE_API ?? process.env.TARO_APP_BASE_API ?? '',
    TARO_APP_MINI_BASE_API: env.TARO_APP_MINI_BASE_API ?? process.env.TARO_APP_MINI_BASE_API ?? '',
    TARO_APP_API_ORIGIN: env.TARO_APP_API_ORIGIN ?? process.env.TARO_APP_API_ORIGIN ?? '',
    TARO_APP_ENCRYPT: env.TARO_APP_ENCRYPT ?? process.env.TARO_APP_ENCRYPT ?? '',
    TARO_APP_RSA_PUBLIC_KEY: env.TARO_APP_RSA_PUBLIC_KEY ?? process.env.TARO_APP_RSA_PUBLIC_KEY ?? '',
    TARO_APP_RSA_PRIVATE_KEY: env.TARO_APP_RSA_PRIVATE_KEY ?? process.env.TARO_APP_RSA_PRIVATE_KEY ?? '',
    TARO_APP_CLIENT_ID: env.TARO_APP_CLIENT_ID ?? process.env.TARO_APP_CLIENT_ID ?? '',
    TARO_ENV: env.TARO_ENV ?? process.env.TARO_ENV ?? ''
  };
  validateBuildEnv(compileTimeMobileEnv);

  return {
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      }
    },
    plugins: [Uni()],
    define: {
      __INFOQ_COMPILE_ENV__: JSON.stringify(compileTimeMobileEnv)
    }
  };
});
