# Adapters

Adapters make `agent-handoff` discoverable by different agent hosts.

The shared memory format stays the same:

```text
.agents/state.md
```

Each adapter should only teach a host agent to read and update that file.

## Planned Adapters

- `codex-plugin`: Codex plugin wrapper with a skill that can install the templates into a repository.
- `claude-code`: Claude Code command and startup-file convention.
- `cursor`: Cursor rules file.

## Rule

Do not create separate memories per adapter unless the user explicitly asks for task-specific state files.
