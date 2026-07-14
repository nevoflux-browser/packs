# ImageMagick — Command-line Processing Reference

## Anatomy of a command

A `magick` command follows this structure (all parts except input are optional):

```
magick [input(s)] [settings] [operators] [sequence-operators] [output]
```

- **Settings** — persist for all subsequent operations (e.g. `-background`, `-quality`, `-gravity`)
- **Operators** — act immediately on the current image (e.g. `-resize`, `-blur`, `-rotate`)
- **Sequence operators** — act on the image stack (e.g. `-append`, `-flatten`, `-composite`)
- **Image stack** — parentheses `\( ... \)` isolate a sub-sequence

## Input filename extensions

### Globbing
```bash
magick *.jpg animation.gif          # all JPGs in current dir
```

### Explicit format
```bash
magick -size 640x480 -depth 8 rgb:rawdata output.png
```

### Built-in patterns and images
```bash
magick -size 200x200 pattern:checkerboard out.png
magick -size 320x240 gradient:white-black out.png
magick -size 320x240 radial-gradient:white-black out.png
magick -size 320x240 xc:cornflowerblue out.png   # solid color
magick logo: logo.png                             # built-in wizard logo
magick rose: rose.png                             # built-in rose photo
```

### Frame selection (animated GIF, multi-page PDF, TIFF)
```bash
magick 'animation.gif[0]' first-frame.png        # first frame
magick 'animation.gif[0-3]' frames.mng           # frames 0–3
magick 'animation.gif[3,0,2]' reordered.mng      # specific order
magick 'document.pdf[0-4]' page-%02d.png         # PDF pages 0–4
```

### Region selection (raw images)
```bash
magick -size 6000x4000 -depth 8 'rgb:image[600x400+1900+2900]' crop.jpg
```

### Inline resize / crop on read (faster for large files)
```bash
magick '*.jpg[200x200]' thumbnail%03d.png        # resize as read
magick 'large.jpg[800x600+0+0]' cropped.jpg      # crop as read
```

### File list reference
```bash
magick @filelist.txt output.gif                  # read filenames from file
```

### STDIN / STDOUT (piping)
```bash
magick logo: gif:- | magick display gif:-        # pipe between commands
magick rose: gif:- | magick - -resize 200% big.jpg
```

## Geometry syntax

Used by `-resize`, `-crop`, `-extent`, `-region`, `-geometry`, `-thumbnail`, etc.

| Geometry | Meaning |
|----------|---------|
| `800x600` | Fit within 800×600, preserve aspect ratio |
| `800x600!` | Force exact 800×600 (may distort) |
| `800x600^` | Fill at least 800×600, preserve ratio (may overflow) |
| `800x600>` | Shrink only if larger than 800×600 |
| `800x600<` | Enlarge only if smaller than 800×600 |
| `50%` | Scale both dimensions by 50% |
| `200x50%` | Width 200px, height 50% of original |
| `800` | Width 800px, height auto (preserve ratio) |
| `x600` | Height 600px, width auto (preserve ratio) |
| `10000@` | Resize to ~10000 total pixels, preserve ratio |
| `widthxheight+x+y` | Size + offset from top-left (for crop/region) |

### Examples
```bash
magick logo: -resize '200%' big.png
magick logo: -resize '100x200' fit-box.png      # max 100 wide, 200 tall
magick logo: -resize '100x200^' fill-box.png    # min 100 wide, 200 tall
magick logo: -resize '100x200!' exact.png        # exactly 100x200
magick logo: -resize '10000@' small.png          # ~10K pixels total
```

## Option categories

### Image settings (persist throughout the command)
Common settings: `-background`, `-channel`, `-colorspace`, `-compress`, `-delay`, `-density`,
`-depth`, `-dither`, `-encoding`, `-fill`, `-filter`, `-font`, `-format`, `-fuzz`, `-geometry`,
`-gravity`, `-interlace`, `-label`, `-limit`, `-loop`, `-page`, `-pointsize`, `-quality`,
`-sampling-factor`, `-size`, `-stroke`, `-tile`, `-type`, `-units`, `-verbose`

### Image operators (applied immediately to current image)
Common operators: `-annotate`, `-blur`, `-border`, `-charcoal`, `-chop`, `-colorize`,
`-contrast`, `-crop`, `-despeckle`, `-draw`, `-edge`, `-emboss`, `-enhance`, `-equalize`,
`-extent`, `-flip`, `-flop`, `-frame`, `-gamma`, `-gaussian-blur`, `-grayscale`, `-implode`,
`-level`, `-median`, `-modulate`, `-negate`, `-noise`, `-normalize`, `-paint`, `-posterize`,
`-raise`, `-resize`, `-roll`, `-rotate`, `-sample`, `-scale`, `-sepia-tone`, `-shade`,
`-shadow`, `-sharpen`, `-shave`, `-shear`, `-solarize`, `-spread`, `-strip`, `-swirl`,
`-threshold`, `-thumbnail`, `-tint`, `-trim`, `-unsharp`, `-wave`

### Image sequence operators (act on image stack)
`-append`, `-average`, `-coalesce`, `-combine`, `-composite`, `-delete`, `-evaluate-sequence`,
`-flatten`, `-fx`, `-hald-clut`, `-insert`, `-layers`, `-maximum`, `-minimum`, `-morph`,
`-mosaic`, `-optimize`, `-swap`

## Image stack with parentheses

Isolate operations to a sub-image without affecting the outer stack:

```bash
# Rotate only wizard, then append both
magick wand.gif \( wizard.gif -rotate 30 \) +append combined.gif

# Linux: escape parens with backslash
# Windows: no escaping needed — use ( ) directly
```

## Output filename patterns

```bash
magick *.jpg frame-%03d.png           # frame-000.png, frame-001.png, ...
magick rose: -set filename:area '%wx%h' 'rose-%[filename:area].png'  # rose-70x46.png
magick *.jpg +adjoin page-%d.pdf      # separate PDF pages
```

## Settings that affect write behavior

- `-quality 85` — JPEG/WebP compression (1–100; higher = better quality, larger file)
- `-compress LZW` — PNG/TIFF lossless compression algorithm
- `-strip` — remove all embedded profiles and metadata (reduces file size)
- `-interlace Plane` — progressive/interlaced output (JPEG or PNG)
- `-depth 8` — bits per channel for raw formats

## Gravity

Controls anchor point for positioning operations (`-crop`, `-extent`, `-annotate`, `-composite`):

```
NorthWest  North  NorthEast
West       Center  East
SouthWest  South  SouthEast
```

```bash
magick input.jpg -gravity center -crop 400x300+0+0 +repage out.jpg
magick input.jpg -gravity southeast -extent 800x600 padded.jpg
```

## Performance tips

- Read-resize for large batches: `'*.jpg[200x200]'` instead of `-resize` after load
- Use `-limit memory 512MB` to cap RAM use on large images
- `magick mogrify -path ./out/` with `-thumbnail` for batch thumbnailing
- `-strip` removes metadata and can significantly reduce output file size
- `-sampling-factor 4:2:0 -interlace JPEG` for web-optimized progressive JPEGs
