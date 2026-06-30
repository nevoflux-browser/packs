# conventions: review rubric (STORM Prompt 4) — peer review

STORM's known weaknesses are no self-criticism, source bias, and fact-mismatch. This phase exists to
fix exactly those: grade your own briefing **adversarially**, as a skeptical reviewer would. **No new
retrieval** — everything is already sourced; the review judges what's on the pages, not the web.

## The five review outputs

1. **Confidence scores** — per major finding, a calibrated confidence + its **basis** (source count &
   quality, cross-perspective agreement, whether it was verified). Use the briefing's reliability
   tiers; **score unsourced or single-source load-bearing claims low** — that is correct, not a defect.
2. **Weakest link** — the single claim whose failure would most damage the conclusion. Name it, say
   **what would falsify it**, and how exposed the briefing is if it breaks.
3. **Bias check** — audit the STORM failure modes explicitly:
   - *Source bias* — over-reliance on one outlet/author/platform.
   - *False consensus* — perspectives agreeing because they share sources, not because they reasoned
     independently.
   - *Recency / availability* — loudest or newest sources crowding out better ones.
   - *Fact-mismatch* — a claim that has drifted from what its `[Source:]` actually supports. Spot-check
     the load-bearing citations.
4. **Missing sixth perspective** — the viewpoint none of the five covered (start from the contradiction
   map's **blind spot**). Name the lens that would most change the conclusion if added.
5. **Overall grade** — a letter grade (rubric below) + the **single biggest fix**.

## Grade rubric

- **A** — load-bearing claims sourced & cross-checked, contradictions resolved or flagged honestly,
  calibration-ready predictions, no unaddressed bias.
- **B** — sound and well-sourced, but a notable gap, an unverified high-risk claim, or a thin
  perspective.
- **C** — usable but with an unsourced load-bearing claim, a real bias, or an unresolved contradiction
  treated as settled.
- **D** — conclusion outruns the evidence, or key claims are reasoning dressed as fact. Don't ship;
  say what to redo.

## Deliverable

Write `research/<topic-slug>/review` (page model + links in `filing.md`); link
`review --reviews--> brief`. The grade and biggest-fix go into the run's final report.

This is the last quality gate before completion. **After** the review page is written, the run
completes (in the skill, not here): create the deferred `--about-->` edges, set `index.status` to
`complete` with a final `add_timeline_entry`, then render the read-only `create_artifact` snapshot of
the brief. Until `status: complete`, the subgraph stays invisible to compounding.
