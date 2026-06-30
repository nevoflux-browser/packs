# conventions: brief format (STORM Prompt 3) — the synthesis briefing

The `brief` is the main deliverable. It synthesizes the grounded perspective pages + the contradiction
map into one decision-ready document. It does **not** introduce new perspectives or dump raw sources —
it *resolves* them into findings the reader can act on.

## The five parts

1. **CEO summary** — one tight paragraph: what's true, why it matters, what to do. This becomes the
   `index` (and `brief`) **`compiled_truth`** verbatim, so write it to stand alone.
2. **Findings, ranked by reliability** — ~5 findings, **most-reliable first** (see ranking below).
   Each finding is one claim + its support + `[Source:]`. Rank, don't flatten — the ordering *is*
   information.
3. **Hidden connections** — links the perspectives didn't see individually: where Practitioner reality
   explains an Economist incentive, where the Historian's precedent predicts the Skeptic's failure
   mode. This is the value synthesis adds over five separate reads.
4. **Action recommendations** — concrete next moves the findings justify. Tie each to the finding(s)
   it rests on; don't recommend past the evidence.
5. **Frontier questions** — the open questions that matter most, led by the contradiction map's
   *resolving question* and *blind spot*. What to research next, and why it's decisive.

## Reliability ranking (part 2)

Order findings by support strength:

- **High** — multiple independent sources **and** cross-perspective agreement (even opponents concede
  it → likely true).
- **Medium** — sourced but single-source, or contested in the contradiction map.
- **Low / reasoned** — inference or framing with no direct source. **Mark it as reasoning**, don't
  dress it as sourced fact. (The review phase scores unsourced load-bearing claims lower — intended.)

## Calibration-ready writing

Predictive or contested claims must be written so they *could* be checked later:

- **Falsifiable** — state what would prove it wrong, and by when. "X will Y by <date>" beats "X looks
  promising."
- **Confidence-tagged** — attach an explicit confidence (high/medium/low or %), grounded in the
  reliability tier, not vibes.
- **Honest framing** — the client cannot create or resolve takes. Never say a prediction is "tracked"
  or "scored"; say **calibration-ready**.

## Source & verification discipline

- Every **load-bearing** claim carries `[Source:]`. A briefing whose conclusions lack sources is a
  failed run — it corrupts later `find_trajectory`/`find_contradictions`.
- Before committing any **high-risk claim** (load-bearing / contested / falsifiable — rule in
  `retrieval.md`), verify it with targeted retrieval. This counts against the run-level `web_fetch`
  cap; stay under it.

## Deliverable

Write `research/<topic-slug>/brief` (page model + links in `filing.md`): set `compiled_truth` to the
CEO summary; link `brief --synthesizes--> perspectives/*, contradictions`. **Do not create
`--about-->` edges here** — they are deferred to completion (after review), so a run that dies before
review never wires a half-finished subgraph into the user's graph.
