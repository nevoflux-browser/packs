# ImageMagick — `magick animate`

Display an animated image sequence in an X server window. **Interactive/GUI tool — requires
an X server**; not usable in headless agent sessions or on Windows without an X server.

## Syntax

```
magick animate [options] filename
```

## Usage

```bash
magick animate movie.gif        # play a GIF
magick animate *.jpg            # animate a JPEG sequence
magick animate -delay 20 frame*.png   # 20 centiseconds between frames
```

## Key options

| Option | Purpose |
|--------|---------|
| `-delay centiseconds` | pause between frames |
| `-coalesce` | merge frame layers before display |
| `-update seconds` | re-animate when the file changes on disk |
| `-window id` | animate onto the background of a window |
| `-backdrop` | center on a full-screen backdrop |
| `-remote command` | control an already-running animate process |

## Agent notes

To **create or modify** animations without a display, use the main `magick` command instead:

```bash
magick -delay 10 frame*.png -loop 0 animation.gif   # build a GIF
magick animation.gif frame_%03d.png                 # extract frames
```

See the Animation section of magick/common-operations.
