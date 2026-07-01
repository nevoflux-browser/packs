# learn

**English** · [中文](README.zh.md)

A NevoFlux pack that **learns from any source and generates another pack**. Point it at the current
page, a URL, several tabs, a GitHub skill repo, a web skill portal, local files, or your GBrain — and it
writes a **capability-valid, installable NevoFlux pack** into a directory you name. It's a **pure
generator**: it writes files and stops. Invoke with `/learn`.

## Requires agent mode

learn writes files (`read`/`write`/`glob`/`bash` are agent-mode tools), so it must run in **agent mode**.
If it can't see those tools it stops and asks you to switch. It also **never installs** — you install the
generated pack yourself with the existing NevoFlux pack tools.

## Usage

Invoke `/learn` in **agent mode**, describing what to learn from and (optionally) where to write the
pack. Trigger phrases include `/learn`, "learn a skill…", "turn this into a pack", 学一个, 把这个做成
pack.

### Examples by source

| Learn from… | Example |
| --- | --- |
| The current page | `/learn turn this page into a pack in ./packs` |
| A specific URL | `/learn learn from https://example.com/guide and make a pack` |
| Local files / a folder | `/learn make a pack from ./notes/scraping/, output to ./packs` |
| Several open tabs | `/learn combine my open tabs into one research pack` |
| A named GitHub skill | `/learn learn anthropics/skills/pdf into ./packs` |
| Find a skill by intent | `/learn learn a skill that scrapes Airbnb` |
| Your GBrain | `/learn make a pack from what I know about vector databases` |
| 中文 | `/learn 学一个爬 Airbnb 的 skill，生成到 ./packs` |

### What a run looks like

1. **Output directory** — if you didn't give one, learn asks. It never picks a directory itself.
2. **(Active search only)** learn searches the built-in skill sites + GitHub repos and shows a few
   candidates, each tagged with its license, for you to pick — or "none":
   ```
   Found these related skills:
   1. anthropics/skills/pdf        [MIT]         ✅ rewrite + attribution
   2. skills.sh/…/airbnb-search    [Apache-2.0]  ✅ rewrite + attribution
   3. some-portal/…/airbnb         [unknown]     ⚠️ pure-learning only
   [ none ]
   ```
3. **License** — each source is classified; unknown/absent → pure-learning (no rewrite).
4. **Component plan** — learn proposes the pack's components (skills / seed / …) one at a time with a
   recommendation, and generates only after you agree.
5. **Generate + validate** — it writes the pack, runs `nevoflux pack validate` (the real validator),
   and fixes anything that fails.
6. **Install hint** — it prints the generated path and how to install with the existing pack tools.
   **learn never installs.**

Then install it yourself, e.g. `nevoflux pack install <output-dir>/<pack-name>/pack.toml`.

## How it works

learn runs four stages:

1. **Ingest** — gather material from whatever you point at (passive: current page / tabs, a URL, local
   files, GBrain; active: a **site-bounded** `web_search` across built-in skill sites + GitHub repos,
   each candidate tagged with its license). A chosen GitHub skill is fetched **whole** via one codeload
   tarball, so nothing is half-fetched.
2. **License gate** — classify each source (most-specific-wins; any unknown layer → pure-learning).
   Permissive → rewrite + attribution; copyleft → rewrite + warning; unknown/none → learn only.
3. **Synthesize** — plan the pack's components *with you*, one at a time; rewrite tool names to NevoFlux;
   satisfy the 5 capability invariants.
4. **Emit** — write the pack, then run the **real `nevoflux pack validate`** as the delivery gate (with a
   bundled bash validator as fallback), write a `.provenance.json` source manifest, and tell you how to
   install. It does not install.

## Structure

```
learn/
  pack.toml
  components/skills/learn/
    SKILL.md
    references/pack-authoring.md   # pack.toml rules, the 5 capability invariants, tool mapping, license, provenance
    scripts/validate-pack.sh       # fallback validator (bash mirror of capability.rs) when the CLI isn't on PATH
```

## Notes

- **Pure generator, no install** — learn writes compliant files; you install them yourself.
- **The real validator gates delivery** — it runs `nevoflux pack validate` (the same check as install),
  not a mental checklist, so generated packs actually install.
- **License honesty** — unreadable/absent license → `unknown` → pure-learning, never guessed; each
  source's license + where it was read from is recorded in `.provenance.json`.
- **Never generates `[components.knowledge]`** (install rejects it) — domain knowledge goes to seed.

## License

MIT
