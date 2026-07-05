---
name: learn
description: Learn from any source — the current page, a URL, multiple tabs, GitHub skill repos, web skill portals, local files, or GBrain — and generate a capability-valid NevoFlux pack in a directory you choose. A pure generator that writes files only and never installs. Runs in agent mode. Use for "learn a skill that does X", "turn this into a pack", 学一个 X 的 skill, 把这个做成 pack.
version: "0.1.1"
author: dorisgyl
tags: [meta, pack, skill, generator, learn, capability]
enabled: true
triggers:
  - "/learn"
  - "learn a skill"
  - "turn this into a pack"
  - "make a pack from"
  - "学一个"
  - "把这个做成 pack"
  - "做一个 pack"
# allowed_tools is an AVAILABILITY GATE, not a restriction (nevoflux skills crate:
# check_tool_availability). List ONLY tools present in every mode's catalog so the skill
# always injects; then probe for agent mode in the body. learn reaches gbrain/browser/MCP
# via tool_call_dynamic; file/exec tools (read/write/glob/bash) are native-only and called
# directly — they are NOT reachable via tool_call_dynamic, so they must NOT be listed here.
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# learn — generate a compliant NevoFlux pack from any source

Take any knowledge source and produce a **capability-valid, installable NevoFlux pack** in a directory
the user names. learn is a **pure generator**: it writes pack files and stops — it does **not** install
(the user installs with the existing pack tools). Same "heavy skill, zero new Rust, borrowed tools"
model as skill-creator, packaged as an installable pack.

Read the authoring reference first: `skill_read('learn', 'references/pack-authoring.md')` — it holds the
5 capability invariants, the tool-name mapping, and the generation checklist. *(reference file authored
separately — this is the skill skeleton.)*

## Operating rules (always apply)

- **Agent mode is required — probe for it first.** learn writes files (`read`/`write`/`glob`/`bash` are
  agent-mode tools). There is no runtime mode query, so **probe by capability**: if `write`/`read`/`glob`/
  `bash` are not in your tool list, you are **not** in agent mode — **stop and tell the user to switch to
  agent mode** before doing anything else.
- **Tool routing — two naming worlds; get this right or generated packs silently fail:**
  - **File / exec: native names, called DIRECTLY** — `read` / `write` / `glob` / `bash` / `edit` / `grep`.
    **Never route these through `tool_call_dynamic`** — it returns `unknown tool` (silent failure).
  - **gbrain / browser_* / MCP-server tools: via `tool_search` → `tool_call_dynamic`** (no mode gate).
  - **Web: `web_search` / `web_fetch` directly** (`fetch_page` is an alias; `WebSearch`/`WebFetch` are
    internal enum names, not tools).
  - Rewriting a source skill's tools into a generated pack uses `pack-authoring.md`'s mapping table —
    **verify every name against the live tool registry** (the engine changes; the table can go stale).
- **Ask for the output directory if unspecified.** Never pick a directory yourself — if the user didn't
  name one, ask, and only generate once they confirm.
- **Pure generator, never install.** Write files, validate, then tell the user how to install with the
  existing pack tools. Do **not** call `pack.install`.
- **License honesty.** Fill `license` truthfully; unreadable/absent → `unknown` → pure-learning (no
  rewrite). Never guess a license. Scope + precedence in `pack-authoring.md`.

## Pipeline — Ingest → License gate → Synthesize → Emit

### 1 — Ingest (gather source material into one pool)
- **Passive:** current page / tabs (`browser_get_markdown` / `browser_get_tabs` via `tool_call_dynamic`),
  a URL (`web_fetch`), local files (`read` / `glob`), GBrain (brain tools via `tool_call_dynamic`).
- **Active search — site-bounded, not open-web (G4):** `web_search` with `site:` restricted to the
  built-in skill sites (skills.sh / ClawHub / LobeHub / browse.sh + GitHub skill repos), 1–2 hits per
  site, each tagged with its license; present candidates, user picks or "none".
