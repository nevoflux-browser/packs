---
name: voxcpm-finetune
description: VoxCPM fine-tuning support. Prepare and validate a JSONL training manifest, generate LoRA or full fine-tuning configs, and run inference with the resulting checkpoint. Use when user wants to fine-tune VoxCPM, train a custom voice, prepare training data, or says "voxcpm 微调", "微调语音模型", "训练音色", "LoRA", "fine-tune voxcpm".
version: "0.1.0"
author: "NevoFlux"
tags: [voxcpm, finetune, lora, training, 微调, 语音训练]
enabled: true
triggers:
  - "/voxcpm-finetune"
  - "voxcpm 微调"
  - "微调语音模型"
  - "训练音色"
  - "fine-tune voxcpm"
dependencies:
  - "voxcpm/cli-reference"
  - "voxcpm/environment"
  - "voxcpm/finetune-data"
  - "voxcpm/finetune-config"
  - "voxcpm/troubleshooting"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# voxcpm-finetune — VoxCPM fine-tuning support

`dependencies` above is decorative — it does not auto-load anything (see this repo's
CLAUDE.md). Read the pages listed below on demand, by slug.

## Step 0 — Environment probe + source checkout check

Before doing anything else, resolve the environment. First read `voxcpm/environment` — if it
has a valid, previously-recorded probe, use it directly and skip to Step 1. Only run a fresh
probe if that page is empty/stale or the recorded executable no longer resolves.

**The rule that governs this whole step, and must not be violated:**

> The test is whether `voxcpm --help` runs successfully — **not** whether some `python` can
> `import voxcpm`. The `voxcpm` executable is a shim with its own interpreter baked in at
> install time; it does not consult `PATH` or `VIRTUAL_ENV` at run time. Verified in practice:
> activate an empty venv, and `python -c "import voxcpm"` raises `ModuleNotFoundError` — while
> `voxcpm --help` in that same shell still works fine. Using import as the test produces a
> false "not installed" verdict exactly when a venv is active and voxcpm is actually installed
> globally.

A tempting but wrong design is: find a Python interpreter first, check whether it can
`import voxcpm` and `import torch`, and use that interpreter. **Do not do this.** The correct
order is the reverse: resolve the `voxcpm` executable, run it directly, and only chase down
which interpreter it's bound to if running it fails (for diagnosis, per `voxcpm/troubleshooting`).

Probe sequence:

1. Read `voxcpm/environment`. If it has a valid recorded probe, use it and stop here.
2. Resolve the executable, in order: `$VOXCPM_BIN` override → `voxcpm` on `PATH`
   (`where voxcpm` / `which voxcpm`) → common venv locations.
3. Run `voxcpm --help` to verify:
   - **Succeeds** → the environment is usable. Record the executable's absolute path and use
     that path for every command for the rest of the session.
   - **Fails** → read the shim's shebang to find its bound interpreter, and use that
     interpreter to diagnose why (see `voxcpm/troubleshooting`).
4. Get the version by running, against the **bound interpreter** (not whatever `python`
   resolves to on `PATH`):
   `<bound-interpreter> -c "from importlib.metadata import version; print(version('voxcpm'))"`
5. Write the results back to `voxcpm/environment`.

How to read the shim's shebang (step 3's failure branch, or whenever the bound interpreter is
otherwise needed):

- **Unix**: `head -1 "$(command -v voxcpm)"`
- **Windows**: the shebang is embedded inside the `.exe` binary itself — extract it:
  ```bash
  python -c "import re,shutil; d=open(shutil.which('voxcpm'),'rb').read(); m=re.findall(rb'#!(.{0,200}?python[^\x00\r\n]*)', d); print(m[0].decode() if m else 'unknown')"
  ```
- **Unusable shortcut — do not do this**: assume the bound interpreter lives next to the
  `voxcpm` executable. It doesn't reliably. A global install puts `voxcpm.exe` in
  `C:\Python313\Scripts\` but the interpreter is one level up, at `C:\Python313\python.exe`;
  a venv install puts the interpreter inside that same `Scripts/` directory as the shim. The
  layout differs between the two cases, so guessing from the shim's directory is wrong exactly
  half the time. Reading the shebang is the only reliable way.

### Source checkout check (specific to this skill)

Fine-tuning needs one more thing the plain synthesis skill doesn't: a source checkout. Look
for `scripts/train_voxcpm_finetune.py`:

- **Found** → note the checkout's absolute path. Training is possible on this machine.
- **Not found** → training is not possible here. Tell the user plainly: the pip wheel does
  not ship `scripts/` or `conf/`, so training requires `git clone`-ing the source repository
  (see `voxcpm/installation`, "From source"). This does **not** block the rest of this
  skill — manifest validation (`voxcpm validate`) and LoRA inference against an
  already-trained checkpoint both run from the pip CLI alone, no checkout required.

Record whatever you find in `voxcpm/environment` under "源码 checkout".

## Step 1 — The four-stage workflow and where the skill's job ends

```
data prep ──→ voxcpm validate ──→ generate yaml ──→ [user runs training] ──→ inference on ckpt
 skill-driven     skill-driven       skill-driven      handed to user         skill-driven
