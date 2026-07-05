---
name: unknowns-brainstorming
description: "Generate options and prototypes to activate latent preferences you can't articulate until you see them (unknown knowns). Includes a prototyping mode that generates visual artifact prototypes for design/UX topics. Use when exploring directions, choosing between approaches, or needing to discover what you actually want."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, brainstorming, prototyping, options, unknowns]
enabled: true
triggers:
  - "/unknowns:brainstorming"
  - "help me brainstorm options"
  - "I don't know what I want"
  - "show me some directions"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:brainstorming — discover what you actually want

Generate options (and optionally prototypes) to activate the user's latent preferences. This
targets **unknown knowns** — things you know but can't articulate until you see them.

> Part of the Unknowns toolkit (Discovery stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Conversational

Multi-turn dialogue. The user's reactions to options reveal preferences they couldn't state upfront.

## Flow

### 1. Opening — scope the problem

Ask the user to describe the problem, decision, or direction to explore.

Determine if the topic is **visual/experiential** (UI design, layout, physical arrangement,
branding, presentation style) or **conceptual** (strategy, naming, process, structure). This
determines whether to use prototyping mode.

### 2. Core — option generation and reaction loop

**Round 1.** Generate 5-8 distinct options. Make them genuinely different — not variations on
the same idea. Each option should have:
- A short name
- A 2-3 sentence description
- What makes it distinct from the others

**If visual/experiential topic → prototyping mode.** Instead of text-only options, generate
HTML artifact prototypes using `create_artifact`. Create 3-4 radically different visual
directions the user can see and interact with. Users react more honestly to something tangible
than to descriptions.

**Collect reactions.** For each option, ask the user to react:
- Like it
- Don't like it
- Interesting but not sure

**Probe dislikes.** When the user says "don't like," ask: "What specifically doesn't work?"
This is the key mechanism — the reason behind the dislike reveals a latent preference.

**Subsequent rounds.** Based on reactions, generate the next batch of 5-8 options that:
- Incorporate revealed preferences
- Avoid patterns the user rejected
- Push into territory adjacent to what they liked

Repeat until convergence (user gravitates toward 2-3 clear favorites) or 3-4 rounds max.

### 3. Output — converged options + preference map

Deliver:

```
## Brainstorming Results: [topic]

### Top options (converged)
1. [option]: [description] — [why the user gravitated here]
2. [option]: [description] — [why]
3. [option]: [description] — [why]

### Preferences revealed during the process
- [preference]: [evidence from reactions]
- [preference]: [evidence]

### Rejected patterns
- [pattern]: [why the user consistently rejected this]
```

If relevant, suggest: "Ready to turn one of these into an execution plan? Try
`unknowns:plans`."

### 4. Storage

Ask: "Save these results to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
