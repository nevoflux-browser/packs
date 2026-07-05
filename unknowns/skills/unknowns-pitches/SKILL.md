---
name: unknowns-pitches
description: "Package your work into a deliverable document for a specific audience to get buy-in. Assembles outputs from previous unknowns techniques into a cohesive pitch. Supports multi-audience comparison (2-3 audiences). Use when you need to communicate your work to others for approval, alignment, or buy-in."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, pitches, communication, packaging, buy-in, unknowns]
enabled: true
triggers:
  - "/unknowns:pitches"
  - "pitch this to my team"
  - "package this for review"
  - "explain this to stakeholders"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:pitches — package your work for others

Package your work into a deliverable document that a specific audience can understand and
act on. This is a **packaging and communication tool** — it assembles and presents, rather
than critiques. Targets **known unknowns** — you know you need buy-in, you need the right
framing.

> Part of the Unknowns toolkit (Communication stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Structured Generation

The user specifies what to pitch and to whom; the agent assembles a deliverable document.

## Core principle

This is about **reducing the audience's unknowns**, not the user's. The audience has the same
problem — they don't know what the user has been working on. A good pitch accelerates their
understanding by packaging everything they need into one self-contained document.

## Flow

### 1. Opening — what and to whom

Ask:
- **What to pitch:** What work to package (can reference outputs from previous unknowns
  techniques — brainstorming results, plans, notes, references)
- **Target audience(s):** Who will read this (natural language: "my team," "an investor,"
  "my manager," "a technical reviewer")
- Supports 2-3 audiences in one session for cross-audience comparison

### 2. Core — assemble the pitch

For each audience:

**Gather raw material.** Collect outputs from any unknowns techniques used in this
conversation:
- Brainstorming results → the chosen direction and why
- Plans → the execution approach
- Notes → what happened during execution, key decisions
- References → prior art and how this builds on it
- Interview insights → perspectives considered
- Blind spot analysis → risks acknowledged

**Frame for the audience.** Structure the pitch around what this audience cares about:
- **Technical reviewers** → approach, tradeoffs, alternatives considered
- **Business stakeholders** → impact, timeline, resources needed
- **Team members** → what changes for them, what they need to do
- **External parties** → value proposition, differentiation, credibility

**Package into a document.** Create a self-contained document the user can send directly.
Include everything the audience needs — no context assumed.

### 3. Output — pitch document(s)

For each audience:

```
## [Topic] — Pitch for [Audience]

### The short version
[2-3 sentences: what this is and why it matters to this audience]

### Background
[What the audience needs to know to understand the rest]

### The approach
[What was done / will be done and why this way]

### Key decisions made
[Decisions and their reasoning — from plans and notes]

### What's next
[Clear asks: what you need from this audience]
```

**Multi-audience comparison.** If multiple audiences, add a section at the end:

```
### Cross-audience notes
- [Topic X] is framed differently for [audience A] vs [audience B]: [how and why]
- [Audience C] needs [specific detail] that others don't
```

If cross-audience gaps reveal areas where messaging is inconsistent, suggest:
"Inconsistent framing on [topic] — you might want to verify your understanding with
`unknowns:quizzes`."

### 4. Storage

Ask: "Save this pitch to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
