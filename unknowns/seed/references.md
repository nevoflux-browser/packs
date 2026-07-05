---
slug: unknowns/references
title: "References"
tags: [unknowns, research, probing]
---

# References

**Stage:** Research | **Mode:** Probing | **Targets:** Known unknowns

## What it does

Uses existing things as reference anchors — "show don't tell" to reduce communication cost.
You point at something and say "like this, but..." instead of describing from scratch.

## When to use it

- When you know what good looks like but can't describe it in words
- When starting something new and wanting to build on prior art
- When communication about what you want keeps failing
- When you need concrete examples to ground abstract discussions

## How it works

**Path A — You have a reference:**
1. Point at it (URL, file, brain page, screenshot, or description)
2. The agent reads and analyzes it: structure, patterns, style, strengths
3. You say "like this, but..." to guide adaptation
4. The agent extracts what to borrow, adapt, and skip

**Path B — You don't have a reference:**
1. Describe what you're working on and what kind of reference would help
2. The agent searches your knowledge base first (you may already have relevant material)
3. Then searches the web using analogical reasoning (structural similarity, not keywords)
4. Presents 3-5 candidates for you to pick from

## Key mechanism

**User-specified > agent-searched.** You usually know what good looks like — you just can't
describe it abstractly. Pointing at something concrete removes more ambiguity than any amount
of verbal description. The agent's job is to extract the structure from your reference, not to
find the reference for you (though it can help if needed).

## Output

Reference analysis: structure, patterns, strengths, relevance to your situation, plus
adaptation notes (what to borrow, what to change, what to skip).

## Connects to

- After this → `plans` to structure how to build on the reference
- After this → `brainstorming` if the reference sparks new directions
- Before this ← `interviews` (a role mentioned something worth finding a reference for)

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"
