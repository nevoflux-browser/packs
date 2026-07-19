# Story mining — lenses, gates, dedup, ranking

The methodology's highest-value input is internal knowledge: *"The people doing the work day
to day have the stories worth telling. Our job is to interview the team, pull those stories
out, and turn them into posts."* This file defines the how: what to look through (**lenses**),
what survives (**gates**), what to drop (**dedup**), and what goes first (**ranking**).

## Nine story lenses

Run the team's material (people, product, users — the Internal layer of
`linkedin-to-pipeline/idea-sources`) through each lens. Each maps naturally to a funnel
stage; the hook column is a **hint, not an assignment** — hook choice belongs to
`linkedin-post-write`.

| Lens | Trigger signal | Stage | Natural hook |
|---|---|---|---|
| Repeated question | Same question answered ≥3 times | MOFU how-to / framework | Relevance |
| Problem → solution | A real client/internal problem got solved | MOFU / BOFU | Relevance |
| Before → after | A real number moved | BOFU case study | Numbers / social proof |
| Just shipped | A real release / commit / changelog entry | BOFU demo / MOFU how-to | Numbers |
| Mistake → lesson | A real failure plus what it taught | TOFU story | Relevance |
| Contrarian take | An opinion you can back with firsthand experience | TOFU opinion | Relevance |
| Behind the scenes / milestone | A real moment worth showing | TOFU story | Social proof |
| User signal | A user asked / complained / praised (real artifact) | MOFU / BOFU | Social proof |
| Toolbox / stack | Tools, workflows, resources you actually use | TOFU resource list / MOFU tech stack | Numbers |

**The lenses double as the interview question bank.** The layered interview:
*artifact-first* (pull GitHub releases/commits, changelog, teammates' posts/talks, user
feedback — cheap, always available) → *model synthesis* (run the artifacts through the lenses
to produce candidate stories) → *light human grill* only for gaps and ambiguity, **seeded by
the artifacts** ("I saw you merged X last week — what broke before?"). Never a cold
interview.

**Explicit exclusion:** BOFU handraiser / free-audit posts are not mined stories — generate
them directly from the `brand-profile` offer.

## Four hard gates — all must pass

1. **Specific** — a real event, number, or artifact. No generalities.
2. **Has an engine** — *tension* for narratives (change, contrast, conflict, reversal), or
   *utility* for lists and how-tos (save-worthy usefulness). No engine, no readers.
3. **Reader-relevant** — lands on an ICP pain from `brand-profile`. A story only the team
   finds interesting is not pipeline.
4. **Provable / authentic** — anchored in a real artifact, a real number, or (for opinion
   posts) firsthand experience you can defend. If you can't back it, you can't post it.

Fail one gate → kill the candidate. Typical kills: thought-leadership with no underlying
event; internal trivia with no ICP relevance; a hot take with no evidence.

## Dedup

- Same story + same angle + same stage as an existing backlog item or published post →
  **duplicate — drop it**.
- Same story + a new angle or format → **not a duplicate**: route it to
  `linkedin-post-repurpose` instead.

## Ranking — and where heat fits

Order gate-passing candidates by priority: **provable > reader-relevant > engine strength**.

**Industry heat is an amplifier, not a gate:**

- Boost candidates that plug into a live conversation in the niche (heat ≈ frequency ×
  freshness of a topic across the External sources).
- Weight heat **high for TOFU opinion** posts (opinions feed on discourse), **low for BOFU
  case studies** (cases are evergreen).
- Heat may also **initiate**: start from a hot topic in the niche, then search the Internal
  layer for evidence or an angle that can carry it. Found → proceed through the gates as
  usual. Not found → discard the topic.
- **Guardrail:** hot but failing the provable gate → discard. Chasing one viral spike is the
  wrong goal (`algorithm.md`); never ship a take you can't back.

## Output discipline

- Mine **toward the open slots**; stop when each open slot has **2–3 surviving candidates**.
  Surface them with a one-line "why" each and let the user pick — the idea matters more than
  the draft (mirrors `post-write`'s hook-variant step).
- Slot match → queue the pick in `idea-backlog` for that slot. Gate-passing but no current
  slot → **bank it** in the backlog tagged with its natural stage; the backlog stays deeper
  than the slots (`calendar-arc.md`).
- Durable proof points discovered while mining (a number, a named win) → collect them and, at
  session end, offer a **batch confirmation** to append them to the `brand-profile` proof
  bank. **Never append without confirmation** — the proof bank is the pack's factual
  baseline; `post-review` verifies claims against it, so an unconfirmed append would make
  that check circular.
