# conventions: contradiction map (STORM Prompt 2)

The fights between perspectives are where real understanding lives. Run this over the **grounded**
perspective + source pages from scan-2 — not over raw model opinion.

## How to compute it
- **First-time topic** → compute live with gbrain `think`: `tool_search` → `tool_call_dynamic('think',
  {question: '<the contradiction question>', anchor: 'research/<topic-slug>/index'})`. `anchor` pulls
  the entity subgraph around the index, so it reaches the perspective + source pages **only if they're
  already written and linked** (put_page → add_link must run before think — a hard ordering
  dependency). If the default anchor depth doesn't reach all perspective/source pages, widen it
  (`rounds > 1` or an explicit `depth`) — verify the right depth in smoke testing. `think` returns a
  cited answer with conflict/gap analysis — that *is* the contradiction map engine.
- **Pull in history** → also `tool_call_dynamic('find_contradictions', …)` to surface contradictions
  between this topic and the user's **past, `complete`** research (this is where compounding pays off;
  filter out `in_progress` subgraphs). Do not rely on it for the current topic's contradictions — it
  reports *cached* findings only.

## The five outputs (STORM Prompt 2)
1. **Direct conflicts** — where two+ perspectives contradict. List each with the **specific clashing
   claims** (and their `[Source:]`), not vague "they disagree".
2. **Strongest vs weakest evidence** — which perspective is best-supported, which is weakest, why.
3. **The resolving question** — the single question that, if answered, would settle the biggest
   contradiction.
4. **The consensus** — what **every** perspective agrees on. Even opponents confirm it → likely true.
5. **The blind spot** — what **none** of the perspectives addressed. This is the gap in the field
   and is often the most valuable finding. Cross-check with `think`'s gap analysis / `find_orphans`.

The blind spot is also the seed for v0.2's moderator: the thing to inject a new perspective about.

## Deliverable
Write `research/<topic-slug>/contradictions` (see `filing.md`), linked `--derived_from-->` each
perspective page it draws on.
