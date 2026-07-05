---
name: unknowns-blind-spot-pass
description: "Scan a plan or idea from multiple perspectives to find gaps and assumptions you haven't examined. The agent actively probes for blind spots the user hasn't considered (unknown unknowns). Use when reviewing a plan, proposal, strategy, or any idea before committing to it."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, blind-spots, review, probing, unknowns]
enabled: true
triggers:
  - "/unknowns:blind-spot-pass"
  - "check my blind spots"
  - "what am I missing in this plan"
  - "review my assumptions"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:blind-spot-pass — find what you haven't examined

Scan a plan, idea, or proposal from multiple perspectives to surface gaps and assumptions the
user hasn't considered. This targets **unknown unknowns** — things you don't know you don't know.

> Part of the Unknowns toolkit (Discovery stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Probing

The agent actively analyzes and surfaces things. The user reviews and reacts.

## Flow

### 1. Opening — collect the subject

Ask the user for the plan, idea, or proposal to examine. Accept:
- Direct description in conversation
- Pasted text
- A reference to something discussed earlier in the conversation

If the input is vague, ask one clarifying question to scope it. Do not over-question.

### 2. Core — multi-perspective scan

**Generate perspectives.** Based on the subject matter, propose 5-7 scanning perspectives.
These are NOT fixed categories — they are dynamically generated to match the topic. Examples:

- For a product idea: user needs, market competition, technical feasibility, unit economics,
  regulatory, distribution, timing
- For a life decision: financial impact, relationship effects, opportunity cost, reversibility,
  emotional readiness, timeline pressure
- For a strategy: stakeholder alignment, resource constraints, competitive response, execution
  risk, measurement, second-order effects

**Present perspectives to the user.** List them and ask: "These are the angles I'll examine.
Add, remove, or adjust any before I start?" Let the user see the lenses before applying them —
this itself is a discovery moment (seeing a perspective you hadn't thought of).

**Scan.** For each confirmed perspective, analyze the subject and identify:
- Assumptions being made (stated or implicit)
- Gaps in information or reasoning
- Risks not addressed
- Dependencies not acknowledged
- Edge cases not considered

### 3. Output — blind spot checklist

Deliver a structured report:

```
## Blind Spot Report: [subject]

### Perspectives scanned: [N]

### Critical blind spots (address before proceeding)
- [blind spot]: [why it matters] — [suggested action]

### Notable gaps (worth investigating)
- [gap]: [context] — [suggested action]

### Assumptions to validate
- [assumption]: [where it appears] — [how to test it]
```

Sort by severity within each section. End with a one-line summary: "X critical blind spots,
Y gaps, Z assumptions to validate."

If relevant, suggest other unknowns techniques: "Some of these gaps could be explored further
with `unknowns:interviews` (get other perspectives) or `unknowns:references` (find prior art)."

### 4. Storage

Ask: "Save this blind spot report to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic` to store.
