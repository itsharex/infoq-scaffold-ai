---
name: infoq-browser-automation
description: Browser automation skill for this repository. Use whenever the user needs website interaction or browser-state verification, including opening pages, filling forms, clicking buttons, logging in, taking screenshots, scraping rendered content, checking console errors, or testing web-app flows, even if they do not explicitly ask for “browser automation”. This skill uses the `agent-browser` CLI as the execution backend.
allowed-tools: Bash(npx agent-browser:*), Bash(agent-browser:*)
---

# InfoQ Browser Automation

Use `infoq-browser-automation` as the default repository skill for real browser interaction.
The execution backend is still the `agent-browser` CLI, but the repository skill name follows the local `infoq-` naming convention.
It requires the `agent-browser` CLI and a local Playwright-compatible browser runtime. If a custom browser binary or persisted session is needed, use the documented flags instead of ad-hoc shell workarounds.

## Fast Path

Most tasks should follow this sequence:

1. Open the target page.
2. Wait for load or a stable element.
3. Snapshot interactive elements.
4. Interact using `@e` refs or semantic locators.
5. Re-snapshot after navigation or DOM changes.
6. Capture output: text, screenshot, PDF, console, or errors.

Baseline pattern:

```bash
agent-browser open https://example.com
agent-browser wait --load networkidle
agent-browser snapshot -i
```

Then act on the returned refs:

```bash
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --load networkidle
agent-browser snapshot -i
```

## Core Rules

- Re-snapshot after any navigation, modal open, DOM refresh, or major client-side render.
- Prefer `snapshot -i` for normal workflows. Use `snapshot -i -C` when clickable containers are missing from the ref list.
- Prefer semantic locators such as `find role`, `find text`, `find label`, or `find placeholder` when refs are unstable.
- Prefer `wait --load networkidle`, `wait --url`, or `wait <selector>` over blind sleeps.
- Prefer saved auth state or `auth` commands over exposing raw passwords in shell history.
- When changing runtime options such as `--executable-path`, `--session-name`, or headed/headless mode, close the browser first and restart with the new flags.

## Reference Loading Guide

Load only the file needed for the current task.

- Full command surface and flags: `references/commands.md`
- Ref lifecycle and locator stability: `references/snapshot-refs.md`
- Login flows and credential handling: `references/authentication.md`
- Sessions, cookies, storage, cleanup: `references/session-management.md`
- Trace, profiler, console, errors: `references/profiling.md`
- Proxy and custom browser setup: `references/proxy-support.md`
- Video recording workflows: `references/video-recording.md`

## Assets

- `assets/templates/authenticated-session.sh`
- `assets/templates/capture-workflow.sh`
- `assets/templates/form-automation.sh`

## Guardrails

- Treat `eval` as a last-mile tool for inspection or state injection, not the default interaction method.
- If shell escaping becomes fragile, switch to `eval --stdin` or the dedicated template or reference flow instead of forcing nested quoting.
- Use `--headed`, annotated screenshots, traces, or profiler output when a task is visually or timing sensitive.
