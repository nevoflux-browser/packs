---
name: unknowns-notes
description: "Record decisions, deviations, and discoveries during execution — both the agent's and yours. Supports continuous appending across multiple invocations via scratchpad. Use during or after executing a plan to capture what happened, what changed, and what was unexpected."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, notes, execution, decisions, tracking, unknowns]
enabled: true
triggers:
  - "/unknowns:notes"
  - "record what happened"
  - "track my execution"
  - "note this decision"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:notes — capture what happens during execution

Record decisions, deviations, and discoveries during execution. Dual-subject: the agent
records its own autonomous decisions, and guides the user to record theirs. This targets
**known unknowns** — during execution, things always deviate from the plan.

> Part of the Unknowns toolkit (Execution stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Structured Generation

Ongoing structured capture, supporting multiple invocations within and across conversations.

## Dual-subject model

**Agent side.** When the agent is executing a task for the user, it automatically records:
- Deviations from the original plan
- Decisions made autonomously (and why)
- Unexpected situations encountered
- Assumptions that turned out to be wrong

**User side.** The agent prompts the user to record:
- Decisions they made and the reasoning
- Discoveries — things they learned during execution
- Plan changes — what they adjusted and why
- Open questions — things that came up and remain unresolved

## Flow

### 1. Opening — establish context

Ask: "What are you working on?" Accept:
- A description of the current task
- A reference to a previous `unknowns:plans` output
- Continuation of an existing notes session

If continuing, retrieve previous entries from scratchpad.

### 2. Core — capture entries

For each entry, auto-tag with:

**Type tags:**
- `decision` — a choice was made
- `discovery` — something was learned
- `deviation` — plan changed
- `change` — scope or approach shifted
- `open-question` — unresolved issue surfaced

**Subject tags:**
- `agent` — the agent's own record
- `user` — the user's record

Prompt the user with targeted questions:
- "What decisions have you made since we last checked in?"
- "Did anything surprise you or go differently than expected?"
- "Are there any open questions that came up?"

### 3. Output — structured execution notes

```
## Execution Notes: [task]

### Decisions
- [agent/user] [entry] — [reasoning]

### Discoveries
- [agent/user] [entry] — [context]

### Deviations from plan
- [agent/user] [entry] — [original plan vs what happened]

### Open questions
- [entry] — [context, blocking what?]
```

Group by type, highlight open questions prominently. Distinguish agent-side and user-side
entries.

### Persistence

Uses scratchpad for cross-invocation continuity (4KB limit). Each entry stored in compressed
format: `[type|subject] key info`. Full text goes to brain only if the user chooses to save.

The user can call `/unknowns:notes` multiple times to append new entries.

If relevant, suggest: "Execution documented — ready to package this for others with
`unknowns:pitches`?"

### 4. Storage

Ask: "Save these notes to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
