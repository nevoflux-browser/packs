# VoxCPM Fine-Tuning: Config, Launch, and Monitoring

For the authoritative CLI flag table, see `voxcpm/cli-reference`. For manifest preparation
and the `validate` command, see `voxcpm/finetune-data`. This page covers what actually
requires a source checkout, how much VRAM to expect, the hyperparameters that matter, how to
launch a run, what to watch while it trains, and how to run inference on the result.

## Prerequisite: training needs a source checkout

`scripts/train_voxcpm_finetune.py` and the `conf/*.yaml` config files are **not included in
the pip wheel** — they only exist in a source checkout (see `voxcpm/installation`, "From
source"). You cannot launch a training run from a pip-only install.

By contrast, both of the following work from a plain pip install, no checkout needed:

- Manifest validation (`voxcpm validate`, see `voxcpm/finetune-data`).
- LoRA inference against a checkpoint someone else trained (`voxcpm design --lora-path ...`).

So "can I fine-tune on this machine" and "can I validate a manifest or run a LoRA checkpoint
on this machine" are different questions with different answers. Check `voxcpm/environment`
for whether a source checkout is on record for this machine before assuming training is
possible here.

## VRAM budget

These figures come from upstream docs and have not been tested against on this machine.

| 模型 | LoRA | 全量 |
|---|---|---|
| VoxCPM 1.5 (750M) | ~12GB | ~24GB |
| VoxCPM 2 (2B) | ~20GB | ~40GB |

Estimated at `batch_size=16`, `max_batch_tokens=8192`.

**Check this against available VRAM before starting a run, not after.** Tell the user
up front if their hardware doesn't clear the relevant number — don't let them discover an
OOM three hours into a training run that was never going to fit.

## Key hyperparameters

- `learning_rate` — LoRA: `1e-4`. Full fine-tune: `1e-5`.
- `sample_rate` — `16000`.
- `lora.r` — `32` for voice cloning, `64` for style.
- `training_cfg_rate` — `0.1`. This exists to prevent overfitting — **do not turn it off.**

## Launching a run

LoRA, single GPU:

```bash
python scripts/train_voxcpm_finetune.py --config_path conf/your_lora_config.yaml
```

Full fine-tune, multi-GPU:

```bash
CUDA_VISIBLE_DEVICES=0,1,2,3 torchrun --nproc_per_node=4 scripts/train_voxcpm_finetune.py --config_path conf/your_full_config.yaml
```

`--config_path` belongs to `train_voxcpm_finetune.py` itself, and `--nproc_per_node` belongs
to `torchrun` — neither is a `voxcpm` CLI flag. Both commands invoke the training script
directly through `python`/`torchrun`, not through the `voxcpm` executable.

## Monitoring

```bash
tensorboard --logdir checkpoints/<run>/logs
```

Watch: `loss/diff`, `loss/stop`, `grad_norm`, `val/loss`.

## Overfitting is the most common failure

It shows up as the fine-tuned model **ignoring the text condition** — output that doesn't
track what you asked it to say. Countermeasures:

- Keep `training_cfg_rate=0.1` — don't disable it.
- Use the conservative learning rate (`1e-5` for full fine-tune).
- Check checkpoints early and often rather than waiting until the run finishes.

## Output artifacts and running inference on them

- LoRA training produces `lora_weights.safetensors`. Run it with:
  ```bash
  voxcpm design --lora-path <path> -t "..." -o test.wav
  ```
- Full fine-tuning produces a complete model directory. Point at it with `--model-path <dir>`
  instead of `--lora-path`.

## Hyperparameters must be read back from the training config

The CLI's LoRA inference defaults are `r=32, alpha=16` (see `voxcpm/cli-reference`) — but
fine-tuning guidance calls for `alpha` of `32` or `64`. The upstream FAQ is explicit that
inference configuration must match training configuration exactly.

**Do not rely on the CLI defaults for LoRA inference against a fine-tuned checkpoint.** Read
`r` and `alpha` back out of the training yaml that produced the checkpoint, and pass them
explicitly:

```bash
voxcpm design --lora-path <path> --lora-r <r-from-training-yaml> --lora-alpha <alpha-from-training-yaml> -t "..." -o test.wav
```

If the training yaml used `alpha=32` or `alpha=64` and inference is run with the CLI default
of `alpha=16` instead, inference configuration silently diverges from training configuration
— exactly the mismatch the upstream FAQ warns against.
