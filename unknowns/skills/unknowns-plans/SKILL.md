---
name: unknowns-plans
description: "Turn vague ideas into structured execution plans, sorted so you review the most important decisions first. Each step annotated with certainty level. Low-certainty steps suggest which other unknowns techniques could help. Use when you have a direction but need to organize it into actionable steps."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, planning, execution, structure, unknowns]
enabled: true
triggers:
  - "/unknowns:plans"
  - "make an execution plan"
  - "structure this into steps"
  - "organize my approach"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:plans — structure what you know, surface what you don't

Turn vague ideas into structured execution plans. Two mechanisms work together:
**priority sorting** (where to look) + **certainty annotation** (why to look there). This
targets **known unknowns** — things you know you need to figure out.

> Part of the Unknowns toolkit (Execution stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Structured Generation

The user provides goals and context; the agent generates a structured plan document.

## Flow

### 1. Opening — collect goal and context

Ask the user for:
- **Goal**: What they're trying to accomplish
- **Current thinking**: Any ideas, constraints, or prior work (can reference outputs from
  other unknowns skills — brainstorming results, interview insights, reference analyses)

### 2. Core — generate the plan

Generate an execution plan with two key properties:

**Priority sorting.** Lead with the decisions the user is most likely to need to tweak:
- High-stakes choices (affects users, costs money, hard to reverse)
- Design decisions (multiple valid approaches, judgment required)
- Strategic tradeoffs (competing priorities)

Put mechanical, routine, or low-risk steps at the bottom. The user's attention is limited —
front-load what matters.

**Certainty annotation.** Each step gets a certainty level:
- **High** — clear path, low risk, can proceed confidently
- **Medium** — reasonable approach but some assumptions not validated
- **Low** — significant unknowns, multiple viable paths, insufficient information

Low-certainty steps must include:
- What questions need answering before proceeding
- Which unknowns technique could help (e.g., "consider `unknowns:interviews` to get
  stakeholder perspectives on this step")

### 3. Output — structured plan document

```
## Execution Plan: [goal]

### Decisions requiring your judgment (review these first)
1. [step]: [description]
   - Certainty: [low/medium]
   - Open questions: [list]
   - Suggested exploration: [unknowns technique]

2. [step]: [description]
   - Certainty: [medium]
   - Key tradeoff: [description]

### Steps with clear path (review if time permits)
3. [step]: [description]
   - Certainty: [high]

4. [step]: [description]
   - Certainty: [high]

### Dependencies
- [step X] depends on [step Y]: [why]

### Open questions summary
- [question 1]: blocks [step(s)]
- [question 2]: blocks [step(s)]
```

If relevant, suggest: "Plan ready — track your execution with `unknowns:notes`."

### 4. Storage

Ask: "Save this plan to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
