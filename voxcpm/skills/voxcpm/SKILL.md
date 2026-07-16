---
name: voxcpm
description: VoxCPM command-line speech synthesis. Voice design from a text prompt, voice cloning from reference audio, and batch generation. Use when user wants to synthesize speech, clone a voice, generate audio from text, or says "voxcpm", "/voxcpm", "语音合成", "文字转语音", "配音", "音色克隆", "TTS", "text to speech".
version: "0.1.0"
author: "NevoFlux"
tags: [voxcpm, tts, speech-synthesis, voice-cloning, 语音合成, 音色克隆]
enabled: true
triggers:
  - "/voxcpm"
  - "voxcpm"
  - "语音合成"
  - "文字转语音"
  - "配音"
  - "音色克隆"
  - "text to speech"
  - "tts"
dependencies:
  - "voxcpm/cli-reference"
  - "voxcpm/environment"
  - "voxcpm/installation"
  - "voxcpm/troubleshooting"
  - "voxcpm/synthesis"
  - "voxcpm/text-prep"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# voxcpm — VoxCPM speech synthesis

Synthesize speech with the `voxcpm` CLI. Three modes: **design** (voice from a text
description, no reference audio), **clone** (voice from a reference audio sample), and
**batch** (many lines of text, one output file per line).

`dependencies` above is decorative — it does not auto-load anything (see this repo's
CLAUDE.md). Read the pages listed in the tables below on demand, by slug.

## Step 0 — Environment probe

Before running any synthesis command, resolve the environment. First read `voxcpm/environment`
— if it has a valid, previously-recorded probe, use it directly and skip to synthesis. Only
run a fresh probe if that page is empty/stale or the recorded executable no longer resolves.

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

## Step 1 — Pick a mode and route the request

| Situation | Mode |
|---|---|
| User gave a reference audio sample and wants the output voice to match it | `clone` |
| User only described the desired voice (e.g. "warm female voice") — no reference audio | `design` |
| Many lines of text, one output file per line, same voice for all | `batch` |

The CLI itself does not enforce this distinction — `design` and `clone` accept the exact same
flag set (see `voxcpm/cli-reference`). Route by what the user actually gave you, since a wrong
choice here is a common mistake: reference audio present but no `-ra` passed (silently becomes
an unused file), or `-ra` passed to `design` when the user meant plain voice design.

For picking between the three modes, tuning `--cfg-value`/`--inference-timesteps`, reference
audio requirements (length, noise, high-fidelity prompt pairs), and the no-reproducibility
caveat (no `--seed` flag exists), read `voxcpm/synthesis` — don't guess at defaults or ranges
from memory.

## Step 2 — Prepare the text

- If the text contains numbers or dates, add `--normalize` — otherwise how they're read out is
  unpredictable.
- If the reference audio (clone mode) has background noise, add `--denoise`.
- If the target text is meant to be spoken in a Chinese dialect, or uses non-verbal markers
  like `[laughing]`, read `voxcpm/text-prep` first — dialect text needs authentic phrasing (not
  a Mandarin-literal translation), and non-verbal markers should be used sparingly.

## Step 3 — Run and report

Use the resolved executable path from Step 0. For the exact flags, aliases, and which flags
are required per subcommand, read `voxcpm/cli-reference` — **do not write flags from memory**;
this pack exists because the upstream README documents flags that don't actually exist in the
CLI (`--seed`, `--timestamps`, `--retry-badcase`, `--version`), and getting one wrong fails the
command with "unrecognized arguments".

After a run, report:

- The output file's **absolute path**.
- The audio's **duration**.
- The **parameters used** (mode, `--cfg-value`, `--inference-timesteps`, any prompt/reference
  audio paths) — since there's no `--seed`, this is what makes a good take reproducible-by-recipe,
  not the command itself.

Do not inline or embed the audio content in a report — VoxCPM outputs large wav files; point at
the file path.

If a run fails, read `voxcpm/troubleshooting` for the matching symptom before guessing at a
fix, and if the failure isn't already documented there, add the real error message and cause
once you've found it.

## Read on demand

| Task involves... | Read page |
|---|---|
| Exact flags, aliases, which flags are required per subcommand | `voxcpm/cli-reference` |
| Choosing design/clone/batch, tuning `--cfg-value`/`--inference-timesteps`, reference audio requirements | `voxcpm/synthesis` |
| Dialects, non-verbal markers, text normalization | `voxcpm/text-prep` |
| Install fails, or `voxcpm`/a run doesn't work | `voxcpm/installation`, `voxcpm/troubleshooting` |

Fine-tuning (`voxcpm/finetune-data`, `voxcpm/finetune-config`) is out of scope for this skill.

## Operating rules

- Run `voxcpm` and all shell commands via `bash` **directly** — never through `tool_call_dynamic`.
- Reach any dashboard/artifact tooling via `tool_search` → `tool_call_dynamic`.
- Never invent a flag. If it's not in `voxcpm/cli-reference`, read `voxcpm --help` /
  `voxcpm <subcommand> --help` directly before using it.
- Never claim a specific audio-quality or parameter-effect outcome that isn't backed by
  `voxcpm/synthesis` or a live observation — report what the run actually produced.
