# VoxCPM CLI Reference

This page documents the `voxcpm` command-line interface exactly as observed by running
`voxcpm --help` and `voxcpm <subcommand> --help` against a live install.

**Verified against: voxcpm 2.0.3** (`voxcpm --help`, `voxcpm design/clone/batch/validate --help`).
If your installed version differs, re-run these commands and diff the output against this
page before trusting it — flags do change between releases.

## Subcommands

`voxcpm` has four subcommands:

- **`design`** — voice design: generate speech from a text prompt plus a natural-language
  `--control` instruction describing the desired voice (e.g. "warm female voice"), with no
  reference audio required.
- **`clone`** — voice cloning: generate speech that matches a `--reference-audio` sample.
- **`batch`** — batch generation: synthesize one output file per line of an `--input` text
  file, all sharing the same voice/control settings.
- **`validate`** — validate a JSONL training manifest before fine-tuning (not a synthesis
  command).

`design` and `clone` accept **the exact same flag set** at the CLI level — argparse does not
enforce any difference between them. The distinction is purely a semantic convention: `design`
is meant to be used with `--control` (and no reference audio), `clone` is meant to be used with
`--reference-audio`. Nothing stops you from passing `--reference-audio` to `design` or
`--control` to `clone`; the CLI will accept it either way.

## Top-level

```
voxcpm [-h] [--input INPUT] [--output-dir OUTPUT_DIR] [--text TEXT]
       [--control CONTROL] [--cfg-value CFG_VALUE]
       [--inference-timesteps INFERENCE_TIMESTEPS] [--normalize]
       [--output OUTPUT] [--prompt-audio PROMPT_AUDIO]
       [--prompt-text PROMPT_TEXT] [--prompt-file PROMPT_FILE]
       [--reference-audio REFERENCE_AUDIO] [--denoise]
       [--model-path MODEL_PATH] [--hf-model-id HF_MODEL_ID]
       [--device DEVICE] [--cache-dir CACHE_DIR] [--local-files-only]
       [--no-denoiser] [--no-optimize]
       [--zipenhancer-path ZIPENHANCER_PATH] [--lora-path LORA_PATH]
       [--lora-r LORA_R] [--lora-alpha LORA_ALPHA]
       [--lora-dropout LORA_DROPOUT] [--lora-disable-lm]
       [--lora-disable-dit] [--lora-enable-proj]
       {design,clone,batch,validate} ...
```

## Shared inference/synthesis flags (`design`, `clone`, `batch`)

| Flag | Alias | Meaning |
|---|---|---|
| `--text` | `-t` | Text to synthesize |
| `--output` | `-o` | Output audio file path (single or clone mode; not used by `batch`) |
| `--input` | `-i` | Input text file, one text per line (`batch` only) |
| `--output-dir` | `-od` | Output directory (`batch` only) |
| `--control` | | Control instruction for VoxCPM2 voice design/cloning |
| `--cfg-value` | | CFG guidance scale (float, recommended 1.0–3.0, default: 2.0) |
| `--inference-timesteps` | | Inference steps (int, recommended 4–30, default: 10) |
| `--normalize` | | Enable text normalization |
| `--reference-audio` | `-ra` | Reference audio for voice cloning (VoxCPM2 only) |
| `--prompt-audio` | `-pa` | Prompt audio file path (continuation mode, requires `--prompt-text` or `--prompt-file`) |
| `--prompt-text` | `-pt` | Text corresponding to the prompt audio |
| `--prompt-file` | | Text file corresponding to the prompt audio |
| `--denoise` | | Enable prompt/reference speech enhancement |
| `--no-denoiser` | | Disable denoiser model loading |
| `--device` | | Runtime device: `auto`, `cpu`, `mps`, `cuda`, or `cuda:N` (default: `auto`) |
| `--no-optimize` | | Disable model optimization during loading |
| `--model-path` | | Local VoxCPM model path |
| `--hf-model-id` | | Hugging Face repo id (default: `openbmb/VoxCPM2`) |
| `--cache-dir` | | Cache directory for Hub downloads |
| `--local-files-only` | | Disable network access |
| `--zipenhancer-path` | | ZipEnhancer model id or local path (or env `ZIPENHANCER_MODEL_PATH`) |

`--denoise` and `--no-denoiser` are **not opposites of the same switch**: `--denoise` turns
*on* prompt/reference speech enhancement for a given run, while `--no-denoiser` disables
*loading the denoiser model at all*. They act on different things and can in principle both
appear.

`design` and `batch` both require `--output` / `--output-dir` respectively to be supplied
(argparse marks them required in the subcommand parsers); `clone` requires `--output`.

## LoRA inference flags (`design`, `clone`, `batch`)

| Flag | Meaning |
|---|---|
| `--lora-path` | Path to LoRA weights |
| `--lora-r` | LoRA rank (positive int, default: 32) |
| `--lora-alpha` | LoRA alpha (positive int, default: 16) |
| `--lora-dropout` | LoRA dropout rate (0.0–1.0, default: 0.0) |
| `--lora-disable-lm` | Disable LoRA on LM layers |
| `--lora-disable-dit` | Disable LoRA on DiT layers |
| `--lora-enable-proj` | Enable LoRA on projection layers |

## `validate` (manifest validation, not synthesis)

```
voxcpm validate [-h] --manifest MANIFEST [--sample-rate SAMPLE_RATE]
                [--max-samples MAX_SAMPLES] [--verbose]
```

| Flag | Alias | Meaning |
|---|---|---|
| `--manifest` | `-m` | Path to JSONL training manifest (required) |
| `--sample-rate` | | Expected audio sample rate in Hz (default: 16000) |
| `--max-samples` | | Maximum number of samples to validate (0 = all, default: 0) |
| `--verbose` | `-v` | Print per-sample progress |

`validate` does not accept any of the synthesis/LoRA flags above — it only takes the four
flags listed here.

## Documented in the upstream README but does NOT exist in the CLI

The upstream VoxCPM README describes flags that this installed CLI (2.0.3) does not
implement. Do not use these; they will fail with "unrecognized arguments":

- **`--seed`** — no seed/determinism flag exists on any subcommand. There is no way to force
  reproducible output from the CLI: running the same command twice with identical inputs is
  not guaranteed to produce the same audio.
- **`--timestamps`**, **`--timestamp-level`**, **`--timestamp-language`** — no
  timestamp/alignment output flags exist anywhere in the CLI.
- **`--retry-badcase`** — this is a Python API parameter (on the underlying model call), not
  a CLI flag. It cannot be passed on the command line.
- **`--version`** — there is no `--version` flag; passing it produces
  `voxcpm: error: unrecognized arguments: --version`. To get the installed version, use
  `python -c "import importlib.metadata; print(importlib.metadata.version('voxcpm'))"`.
