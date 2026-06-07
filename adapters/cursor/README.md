# Cursor Adapter

Cursor can participate through a rules file:

```text
.cursor/rules/agent-handoff.mdc
```

The rule should instruct Cursor's agent to:

1. Read `.agents/state.md` before work.
2. Update `.agents/state.md` before stopping.
3. Keep only one `Latest Handoff` entry.
4. Run the validator when available.
