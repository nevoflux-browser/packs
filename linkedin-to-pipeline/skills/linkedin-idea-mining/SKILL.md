---
name: linkedin-idea-mining
description: Mine LinkedIn post ideas to fill the calendar's open funnel slots, from internal knowledge, competitor analysis, and weekly performance data. Use when the user asks for content ideas, what to post, or wants to brainstorm LinkedIn topics.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, ideas, research, funnel]
enabled: true
triggers:
  - "linkedin post ideas"
  - "what should i post"
  - "brainstorm linkedin topics"
  - "fill the content slots"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-idea-mining — fill the open slots, don't brainstorm blind

The inner loop's high-frequency step. Mine **toward the open calendar slots**, so the backlog
stays balanced to the 70/20/10 ratio instead of filling up with whatever was easiest to think
of.

## Read first

- `linkedin-to-pipeline/content-calendar` — the **open slots** and their target stages. This
  is your brief ("I need 2 TOFU stories + 1 BOFU case study for the next two weeks").
- `linkedin-to-pipeline/brand-profile` — internal knowledge (positioning, ICP, proof bank).
- `linkedin-to-pipeline/idea-sources` — the configured external sources and per-source rules.
- `linkedin-to-pipeline/weekly-review-log` — what's been resonating.
- Conventions: `.../funnel.md`, `.../pipeline.md`.

## The three inputs (from the methodology)

1. **Internal knowledge** — the workflows you run, the client problems you solve, the
   questions you answer over and over (from `brand-profile`). The most-skipped input and the
   one that makes content sound like *you*.
2. **Market awareness** — study what's already performing in your niche, via `idea-sources`:
   - *Passive:* scan the user's **open browser tabs**; for any tab whose domain matches a
     configured source (reddit, x.com, 知乎, 小红书, 微博, a competitor profile), mine it.
   - *Active:* fetch configured sources directly — product changelog, GitHub releases/commits,
     competitor posts.
   - Apply each source's **mining rule** from `idea-sources` (e.g. `github release → BOFU demo
     / MOFU how-to`; `reddit/知乎 recurring question → MOFU framework / TOFU contrarian`).
3. **Performance feedback** — recent wins/patterns from `weekly-review-log`.

## Steps

1. Load the open slots and their target stages.
2. Mine ideas from the three inputs to fill those specific stages.
3. Tag each idea with its target funnel stage and, where known, a slot.
4. **Write** ideas to `linkedin-to-pipeline/idea-backlog` at status **Idea**. The backlog also
   holds opportunistic ideas captured on the fly.

## Next step

> Ideas mapped to slots. Next: run `linkedin-post-write` on the first queued slot.

## Rules

- **External sourcing is read-only** — reddit/github/tabs are for inspiration; never post or
  write anything externally. Reach browser/web tools via `tool_search` → `tool_call_dynamic`.
- Mine toward open slots first; capture stray good ideas too, but don't drift off-ratio.
