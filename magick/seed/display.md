# ImageMagick — `magick display`

Show an image or image sequence in an X server window. **Interactive/GUI tool — requires an
X server**; not usable in headless agent sessions or on Windows without an X server.

## Syntax

```
magick display [options] image_file
```

## Usage

```bash
magick display rose.jpg                             # show one image
magick display 'vid:*.jpg'                          # visual directory (thumbnail sheet)
magick display -density 72 drawing.svg              # render vector at intended size
magick display -size 1280x1024 -window root bg.png  # tile onto root window
```

## Key options

| Option | Purpose |
|--------|---------|
| `-window id` | display into the background of a window |
| `-update seconds` | redisplay when the file changes |
| `-backdrop` | center image on a backdrop |
| `-remote command` | control a running display process |
| `-geometry` / `-density` / `-size` | sizing controls |

## Agent notes

In an agent session, don't try to open windows. To show an image to the user, generate a
thumbnail and embed it in an artifact instead:

```bash
magick "input.jpg" -auto-orient -resize 500x -quality 80 jpg:- | base64 -w 0
```

(the magick skill's Mode B does exactly this).
