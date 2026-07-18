---
name: linkedin-weekly-review
description: Analyze weekly LinkedIn performance data (comments, saves, shares, profile visits, conversations) and feed insights back into the calendar and next idea cycle. Use when the user asks to review performance, analyze results, or do a weekly LinkedIn recap.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, analytics, review, feedback]
enabled: true
triggers:
  - "weekly linkedin review"
  - "review linkedin performance"
  - "analyze my linkedin results"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-weekly-review — close the loop

The performance-feedback input. Every week, review what happened and feed it back so the next
cycle is smarter. This pack does **not** read LinkedIn data — the user supplies the numbers.

## Read first

- `linkedin-to-pipeline/content-calendar` — which posts went live this week (format, stage,
  hook pattern).
- `linkedin-to-pipeline/weekly-review-log` — prior entries, for trend.
- Conventions: `.../algorithm.md`, `.../funnel.md`.

## Steps

1. **Collect the signals** — ask the user for this week's numbers per post: comments, saves,
   shares, profile visits, and conversations started. (No auto-fetch from LinkedIn.)
2. **Analyze** — which posts, **formats**, **hook patterns**, and **stages** drove engagement
   and conversations; which fell flat.
3. **Update "What's working"** — maintain the distilled section in `weekly-review-log`: the
   current top formats / hook patterns / stages. This is what `linkedin-post-write` reads to
   pick formats and hooks (exploit/explore), so keep it short and current, not raw dumps.
4. **Write** the week's entry (date + signals + next-cycle adjustments) to `weekly-review-log`.
5. **Feed back:**
   - to `linkedin-calendar-planning` — adjust the arc/slot mix if a stage is over/under-working.
   - to `linkedin-idea-mining` — fresh angles from what resonated.

## Next step

> Insights logged and "What's working" updated. Next: run `linkedin-calendar-planning` to
> adjust the arc/slots, or `linkedin-idea-mining` to feed fresh angles.

## Rules

- The user provides the metrics; the pack never reads LinkedIn directly.
- Keep "What's working" distilled (top few), so downstream skills consume signal, not noise.
- Judge by **repeated performance**, not one spike (`algorithm.md`).
