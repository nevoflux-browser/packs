# packs

A collection of NevoFlux packs for agent-driven design and content-generation workflows.

Each top-level subdirectory is one complete, self-contained pack, named after the pack it
contains (e.g. `deep-research/` is the `deep-research` pack — the directory name is the pack
name and its invocation/command name). Every pack follows the NevoFlux pack-development spec:
a `pack.toml` manifest plus its component directories, installed and validated with the
`nevoflux` CLI.

Authoritative format: https://github.com/nevoflux-browser/nevoflux/blob/main/docs/reference/pack-development.md
