# conventions: retrieval — grounding protocol

Two places retrieve: **scan-2** (ground each perspective) and **brief** (verify high-risk claims).
Nothing else retrieves. Retrieval is for quality, but unbounded retrieval is noise — obey the caps.

## Two retrieval tiers

- **Tier 1 — open web (default, Chat tier).** `web_search` + `web_fetch`. Cheap, no permission,
  covers the public web. **Always try Tier 1 first.**
- **Tier 2 — gated / JS-heavy sources (escalation only).** `browser_*` reading for login-walled or
  heavily client-rendered sites (X, LinkedIn, Reddit, 小红书, 知乎, …). **All `browser_*` tools go
  through `tool_call_dynamic`, which has no mode gate — Tier 2 is mode-agnostic** (no mid-run mode
  switch needed). Escalate in this order:
  - **Prefer an already-open, already-logged-in tab** (cheapest, no permission prompt):
    `browser_get_tabs`/`browser_query_tabs` → `browser_get_markdown`/`browser_get_content`, and
    `browser_eval_js` to nudge lazy/infinite-scroll content.
  - **No matching tab → autonomous read**: `browser_navigate` → `browser_scroll` + `browser_wait_for`
    (gated feeds lazy-render; one read grabs only the top) → `browser_get_markdown`. Works in **any**
    mode via `tool_call_dynamic`, but `browser_navigate` may raise a user permission prompt.

**Tier 2 triggers (only these):**
1. A scan-1 perspective's questions explicitly target a gated platform, **or**
2. Tier 1 `web_fetch` returns a login wall / empty client-rendered shell for a source you need.

**Tier 2 hard rules:**
- **The agent never logs in.** Entering credentials is prohibited. NevoFlux is the user's own
  browser — ride their **existing** session. If the needed site isn't open/authenticated, `ask_user`
  to have the **user** open it and log in themselves, then read the tab. Never type a password.
- **Autonomous crawl works in any mode, but Browser mode is smoother.** `browser_navigate` is
  reachable via `tool_call_dynamic` regardless of mode, so you *can* navigate from a Chat-mode run —
  but each navigation may raise a permission prompt. For heavy hands-off gated crawling, tell the user
  it's smoother to start `/research` in **Browser mode** (navigation is in-catalog there). Either way,
  prefer an already-open tab first to avoid prompts entirely.
- **Preserve provenance.** A gated URL can't be re-fetched without login, so a Tier-2 source must be
  saved: write a `sources/<n>` page and `tool_call_dynamic('put_raw_data', …)` the extracted markdown.
  Inline `[Source: url]` is not enough on its own here.

## scan-2 protocol (per surviving perspective)
1. Take the perspective's 2-4 pursuit questions from scan-1.
2. For each question: **Tier 1** `web_search` → pick the strongest 1-2 hits → `web_fetch` the full
   content (snippets are too thin to ground a position). **Escalate to Tier 2** only on a trigger
   above, preferring an already-open tab before navigating.
3. Extract the perspective's grounded position, strongest evidence, and unique insight from the
   fetched sources. Attach `[Source: url]` to every evidentiary claim.

**Caps (quality first, with a cost ceiling):**
- **≤ 4 questions per perspective.** More is marginal noise.
- **≤ ~15–20 unique `web_fetch` per run** (after dedupe), counting both scan-2 grounding and brief
  high-risk verification. A hard run-level ceiling so a 5-perspective fan-out can't explode into 40+
  fetches. v0.1 has no configurable budget (pack config is forbidden), so this structural cap is the
  cost guardrail — measure a real run's token + wall-clock cost once in smoke testing.
- **Dedupe sources** across perspectives — the same URL fetched once, cited many times.
- Promote a source to its own `sources/<n>` page only if it's **load-bearing or reused**; otherwise
  inline `[Source: url]` is enough (avoid page explosion).

## High-risk claim rule (brief phase verification)
In the synthesis, before committing a claim, verify it with targeted retrieval **iff** it is any of:
- **Load-bearing** — the briefing's conclusion or actionable insight depends on it.
- **Contested** — the contradiction map shows perspectives clashing on it.
- **Falsifiable / predictive** — a calibration-ready statement about the future.

Everything else (low-stakes background, framing, definitions) stays model-reasoned and is **marked as
reasoning**, not dressed up as sourced fact. The review phase will score unsourced claims lower —
that is correct and intended.

## Citation discipline
Follow `brain:conventions/quality.md` for citation format and reciprocal links. Every evidentiary
sentence carries `[Source: url]`. A briefing whose load-bearing claims lack sources is a failed run —
fix it before filing, because unsourced claims corrupt later `find_trajectory`/`find_contradictions`.
