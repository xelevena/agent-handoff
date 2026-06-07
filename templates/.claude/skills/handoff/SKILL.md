---
name: handoff
description: Update the compact repo-local handoff state so another coding agent can continue. Use when the user invokes /handoff or asks to prepare a handoff.
disable-model-invocation: true
---

# Agent Handoff

Update `.agents/state.md` in the current repository so another coding agent can continue without shared chat context.

Required behavior:

1. Inspect recent work and current git status.
2. Preserve durable facts in `Current Status`, `Key Decisions`, or `Next Tasks`.
3. Replace the single `Latest Handoff` entry.
4. Run `powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1` if the script exists.
5. Report changed files, tests run, blockers, and the next suggested task.

Do not append a long session log.
