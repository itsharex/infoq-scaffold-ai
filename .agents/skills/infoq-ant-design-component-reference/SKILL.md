---
name: infoq-ant-design-component-reference
description: Reference Ant Design official docs to select components and implement React UIs with correct API usage and version checks. Use when requests mention Ant Design or antd components, building or refactoring React pages with forms, tables, dialogs, or verifying whether a component or feature is supported by the current antd version.
---

# InfoQ Ant Design Component Reference

Use Ant Design official documentation as the source of truth for component selection and API usage.
Start with `references/component-overview-zh-cn.md`, then confirm component-level APIs before coding.

## Workflow

1. Classify the UI requirement.
2. Pick candidate components from the official overview index.
3. Verify component APIs before coding.
4. Check local antd version compatibility with `package.json` or lockfiles.
5. Implement React code with minimal custom CSS overrides.
6. Validate loading, empty, error, disabled, and destructive-action states.

## Resources

- `references/component-overview-zh-cn.md`
- `references/component-selection-playbook.md`
