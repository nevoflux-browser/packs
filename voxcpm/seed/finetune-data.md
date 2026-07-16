# VoxCPM Fine-Tuning: Training Data

For the authoritative CLI flag table, see `voxcpm/cli-reference`. For memory budgeting,
hyperparameters, and launch commands, see `voxcpm/finetune-config`. This page is only about
preparing and validating the training manifest.

## Manifest format: JSONL, one sample per line

Each line of the manifest is a single JSON object describing one training sample.

Required fields:

- `audio` — path to the audio file.
- `text` — the transcript of that audio.

Optional fields:

- `ref_audio` — reference audio path.
- `duration` — sample duration in seconds.
- `dataset_id` — integer identifying which dataset the sample came from.

Minimal example line:

```json
{"audio": "path/to/audio.wav", "text": "Transcript"}
```

One JSON object per line — this is JSON Lines, not a single JSON array. Do not wrap the
lines in `[...]` or join them with commas.

## Sample rate

Audio is encoded through AudioVAE, whose encoder expects **16000 Hz** input. This is also the
`validate` command's default `--sample-rate`, and the value to pass explicitly if your audio
isn't already at that rate so validation actually checks it.

## Trim trailing silence

**Trim any trailing silence longer than 0.5s off the end of each audio clip.** The upstream
FAQ identifies exactly this — trailing silence past 0.5s in training clips — as the root
cause of "generation won't stop" behavior in models fine-tuned on that data. This is a data
prep step, not something you can fix later at inference time: fix it in the source clips
before they go into the manifest.

## Validate before training

```bash
voxcpm validate -m train.jsonl --sample-rate 16000 -v
```

This command ships in the pip package — **it does not require a source checkout.** Run it
against your manifest before starting any training job; catching a malformed manifest here
costs seconds, catching it after a training run has started costs however long that run has
been going.

## Audio and transcript quality

Audio quality and transcript accuracy directly affect convergence. A manifest that passes
`validate` is structurally correct (right fields, right sample rate, parseable JSON) — it
says nothing about whether the transcripts actually match what's spoken in the audio, or
whether the recordings are clean. Structural validity and content quality are two different
things; only the first one is checked by the tool.
