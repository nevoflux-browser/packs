# VoxCPM Environment

This page is filled in by the agent after probing the local machine. You can hand-edit it
yourself — if you do, the agent treats your edits as the source of truth going forward and
will not silently overwrite fields you've changed without re-probing.

For the authoritative flag table (`--device`, `--no-optimize`, etc.), see
`voxcpm/cli-reference` — this page does not repeat it.

## Probe template

| Field | Value |
|---|---|
| `voxcpm` 可执行文件 | *(absolute path to the `voxcpm`/`voxcpm.exe` entry point)* |
| 绑定解释器 | *(absolute path to the Python interpreter read out of the shim's shebang — see `voxcpm/troubleshooting` for why this matters)* |
| voxcpm 版本 | *(from `python -c "import importlib.metadata; print(importlib.metadata.version('voxcpm'))"`, run against the bound interpreter above)* |
| torch 版本 | *(e.g. `2.6.0+cu124`)* |
| CUDA 可用 | *(yes/no — from `torch.cuda.is_available()`)* |
| Python 版本 | *(from the bound interpreter, e.g. `3.13.5`)* |
| device | *(default device VoxCPM will pick with `--device auto`)* |
| 源码 checkout | *(absolute path if a source clone exists on this machine, otherwise: `未找到（微调不可用）` — see `voxcpm/installation` for why fine-tuning needs the source tree)* |
| 探测时间 | *(ISO 8601 timestamp of the last probe)* |

## Example (filled in from a real probe)

This is a real probe result from one machine, kept here as a worked example of what a
completed page looks like — not a claim about your machine.

| Field | Value |
|---|---|
| `voxcpm` 可执行文件 | `C:\Python313\Scripts\voxcpm.exe` |
| 绑定解释器 | `C:\Python313\python.exe` |
| voxcpm 版本 | `2.0.3` |
| torch 版本 | `2.6.0+cu124` |
| CUDA 可用 | 是 |
| Python 版本 | `3.13.5` |
| device | `cuda` |
| 源码 checkout | 未找到（微调不可用） |
| 探测时间 | 2026-07-16T00:00:00 |

Note that voxcpm here is installed **globally** (not in a venv) — the exe shim's shebang
points straight at `C:\Python313\python.exe`. This is expected and fine; see
`voxcpm/troubleshooting` for why checking `voxcpm --help` (not `python -c "import voxcpm"`
in some other, currently-active environment) is the only reliable way to confirm this.

## How to re-probe

1. Locate the `voxcpm` executable: `where voxcpm` (Windows) or `which voxcpm` (POSIX).
2. Read the shim's shebang/launcher line to find the bound interpreter — on Windows this is
   embedded in the `.exe` shim; on POSIX it's the `#!/path/to/python` line at the top of the
   script.
3. Run `voxcpm --help` (not `--version` — that flag does not exist) to confirm the CLI is
   actually reachable.
4. Query version/torch/CUDA/Python using the bound interpreter found in step 2, not
   whatever `python` currently resolves to on `PATH`.
5. Check for a source checkout (needed for fine-tuning) by looking for a directory containing
   `scripts/` and `conf/` alongside a VoxCPM `pyproject.toml` or `.git`.
6. Update this page with the results and the current timestamp.
