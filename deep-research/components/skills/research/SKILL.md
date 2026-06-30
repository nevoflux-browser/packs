---
name: research
description: Deep research via the Stanford STORM/Co-STORM method — runs a 5-perspective scan, a contradiction map, a synthesis briefing, and a peer review, with one user-steering checkpoint, grounded in real web retrieval and filed into the user's brain (gbrain) as a linked, reusable research subgraph. Use for "research X deeply", "deep research", "/research", "STORM", 深度研究, 多视角研究, 帮我研究.
version: "0.1.0"
author: "NevoFlux"
tags: [research, storm, co-storm, deep-research, multi-perspective, gbrain, brain]
enabled: true
triggers:
  - "/research"
  - "deep research"
  - "research deeply"
  - "STORM"
  - "深度研究"
  - "多视角研究"
  - "帮我研究"
dependencies:
  - "brain:conventions/brain-first.md"
  - "brain:conventions/quality.md"
# allowed_tools for a SKILL is an AVAILABILITY GATE, not a restriction (nevoflux skills
# crate: check_tool_availability). List ONLY tools that are in the run's static catalog.
# Listing a tool that isn't in the catalog for the run's mode — e.g. browser_navigate in a
# Chat-mode run — makes the gate report Missing and the skill SILENTLY FAILS TO INJECT.
# Everything else this skill drives (all browser_*, all gbrain tools, ask_user, web_search,
# web_fetch) is reached at runtime via tool_call_dynamic, which has NO mode gate — so those
# must NOT be listed here. tool_search + tool_call_dynamic are in every mode's catalog.
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# research — STORM/Co-STORM deep research

Turn a topic into a **multi-perspective, contradiction-aware, peer-reviewed briefing** that is
**grounded in real sources** and **filed into the user's brain** so it persists and compounds across
future research.

Method = the Stanford STORM four-step thinking (multi-perspective scan → contradiction map →
synthesis → peer review), upgraded for NevoFlux with real retrieval, a user-steering checkpoint, and
gbrain persistence. Do **not** invent a STORM algorithm — orchestrate the phases below.

## Operating rules (always apply)

- **Reach non-catalog tools via `tool_call_dynamic`.** Only `tool_search` + `tool_call_dynamic` are
  in `allowed_tools`. Everything else this skill drives — **all gbrain tools, all `browser_*` tools,
  and `ask_user`** — is reached by `tool_search` (discover) → `tool_call_dynamic` (invoke).
  `tool_call_dynamic` has **no mode gate**, so this works the same in Chat, Browser, or Agent mode.
  Never call `brain_*` directly (not registered → silent no-op), and don't assume `browser_*` /
  `ask_user` are in the static catalog — dispatch them dynamically.
- **Ground claims in real sources.** Phases that say "retrieve" mean actual `web_search` +
  `web_fetch`, with inline `[Source: url]`. Never fabricate a perspective's evidence.
- **Two retrieval tiers** (`conventions/retrieval.md`): **Tier 1** open web (`web_search`/`web_fetch`,
  default) → **Tier 2** gated/JS-heavy sources via `browser_*` (all through `tool_call_dynamic`).
  Tier 2 is **mode-agnostic** — there is no mid-run mode switch and you don't need one:
  - **Prefer an already-open, already-logged-in tab** (cheapest, no permission prompt):
    `browser_get_tabs`/`browser_query_tabs` → `browser_get_markdown`/`browser_get_content`
    (`browser_eval_js` to nudge lazy/infinite-scroll content).
  - **No matching tab → autonomous read**: `browser_navigate` → `browser_scroll`/`browser_wait_for`
    → `browser_get_markdown`. Works in **any** mode via `tool_call_dynamic`, but navigation may raise
    a user permission prompt; for heavy gated crawling tell the user it's smoother to start
    `/research` in **Browser mode**.
  **Never log in for the user** — entering credentials is prohibited; ride their existing session. If
  a needed site isn't open/authenticated, `ask_user` to have the user open + log in themselves.
- **File into the brain** under the `research/<topic-slug>/` namespace, following the brain page
  model and quality conventions (`skill_read('brain', 'conventions/brain-first.md')` and
  `'conventions/quality.md')`): `compiled_truth` above the `---`, append-only newest-first
  `timeline` below, cite every fact, create reciprocal links.
- **Mark completion; compound only what's complete.** The `index` carries a `status`
  (`in_progress` → `complete`): set `in_progress` at the start, `complete` only after review.
  Cross-research compounding (`--about-->` edges, `find_contradictions`/`find_trajectory` over past
  work) covers **only `complete`** subgraphs, so a half-finished run never pollutes future research
  (see `conventions/filing.md`).
- **Honest calibration.** You can write predictions in calibratable form, but the client cannot
  create or resolve takes — never claim a finding is "tracked" or "scored". Say "calibration-ready".

## Pipeline

Run the phases in order. Read the matching convention file at the start of each phase.

### Phase 0 — preflight  (before anything else)
This pack **requires the `brain` pack**. Confirm gbrain is reachable: `tool_search` for `brain`
(retry once with `知识库` / `gbrain`). If no gbrain tools surface, **stop immediately** — tell the
user "research-pack requires the `brain` pack; install it first" — before spending any retrieval.
Then **set expectations**: tell the user this is a multi-source deep-research run that takes a few
minutes and makes many web calls (not an instant answer). Create the `research/<topic-slug>/index`
page with `status: in_progress`.

