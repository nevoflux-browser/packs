# conventions: filing — gbrain slug scheme & links (the mind map)

All research is filed under the `research/` namespace following the brain page model
(`skill_read('brain', 'conventions/brain-first.md')`) and quality rules
(`skill_read('brain', 'conventions/quality.md')`). Reach every gbrain tool via `tool_search` →
`tool_call_dynamic`.

`<t>` = the topic slugified (lowercase, hyphenated, stable). Confirm with `resolve_slugs` first so a
re-run on the same topic **updates** rather than duplicates.

## Pages
```
research/<t>/index               hub. compiled_truth = CEO summary. status = in_progress|complete. timeline = run trace.
research/<t>/perspectives/<role> one per surviving perspective (practitioner|academic|skeptic|economist|historian|…)
research/<t>/sources/<n>         only for load-bearing / reused sources; else inline [Source: url].
                                 Tier-2 (gated) sources MUST be a page + put_raw_data (un-refetchable).
research/<t>/contradictions      the contradiction map
research/<t>/brief               the synthesis briefing (main deliverable)
research/<t>/review              the peer review
```
Page model on every page: `compiled_truth` above the `---`, append-only newest-first `timeline`
below. Rewrite `compiled_truth`, never append to it; never rewrite timeline history.

## Run status (completeness gate)
The `index` carries a `status`: set `in_progress` when the index is first created (Phase 0), and
`complete` only at the end of the review phase. **Compounding reads only `complete` subgraphs** — when
running `find_contradictions` / `find_trajectory` over the user's past research, filter to
`status: complete` so a half-finished or unreviewed run never feeds future research. A crash mid-run
thus leaves an isolated `in_progress` draft that is invisible to compounding and harmless.

## Typed links (this graph *is* the Co-STORM mind map)
`link_type` is a **free-form string** (gbrain examples: `invested_in`, `works_at`) — no fixed enum.
Use consistent snake_case. Create with `add_link({from, to, link_type, context})` + the reciprocal
back-link (per quality.md):
```
index            --has_perspective-->  perspectives/*
perspectives/*   --cites-->            sources/*
contradictions   --derived_from-->     perspectives/*
brief            --synthesizes-->      perspectives/*, contradictions
review           --reviews-->          brief
index            --about-->            <existing brain entities: companies/x, concepts/y, people/z>
```
The `--about-->` edges are what make research **compound**: they wire this run into the user's
existing graph so later `find_experts` / `find_trajectory` / `find_contradictions` can reach across
past research. **Create them only at completion — after the review phase, as `index.status` is set to
`complete`** (not during scan-2/brief), so a run that dies mid-pipeline never wires a half-finished
subgraph into the main graph. Never skip them on a completed run. To walk them later:
`traverse_graph({slug: '<entity>', direction: 'both', link_type: 'about', depth: 2})`
(depth default 5, capped at 10; direction in|out|both).

## Timeline (the discourse trace)
`add_timeline_entry` on `index` at each phase boundary: perspectives discovered, user pruned/added X,
scan-2 grounded, contradiction map written, brief written, graded `<grade>`. This is the auditable
run trace and the seed of v0.2's per-round discourse log.

## Re-runs
On a repeated topic: `resolve_slugs` → update the existing `index` and pages, append new timeline
entries, refresh `compiled_truth`. If the existing `index` is `status: in_progress` (a prior run
crashed mid-pipeline), treat it as a resume/redo: the pages are idempotent, so re-run the phases to
overwrite the draft and set `complete` at the end — no special checkpoint recovery needed. Use
`find_trajectory` on the topic entity to show how the briefing changed across runs.
