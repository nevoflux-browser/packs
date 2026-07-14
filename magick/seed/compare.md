# ImageMagick — `magick compare`

Mathematically and visually annotate the difference between two images. Produces a numeric
distortion metric (on stderr) and optionally a visual difference image.

## Syntax

```
magick compare [options] image1 image2 [difference-output]
```

## Exit codes (differ from other magick tools!)

- `0` — images are similar
- `1` — images are dissimilar
- `2` — error (bad syntax, unreadable input)

## Common usage

```bash
# Numeric difference only (metric printed to stderr), no output image
magick compare -metric RMSE a.png b.png null:

# Visual diff image: changed pixels highlighted red, unchanged faded
magick compare a.png b.png diff.png

# Custom highlight colors
magick compare -highlight-color blue -lowlight-color white a.png b.png diff.png

# Tolerant comparison — ignore small color differences
magick compare -metric AE -fuzz 5% a.png b.png diff.png

# Find where a small image appears inside a larger one
magick compare -metric RMSE -subimage-search large.png crop.png result.png
```

## Metrics (`-metric type`)

Common values: `AE` (absolute pixel count differing), `MAE`, `MSE`, `RMSE`, `PAE`, `PSNR`,
`NCC`, `FUZZ`, `SSIM`, `DSSIM`, `PHASH` (perceptual hash — robust to resize/recompress).
Verify the installed list with `magick compare -list metric`.

- `AE` + `-fuzz` answers "how many pixels actually changed"
- `RMSE`/`PSNR` for overall signal difference
- `SSIM`/`PHASH` for perceptual similarity

## Tool-specific options

| Option | Purpose |
|--------|---------|
| `-metric type` | which distortion metric to report |
| `-fuzz distance` | colors within this distance count as equal |
| `-dissimilarity-threshold value` | max distortion still considered a match (default 0.2) |
| `-similarity-threshold value` | min distortion for subimage match (default 0.0) |
| `-subimage-search` | locate a smaller image within a larger one |
| `-highlight-color color` | color for changed pixels in diff image |
| `-lowlight-color color` | color for unchanged pixels in diff image |
| `-channel type` | restrict comparison to specific channels |
| `-verbose` | per-channel distortion detail |

## Agent notes

- The metric value goes to **stderr**, not stdout — capture accordingly (`2>&1`).
- Use `null:` as output when you only need the number.
- Images of different dimensions error out unless using `-subimage-search`.
