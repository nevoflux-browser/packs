# pack-authoring — the generation reference

This is learn's authoritative checklist for emitting a **capability-valid** NevoFlux pack. Everything
here is grounded in the engine (`crates/pack/src/{capability,manifest}.rs`). Follow it while generating,
then let the **real validator gate delivery** (see the end).

## pack.toml — required fields & rules

```toml
[pack]
name = "<a-z0-9->"          # REQUIRED. must match ^[a-z0-9-]+$. = the pack directory name.
version = "0.1.0"           # REQUIRED. semver.
protocol = "pack-protocol/0.1"   # REQUIRED. only this value is supported.
min_nevoflux = "0.3.0"      # REQUIRED. semver. match the target engine (don't over-set, e.g. 1.0.0).
description = "..."         # optional
license = "<SPDX or 'unknown'>"  # optional, but fill truthfully (see License)
authors = ["..."]           # optional
namespace = "<a-z0-9-/>"    # optional; defaults to `name`. The prefix for all seed/protected slugs.

[components.skills]
dir = "components/skills"   # relative source dir; the skill lives at <dir>/<skill>/SKILL.md
```

- Skill folder name = the skill's own `name` (from SKILL.md frontmatter); it need **not** equal the pack
  name (e.g. pack `okf-export-pack` ships a skill `okf`).
- Keep the manifest minimal. Only add a component when the material clearly supports it (default: skills
  only).

## The 5 capability invariants (hard-enforced at install; `Err(Vec<Violation>)`, no tolerance layer)

Generate to satisfy every one. From `capability.rs::validate`:

