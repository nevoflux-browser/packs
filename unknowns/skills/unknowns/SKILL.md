---
name: unknowns
description: "A universal thinking toolkit for discovering what you don't know. Entry point that routes to 8 techniques across 4 cognitive stages: Discovery (blind-spot-pass, brainstorming), Research (interviews, references), Execution (plans, notes), Communication (pitches, quizzes). Use /unknowns for guided triage or /unknowns:<technique> for direct access. Generates a cognitive map dashboard with conversation-level progress tracking."
version: "0.1.1"
author: "NevoFlux"
tags: [thinking, unknowns, cognitive, discovery, brainstorming, planning, metacognition]
enabled: true
triggers:
  - "/unknowns"
  - "find my unknowns"
  - "what am I missing"
  - "discover blind spots"
  - "cognitive map"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns — discover what you don't know you don't know

A thinking toolkit with 8 techniques organized into 4 cognitive stages. Each technique targets
a different type of unknown and uses a matching interaction mode.

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"

## Stages and techniques

| Stage | Technique | Mode | Unknown type |
|-------|-----------|------|-------------|
| **Discovery** | `unknowns:blind-spot-pass` | Probing | Unknown unknowns |
| **Discovery** | `unknowns:brainstorming` | Conversational | Unknown knowns |
| **Research** | `unknowns:interviews` | Conversational | Unknown unknowns |
| **Research** | `unknowns:references` | Probing | Known unknowns |
| **Execution** | `unknowns:plans` | Structured Generation | Known unknowns |
| **Execution** | `unknowns:notes` | Structured Generation | Known unknowns |
| **Communication** | `unknowns:pitches` | Structured Generation | Known unknowns |
| **Communication** | `unknowns:quizzes` | Conversational | Unknown unknowns |

## Operating rules

- **Pack-local priority.** When inside the `/unknowns` flow, always use this pack's own skills
  even if a local skill with the same name exists (e.g., use `unknowns:brainstorming` not local
  `brainstorming`).
- **Conversation-level tracking.** Track which techniques the user has used in this conversation.
  Reset on new conversation — no cross-session state.
- **Never force a path.** Suggest techniques, never auto-launch them. The user always decides.

## Entry behavior

When the user invokes `/unknowns` without a sub-skill:

### Step 1 — Triage

Ask the user about their current situation with a short question:

> "What are you working on right now, and where do you feel stuck or uncertain?"

### Step 2 — Recommend

Based on their answer, determine which cognitive stage they're in and recommend 1-2 techniques:

- **"I have an idea but I'm not sure it's good"** → Discovery: blind-spot-pass, brainstorming
- **"I need to understand other perspectives"** → Research: interviews, references
- **"I know what to do but need to organize it"** → Execution: plans, notes
- **"I need to explain this to someone / verify my understanding"** → Communication: pitches, quizzes

Present the recommendation with a one-sentence explanation of why, plus the slash command to invoke it.

### Step 3 — Cognitive map (on request)

If the user asks to see the cognitive map or progress, render it with `create_artifact`
(`content_type: "text/html"`, artifact id starting with `unknowns`) — **from the shipped template, not
ad-hoc HTML**:

1. **Read the template:** `skill_read('unknowns', 'references/cognitive-map-template.html')`. It already
   contains the 4-stage → 8-technique layout, the progress bar, and a **5-theme picker**
   (Copper & Sage / Ocean Depth / Sand Dune / Neon Noir / Ivory Paper) the user clicks to switch, all
   self-contained.
2. **Only edit the status:** for each technique the user has used **this conversation**, add the `done`
   class to that technique's `.card` (cards carry `data-technique="<name>"`, e.g. `blind-spot-pass`).
   Change nothing else — keep all 5 theme buttons and the `<script>`; the progress bar and checkmarks
   recompute on load.
3. `create_artifact` with the filled-in HTML.

**Let the user pick the theme** — keep the 5-button bar; never hard-select one for them.

## Cross-skill orchestration

After the user completes a technique, check the dashboard state and suggest a natural next step:

- After `blind-spot-pass` → "You found gaps — want to explore solutions with `brainstorming`?"
- After `brainstorming` → "Ready to structure this into a plan with `plans`?"
- After `interviews` → "Multiple perspectives surfaced — want to check for blind spots with `blind-spot-pass`?"
- After `references` → "Found reference material — ready to build a plan with `plans`?"
- After `plans` → "Plan ready — track execution with `notes`?"
- After `notes` → "Execution documented — want to package this for others with `pitches`?"
- After `pitches` → "Pitch ready — want to verify your understanding with `quizzes`?"
- After `quizzes` → "Knowledge gaps found — want to dig deeper with `interviews` or `references`?"

These are text suggestions only. The user decides whether to follow them.

## Unified lifecycle (all sub-skills)

Every technique follows a 4-phase lifecycle:

1. **Opening** — State purpose, collect context from the user
2. **Core** — Mode-specific interaction (probing / conversational / structured generation)
3. **Output** — Structured deliverable
4. **Storage** — Ask: "Save this to your knowledge base?" If yes, use brain tools via `tool_call_dynamic`.