```

This skill drives the first two stages and the last one. It does **not** launch or babysit
the training run itself, and that's a deliberate boundary, not a gap: training runs for
hours, and an agent sitting in a loop watching a multi-hour job consumes context the whole
time while being unable to do anything useful — it can't make the loss converge faster or
intervene mid-epoch. What the skill *can* usefully do is get the user to the point where the
training command is correct and worth running, then pick back up once a checkpoint exists.

Concretely, per stage:

- **Data**: help the user assemble a JSONL manifest and trim trailing silence (>0.5s) from
  clips. Read `voxcpm/finetune-data` for the manifest format and why trailing silence matters.
- **Validate**: run `voxcpm validate -m <manifest> --sample-rate 16000 -v` **before** any
  training starts, not after. Read `voxcpm/finetune-data` for how to interpret its report —
  a real run against a manifest pointing at a missing audio file produces a structured
  `ERRORS (N)` section naming the offending line, and exits non-zero; catching that here
  costs seconds, catching it after training has started costs however long that run has
  been going.
- **Config**: ask about available VRAM before picking LoRA vs. full fine-tuning — VoxCPM 2
  needs roughly 20GB (LoRA) or 40GB (full). **If the hardware doesn't clear that number, say
  so immediately** rather than generating a config that's certain to OOM only after the user
  has let it run for hours. Read `voxcpm/finetune-config` for the full VRAM table,
  hyperparameters, and the overfitting countermeasures.
- **Training**: hand the user the exact launch command from `voxcpm/finetune-config` and tell
  them what to watch (`loss/diff`, `val/loss`, and the overfitting symptom: the model starts
  ignoring the text condition). Do not run this step yourself.
- **Inference**: once a checkpoint exists, run
  `voxcpm design --lora-path <ckpt> --lora-r <from training yaml> --lora-alpha <from training yaml> -t "..." -o test.wav`.
  **Read `r` and `alpha` back out of the training yaml that produced the checkpoint — never
  rely on the CLI's LoRA defaults here.** The CLI defaults to `r=32, alpha=16` (see
  `voxcpm/cli-reference`), but fine-tuning guidance calls for `alpha` of `32` or `64`, and the
  upstream FAQ requires inference configuration to match training configuration exactly. If
  training used a non-default `alpha` and inference falls back to the CLI default, the two
  silently diverge — precisely the mismatch the FAQ warns about.

## Read on demand

| Task involves... | Read page |
|---|---|
| JSONL manifest format, trailing-silence trimming, `validate` output | `voxcpm/finetune-data` |
| VRAM budget, LoRA vs. full fine-tune, hyperparameters, launch commands, monitoring, overfitting, post-training inference | `voxcpm/finetune-config` |
| Exact `voxcpm` CLI flags (including LoRA inference flags) | `voxcpm/cli-reference` |
| Probing/recording the environment, source checkout location | `voxcpm/environment` |
| A command fails | `voxcpm/troubleshooting` |

Plain synthesis (design/clone/batch, no training) is out of scope for this skill — see the
`voxcpm` skill instead.

## Operating rules

- Run `voxcpm` and all shell commands via `bash` **directly** — never through `tool_call_dynamic`.
- Reach any dashboard/artifact tooling via `tool_search` → `tool_call_dynamic`.
- Never invent a flag. If it's not in `voxcpm/cli-reference`, read `voxcpm --help` /
  `voxcpm <subcommand> --help` directly before using it.
- Never claim a specific training-quality or audio-quality outcome that isn't backed by a
  seed page or a live observation (e.g. an actual `validate` report or an actual metric value
  from a monitoring run) — report what was actually observed, not a guess about how well the
  fine-tune will turn out.
- Do not launch or run the training command yourself — hand it to the user with the exact
  command and the metrics to watch, per Step 1.
