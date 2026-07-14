# ImageMagick — Common Operations Reference

## Format conversion

```bash
# Single file — format determined by output extension
magick input.bmp output.png
magick input.jpg output.webp
magick input.png output.pdf

# Batch convert all JPGs to PNG
magick mogrify -format png -path ./png_out *.jpg

# Convert all PNGs to WebP
magick mogrify -format webp -path ./webp_out *.png

# Multi-page PDF to individual images
magick -density 150 document.pdf page-%03d.jpg
```

## Resizing and scaling

```bash
# Fit within bounding box (preserve aspect ratio)
magick input.jpg -resize 800x600 output.jpg

# Scale by percentage
magick input.jpg -resize 50% output.jpg

# Force exact dimensions (may distort)
magick input.jpg -resize 800x600! output.jpg

# Shrink only (never enlarge)
magick input.jpg -resize 800x600> output.jpg

# Enlarge only (never shrink)
magick input.jpg -resize 800x600< output.jpg

# Set maximum area in pixels
magick input.jpg -resize 250000@ output.jpg

# Batch resize all JPGs (in-place — overwrites!)
magick mogrify -resize 1200x -quality 85 *.jpg

# Batch resize into output folder (safe)
magick mogrify -resize 800x -quality 85 -path ./resized *.jpg
```

## Thumbnails

```bash
# Square thumbnail (crop to fill)
magick input.jpg -thumbnail 200x200 -gravity center -extent 200x200 thumb.jpg

# Thumbnail with padding (letterbox / pillarbox)
magick input.jpg -thumbnail 200x200 -gravity center -background white -extent 200x200 thumb.jpg

# Batch thumbnails into ./thumbs/
mkdir -p thumbs
magick mogrify -auto-orient -thumbnail 200x200 -gravity center -extent 200x200 \
  -quality 75 -path ./thumbs *.jpg
```

## Cropping

```bash
# Crop region: WIDTHxHEIGHT+X_OFFSET+Y_OFFSET
magick input.jpg -crop 400x300+50+100 +repage output.jpg

# Crop centered
magick input.jpg -gravity center -crop 400x300+0+0 +repage output.jpg

# Trim whitespace / border from edges
magick input.jpg -fuzz 5% -trim +repage output.jpg

# Chop 20px from top
magick input.jpg -chop 0x20 output.jpg

# Shave 10px border from all sides
magick input.jpg -shave 10x10 output.jpg
```

## Rotation and flipping

```bash
magick input.jpg -rotate 90 output.jpg       # clockwise 90
magick input.jpg -rotate -90 output.jpg      # counter-clockwise 90
magick input.jpg -rotate 180 output.jpg      # upside-down
magick input.jpg -rotate 45 output.jpg       # arbitrary angle (adds background)
magick input.jpg -auto-orient output.jpg     # correct from EXIF orientation tag
magick input.jpg -flip output.jpg            # vertical mirror (top-bottom)
magick input.jpg -flop output.jpg            # horizontal mirror (left-right)
```

## Blur and sharpening

```bash
# Gaussian blur: -blur RADIUSxSIGMA
magick input.jpg -blur 0x4 output.jpg        # sigma=4, noticeable blur
magick input.jpg -blur 0x1 output.jpg        # subtle blur

# Gaussian blur (slower, more accurate)
magick input.jpg -gaussian-blur 0x2 output.jpg

# Sharpen: -sharpen RADIUSxSIGMA
magick input.jpg -sharpen 0x1 output.jpg
magick input.jpg -sharpen 0x2 output.jpg     # stronger sharpen

# Unsharp mask (better for photos): RADIUS x SIGMA + AMOUNT + THRESHOLD
magick input.jpg -unsharp 0x1+1.5+0.05 output.jpg
```

## Color adjustments

```bash
# Convert to grayscale
magick input.jpg -grayscale Rec709Luma output.jpg

# Negate (invert) colors
magick input.jpg -negate output.jpg

# Normalize (auto stretch levels to full range)
magick input.jpg -normalize output.jpg

# Adjust levels: black point, white point
magick input.jpg -level 10%,90% output.jpg

# Modulate: brightness, saturation, hue (all as % of original)
magick input.jpg -modulate 110,80,100 output.jpg   # +10% bright, -20% saturation

# Gamma correction
magick input.jpg -gamma 1.5 output.jpg

# Colorize (tint)
magick input.jpg -colorize 0,0,50 output.jpg       # blue tint

# Sepia tone
magick input.jpg -sepia-tone 80% output.jpg

# Equalize histogram
magick input.jpg -equalize output.jpg

# Threshold (make binary black/white)
magick input.jpg -threshold 50% output.jpg
```

