---
name: linkedin-calendar-planning
description: Plan a LinkedIn content calendar that maintains a 70/20/10 funnel mix over a rolling window and, on a cold start or repositioning, lays out a one-time positioning→authority→conversion arc — with cadence and arc length read from the brand profile. Use when the user asks to plan content, schedule a content arc, or build/adjust a content calendar.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, calendar, funnel, planning]
enabled: true
triggers:
  - "plan my linkedin content"
  - "build a content calendar"
  - "plan the content arc"
  - "adjust the calendar"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-calendar-planning — the strategic entry point

This is the **top of the loop** and a **low-frequency** skill. Strategy decides whether the
rest of the system has anything good to publish, so plan first — then mine ideas to fill the
plan, not the other way around.

## Read first

- `linkedin-to-pipeline/brand-profile` — positioning (drives the arc), and the cadence knobs
  (arc length, default 90 days; posts/week, default 2–3) and any custom ratio override.
- Conventions (by slug, on demand): `linkedin-to-pipeline/conventions/calendar-arc.md`,
  `.../funnel.md`, `.../algorithm.md`.

Resolve page read/write via `tool_search` → `tool_call_dynamic`.

## Steps

1. **Decide the mode.**
   - *Cold start / repositioning* → lay out the one-time arc (positioning → authority →
     conversion) across the configured length. Read positioning from brand-profile so the arc
     isn't planned in the abstract.
   - *Already ramped* → don't re-plan the whole arc; just top up the open slots ahead.
2. **Open the slots, not the posts.** For the upcoming weeks, create empty slots that hold the
   **70/20/10 rolling-window** mix with the **spacing rules** from `calendar-arc.md`: TOFU is
   the backbone; MOFU ≈ every 5th; BOFU ≈ every 10th, spaced and always after trust content
   (never cold). You are placing stage-shaped slots, not writing content.
3. **Honor overrides.** If brand-profile sets a custom ratio or cadence, use it over the
   defaults.
4. **Write** the plan to `linkedin-to-pipeline/content-calendar`: mark the arc phase per week
   and the open TOFU/MOFU/BOFU slots. Leave the slots empty for `idea-mining` to fill.

## Next step

> Arc set and slots opened. Next: run `linkedin-idea-mining` to fill the open TOFU/MOFU/BOFU
> slots.

## Rules

- Plan slots, not ideas — filling is `idea-mining`'s job.
- The arc runs once, then it's steady-state top-ups. Don't restart the arc every window.