1. **PathTraversal** — every source path (`skills.dir`, `canvas_tools.files[]`, `seed.from`,
   `dashboard.files_from`) must be a **safe relative path**: non-empty, no NUL, **not** starting with
   `/` or `\`, **no** drive prefix (`C:`), **no** `..` segment. Both `/` and `\` count as separators.
   → Only ever emit pack-internal relative paths.
2. **ConfigComponentForbidden** — `[components.config]` is forbidden (scanned in raw TOML). → Never emit
   it.
3. **SlugOutsideNamespace** — every `seed.slug`, `protected.slugs[]`, and `protected.prefixes[]` must be
   `== namespace` or start with `<namespace>/`. → Prefix every slug with the namespace.
4. **SeedNotProtected** (hard reject) — every `seed.slug` must be covered by a `protected.slugs[]`
   **exact** match or a `protected.prefixes[]` **prefix**. → **Whenever you emit a seed, emit matching
   protected coverage in the same pass.** The common shape:
   ```toml
   [[components.seed]]
   slug = "<ns>/notes/intro"
   from = "seed/notes/intro.md"
   [components.protected]
   prefixes = ["<ns>/"]        # covers all seeds under the namespace
   ```
5. **ArtifactIdNotNamespaced** — a dashboard's `artifact_id` must start with `pack.name` (convention
   `<name>-dashboard`). → Only if you emit `[components.dashboard]`.

Note: `ns = namespace()` = explicit `namespace`, else `pack.name`.

## Components: allowed vs forbidden

- `[components.skills]` — the workhorse; almost always present.
- `[components.seed]` — starter KB pages (route domain knowledge here). Must be protected (invariant 4).
- `[components.canvas_tools]` — tool TOML files, when the material needs them.
- `[components.dashboard]` — only if the material is a displayable panel (invariant 5).
- `[components.protected]` — declare alongside any seed.
- **`[components.knowledge]` — DO NOT GENERATE.** Install hard-rejects it (`rpc.rs` `KNOWLEDGE_UNSUPPORTED`,
  deferred until gbrain source-mapping lands). Route domain knowledge to `[components.seed]` instead.
- **`[components.config]` — forbidden** (invariant 2).

## Tool-name mapping & routing (two naming worlds — get this right or generated packs silently fail)

The generated pack runs on the **native builtin-wasm agent**. Map source-skill tools to the **native
names, called directly**. `tool_call_dynamic` **cannot execute file/exec tools** (`execute_mcp_tool`
returns `unknown tool`) — it's only for gbrain/browser/MCP.

| Source (Claude Code / generic) | NevoFlux (real name) | How the generated skill calls it |
| --- | --- | --- |
| Read | `read` | native, **direct** (agent mode) |
| Write | `write` | native, **direct** |
| Glob | `glob` | native, **direct** |
| Bash | `bash` (**not** `run_command`) | native, **direct** |
| Edit / Grep | `edit` / `grep` | native, **direct** |
| Skill | `skill_load` | native, direct |
| Agent | `subagent_spawn` + `subagent_wait_all` | native, direct |
| Web search / fetch | `web_search` / `web_fetch` (`fetch_page` is an alias) | native, direct |
| gbrain / browser_* / MCP tools | `brain_*` / `browser_*` / server name | via `tool_search` → `tool_call_dynamic` |

- **Never** put `read`/`write`/`glob`/`bash` behind `tool_call_dynamic`.
- **Never** emit `read_file`/`write_file`/`run_command` — those are the ACP/MCP-layer names; the native
  agent doesn't expose them (they'd be `unknown tool`). `WebSearch`/`WebFetch` are Rust enum names, not
  tools.
- The generated skill's `allowed_tools` is an **availability gate**, not a restriction. List only tools
  in every mode's catalog (typically `tool_search` + `tool_call_dynamic`); reach the rest at runtime.
- **Verify every emitted tool name against the live tool registry** — the engine changes; this table can
  go stale.
- Browser-automation sources → `browser_*` (via `tool_call_dynamic`), following record-and-replay's
  relocate-then-act (durable role+name, not pinned snapshot element ids).

## License (fill truthfully; fail-safe toward pure-learning)

- **Scope, most-specific-wins:** ① skill's own header / SKILL.md frontmatter `license` > ② the skill
  dir's own LICENSE > ③ repo-root LICENSE / `pack.toml` `license`. Take the most specific present.
- **Any layer unknown/absent → `unknown`.** A repo-level MIT does **not** bless a specific file that
  carries a conflicting/absent license (no license laundering).
- **SPDX / dual:** parse SPDX ids; `A OR B` → pick the one you'll comply with and record it; `A AND B` →
  strictest.
- **Behavior:** MIT/Apache → rewrite + carry attribution; copyleft → rewrite + warn on terms;
  unknown/none → **pure-learning only** (no rewrite) unless the user explicitly overrides; mixed → take
  the strictest.
- `pack.toml` `license`: carry the source's for permissive/copyleft; `unknown` when unreadable. Never
  guess.

## Provenance — `.provenance.json`

A **non-component** file in the pack root (like README — **not** declared in `pack.toml`, so capability
doesn't touch it). One entry per source:

```json
{
  "provenance_version": "1",
  "generated_by": "learn/0.1.0",
  "sources": [
    { "source": "github:owner/repo/sub@ref", "license": "MIT",
      "license_source": "repo-root LICENSE", "mode": "rewrite", "content_sha256": "..." },
    { "source": "https://portal/x", "license": "unknown",
      "license_source": "none found", "mode": "pure-learning", "content_sha256": "..." }
  ]
}
```

`license_source` records which file/field the license came from, so an auditor can verify inheritance.

## Delivery gate — the real validator, not this checklist

After writing the pack, **run the authoritative validator** (agent mode has `bash`):

```
nevoflux pack validate <output-dir>/<pack-name>/pack.toml   # static check, no writes
```

Parse the violations; if not clean, fix and regenerate — loop until clean. If the `nevoflux` CLI isn't
on PATH, fall back to the bundled `scripts/validate-pack.sh <dir>` (a bash approximation of the 5
invariants; the CLI is authoritative). This checklist is *generation guidance*; the validator is the
gate.
