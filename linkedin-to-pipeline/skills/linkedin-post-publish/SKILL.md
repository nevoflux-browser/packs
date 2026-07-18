---
name: linkedin-post-publish
description: Finalize a LinkedIn post into paste-ready copy plus a visual brief and a suggested slot, and hand it off for publishing (no auto-posting). Use when the user asks to publish, schedule, finalize, or post a LinkedIn update.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, publish, scheduling, handoff]
enabled: true
triggers:
  - "publish my linkedin post"
  - "schedule this linkedin post"
  - "finalize this linkedin post"
  - "post this linkedin update"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-post-publish — finalize and hand off

This pack **does not auto-post**. It finalizes everything so publishing is a single paste +
click that the user does.

## Read first

- `linkedin-to-pipeline/idea-backlog` / `content-calendar` — the cleared draft and its slot.
- Conventions: `.../algorithm.md` (for a sensible suggested time — soft heuristic only).

## Steps

1. **Paste-ready copy** — final body text, formatted for LinkedIn (line breaks, no markdown
   artifacts), ready to paste as-is.
2. **Visual brief** — carry through the brief + renderer pointer from write/repurpose (video/
   GIF → `video` skill; carousel/infographic → create-artifact). Still no rendering here.
3. **Suggested slot** — recommend a publish time so the first audience is likely active
   (early engagement matters; `algorithm.md`). This is a suggestion, not a rule.
4. **Record status** — write **Scheduled** or **Live** back to `content-calendar` (and update
   the `idea-backlog` item).
5. **Optional handoff assist** — if the user wants, use the browser (resolve tools via
   `tool_search` → `tool_call_dynamic`) to open LinkedIn's composer to the ready-to-post state.
   **The user hits Post.** For timing, point them at LinkedIn's **native scheduler** — do not
   try to schedule via any background/cron mechanism.

## Next step

> Handed off. If this post performs well, come back and run `linkedin-post-repurpose` to turn
> it into a carousel or video.

## Rules

- **Never auto-post** and never cross into writing LinkedIn data. The Post click is the user's.
- Scheduling = LinkedIn's native scheduler, not this pack.
