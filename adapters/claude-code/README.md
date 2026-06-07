# Claude Code Adapter

Claude Code can participate through repo-local files:

- `CLAUDE.md`
- `.claude/commands/handoff.md`
- `.agents/state.md`

Recommended behavior:

1. Claude reads `CLAUDE.md` on startup.
2. `CLAUDE.md` points Claude to `.agents/state.md`.
3. The optional `/handoff` command reminds Claude to update the state before stopping.

This adapter does not require a model provider or daemon.
