# Agent Handoff Protocol

`agent-handoff` is a repo-level convention, not a single-host plugin.

The core idea:

```text
agent-specific startup file
  -> points every agent to .agents/state.md
  -> agent updates that one compact state file before handoff
```

This works across tools because each agent already knows how to read a different repo-level instruction file:

- Codex reads `AGENTS.md`.
- Claude Code reads `CLAUDE.md`.
- Cursor can read `.cursor/rules/*.mdc`.
- Other agents can add their own adapter file.

All of those entry points converge on:

```text
.agents/state.md
```

## Design Goals

- Avoid relying on chat history.
- Keep the next agent's startup context small.
- Support quota/time-window handoff between tools.
- Avoid binding the protocol to one model provider or one agent host.
- Let git preserve history; keep the handoff file latest-only.

## Non-Goals

- Perfect long-term memory.
- Multi-branch task memory.
- Automatic preservation of every side quest.
- Replacing issue trackers, commits, docs, or project management tools.

## Required Files

```text
AGENTS.md
CLAUDE.md
.agents/state.md
scripts/validate-agent-state.ps1
```

Optional adapters:

```text
.codex/commands/handoff.md
.claude/commands/handoff.md
.cursor/rules/agent-handoff.mdc
```

## Handoff Rule

Agents must replace the `## Latest Handoff` section instead of appending a growing session log.

If a fact must survive multiple handoffs, promote it to:

- `## Current Status`
- `## Key Decisions`
- `## Next Tasks`
- project docs
- issues
- commits

## Failure Mode

Latest-only state can forget details.

Example:

```text
Codex updates state after Task A
-> user switches to Claude
-> user asks Claude to do unrelated Task B first
-> Claude updates state for Task B
-> Task A details may be gone unless promoted to durable sections
```

This is intentional. The protocol is optimized for small, cheap, practical handoff, not exhaustive history.

## Adapter Rule

Adapters should not invent separate memory formats. They should only:

1. Make the host agent read `.agents/state.md`.
2. Make the host agent update `.agents/state.md` before stopping.
3. Run the validator when possible.

## Slash Command Convention

`/handoff` means:

```text
Update .agents/state.md now so another agent can continue immediately.
```

The command is intentionally a convention, not a host-specific feature. Adapters may implement it using native slash commands, command files, skills, or rules.

Required behavior:

1. Summarize recent work.
2. Promote durable facts to stable sections.
3. Replace the single `Latest Handoff` entry.
4. Run the validator when available.
5. Report that handoff is ready.
