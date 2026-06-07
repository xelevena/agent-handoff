# agent-handoff

A tiny repo-local handoff ledger for coding agents that do not share chat context.

Use it when you switch between tools such as Codex, Claude Code, Cursor, or other agents during the same project. The goal is simple: a fresh agent should be able to read one short file and know what changed, what is next, and what not to forget.

The main use case is quota or time-window handoff. For example, when one agent reaches a 5-hour usage window or rate limit, you can switch to another tool and keep working without rebuilding context from the entire chat history.

`agent-handoff` is a repo-level protocol first. Plugins and commands are only adapters. The durable mechanism is the set of files inside your repository, because different agents already know how to read different startup files.

## What It Provides

- `AGENTS.md`: startup note for Codex and other agents.
- `CLAUDE.md`: startup note for Claude Code.
- `.agents/state.md`: the single shared handoff state.
- `scripts/validate-agent-state.ps1`: validator that keeps the state file short and latest-only.

Optional adapter templates:

- `.claude/commands/handoff.md`: Claude Code command-style reminder.
- `.cursor/rules/agent-handoff.mdc`: Cursor rule.
- `adapters/codex-plugin`: planned Codex plugin wrapper.

See [docs/protocol.md](docs/protocol.md) for the protocol design.

## How Agents Auto-Discover It

The trick is not one universal plugin system. The trick is repo-local files that each agent already recognizes:

```text
Codex        -> AGENTS.md
Claude Code  -> CLAUDE.md
Cursor       -> .cursor/rules/agent-handoff.mdc
All agents   -> .agents/state.md
```

Every adapter points back to `.agents/state.md`, so the shared state remains tool-neutral.

## Why Latest-Only?

Long agent logs become a second chat history and burn context. This project intentionally uses a rolling state file:

- keep the durable facts
- replace the latest handoff
- do not append an endless session log

That makes the next agent cheaper and faster to brief.

## Quota / Time-Window Handoff

Many coding agents are limited by usage windows, rate limits, or session availability. A common workflow looks like this:

```text
Codex works for a few hours
-> Codex updates .agents/state.md
-> user switches to Claude Code
-> Claude reads .agents/state.md and continues
-> Claude updates .agents/state.md
-> user switches back later if needed
```

The point is not to preserve every token of the previous conversation. The point is to preserve just enough durable state for the next agent to continue the work.

## Important Limitation

This is not a perfect shared memory system. It is a compact handoff file.

If you switch from Codex to Claude Code, then ask Claude to do a completely new task first, Claude may update `.agents/state.md` and overwrite the previous Codex handoff. When you later switch back to Codex, details from Codex's earlier state may be gone unless they were preserved as durable project status, decisions, or next tasks.

In other words:

- good for short, explicit handoffs
- good for keeping agent context small
- not good for preserving every branch of work history
- not a replacement for git commits, issues, docs, or a real long-term memory database

If you need multi-branch memory, use separate state files per task, issues, or a proper task tracker.

## Installation

Copy these files into the root of your repository:

```text
AGENTS.md
CLAUDE.md
.agents/state.md
scripts/validate-agent-state.ps1
```

Then edit `.agents/state.md` for your project.

For broader adapter coverage, also copy from `templates/`:

```text
.claude/commands/handoff.md
.cursor/rules/agent-handoff.mdc
```

## Agent Workflow

Before work:

```text
Read AGENTS.md or CLAUDE.md.
Read .agents/state.md.
Continue from the next task unless the user says otherwise.
```

After meaningful work:

```text
Update .agents/state.md.
Replace the Latest Handoff entry.
Run the validator.
Commit when appropriate.
```

## `/handoff`

After installation, the intended quick path is:

```text
/handoff
```

When an agent sees `/handoff`, it should immediately update `.agents/state.md` for the current repository so another agent can continue right away.

Expected behavior:

1. Inspect the current worktree and recent work.
2. Update durable sections if needed: `Current Status`, `Key Decisions`, and `Next Tasks`.
3. Replace the single `Latest Handoff` entry with a concise summary.
4. Run the validator.
5. Tell the user the handoff is ready and mention any blockers.

Implementation note: not every host has the same slash-command system. Claude Code can use `.claude/commands/handoff.md`. Codex can use the Agent Handoff plugin skill to treat a user message of `/handoff` as the same instruction. Other agents can implement the same convention through their own adapter files.

Validator:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1
```

## Recommended State Shape

Keep `.agents/state.md` short:

```md
# Project Agent State

Last updated: YYYY-MM-DD

## Project

One paragraph describing the project.

## Current Status

- ...

## Key Decisions

- ...

## Next Tasks

1. ...
2. ...

## Latest Handoff

### YYYY-MM-DD - Agent Name

What changed:

- ...

Tests run: ...

Blockers: ...

Next: ...
```

## Design Rules

- One state file.
- One latest handoff entry.
- Durable facts belong in status or decisions.
- Temporary session details belong in the latest handoff.
- If it matters after the next handoff, promote it out of the handoff.
- Let git preserve history; do not make the state file a history log.

## License

MIT
