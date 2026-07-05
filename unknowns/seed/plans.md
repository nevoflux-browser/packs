---
slug: unknowns/plans
title: "Plans"
tags: [unknowns, execution, structured-generation]
---

# Plans

**Stage:** Execution | **Mode:** Structured Generation | **Targets:** Known unknowns

## What it does

Turns vague ideas into structured execution plans, sorted so you review the most important
decisions first. Each step annotated with certainty level.

## When to use it

- When you have a direction but need to organize it into steps
- When you want to know which parts of your plan need the most attention
- After brainstorming converges on a direction
- When you need to communicate a plan to others and want it structured

## How it works

1. You provide your goal and current thinking
2. The agent generates a plan with two key properties:
   - **Priority sorted** — decisions you're most likely to need to adjust come first
   - **Certainty annotated** — each step marked high/medium/low certainty
3. Low-certainty steps include open questions and suggest which other unknowns technique could help

## Key mechanism

**Two mechanisms working together:**

- **Priority sorting** answers "where should I look?" — front-loads the steps that need your
  judgment, buries the mechanical stuff at the bottom
- **Certainty annotation** answers "why should I look here?" — explains what makes a step
  uncertain and what information is missing

This combination means you spend your attention budget on the steps that actually need it,
rather than reviewing everything equally.

**Cross-technique suggestions.** Low-certainty steps don't just say "this is uncertain" — they
suggest which unknowns technique could reduce the uncertainty (interviews for stakeholder
alignment, references for prior art, blind-spot-pass for risk analysis).

## Output

Structured plan: steps sorted by review priority, certainty per step, open questions, dependencies,
and suggested explorations for uncertain steps.

## Connects to

- After this → `notes` to track execution
- After this → `interviews` or `references` to address low-certainty steps
- Before this ← `brainstorming` (structure the chosen direction)
- Before this ← `blind-spot-pass` (plan incorporating identified risks)

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"
