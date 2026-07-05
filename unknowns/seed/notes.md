---
slug: unknowns/notes
title: "Notes"
tags: [unknowns, execution, structured-generation]
---

# Notes

**Stage:** Execution | **Mode:** Structured Generation | **Targets:** Known unknowns

## What it does

Records decisions, deviations, and discoveries during execution — both the agent's and yours.
A living document that captures what actually happened vs what was planned.

## When to use it

- During execution of a plan (any plan, not just one from this toolkit)
- When things are deviating from the original plan and you want to track why
- When you're making decisions on the fly and want to remember the reasoning
- After a work session to capture what happened

## How it works

1. You describe what you're working on (can reference a previous plan)
2. The agent records its own autonomous decisions and deviations
3. The agent prompts you to record your decisions, discoveries, and changes
4. Each entry is auto-tagged by type and subject
5. You can invoke multiple times to append new entries

## Key mechanism

**Dual-subject model.** Execution involves two actors — you and the agent. Both make decisions,
both encounter surprises. The notes capture both sides:

- **Agent entries:** "I deviated from step 3 because X" / "I made assumption Y"
- **User entries:** "I decided to change approach because Z" / "I discovered Q"

**Continuous accumulation.** Unlike other techniques that run once, notes supports repeated
invocations. Each call appends to the existing notes. Uses compressed scratchpad storage for
continuity.

**Typed entries.** Every entry gets a type tag (decision / discovery / deviation / change /
open-question) so the final document is structured by nature of content, not chronology.

## Output

Structured execution notes grouped by type, with open questions prominently highlighted and
agent-side vs user-side entries distinguished.

## Connects to

- After this → `pitches` to package the work for others
- After this → `blind-spot-pass` if open questions suggest unexamined gaps
- Before this ← `plans` (track execution of the plan)

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"
