export const DEFAULT_ICON_COLOR = 'currentColor';

export const normalizeIconColor = (color?: string) => {
  const trimmed = color?.trim();
  return trimmed || DEFAULT_ICON_COLOR;
};

export const resolveSvgColor = (color?: string) => {
  const normalized = normalizeIconColor(color);
  return normalized === 'inherit' ? DEFAULT_ICON_COLOR : normalized;
};
