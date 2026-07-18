---
name: linkedin-post-review
description: Review and QA a LinkedIn post draft against the pipeline standards before it ships. Use when the user asks to review, check, or edit a LinkedIn post draft.
version: "0.1.0"
author: "doris"
tags: [linkedin, content, review, qa, editing]
enabled: true
triggers:
  - "review my linkedin post"
  - "check this linkedin draft"
  - "edit this linkedin post"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# linkedin-post-review — the hard gate

Nothing ships without this pass. Review is a distinct role from writing (see `pipeline.md`):
its job is to catch what the writer missed, and it can **send a draft back to Draft**.

## Read first

- `linkedin-to-pipeline/idea-backlog` — the draft under review.
- `linkedin-to-pipeline/brand-profile` — voice and banned words to check against.
- Conventions: `.../pipeline.md` (and `.../hooks.md` for hook length).

## QA checklist

1. **De-slop gate** (D9): re-run the body through the `no-slop` skill. If it isn't available,
   surface the install hint (stop-slop pack) and do a manual AI-tell pass instead of skipping.
2. **Voice & banned words** — matches `brand-profile`; no banned phrases.
3. **Hook** — specific, and ideally ≤ ~55 characters.
4. **Proof accuracy** — every claim/number cited from the proof bank is real and correct.
5. **Format fit** — the format matches what the idea needs; the visual brief is complete.
6. **Human pass** — a person has actually read it. 100% AI output isn't acceptable.

## Outcome

- **Pass** → set the item's status to cleared/Review-passed and advance.
- **Fail** → send it back to `linkedin-post-write` with **specific fixes**, not vague notes.

## Next step (on pass)

> Cleared. Next: run `linkedin-post-publish` to finalize and hand off (schedule via LinkedIn's
> native scheduler if not posting now).

## Rules

- Reviewing is not rewriting — flag and route back; large rewrites belong to `post-write`.
- The de-slop check here is a gate, not optional.
