import { describe, expect, it } from 'vitest';
import { normalizeIconColor, resolveSvgColor } from '../../src/utils/icon';

describe('icon utils', () => {
  it('should preserve currentColor by default for css-driven icons', () => {
    expect(normalizeIconColor()).toBe('currentColor');
    expect(resolveSvgColor()).toBe('currentColor');
  });

  it('should map inherit to currentColor inside embedded svg data uris', () => {
    expect(normalizeIconColor('inherit')).toBe('inherit');
    expect(resolveSvgColor('inherit')).toBe('currentColor');
  });

  it('should keep explicit colors unchanged', () => {
    expect(normalizeIconColor('#1677ff')).toBe('#1677ff');
    expect(resolveSvgColor('#1677ff')).toBe('#1677ff');
  });
});
