# Admin Commands

## Start Backend + React Admin

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/start_admin_dev_stack.sh
```

## Stop Only The Processes Started By This Skill

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/stop_admin_dev_stack.sh
```

## Print Token Injection Snippet

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/print_admin_login_inject_snippet.sh
```

## Fetch Real Router Paths From Backend

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/fetch_admin_routes_with_token.sh
```

## Default Admin URLs

- Login: `http://127.0.0.1:5174/login`
- Home shell: `http://127.0.0.1:5174/index`
- Backend captcha probe: `http://127.0.0.1:8080/auth/code`

## Browser Verification Pattern

1. Start the local stack.
2. Use `print_admin_login_inject_snippet.sh` to obtain the exact localStorage injection expression.
3. Use `infoq-browser-automation` or Playwright MCP to open `/login`, inject the token, and navigate the routes returned by `fetch_admin_routes_with_token.sh`.
