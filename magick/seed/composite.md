# ImageMagick — `magick composite`

Layer one image over another (watermarks, overlays, masks, blends).

## Syntax — argument order matters

```
magick composite [options] overlay base [mask] output
```

The **overlay comes first**, then the base image it is placed onto. This is the reverse of the
equivalent `magick base.jpg overlay.png -composite out.jpg` form.

## Common usage

```bash
# Watermark in the bottom-right corner
magick composite -gravity southeast watermark.png photo.jpg out.jpg

# Position by explicit offset from top-left
magick composite -geometry +50+100 logo.png base.jpg out.jpg

# 50% transparent overlay
magick composite -dissolve 50 overlay.png base.jpg out.jpg

# Blend two images
magick composite -blend 30x70 a.jpg b.jpg out.jpg

# Classic faint watermark (brightness/saturation percent)
magick composite -watermark 30 logo.png photo.jpg out.jpg

# Tile a texture across the whole base
magick composite -tile pattern.png base.jpg out.jpg

# Use a specific compose operator
magick composite -compose Multiply overlay.png base.jpg out.jpg
```

## Compose operators (`-compose operator`)

Common values: `Over` (default), `Multiply`, `Screen`, `Overlay`, `Darken`, `Lighten`,
`CopyOpacity`, `Difference`, `Atop`, `Xor`, `Plus`, `SrcOver`, `DstOver`, `SeamlessBlend`.
Full installed list: `magick -list compose`.

## Tool-specific options

| Option | Purpose |
|--------|---------|
| `-compose operator` | composite method |
| `-geometry geometry` | overlay size and/or position (`+x+y`) |
| `-gravity type` | anchor corner/edge/center for positioning |
| `-dissolve value` | overlay opacity percent |
| `-blend geometry` | blend the two images (`src%xdst%`) |
| `-watermark geometry` | percent brightness and saturation of a watermark |
| `-tile` | repeat the composite across and down the base |
| `-stereo geometry` | combine two images into a stereo anaglyph |
| `-displace geometry` | shift pixels using a displacement map |
| `-alpha ...` | control the alpha channel (on/off/set/extract/...) |

## Agent notes

- An optional third input image acts as a mask. Read-masks are black-on-white (inverse of
  normal white-on-black masks).
- For multi-layer or scripted composition, the main `magick` command with parenthesized
  stacks and `-composite` is more flexible — see magick/command-line-processing.
