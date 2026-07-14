# ImageMagick — `magick montage`

Combine multiple images into one composite grid (contact sheets, galleries, comparison
strips) with optional borders, frames, and labels.

## Syntax

```
magick montage [options] input-images output-file
```

## Common usage

```bash
# Basic contact sheet with filename labels
magick montage *.jpg -geometry 200x200+5+5 -label '%f' montage.jpg

# Fixed 3-column grid
magick montage *.jpg -tile 3x -geometry 200x200+4+4 grid.jpg

# Framed thumbnails on a colored background
magick montage -label %f -frame 5 -background '#336699' \
  -geometry 70x70+4+4 *.png framed.jpg

# Title above the sheet
magick montage *.jpg -title "My Photos" -background grey20 \
  -geometry 200x200+8+8 montage.jpg

# Side-by-side before/after strip (2 images, 1 row)
magick montage before.jpg after.jpg -tile 2x1 -geometry +2+2 compare.jpg
```

## Geometry semantics

`-geometry WIDTHxHEIGHT+X+Y`: each input is resized to fit WIDTHxHEIGHT, and `+X+Y` is the
**spacing** between tiles (not an offset). Omit the size part to keep original dimensions.

## Tool-specific options

| Option | Purpose |
|--------|---------|
| `-tile geometry` | tiles per row x column, e.g. `-tile 8x` = 8 columns |
| `-geometry geometry` | per-tile size + inter-tile spacing |
| `-label string` | label under each tile (`%f` = filename) |
| `-title string` | title across the top of the montage |
| `-frame geometry` | ornamental frame around each tile |
| `-shadow` | drop shadow under each tile |
| `-background color` | canvas background |
| `-texture filename` | tile a texture as the background |
| `-bordercolor` / `-border geometry` | plain border around tiles |
| `-mattecolor color` | frame color |
| `-mode type` | framing style (`Frame`, `Unframe`, `Concatenate`) |

## Agent notes

- `-mode Concatenate` joins images edge-to-edge with no padding — useful for pixel-exact
  side-by-side comparisons.
- Output paginates automatically when tiles exceed one sheet (`out-0.jpg`, `out-1.jpg`, ...).
- For per-image processing before tiling, pre-process with `magick`/`mogrify` first — montage
  applies its operators to every input uniformly.
