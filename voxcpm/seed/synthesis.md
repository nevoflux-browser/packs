# VoxCPM Synthesis Guide

For the authoritative CLI flag table, see `voxcpm/cli-reference` — this page does not repeat
the flag list. It covers which mode to pick and how to tune the parameters that actually
affect output quality.

## Three modes

| Mode | Command shape | When to use |
|---|---|---|
| `design` | `voxcpm design -t "..." -o out.wav` | No reference audio. Voice comes from a `--control` description of the desired timbre. |
| `clone` | `voxcpm clone -t "..." -ra spk.wav -o out.wav` | You have a reference audio sample and want the output to match its voice. |
| `batch` | `voxcpm batch -i list.txt -od outs/` | Many lines of text, one output file per line, same voice/control settings for all of them. |

`design` and `clone` accept **the exact same flag set** — the CLI does not enforce any
distinction between them. The mode name you pick is a suggestion for a human reading the
command later, not a constraint the CLI checks: nothing stops `clone` from being called
without `-ra`, or `design` from being called with one. Route by what you actually have:

- Only a voice description in words → `design`.
- An actual reference recording → `clone`.

For how to write `--control` descriptions and cloning style instructions, see
`voxcpm/text-prep`.

## High-fidelity cloning

Plain `clone` with just `-ra` gets you *a* similar voice. For closer fidelity, add a prompt
pair: `--prompt-audio` (`-pa`) plus `--prompt-text` (`-pt`), where the prompt text is the
**exact transcript** of the prompt audio — not a paraphrase, not what you meant to say, the
literal words spoken in that clip.

## Reference audio requirements

- At least **5 seconds** of clean recording.
- If the reference has background noise, add `--denoise` to enhance it before use.

`--denoise` and `--no-denoiser` are unrelated switches, not opposites of the same thing:

- `--denoise` turns *on* enhancement of your prompt/reference audio for this run — use it
  when your reference recording is noisy.
- `--no-denoiser` disables *loading the denoiser model at all* — an optimization for when you
  know you'll never need denoising and want to skip that model's load time.

Passing `--no-denoiser` does not affect whether `--denoise` is honored the other way around;
they act on different things and can in principle both appear on the same command.

## Tuning generation

| Flag | Range | Default | Effect |
|---|---|---|---|
| `--cfg-value` | 1.0–3.0 | 2.0 | Higher = output sticks more strictly to the text/control condition (less variation). Lower = more variation and expressiveness, at the cost of adherence. |
| `--inference-timesteps` | 4–30 | 10 | More steps = better detail, but slower generation. Fewer steps = faster, coarser output. |

Start at the defaults and move one parameter at a time — moving both together makes it hard
to tell which change caused a given result.

## No reproducibility guarantee

**There is no `--seed` flag on any subcommand.** Running the exact same command twice with
identical text, identical reference audio, and identical flags is **not guaranteed to
produce the same audio** — VoxCPM's generation has randomness that the CLI gives you no way
to pin down.

Practical consequence: if a particular take sounds good, that specific take is what you have
— rerunning the same command is a new roll, not a way to reproduce it. If you need a
consistent-sounding result, the only lever available is holding every other parameter fixed
(`--cfg-value`, `--inference-timesteps`, reference audio, text) and generating multiple takes
to pick from, not expecting any one command to be replayable on demand.

## Reporting output

After a synthesis run, report:

- The **absolute path** to the output file.
- The audio **duration**.
- The **parameters used** (mode, `--cfg-value`, `--inference-timesteps`, any prompt/reference
  audio paths) — this is what makes a "good take" reproducible-by-recipe later, since the
  command itself isn't guaranteed to reproduce it.

Do not embed or inline the audio itself in a report — VoxCPM outputs 48kHz wav files, which
are large. Point at the file path instead of pasting audio content.
