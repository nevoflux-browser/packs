# voxcpm

**English** · [中文](README.zh.md)

A NevoFlux pack for the `voxcpm` command-line speech synthesizer: voice design from a text
description, voice cloning from reference audio, batch generation, and fine-tuning support
(manifest prep, validation, config generation). Two skills: `/voxcpm` for synthesis,
`/voxcpm-finetune` for fine-tuning.

## Requires VoxCPM — not installed by this pack

This pack does **not** install VoxCPM. You need the `voxcpm` CLI on your machine first:

```bash
pip install voxcpm
# or
uv pip install voxcpm
```

Fine-tuning needs more than the pip wheel provides — see "Fine-tuning" below. Full
dependency and installation details (PyTorch, FFmpeg, CUDA, Python version notes, HF mirror)
are in `voxcpm/installation`, routed to on demand by both skills.

## Quick start

```bash
voxcpm design -t "Hello, this is a test." -o out.wav
```

`design` synthesizes speech from a text prompt with no reference audio (voice comes from an
optional `--control` description). `clone` does the same but matches a `--reference-audio`
sample's voice. `batch` runs one synthesis per line of an input text file. See
`voxcpm/cli-reference` for the full flag table.

## Skills

| Skill | Command | What it does |
| --- | --- | --- |
| `voxcpm` | `/voxcpm` | Synthesis: routes between `design` (voice from a text description), `clone` (voice from reference audio), and `batch` (many lines, one output file per line). Resolves the local environment first (the `voxcpm` executable, not `import voxcpm`, is the install-verification test), then runs the CLI and reports the output path, duration, and parameters used. |
| `voxcpm-finetune` | `/voxcpm-finetune` | Fine-tuning support: helps prepare a JSONL training manifest, runs `voxcpm validate` against it, generates LoRA or full fine-tuning configs, and (once a checkpoint exists) runs LoRA inference. Hands the actual training command to the user rather than launching or babysitting a multi-hour run itself. |

## Known limitations

These are facts about the installed CLI (verified against voxcpm 2.0.3), not this pack's
choices — the upstream README documents flags the CLI does not actually implement:

- **No `--seed` flag exists on any subcommand.** There is no way to force reproducible
  output from the CLI — running the same command twice with identical inputs is **not**
  guaranteed to produce the same audio. If a take sounds good, that take is what you have;
  rerunning is a new roll, not a way to reproduce it.
- **`--timestamps` (and `--timestamp-level`, `--timestamp-language`) do not exist on this
  CLI**, despite being documented in the upstream README. There is no way to get
  timestamp/alignment output from the command line.
- `--retry-badcase` is a Python API parameter, not a CLI flag, and `--version` does not exist
  either (use `python -c "import importlib.metadata; print(importlib.metadata.version('voxcpm'))"`
  instead). Full detail in `voxcpm/cli-reference`.

## Fine-tuning

- **Training needs a source checkout.** `scripts/train_voxcpm_finetune.py` and the
  `conf/*.yaml` configs are not included in the pip/uv wheel — fine-tuning a model requires
  `git clone`-ing the source repository. Manifest validation (`voxcpm validate`) and LoRA
  inference against an already-trained checkpoint both work from a plain pip install, no
  checkout needed.
- **VRAM budget** (VoxCPM 2, estimated at `batch_size=16`, `max_batch_tokens=8192`): roughly
  **20GB for LoRA**, **40GB for full fine-tuning**. See `voxcpm/finetune-config` for the full
  table (including VoxCPM 1.5), hyperparameters, launch commands, and overfitting
  countermeasures.
- The `voxcpm-finetune` skill drives manifest prep, validation, and config generation, and
  runs post-training LoRA inference — it does not launch or watch the training run itself.

## Structure

```
voxcpm/
  pack.toml
  skills/
    voxcpm/SKILL.md                 # synthesis: design/clone/batch routing, env probe, reporting
    voxcpm-finetune/SKILL.md        # fine-tuning: data → validate → config → (user trains) → inference
  seed/
    cli-reference.md                # exact flag table per subcommand, and flags that don't exist
    environment.md                  # probe template (agent-filled, user-editable)
    installation.md                 # install methods, dependencies, Python version notes
    troubleshooting.md              # environment-related failure diagnosis
    synthesis.md                    # design/clone/batch selection, tuning, reference audio
    text-prep.md                    # text preparation cookbook
    finetune-data.md                # manifest format, validate, trailing-silence trimming
    finetune-config.md              # VRAM budget, hyperparameters, launch commands, monitoring
  scripts/
    check-cli-reference.sh          # dev-time check that seed/skill flags match cli-reference.md
                                     # (not referenced by pack.toml, not installed)
```

## Notes

- **Reference pages load on demand.** Both SKILL.md files keep an inline environment-probe
  procedure and route to seed pages only for the specifics (exact flags, tuning ranges,
  manifest format), so the skill stays small.
- **The install-verification test is `voxcpm --help` succeeding, not `import voxcpm`
  succeeding** — the `voxcpm` executable is a shim with its own interpreter baked in at
  install time and does not consult `PATH`/`VIRTUAL_ENV` at run time. Verified in practice:
  with an empty venv activated, `python -c "import voxcpm"` raises `ModuleNotFoundError`
  while `voxcpm --help` in that same shell still works.
- **Every flag in the seed pages and both SKILL.md files is checked against a live
  `voxcpm --help`** by `voxcpm/scripts/check-cli-reference.sh` during development. That
  script does not scan README files, so flags mentioned here were checked by hand against
  `voxcpm/cli-reference.md` instead.

## License

MIT
