# ImageMagick — `magick identify`

Report format, size, color depth, and other metadata about image files. Read-only — never
modifies the input.

## Syntax

```
magick identify [options] filename...
```

Default output: `Filename[frame #] format widthxheight page-geometry colorspace filesize user-time elapsed-time`

```bash
magick identify rose.jpg
# rose.jpg JPEG 70x46 70x46+0+0 8-bit sRGB 2.36KB 0.000u 0:00.000
```

## Common usage

```bash
# Full metadata dump (EXIF, profiles, histogram, statistics)
magick identify -verbose image.jpg

# Custom per-image output with format escapes
magick identify -format "%f: %wx%h %b\n" *.jpg

# Fast check — read only the header, not pixel data
magick identify -ping image.jpg

# Computed values via fx escapes (e.g. print size at 72 DPI)
magick identify -format "%[fx:w/72] by %[fx:h/72] inches" document.png

# Identify raw data (needs explicit size/depth)
magick identify -depth 8 -size 640x480 image.raw

# Verify an image is not corrupt/incomplete
magick identify -regard-warnings image.jpg   # non-zero exit on warnings
```

## Useful format escapes (`-format`)

| Escape | Meaning |
|--------|---------|
| `%f` | filename |
| `%w` / `%h` | width / height in pixels |
| `%b` | file size |
| `%m` | format (JPEG, PNG, ...) |
| `%[colorspace]` | colorspace |
| `%[EXIF:Orientation]` | specific EXIF tag |
| `%[fx:...]` | computed expression |
| `%n` | number of frames/pages in the file |

## Tool-specific options

| Option | Purpose |
|--------|---------|
| `-verbose` | print detailed information |
| `-format string` | formatted output per image |
| `-ping` | header-only read (fast); `+ping` forces full pixel analysis |
| `-precision value` | max significant digits printed |
| `-unique` | report number of unique colors |
| `-moments` | image moments and perceptual hash |
| `-features distance` | texture features (contrast, correlation, ...) |
| `-regard-warnings` | treat warnings as significant (exit code) |
| `-quiet` | suppress warnings |
| `-define identify:locate=maximum -define identify:limit=3` | locate extreme pixels |

## Agent notes

- Use `-ping` when scanning many files — it avoids decoding pixels.
- `-format` output has no trailing newline unless you add `\n`.
- For batch dimension checks prefer one call with a glob over per-file calls.
