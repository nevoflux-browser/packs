# VoxCPM Installation

For the authoritative CLI flag table, see `voxcpm/cli-reference`. This page only covers
getting VoxCPM installed and confirming it works — not what flags do.

## Install

Pick one:

```bash
# pip
pip install voxcpm

# uv
uv pip install voxcpm
```

### From source (required for fine-tuning)

The pip/uv wheel does **not** include the `scripts/` and `conf/` directories that fine-tuning
needs. If you plan to fine-tune, install from a source checkout instead:

```bash
git clone <voxcpm-repo-url>
cd voxcpm
uv sync            # or: pip install -e .
```

Record the checkout path in `voxcpm/environment` under "源码 checkout" once you have one —
its absence there means fine-tuning workflows are unavailable on this machine.

## Dependencies

The version floors below are from upstream docs and have not been independently tested
against on this machine (see "Python version" below for the one number on this page that
has).

- **PyTorch ≥ 2.5.0** — required.
- **CUDA 12.0+** — optional. Only needed for GPU inference; CPU and MPS backends don't need
  it (see `--device` in `voxcpm/cli-reference`).
- **FFmpeg** — must be installed at the system level (not just as a Python package). Without
  it, the audio backend errors out at load or decode time.

## Python version

Official guidance recommends **Python 3.10–3.11**, and the upstream README states `<3.13`.
**However, 3.13.5 has been verified to work in practice** — this pack's own reference
environment runs voxcpm 2.0.3 on Python 3.13.5 with no issues. Do not treat "Python 3.13" by
itself as a reason something is broken. That said, if you hit an installation or runtime
problem and the Python version doesn't match the officially-recommended 3.10–3.11 range,
**Python version mismatch should be your first suspect** before digging elsewhere.

## Model download

Model weights are downloaded automatically from Hugging Face on first use. If you're in a
region where Hugging Face is slow or blocked, redirect downloads through a mirror:

```bash
export HF_ENDPOINT=https://hf-mirror.com
```

## Disk space

Model weights are several GB — make sure the cache directory (`--cache-dir`, see
`voxcpm/cli-reference`) has room before the first run.

## Verifying the install

```bash
voxcpm --help
```

Use `voxcpm --help`, **not** `voxcpm --version` — there is no `--version` flag; passing it
fails with `unrecognized arguments`. A successful `--help` listing is the install-verification
signal this pack relies on everywhere (see `voxcpm/troubleshooting` for why `python -c "import
voxcpm"` is not a substitute for this check).
