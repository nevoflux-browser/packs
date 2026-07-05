---
name: unknowns-references
description: "Use existing things as reference anchors — 'show don't tell' to reduce communication cost. Point at something and say 'like this, but...' instead of describing from scratch. Falls back to searching your knowledge base and the web when no reference is available. Use when you know what good looks like but can't describe it in words."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, references, show-dont-tell, analogies, unknowns]
enabled: true
triggers:
  - "/unknowns:references"
  - "find references for this"
  - "something like this but"
  - "show me similar examples"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:references — show don't tell

Use existing things as reference anchors to reduce communication cost. Instead of describing
what you want from scratch, point at something and say "like this, but..." This targets
**known unknowns** — you know you need a reference point, you just need to find or analyze one.

> Part of the Unknowns toolkit (Research stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Probing

The agent reads and analyzes reference material, then extracts patterns the user can build on.

## Core principle

**User-specified reference > active search.** The user often knows what good looks like — they
just can't describe it in words. A concrete reference removes ambiguity faster than any amount
of description.

## Flow

### 1. Opening — find the reference

Ask: **"Do you have something in mind you'd like to use as a reference?"**

Accept any of:
- A URL (web page, design, article)
- A file path
- A page in their knowledge base (brain)
- A screenshot or image
- A description of something they've seen before

### 2. Core — analyze or search

**Path A: User has a reference.**

1. Read/analyze the reference using appropriate tools:
   - URL → `web_fetch` or browser tools via `tool_call_dynamic`
   - File → `read`
   - Brain page → brain tools via `tool_call_dynamic`
   - Screenshot → visual analysis
2. Extract the reference's:
   - Structure and organization
   - Patterns and conventions
   - Style and tone
   - Key strengths
3. Ask: "What do you want to borrow from this? What would you change?"
4. The user's "like this, but..." response reveals what they actually want

**Path B: User doesn't have a reference.**

1. Ask the user to describe what they're working on and what kind of reference would help
2. Search the user's knowledge base (brain) first via `tool_call_dynamic` — they may already
   have relevant material saved
3. If brain search doesn't surface enough, search the web using `web_search` with analogical
   reasoning (look for structurally similar problems, not just keyword matches)
4. Present 3-5 candidate references, each with:
   - Source and link
   - What makes it relevant (structural similarity, not surface similarity)
   - What could be borrowed
5. Let the user pick which reference(s) to dig into, then proceed as Path A

### 3. Output — reference analysis

```
## Reference Analysis: [subject]

### Reference: [source]
- Structure: [how it's organized]
- Patterns: [recurring approaches]
- Strengths: [what works well]
- Relevance: [what applies to the user's situation]

### Adaptation notes
- Borrow: [what to take directly]
- Adapt: [what to modify and how]
- Skip: [what doesn't apply]
```

If relevant, suggest: "Ready to build on this? Try `unknowns:plans` to structure the
execution."

### 4. Storage

Ask: "Save this reference analysis to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
