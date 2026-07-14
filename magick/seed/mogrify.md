# ImageMagick — `magick mogrify`

Batch-transform many images with one command. **Overwrites the originals in place** unless
`-format` (new extension) or `-path` (new directory) redirects the output.

## Syntax

```
magick mogrify [options] filename(s)
```

## Overwrite semantics — read this first

| Invocation | Originals |
|------------|-----------|
| `magick mogrify -resize 50% *.jpg` | **OVERWRITTEN** |
| `magick mogrify -format png *.jpg` | kept (writes `.png` siblings) |
| `magick mogrify -path ./out *.jpg` | kept (writes into `./out/`) |

Always confirm with the user before running mogrify without `-format` or `-path`.

## Common usage

```bash
# Resize one file in place
magick mogrify -resize 50% rose.jpg

# Batch resize in place (destructive!)
magick mogrify -resize 256x256 *.jpg

# Convert all PNGs to JPG — originals untouched, 1.jpg, 2.jpg... created
magick mogrify -format jpg *.png

# Safe batch resize into a subdirectory
mkdir -p resized
magick mogrify -resize 800x -quality 85 -path ./resized *.jpg

# Batch thumbnails
mkdir -p thumbs
magick mogrify -auto-orient -thumbnail 200x200 -gravity center -extent 200x200 \
  -quality 75 -path ./thumbs *.jpg

# Strip metadata from all images in place
magick mogrify -strip *.jpg
```

## Tool-specific options

| Option | Purpose |
|--------|---------|
| `-format type` | write output with this extension instead of overwriting |
| `-path path` | write output files to this directory |

All regular image operators (`-resize`, `-blur`, `-crop`, `-rotate`, `-flip`, `-flop`,
`-quality`, `-strip`, ...) apply per file — see the magick/common-operations page for recipes
and magick/command-line-processing for geometry syntax.

## Agent notes

- `-path` directory must already exist (`mkdir -p` first).
- Combine `-format` and `-path` to both convert and redirect.
- Quote globs on shells that expand them differently than expected; on Windows cmd, globs are
  expanded by ImageMagick itself.