- **Complete fetch of a chosen skill (never ship half a skill):**
  - **GitHub source (preferred):** one `bash` `curl -L codeload.github.com/{owner}/{repo}/tar.gz/{ref}`
    → `tar xz` → read the skill subdir locally with `read`/`glob`. One download, deterministic, no API
    rate limits. (Fallback if no `curl`/`tar`: `web_fetch` the few `raw.githubusercontent.com` files.)
  - **Web portal source (three layers):** ① try to resolve the underlying GitHub repo and fall back to
    the tarball; ② if it's a pure portal, best-effort relative-URL fetch of referenced files (no per-site
    adapters); ③ **if any referenced file is missing, do NOT silently ship a half pack** — surface the
    gap and let the user decide (provide the file / generate-with-missing-marked / switch source).

### 2 — License gate
Classify each source (most-specific-wins: file/frontmatter > dir LICENSE > repo LICENSE; **any unknown
layer → `unknown`**). MIT/Apache → rewrite + carry attribution; copyleft → rewrite + warn on terms;
unknown/none → **pure-learning only** unless the user explicitly overrides; mixed → take the strictest.
Record `license` + `license_source` for provenance.

### 3 — Synthesize (heterogeneous material → one compliant pack — the hard part)
- **Plan components with the user (G2/G3):** propose skills / seed / canvas_tools **one at a time**, each
  as a question with a recommended answer; generate only after agreement. Default minimal (skills only)
  unless the material clearly supports more. **Never generate `[components.knowledge]`** — install
  hard-rejects it (platform gap); route domain knowledge to `[components.seed]`.
- **Suggest the namespace (G5):** derive from `pack.name`; user can change it.
- **Rewrite tool names** to NevoFlux per the routing rules + mapping table.
- Satisfy the **5 capability invariants** as you generate (path-traversal-safe relative paths; no
  `[components.config]`; slugs namespaced; every seed slug covered by protected; dashboard `artifact_id`
  starts with pack name). Details in `pack-authoring.md`.

### 4 — Emit (write files; the real validator gates delivery)
- Write the pack under `<output-dir>/<pack-name>/` (layout below).
- **Delivery gate = the real validator, not a mental check:** `bash nevoflux pack validate
  <dir>/<pack-name>/pack.toml` (same `capability::validate` as install, read-only). Parse violations; if
  not clean, return to synthesis and regenerate — loop until clean. If the `nevoflux` CLI isn't on PATH,
  fall back to the bundled `scripts/validate-pack.sh`.
- Write `.provenance.json` (a **non-component** file — not declared in pack.toml) recording each source,
  its `license` + `license_source`, and the processing `mode`.
- Tell the user the generated path and how to install with the existing pack tools. **Do not install.**

### Generated layout
```
<pack-name>/
  pack.toml              # passes the 5 capability invariants
  skills/<skill>/SKILL.md
  seed/                  # only if [components.seed] was agreed (never knowledge)
  canvas-tools/          # only if [components.canvas_tools] was agreed
  .provenance.json       # source manifest (non-component file)
```

## Anti-patterns

Don't:
- **Run in chat/browser mode** — if you can't see `write`/`read`/`glob`/`bash`, stop and ask for agent mode.
- **Route `read`/`write`/`glob`/`bash` through `tool_call_dynamic`** — returns `unknown tool`, silent failure.
- **Emit `read_file`/`write_file`/`run_command` into a generated pack** — those are ACP/MCP-layer names;
  generated packs run on the native agent (`read`/`write`/`glob`/`bash`).
- **Generate `[components.knowledge]`** — install hard-rejects it; use `[[components.seed]]` instead.
- **Declare seed as `[components.seed] dir=…`** — seed is `[[components.seed]]` (slug + from per page);
  `dir` is skills-only. The single-table form fails `Manifest::parse` (`BAD_MANIFEST`).
- **Ship a half pack when a referenced file couldn't be fetched** — surface the gap, let the user decide.
- **Trust a mental capability check** — the real `nevoflux pack validate` is the delivery gate.
- **Pick the output directory yourself, or install the pack** — ask for the dir; hand install back to the user.
- **Guess a license** — unreadable/absent → `unknown` → pure-learning.
