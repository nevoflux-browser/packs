# VoxCPM Troubleshooting

For the authoritative CLI flag table, see `voxcpm/cli-reference`. For install steps, see
`voxcpm/installation`. Each entry below is symptom -> cause -> fix.

## The one rule that overrides your instincts

**`python -c "import voxcpm"` failing does NOT mean voxcpm is unavailable.**

Verified in practice: activate an empty venv, and `python -c "import voxcpm"` raises
`ModuleNotFoundError` — but `voxcpm --help` still works perfectly fine in that same shell.

Why: the `voxcpm` executable is not "whatever Python happens to be on `PATH` right now." It's
a shim (an `.exe` launcher on Windows, a shebang script on POSIX) with its own interpreter
path baked in at install time. That baked-in path is fixed — it does not look at `PATH` or
`VIRTUAL_ENV` at run time. So activating a *different, unrelated* venv changes what `python`
and `python -c "import ..."` resolve to, but it changes nothing about what the `voxcpm` shim
runs, because the shim was never asking the currently-active environment in the first place.

The practical consequence: if you probe "is voxcpm installed" by trying to import it from
whatever Python is currently active, you will get a false negative every time voxcpm is
installed globally (or in some other env) while a different, empty env happens to be active.
That's a very common state — it's what activating any fresh venv looks like.

**The correct test is always: does `voxcpm --help` succeed? Never: can some particular
`python` import the `voxcpm` module.** If you need to know which interpreter voxcpm is
actually bound to (e.g. to install a missing dependency into the right place), read the
shim's shebang — see `voxcpm/environment` for how, and record the result there.

## `voxcpm: command not found`

**Cause:** Either voxcpm isn't installed anywhere, or it's installed into some other
environment whose `Scripts/` (Windows) or `bin/` (POSIX) directory isn't on the current
`PATH`.

**Fix:** Confirm with `pip show voxcpm` (or `uv pip show voxcpm`) in the environment you
expect it in. If found there, add that environment's `Scripts/`/`bin/` directory to `PATH`,
or invoke the shim by its full path. If not found anywhere, install per `voxcpm/installation`.

## `ModuleNotFoundError: No module named 'torch'` (raised while running `voxcpm`)

**Cause:** torch is missing from the **environment the shim is bound to** — not necessarily
the environment you currently have activated. Since the shim's interpreter path is fixed at
install time (see the rule above), installing torch into your currently-active env does
nothing if that's not the env the shim points at.

**Fix:** Read the shim's shebang to find its bound interpreter (see `voxcpm/environment`),
then install torch into *that* environment specifically, e.g.
`"<bound-interpreter>" -m pip install torch`.

## Windows Triton / `torch.compile` errors

**Cause:** Triton support on Windows is incomplete/unofficial, and `torch.compile`-based
optimization can fail or misbehave there.

**Fix:** Pass `--no-optimize` to disable the optimization path, or switch to a
triton-windows community build if you need the optimized path.

## Audio backend / audio loading errors

**Cause:** FFmpeg isn't installed at the system level, or torchaudio is too old.

**Fix:** Install FFmpeg system-wide (see `voxcpm/installation`). Also make sure torchaudio is
≥ 2.9.

## Model download failures

**Cause:** Hugging Face Hub is unreachable or slow from your network.

**Fix:** Point downloads at a mirror: `export HF_ENDPOINT=https://hf-mirror.com`. For fully
offline use, pass `--local-files-only` together with `--model-path` pointing at a local copy
(see `voxcpm/cli-reference` for both flags).

## Out of GPU memory

**Cause:** Insufficient VRAM for GPU inference. VoxCPM 2 inference needs roughly 8GB of VRAM.

**Fix:** Switch to CPU inference with `--device cpu` (see `voxcpm/cli-reference` for the full
list of `--device` values).

## Errors under concurrency / multi-threading

**Cause:** `torch.compile`'s CUDA Graphs path doesn't support multi-threaded use.

**Fix:** Pass `--no-optimize` to disable that optimization path when running concurrently.
