# Claude Note

Before working, read `.agents/state.md`.

After meaningful work:

1. Update `.agents/state.md`.
2. Replace the `## Latest Handoff` entry instead of appending old entries.
3. Run `powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1` when available.

Keep `.agents/state.md` concise. It is the durable handoff context shared between Claude Code and other coding agents.

If the user sends `/handoff`, immediately update `.agents/state.md` for the next agent, run the validator if available, and report that handoff is ready.
