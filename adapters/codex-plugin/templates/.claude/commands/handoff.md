# Handoff

Update `.agents/state.md` before stopping work.

Required behavior:

1. Preserve durable facts in `Current Status`, `Key Decisions`, or `Next Tasks`.
2. Replace the single `Latest Handoff` entry.
3. Run `powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1` if the script exists.
4. Report changed files, tests run, blockers, and next suggested task.

Do not append a long session log.