### Phase scan-1 — perspective discovery  (cheap, no retrieval)
`skill_read('research', 'conventions/perspectives.md')`.
Propose the **five fixed perspectives** (Practitioner / Academic / Skeptic / Economist / Historian)
framed to *this* topic — just each one's angle and the 2-3 questions it will pursue. No web calls yet.

### ★ User-steering checkpoint
Present the five framed perspectives and call `ask_user` (via `tool_call_dynamic`) to let the user
add, remove, or replace perspectives before you spend retrieval. The answer returns inline and the run
continues (the call blocks until the user responds, up to the tool's timeout). **Never proceed with
zero perspectives** — if the user prunes them all, re-ask for at least one before scan-2. (Co-STORM
user-steering; in v0.2 a moderator automates this per round.)

### Phase scan-2 — perspective-guided question asking + retrieval
`skill_read('research', 'conventions/retrieval.md')`.
For **each surviving perspective**: generate its 2-4 questions, run **Tier 1** `web_search`,
`web_fetch` the strongest hits, and extract that perspective's grounded position (use the run's
**current model** — no model tiering). If a perspective targets a gated platform or Tier 1 hits a
login wall, go **Tier 2** per `retrieval.md` (all `browser_*` via `tool_call_dynamic`): **first** look
for an already-open, logged-in tab (`browser_get_tabs` → `browser_get_markdown`, `browser_eval_js` to
nudge lazy content); **only if none**, `browser_navigate` → `browser_scroll`/`browser_wait_for` →
`browser_get_markdown` (may prompt for permission). Never log in yourself — `ask_user` to have the
user open/log in if needed. Then `tool_call_dynamic('put_raw_data', …)` the gated extract onto a
`sources/<n>` page (gated URLs can't be re-fetched). Write one gbrain page per perspective (see
`conventions/filing.md`). **Respect the caps in `retrieval.md`: ≤4 questions per perspective AND
≤~15–20 unique `web_fetch` per run; dedupe sources** across perspectives.

### Phase map — contradiction map
`skill_read('research', 'conventions/contradiction.md')`.
Use gbrain `think` (via `tool_call_dynamic('think', {question, anchor: 'research/<topic-slug>/index'})`
— `anchor` pulls the research subgraph, so the perspective/source pages must already be written and
linked) to surface conflicts, strongest/weakest evidence, the resolving question, the consensus, and
the blind spot. For *first-time* topics compute this live; use `find_contradictions` only to pull in
contradictions against the user's **past, `complete`** research. Write the `contradictions` page.

### Phase brief — synthesis
`skill_read('research', 'conventions/brief-format.md')`.
Synthesize into the five-part briefing. Before committing any **high-risk claim** (load-bearing /
contested / falsifiable — rule in `retrieval.md`), verify it with targeted retrieval (counts against
the run-level `web_fetch` cap). Write the `brief` page; set its `compiled_truth` to the one-paragraph
CEO summary. **Do not create `--about-->` edges yet** — they are deferred to completion (see review).

### Phase review — peer review  → completion
`skill_read('research', 'conventions/review-rubric.md')`.
Grade your own briefing: confidence scores, weakest link, bias check, missing 6th perspective,
overall grade. **No new retrieval** — everything is already sourced. Write the `review` page. Then
**complete the run**, in this order:
1. Create the `index` `--about-->` edges into existing brain entities (companies / concepts / people)
   so the research compounds — deferred to here so a half-finished run never wires into the graph.
2. Set the `index` `status` to `complete`, then `add_timeline_entry` (graded `<grade>`).
3. **Render the deliverable**: `tool_call_dynamic('create_artifact', {content_type: 'text/markdown',
   …})` with the brief as a **read-only snapshot view** — label it with the live slug
   `research/<topic-slug>/brief`. The gbrain `brief` page stays the single source of truth; the
   artifact is a one-time render, never written back to and not part of compounding.

## Output format

After the run, report concisely:
- **Index** — `research/<topic-slug>/index` (the hub; CEO summary in its `compiled_truth`; `status: complete`)
- **Pages written** — perspectives/*, contradictions, brief, review, sources/*
- **Linked into** — which existing brain entities got `--about-->` back-links
- **Deliverable** — the `create_artifact` snapshot of the brief (live page: `research/<topic-slug>/brief`)
- **Grade** — the review's overall grade + the single biggest fix it flagged

## Anti-patterns

Don't:
- **Skip the steering checkpoint** — retrieving for all five before the user prunes wastes the run.
- **Proceed with zero perspectives** — if the user prunes them all, re-ask for at least one.
- **Retrieve per sentence** — retrieval is for perspective grounding (scan-2) and high-risk
  verification (brief) only; low-stakes background stays reasoned. Stay under the run-level fetch cap.
- **Write a brief with no `[Source:]`** on load-bearing claims — unsourced research pollutes the
  graph and corrupts later `find_trajectory`/`find_contradictions`.
- **Call `brain_*`, `browser_*`, or `ask_user` from the static catalog** — reach them all via
  `tool_search`/`tool_call_dynamic`; don't list `browser_*` in `allowed_tools` (it makes the skill
  fail its availability gate and silently not inject in a Chat-mode run).
- **Claim auto-calibration** — the pack produces calibration-ready artifacts, nothing more.
- **Log in or type credentials for the user** — ride their existing session; if not authenticated,
  ask them to log in. Never automate a password or accept a login form.
- **Wire `--about-->` before the run is `complete`**, or treat the `create_artifact` snapshot as the
  source of truth — the gbrain `brief` page is canonical; the artifact is a one-time view.
- **Leave a completed run unlinked** — without `--about-->` edges into existing entities it can't compound.
