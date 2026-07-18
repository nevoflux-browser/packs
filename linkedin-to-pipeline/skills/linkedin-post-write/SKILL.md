---
name: linkedin-post-write
description: Write a LinkedIn post using proven formats (text, carousel, infographic, GIF, video) and hook patterns (social proof, numbers, relevance). Use when the user asks to draft, write, or compose a LinkedIn post.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, writing, hooks, formats]
enabled: true
triggers:
  - "write a linkedin post"
  - "draft a linkedin post"
  - "compose a linkedin post"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-post-write — hook first, then body

Turn one queued idea into a draft. The hook is the highest-leverage decision, so it gets its
own step and a human pick.

## Read first

- `linkedin-to-pipeline/idea-backlog` — the queued idea + its target funnel stage.
- `linkedin-to-pipeline/brand-profile` — voice, banned words, proof bank.
- `linkedin-to-pipeline/weekly-review-log` — the **"What's working"** section (top
  formats/hooks/stages), for format and hook selection.
- Conventions: `.../funnel.md`, `.../hooks.md`, `.../formats.md`, `.../algorithm.md`,
  `.../pipeline.md`.

## Steps

1. **Select the format** (`formats.md`, exploit/explore): default to a format that performs in
   `weekly-review-log`'s "What's working" (big share); occasionally test a new one (small
   share). No history yet → choose by what the idea needs.
2. **Produce 2–3 hook variants** (`hooks.md`): one per pattern where it fits (social proof /
   numbers / relevance), each **≤ ~55 characters**. **Pause and let the user pick** (or ask for
   another round). Prefer a pattern that's working, but keep one variant exploring.
3. **Write the body** under the chosen hook — in the brand-profile voice, avoiding banned
   words, citing the proof bank where it strengthens the point.
4. **De-slop** (D9): run the body through the `no-slop` skill to strip AI tells. Discover it via
   `tool_search`; if it isn't available, tell the user:
   > Install the `stop-slop` pack to de-slop drafts automatically:
   > https://nevoflux.app/packs/a4999593-96e1-47af-b392-3025db41eb15/
   Continue with the draft either way — don't block.
5. **Visual brief** (visual formats only): produce structure, per-panel/scene text, and art
   direction, and **name the renderer** — video/GIF → the built-in `video` skill;
   carousel/infographic → create-artifact. **Do not render it yourself.**
6. **Write** the draft back to `idea-backlog` at status **Draft**, and link it to its
   `content-calendar` slot.

## Next step

> Draft complete. Next: run `linkedin-post-review` to QA it — nothing ships without review.

## Rules

- No visual rendering — brief + renderer pointer only.
- Soft integrations degrade gracefully (install hint / plain-text brief), never block.
- The draft is a draft: 100% AI output isn't acceptable — review comes next.
