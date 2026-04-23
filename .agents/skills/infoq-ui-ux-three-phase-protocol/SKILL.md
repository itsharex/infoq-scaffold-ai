---
name: infoq-ui-ux-three-phase-protocol
description: "Enforce a four-phase UI workflow for this repository: Phase 1 ASCII layout proposal, Phase 2 standalone static demo, Phase 3 formal implementation in the target workspace stack, and Phase 4 runtime verification. Use this skill whenever users request major UI or UX redesign, layout-heavy features, approval-gate phrases like `LAYOUT APPROVED` or `DEMO APPROVED`, or ask to lock visual consistency before wiring business logic."
---

# InfoQ UI UX Three Phase Protocol

Use this skill for major UI work that needs explicit approval gates and stable visual baselines.
Do not assume Tailwind, Capacitor, Hono, or any other stack that this repository does not actually use in the target workspace.

## Required Workflow

### Phase 1: Layout Specification

Before writing framework code or business logic:

1. Provide a layout specification with structure, target component strategy, and responsive strategy.
2. Provide desktop and mobile ASCII wireframes.
3. Stop and wait for the exact approval phrase `LAYOUT APPROVED`.

### Phase 2: Static Demo

After `LAYOUT APPROVED`:

1. Create a standalone static demo under `doc/ui-demos/<change-id>.html`.
2. Use plain HTML and lightweight CSS or CDN assets only when needed.
3. Match the visual language of the target workspace instead of imposing a foreign design system.
4. Stop and wait for the exact approval phrase `DEMO APPROVED`.

### Phase 3: Formal Implementation

After `DEMO APPROVED`:

1. Implement in the actual target workspace stack.
2. For React admin, respect React + Ant Design.
3. For Vue admin, respect Vue + Element Plus.
4. For weapp React, respect Taro React page and component constraints.
5. For weapp Vue, respect uni-app Vue page and component constraints.
6. Stabilize the UI shell before wiring complex business logic.

### Phase 4: Runtime Verification

1. Verify the implemented UI against the approved layout.
2. Use Playwright or `infoq-browser-automation` for admin browser flows.
3. Use the corresponding React or Vue runtime verification skill for weapp open-flow and smoke checks.
4. Treat visible layout drift, route drift, and console errors as verification failures.

## Guardrails

- Do not skip approval gates.
- Do not turn a major UI request into a direct implementation jump.
- Do not let the static demo become a permanent shadow implementation.
- Keep the MVP narrow; push scope expansion back to the user when needed.
