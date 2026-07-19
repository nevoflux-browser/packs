---
name: linkedin-idea-mining
description: Mine LinkedIn post ideas to fill the calendar's open funnel slots, from internal knowledge, competitor analysis, and weekly performance data. Use when the user asks for content ideas, what to post, or wants to brainstorm LinkedIn topics.
version: "0.2.0"
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
of. The full mining standard — lenses, gates, dedup, ranking — lives in
`conventions/story-mining.md`; read it before mining.

## Read first

- `linkedin-to-pipeline/content-calendar` — the **open slots** and their target stages. This
  is your brief ("I need 2 TOFU stories + 1 BOFU case study for the next two weeks").
- `linkedin-to-pipeline/brand-profile` — positioning, ICP, proof bank (context for relevance
  and for seeding the interview).
- `linkedin-to-pipeline/idea-sources` — **two layers**: Internal (the team, broadly — people,
  product, users) and External (the market), each with its mining rules.
- `linkedin-to-pipeline/weekly-review-log` — what's been resonating.
- `linkedin-to-pipeline/idea-backlog` — existing items and shipped posts, for dedup.
- Conventions: `.../story-mining.md` (the standard), `.../funnel.md`, `.../pipeline.md`.

## The three inputs (from the methodology)

1. **Internal knowledge — the team's own material.** *"The people doing the work day to day
   have the stories worth telling. Our job is to interview the team and pull those stories
   out."* Work the Internal layer of `idea-sources` in three passes:
   - *Artifact-first:* pull the team's real material — GitHub releases/commits, changelog,
     teammates' posts/talks, user feedback. Cheap, always available.
   - *Synthesis:* run the artifacts through the **story lenses** (`story-mining.md`) to
     produce candidate stories.
   - *Light human grill:* only for gaps and ambiguity — 2–4 targeted questions **seeded by
     the artifacts** ("I saw you shipped X last week — what broke before?"). The lenses
     double as the question bank. Never a cold interview.
2. **Market awareness — the External layer.** What the niche cares about, what competitors
   do, where the live conversations are:
   - *Passive:* scan the user's **open browser tabs**; mine any whose domain matches a
     configured source.
   - *Active:* fetch configured external sources (reddit, x.com, 知乎, 小红书, 微博,
     competitor profiles) directly.
   External gives the timing and the angle; Internal gives the evidence. A live topic
   carried by your own proof is the strongest post.
3. **Performance feedback** — recent wins/patterns from `weekly-review-log`.

## Steps

1. Load the open slots and their target stages.
2. Gather material: Internal artifacts (plus a light grill if needed) and External signals.
3. Apply the **nine story lenses**, then the **four hard gates** (specific / has an engine /
   reader-relevant / provable) — kill anything that fails one. **Dedup** against the backlog
   and shipped posts; same story in a new format is not a dup — route it to
   `linkedin-post-repurpose`.
4. **Rank** survivors: provable > reader-relevant > engine strength, with industry heat as
   amplifier/tiebreaker — and as initiator only when the Internal layer yields evidence to
   carry the topic (`story-mining.md`).
5. **Surface 2–3 candidates per open slot**, each with a one-line "why". The user picks.
6. **Write** picked ideas to `linkedin-to-pipeline/idea-backlog` at status **Idea** — slot
   matches queue for their slot; gate-passing ideas with no current slot are banked with
   their natural stage (the backlog stays deeper than the slots).
7. **Proof-bank write-back:** collect durable proof points found while mining and, at session
   end, offer a **batch confirmation** to append them to the brand-profile proof bank. Never
   append without confirmation — the proof bank is the pack's factual baseline.

## Next step

> Ideas mapped to slots. Next: run `linkedin-post-write` on the first queued slot.

## Rules

- **External sourcing is read-only** — reddit/github/tabs are for inspiration; never post or
  write anything externally. Reach browser/web tools via `tool_search` → `tool_call_dynamic`.
- Mine toward open slots first; bank stray gate-passing ideas, but don't drift off-ratio.
- Never ship a hot take you can't back — heat without the provable gate is a discard.
