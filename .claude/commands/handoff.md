# /handoff

Immediately update `.agents/state.md` so another agent can continue from this repository without shared chat context.

Required behavior:

1. Inspect recent work and current git status.
2. Preserve durable facts in `Current Status`, `Key Decisions`, or `Next Tasks`.
3. Replace the single `Latest Handoff` entry.
4. Run `powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1` if the script exists.
5. Report changed files, tests run, blockers, and next suggested task.

Do not append a long session log.
