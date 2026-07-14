# ImageMagick + LaMa — Remove the Gemini sparkle watermark

Gemini / Imagen images carry a semi-transparent 4-point sparkle (✦) watermark in the
bottom-right corner. This page covers **where it sits** (so magick can build a mask for any
aspect ratio) and **how to erase it with content-aware inpainting** (LaMa via IOPaint), which
is what the main `magick` clone/patch approach cannot do on detailed backgrounds.

## Placement rule (measured across 8 aspect ratios)

The watermark is **fixed pixels, anchored to the bottom-right corner** — NOT proportional to
image size, and NOT dependent on aspect ratio. Same margin whether the side is 1536 or 2752 px.

| Tier | Watermark size | Right margin | Bottom margin |
|------|----------------|--------------|---------------|
| **Standard** (shorter side ≥ ~1200) | 96×96 px | 192 px | 192 px |
| **Half** (small renders, e.g. 896×1200) | 48×48 px | 96 px | 96 px |

The half tier is exactly 0.5× the standard tier (896×1200 is literally half of 2400×1792).
Define a scale factor `s`: `s = 1.0` if `min(width,height) >= 1200`, else `s = 0.5`.

Because the offset is a fixed distance from the corner, **one command covers every ratio** —
no per-ratio mask files needed. Verified to land within 1 px of the real watermark on
1:1, 4:5, 9:16, 16:9, 4:3, 3:4, 2:3, 3:2.

## Step 1 — Build the mask with magick (procedural, no assets)

A filled circle covering the sparkle, corner-anchored. LaMa tolerates a slightly generous
mask, so a circle (simpler) works as well as the exact star shape.

```bash
# Read dimensions
read W H < <(magick identify -format "%w %h" "input.png")

# Scale tier: 1 for standard renders, 0.5 for small ones
s=1; [ "$(( W<H ? W : H ))" -lt 1200 ] && s=... # use 0.5 below the threshold

# Circle center = (W - 240*s, H - 240*s); radius ≈ 62*s   (240 = 192 margin + 48 half-star)
cx=$(( W - 240*s )); cy=$(( H - 240*s )); r=$(( 62*s ))
magick -size ${W}x${H} xc:black -fill white \
  -draw "circle $cx,$cy $cx,$((cy-r))" -blur 0x1 full-mask.png
```

Sanity check the mask covers the watermark: `magick full-mask.png -fuzz 15% -format "%@" info:`
should return a ~127×127 box whose center matches `(W-240*s, H-240*s)`.

For a **tighter** mask on very detailed backgrounds (mask less area → less to hallucinate),
draw an 8-point star polygon instead of a circle: outer points at radius `54*s` (up/down/
left/right), inner points at `18*s` on the diagonals, then `-morphology Dilate Diamond:6`.

## Step 2 — Erase with LaMa via IOPaint (CLI, no web server)

### One-time setup

IOPaint hard-pins `Pillow==9.5.0`, which **will not build on Python 3.13**. Use a 3.10/3.11
environment. Install into a home-relative location so the skill can find it without a
hardcoded path:

```bash
uv venv --python 3.10 "$HOME/iopaint-env"
VIRTUAL_ENV="$HOME/iopaint-env" uv pip install iopaint
```

(Any location works — if you install elsewhere or put `iopaint` on PATH, set `IOPAINT_BIN`
to the binary, or just ensure `iopaint` resolves on PATH. The resolver below checks all three.)

### Locate the binary (portable)

```bash
IOPAINT="${IOPAINT_BIN:-$(command -v iopaint || true)}"
[ -z "$IOPAINT" ] && [ -x "$HOME/iopaint-env/Scripts/iopaint.exe" ] && IOPAINT="$HOME/iopaint-env/Scripts/iopaint.exe"  # Windows venv
[ -z "$IOPAINT" ] && [ -x "$HOME/iopaint-env/bin/iopaint" ]        && IOPAINT="$HOME/iopaint-env/bin/iopaint"          # Unix venv
[ -z "$IOPAINT" ] && { echo "IOPaint not found — install per above"; exit 1; }
```

### Run (batch, headless)

```bash
"$IOPAINT" run \
  --model=lama --device=cpu \
  --image=<input_dir> \
  --mask=full-mask.png \
  --output=<output_dir>
```

- `--mask` as a **single file** applies to every image in `--image` — ideal for a batch of
  same-resolution Gemini images (they all share one mask).
- `--mask` as a **directory** matches masks to images by filename (needed when a batch mixes
  resolutions — generate one mask per image first).
- First run downloads `big-lama.pt` (~196 MB) to `~/.cache/torch/hub/checkpoints/`.

### Device: default to CPU for LaMa

**Keep `--device=cpu` for LaMa watermark removal** — CPU is ~6 s/image and, measured on a
Tesla T4, `--device=cuda` was *not* faster (and slower end-to-end once CUDA init is counted).
Two reasons: LaMa's crop strategy (`hd_strategy_crop_trigger_size=800`) only inpaints a small
region around the mask, so per-image compute is tiny and GPU transfer/launch overhead cancels
the gain; and CUDA context + cuDNN warmup is a fixed cost that a small batch never amortizes.

`--device=cuda` pays off only when the fixed overhead is amortized or the model is heavy:

- **Large batches** (hundreds+ of images) — warmup is paid once, per-image GPU wins add up.
- **Diffusion models** — `--model=runwayml/stable-diffusion-inpainting` or FLUX.1 Fill do
  full-image compute-heavy passes where the T4 gives a multi-x speedup (and they can take a
  text prompt for more control). These also need much more VRAM than LaMa.

To enable CUDA, install a matching CUDA torch build into the venv (Tesla T4 = compute 7.5,
any modern CUDA works). For torch 2.13.0 the cp310 Windows CUDA wheels are `cu126` / `cu130`:

```bash
VIRTUAL_ENV="$HOME/iopaint-env" uv pip install \
  "torch==2.13.0+cu126" "torchvision==0.28.0+cu126" \
  --index-url https://download.pytorch.org/whl/cu126
```

Verify: `python -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0))"`.

## Why not just magick?

`magick`'s clone/patch (copy pixels from elsewhere) removes the watermark cleanly only on
**flat, low-detail** backgrounds. On grass, bokeh, or any directional texture it leaves a
visible seam, because it relocates existing pixels rather than synthesizing new texture. LaMa
(Fourier-convolution GAN) generates plausible texture that continues the surroundings — the
right tool for detailed backgrounds. Keep magick for flat backgrounds; use LaMa for the rest.
