---
name: infoq-react-browser-automation
description: Execute repo-specific browser automation for the React frontend in this project using Playwright MCP, local login token injection, route discovery, screenshot capture, and console diagnostics against the local React dev stack. Use when tasks target infoq-scaffold-frontend-react runtime verification such as React login checks, React route checks, screenshots, or console diagnostics. If the task targets Vue instead, use infoq-vue-browser-automation. Prefer agent-browser first for generic browser work.
compatibility: Requires the local React dev stack, Playwright MCP browser automation, and usually infoq-login-success-check plus infoq-react-run-dev-stack for token/bootstrap preparation.
---

# Infoq React Browser Automation

Use this skill only for repository-local runtime verification of `infoq-scaffold-frontend-react`.
Prefer `agent-browser` as the first-choice browser skill.
Use this skill only when `agent-browser` alone is not enough because the task needs repo-specific token bootstrap, route enumeration, or React runtime verification details for this project.

## Workflow

1. Ensure services are running with `infoq-react-run-dev-stack`.
2. Get login token without captcha with `infoq-login-success-check`.
3. Use browser automation to navigate React routes, collect screenshots, and inspect console errors.

## Token Preparation

```bash
bash .agents/skills/infoq-react-browser-automation/scripts/print_login_inject_snippet.sh
```

## Route Discovery

```bash
bash .agents/skills/infoq-react-browser-automation/scripts/fetch_routes_with_token.sh
```

## Browser Eval Patterns

- Open React frontend:

```text
action=navigate, url=http://127.0.0.1:5174/login
```

- Inject token:

```text
action=evaluate, script=(localStorage.setItem('Admin-Token','...'),location.href='/index','ok')
```

- Navigate target React route:

```text
action=navigate, url=http://127.0.0.1:5174/system/role
```

## Notes

- Shared helper scripts live under `.agents/skills/infoq-browser-automation/`.
- Route paths are case-sensitive; prefer route helper output instead of guessing.
