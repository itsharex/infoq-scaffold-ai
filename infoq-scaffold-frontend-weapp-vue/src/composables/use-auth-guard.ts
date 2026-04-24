import { useSessionStore } from '@/store/session';
import { relaunch, routes } from '@/utils/navigation';

export const ensureAuthenticated = () => {
  const sessionStore = useSessionStore();
  if (sessionStore.token || sessionStore.user) {
    return true;
  }
  const token = uni.getStorageSync('Admin-Token');
  if (token) {
    return true;
  }
  uni.reLaunch({ url: routes.login });
  return false;
};

type PermissionGuardOptions = {
  fallbackRoute?: string;
  failureMessage?: string;
};

export const ensurePermission = async (
  permission: string,
  options: PermissionGuardOptions = {}
) => {
  if (!ensureAuthenticated()) {
    return false;
  }

  const sessionStore = useSessionStore();
  await sessionStore.loadSession();
  if (sessionStore.hasPermission(permission)) {
    return true;
  }

  await uni.showToast({
    title: options.failureMessage || '当前账号没有访问权限',
    icon: 'none'
  });
  relaunch(options.fallbackRoute || routes.admin);
  return false;
};
