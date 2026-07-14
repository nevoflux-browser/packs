# ImageMagick — `magick stream`

Stream raw pixel components of an image (or a region) to a storage format, reading
row-by-row. For very large images where loading everything into memory is infeasible.

## Syntax

```
magick stream [options] input-image output-file
```

## Usage

```bash
# Extract RGB bytes
magick stream -map rgb -storage-type char image.jpg pixels.dat
# ...then interpret the raw data elsewhere, e.g.:
magick -depth 8 -size 640x480 rgb:pixels.dat preview.png

# Extract a 100x100 grayscale region at offset +30+40 as doubles
magick stream -map i -storage-type double -extract 100x100+30+40 image.tif gray.raw

# Same region selection via filename syntax
magick stream -map i -storage-type double 'image.tif[100x100+30+40]' gray.raw
```

## Key options

| Option | Purpose |
|--------|---------|
| `-map components` | which pixel components to emit (`rgb`, `rgba`, `i` = intensity, ...) |
| `-storage-type type` | output data type (`char`, `short`, `integer`, `float`, `double`) |
| `-extract geometry` | stream only this region |
| `-depth value` | source bit depth (for raw inputs) |
| `-limit type value` | cap pixel-cache resources |

## Agent notes

- Streaming requires the format's coder to read pixels in row order — **not all formats
  support it**; JPEG/PNG/TIFF generally do.
- Output is headerless raw data; you must record the dimensions/map/type yourself to
  reinterpret it later.
- For ordinary resize-a-huge-image tasks, prefer read-time resize instead:
  `magick 'huge.jpg[800x600]' out.jpg` (see magick/command-line-processing).