## Effects and filters

```bash
# Charcoal sketch
magick input.jpg -charcoal 2 output.jpg

# Oil painting
magick input.jpg -paint 4 output.jpg

# Emboss
magick input.jpg -emboss output.jpg

# Enhance (reduce noise, improve quality)
magick input.jpg -enhance output.jpg

# Edge detection
magick input.jpg -edge 1 output.jpg

# Despeckle (reduce noise)
magick input.jpg -despeckle output.jpg

# Spread (scatter pixels randomly)
magick input.jpg -spread 5 output.jpg

# Implode (suck inward)
magick input.jpg -implode 0.5 output.jpg

# Swirl
magick input.jpg -swirl 90 output.jpg

# Wave distortion
magick input.jpg -wave 10x100 output.jpg

# Posterize (reduce to N color levels per channel)
magick input.jpg -posterize 4 output.jpg

# Solarize (partial inversion)
magick input.jpg -solarize 50% output.jpg
```

## Adding borders and frames

```bash
# Solid border
magick input.jpg -bordercolor black -border 10 output.jpg
magick input.jpg -bordercolor white -border 20x10 output.jpg   # 20px horizontal, 10px vertical

# 3D-style raised frame
magick input.jpg -frame 10x10+3+3 output.jpg

# Extend canvas (add padding)
magick input.jpg -gravity center -background white -extent 900x700 output.jpg
```

## Text and annotations

```bash
# Simple annotation
magick input.jpg -font Arial -pointsize 36 -fill white \
  -annotate +10+40 "Caption text" output.jpg

# Annotation with shadow
magick input.jpg -font Arial -pointsize 36 \
  -fill black -annotate +12+42 "Shadow" \
  -fill white -annotate +10+40 "Shadow" output.jpg

# Create text label
magick -size 400x100 xc:white -font Arial -pointsize 48 \
  -fill black -annotate +10+60 "Hello World" label.png

# Using label: pseudo-image
magick -background white -fill navy -pointsize 36 label:"Hello World" label.png
```

## Compositing images

```bash
# Overlay on top
magick base.jpg watermark.png -gravity southeast -composite output.jpg

# Overlay with transparency
magick base.jpg watermark.png -gravity center -compose Over -composite output.jpg

# Side by side
magick +append left.jpg right.jpg combined.jpg

# Stack vertically
magick -append top.jpg bottom.jpg stacked.jpg
```

## Metadata

```bash
# View all metadata
magick identify -verbose input.jpg

# Strip all metadata (EXIF, IPTC, ICC profile) — reduces file size
magick input.jpg -strip output.jpg

# Set specific property
magick input.jpg -set comment "My photo" output.jpg
```

## Quality and optimization

```bash
# JPEG quality (1-100; 85 is good for web)
magick input.jpg -quality 85 output.jpg

# Progressive JPEG (loads top-to-bottom while downloading)
magick input.jpg -interlace JPEG -quality 85 output.jpg

# WebP lossless
magick input.jpg -define webp:lossless=true output.webp

# PNG compression level (0-9)
magick input.png -define png:compression-level=9 output.png

# Optimize for web: strip + quality + resize
magick input.jpg -auto-orient -resize 1200x> -quality 82 -strip output.jpg
```

## Montage (contact sheet)

```bash
# Basic montage with labels
magick montage *.jpg -geometry 200x200+5+5 -label '%f' montage.jpg

# Fixed grid (3 columns)
magick montage *.jpg -tile 3x -geometry 200x200+4+4 grid.jpg

# Background color and title
magick montage *.jpg -title "My Photos" -background grey20 \
  -geometry 200x200+8+8 montage.jpg
```

## Animation

```bash
# Create GIF animation from frames
magick -delay 10 frame*.png -loop 0 animation.gif

# Extract frames from GIF
magick animation.gif frame_%03d.png

# Optimize animated GIF
magick animation.gif -coalesce -layers Optimize optimized.gif

# Resize each frame
magick animation.gif -coalesce -resize 200x -layers Optimize resized.gif
```
