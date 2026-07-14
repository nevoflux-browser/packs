# packs

A collection of NevoFlux packs for agent-driven design and content-generation workflows.

Each top-level subdirectory is one complete, self-contained pack, named after the pack it
contains (e.g. `deep-research/` is the `deep-research` pack — the directory name is the pack
name and its invocation/command name). Every pack follows the NevoFlux pack-development spec:
a `pack.toml` manifest plus its component directories, installed and validated with the
`nevoflux` CLI.

Authoritative format: https://github.com/nevoflux-browser/nevoflux/blob/main/docs/reference/pack-development.md

## Packs

| Pack | Command | What it does |
| --- | --- | --- |
| [`deep-research`](deep-research/) | `/research` | STORM / Co-STORM deep research — a five-perspective scan, contradiction map, synthesis, and peer review, grounded in real web sources and filed into your brain (gbrain) as a reusable, compounding research subgraph. |
| [`stop-slop`](stop-slop/) | `/no-slop` | Strips AI writing tells from prose in Chinese or English — detects the language, applies the matching ruleset, gauges the register, and self-checks. |
| [`learn`](learn/) | `/learn` | Learns from any source (page, URL, tabs, GitHub skills, web portals, local files, GBrain) and generates a capability-valid NevoFlux pack in a directory you choose — a pure generator that runs in agent mode and never installs. |
| [`unknowns`](unknowns/) | `/unknowns` | A universal thinking toolkit for surfacing what you don't know you don't know — routes to 8 techniques across 4 cognitive stages (Discovery, Research, Execution, Communication). Inspired by Thariq's *Field Guide to Fable*. |
| [`magick`](magick/) | `/magick` | ImageMagick image processing and interactive browser — browse folders as thumbnail galleries, convert/resize/crop/effect single or batch images, with per-sub-command reference pages routed on demand, plus AI watermark removal (LaMa inpainting) for the Gemini/Imagen sparkle. |
