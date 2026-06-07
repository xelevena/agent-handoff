# Agent Handoff Codex Plugin

This is a Codex plugin wrapper for `agent-handoff`.

It includes:

- `.codex-plugin/plugin.json`
- `skills/agent-handoff/SKILL.md`
- `templates/` for Codex, Claude Code, Cursor, and shared state
- `scripts/install-agent-handoff.ps1`
- `scripts/validate-agent-state.ps1`

## Usage

After installing the plugin in Codex, ask:

```text
Enable agent handoff in this repo.
```

Codex should install the repo-local files:

```text
AGENTS.md
CLAUDE.md
.agents/state.md
.claude/commands/handoff.md
.cursor/rules/agent-handoff.mdc
scripts/validate-agent-state.ps1
```

The plugin is not the source of truth. The repo-local files are.
