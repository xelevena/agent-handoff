# Claude Code Adapter

Claude Code can participate through repo-local files:

- `CLAUDE.md`
- `.claude/commands/handoff.md`
- `.claude/skills/handoff/SKILL.md`
- `.agents/state.md`

Recommended behavior:

1. Claude reads `CLAUDE.md` on startup.
2. `CLAUDE.md` points Claude to `.agents/state.md`.
3. The `/handoff` command or skill reminds Claude to update the state before stopping.

If Claude Code is running from a different project, install the skill into that target project:

```text
<target-repo>/.claude/skills/handoff/SKILL.md
```

The portable source file is:

```text
skills/handoff/SKILL.md
```

This adapter does not require a model provider or daemon.
