---
name: agent-handoff
description: Install, update, validate, or explain a compact repo-local handoff ledger so Codex, Claude Code, Cursor, and other coding agents can switch work without shared chat context.
---

# Agent Handoff

Use this skill when the user asks to enable, install, update, validate, or explain shared agent handoff for a repository.

Also use this skill when the user sends exactly:

```text
/handoff
```

In that case, immediately update `.agents/state.md` so another agent can continue from the current repository.

## Goal

Install a repo-level convention that different coding agents can auto-discover:

```text
Codex        -> AGENTS.md
Claude Code  -> CLAUDE.md
Cursor       -> .cursor/rules/agent-handoff.mdc
All agents   -> .agents/state.md
```

The plugin is only an installer and workflow helper. The durable protocol is the repository files.

## Install Workflow

1. Confirm the current working directory is the target repository.
2. Check whether these files already exist:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `.agents/state.md`
   - `scripts/validate-agent-state.ps1`
3. Run the bundled installer:

```powershell
powershell -ExecutionPolicy Bypass -File <plugin-root>\scripts\install-agent-handoff.ps1 -TargetPath <repo-root>
```

Use `-Force` only when the user explicitly wants to replace existing handoff files.

4. Customize `.agents/state.md` for the current repository.
5. Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1
```

6. Tell the user which files were installed or already existed.

## `/handoff` Workflow

When the user sends `/handoff`:

1. Inspect current git status and recent work from available context.
2. Update `.agents/state.md`.
3. Promote anything that must survive future handoffs into `Current Status`, `Key Decisions`, or `Next Tasks`.
4. Replace the single `Latest Handoff` entry with a concise summary.
5. Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\validate-agent-state.ps1
```

6. Reply with changed files, tests run, blockers, and next suggested task.

Do not append a long session log.

## Update Workflow

When updating an existing setup:

- Do not overwrite project-specific `.agents/state.md` unless explicitly requested.
- Prefer updating missing adapter files and validator scripts.
- Keep durable project facts in `Current Status`, `Key Decisions`, or `Next Tasks`.
- Replace only the `Latest Handoff` entry for session handoff.

## Validation Rules

The state file should remain latest-only:

- exactly one `## Latest Handoff`
- exactly one handoff heading under it
- no growing `## Handoff Log`
- default max 90 lines / 7000 characters

## Limitation

This is compact handoff, not perfect memory. If another agent takes a new unrelated task and updates `.agents/state.md`, details from the previous task may be overwritten unless they were promoted to durable status, decisions, tasks, docs, issues, or commits.
