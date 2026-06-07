---
description: Update the compact repo-local handoff state so another coding agent can continue.
---

# /handoff

Update the repository handoff state now so another coding agent can continue without shared chat context.

Required behavior:

1. Inspect current git status and recent work from available context.
2. Update `.agents/state.md`.
3. Promote durable facts into `Current Status`, `Key Decisions`, or `Next Tasks`.
4. Replace the single `Latest Handoff` entry with a concise summary.
5. Run `powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1` if the script exists.
6. Reply with changed files, tests run, blockers, and the next suggested task.

Do not append a long session log.
