# conventions: perspectives (STORM Prompt 1) — the five-perspective scan

scan-1 is cheap and **does not retrieve**. Its only job: turn the topic into **five distinct lenses**,
each framed to *this* topic, each with the 2-3 questions it will pursue in scan-2. Distinct lenses are
the whole point — five paraphrases of the same view waste the run. Each perspective must be able to
say something the others can't (its **unique insight**).

## The five fixed perspectives

Defaults for every topic. Frame each to the actual subject (don't recite the generic lens back).

| Role | Lens | Signature questions | Unique insight it owes |
| --- | --- | --- | --- |
| **Practitioner** | how it actually works in the field, hands-on | Who does this in practice? What breaks? Where does the day-to-day reality diverge from the pitch? | the gap between how it's *described* and how it's *used* |
| **Academic** | mechanism, theory, the evidence base | What's the underlying mechanism? What do primary/peer-reviewed sources show? Established vs contested? | the principle/model that explains the surface facts |
| **Skeptic** | the strongest case *against*, failure modes | What's the strongest disconfirming evidence? What would make this fail? Who disputes it, on what grounds? | the load-bearing assumption that, if false, collapses the consensus |
| **Economist** | incentives, costs, markets, second-order effects | What are the unit economics? Who captures the value / who pays? What do the incentives push toward? What happens at scale? | the incentive structure that explains *why* things are this way |
| **Historian** | precedent, prior cycles, what's genuinely new | What's the precedent? Has this been tried? What changed to make now different? | the recurring pattern — or the genuine discontinuity |

## Framing rules

- **Frame, don't generalize.** "Skeptic on `<topic>`: is the claimed X actually Y, given Z?" — not
  "the Skeptic doubts things."
- **2-3 pursuit questions per perspective at scan-1.** scan-2 may expand to ≤4 (cap in
  `retrieval.md`); keep them sharp and answerable by retrieval, not rhetorical.
- **No retrieval here.** scan-1 is reasoning only — the five framings are a plan, not yet grounded.

## Steering (the ★ checkpoint)

The five are **defaults, not a fixed set**. At the checkpoint the user may drop, swap, or add
perspectives before any retrieval is spent. A topic often wants a **topic-specific sixth** — e.g.
*Regulator* (policy/legal), *Ethicist* (harms/rights), *Technologist* (what's now feasible),
*Operator* (who runs it at scale). Propose one if it's obviously load-bearing for this topic.

**Never proceed with zero perspectives.** If the user prunes them all, re-ask for at least one before
scan-2 — an empty perspective set produces an empty briefing.

## Deliverable (written in scan-2, not here)

Each surviving perspective becomes a `research/<topic-slug>/perspectives/<role>` page —
**stance / strongest evidence / unique insight**, every evidentiary claim carrying `[Source:]`
(see `filing.md`). At scan-1 you only hold the framings + questions in working state; you write the
pages once scan-2 has grounded them.
