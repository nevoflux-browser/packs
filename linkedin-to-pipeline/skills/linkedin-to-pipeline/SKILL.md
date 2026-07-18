---
name: linkedin-to-pipeline
description: Turn LinkedIn into a content-to-pipeline system. Routes to calendar planning, idea mining, writing, review, publishing handoff, repurposing, and weekly review. Use when the user says "/linkedin-to-pipeline", wants to run LinkedIn as a pipeline system, or isn't sure which LinkedIn step to run next.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, pipeline, marketing, funnel]
enabled: true
triggers:
  - "/linkedin-to-pipeline"
  - "linkedin to pipeline"
  - "linkedin content system"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-to-pipeline — run LinkedIn as a system

Most companies treat LinkedIn as a brand-awareness feed. This pack treats it as **pipeline
infrastructure**. The chain is simple:

> Content creates visibility → visibility builds trust → trust leads to conversations →
> conversations turn into opportunities.

Buyers research your profile and content before they take a call, so **the content isn't the
top of the funnel — it is the funnel.** This host skill routes you to the one step you need
and keeps the loop turning.

## Step 0 — Foundation check (first run)

Before planning anything, make sure the two foundation pages exist and are filled:

- `linkedin-to-pipeline/brand-profile` — positioning, ICP, offer, voice/banned words, cadence
  knobs, and a running proof bank. This is the "internal knowledge" input.
- `linkedin-to-pipeline/idea-sources` — where ideas come from (reddit, x.com, 知乎/小红书/微博,
  competitor profiles, product changelog, GitHub) plus per-source mining rules. This is the
  "market awareness" input.

If either is empty or absent:

> Before planning, fill in `linkedin-to-pipeline/brand-profile` (positioning, ICP, offer,
> voice, proof) and `linkedin-to-pipeline/idea-sources`. Then run `linkedin-calendar-planning`.

Read pages by slug on demand (resolve the page read/write tool via `tool_search` →
`tool_call_dynamic`). The `dependencies` frontmatter field is decorative — it does not
auto-load anything; read what you need by slug.

## The loop

```
brand-profile + idea-sources (filled once)
        ↓
calendar-planning   ── strategic, low-frequency: lay out the arc + open 70/20/10 slots
        ↓
idea-mining         ── inner loop: mine ideas to fill the open slots
        ↓
post-write → post-review → post-publish → [if it performs] → post-repurpose → post-review → post-publish
        ↓
weekly-review ──┬──► back to calendar-planning (adjust arc/slots)
                ├──► back to idea-mining (fresh angles)
                └──► feeds post-write (What's-working → format/hook choice)
```

## Route by intent

| The user wants to… | Run |
|---|---|
| Plan the month, build/adjust the calendar or arc | `linkedin-calendar-planning` |
| Get ideas, decide what to post about | `linkedin-idea-mining` |
| Draft / write / compose a post | `linkedin-post-write` |
| Review / QA / edit a draft | `linkedin-post-review` |
| Publish, finalize, or schedule a post | `linkedin-post-publish` |
| Repurpose / reformat a high performer | `linkedin-post-repurpose` |
| Review performance, analyze results, weekly recap | `linkedin-weekly-review` |

When the user isn't sure, default to where they are in the loop: no calendar yet →
`calendar-planning`; calendar but no ideas → `idea-mining`; a queued idea → `post-write`.

## Where the rules live

- **Static methodology** (read-only) is in this skill's `conventions/`: `funnel.md`,
  `hooks.md`, `formats.md`, `algorithm.md`, `pipeline.md`, `calendar-arc.md`. Action skills
  read these on demand.
- **User overrides** (custom 70/20/10 ratio, own hook words, banned words, cadence/arc length)
  live in `brand-profile`. When a skill reads the methodology, brand-profile values win over
  convention defaults.

## Boundaries

- **No auto-posting.** The pack finalizes paste-ready copy and hands off; the user hits Post.
- **No visual rendering.** It writes copy + a visual brief and points at a downstream renderer.
- **External sourcing is read-only** (open tabs, reddit, github) — for inspiration only.
- **Soft integrations degrade gracefully** — if `no-slop` / the `video` skill / create-artifact
  aren't available, fall back (install hint or plain-text brief); never hard-depend on them.
