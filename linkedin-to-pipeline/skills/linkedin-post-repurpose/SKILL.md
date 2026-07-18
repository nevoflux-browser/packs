---
name: linkedin-post-repurpose
description: Repurpose a high-performing LinkedIn post into a new format (text → carousel → video). Use when the user asks to repurpose, adapt, or reformat a LinkedIn post.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, repurpose, formats, reuse]
enabled: true
triggers:
  - "repurpose this linkedin post"
  - "reformat this linkedin post"
  - "adapt this post into another format"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-post-repurpose — one idea, many formats

The best creators find what works and double down. Take a **high performer** and re-express it
in a new format, so a proven idea earns reach more than once.

## Read first

- `linkedin-to-pipeline/content-calendar` — identify a top-performing post to repurpose.
- `linkedin-to-pipeline/brand-profile` — voice, banned words, proof bank.
- Conventions: `.../formats.md`, `.../hooks.md`.

## Steps

1. **Pick the source** — a post that performed well (check the calendar / weekly-review
   signals). Repurpose winners, not random posts.
2. **Choose the new format** — move up the richness ladder where it fits: text → carousel →
   video (or text → infographic). Keep the core idea; change the container.
3. **New hook variants** — the new format needs its own hook; produce 2–3 (`hooks.md`, ≤ ~55
   chars) and let the user pick.
4. **Visual brief + renderer pointer** — as in `post-write` (video/GIF → `video` skill;
   carousel/infographic → create-artifact). Do not render.
5. **Write** the new draft to `idea-backlog` at status **Draft**.

## Next step

> New format drafted. Run `linkedin-post-review` on it before shipping.

## Rules

- Repurpose high performers only.
- Same boundaries as write: no rendering, soft integrations degrade gracefully.
- It still goes through the review gate — nothing skips review.
