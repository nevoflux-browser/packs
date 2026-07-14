# ImageMagick — `magick import`

Capture some or all of an **X server screen** and save it as an image. X11-only — on Windows
or headless sessions use OS-native tools instead (see notes).

## Syntax

```
magick import [options] output_file
```

## Usage

```bash
magick import rose.jpg           # interactive: click a window or drag a region
magick import -window root screen.png    # capture the entire screen
magick import -window "Firefox" shot.png # capture a window by name
magick import -pause 3 -window root delayed.png  # wait 3s first
magick import clipboard:         # capture into the clipboard
```

## Key options

| Option | Purpose |
|--------|---------|
| `-window id` | window to capture (ID, name, or `root` for full screen) |
| `-screen` | grab from the root window (includes overlapping windows) |
| `-frame` | include the window-manager frame |
| `-border` | include the window border |
| `-pause seconds` | delay before capturing |
| `-crop geometry` | crop the captured region |
| `-trim` | trim edges of the capture |

## Agent notes

- On **Windows**, `import` does not work; screenshot via PowerShell/`Snipping Tool` or other
  native tooling, then process the file with `magick`.
- On **macOS**, use `screencapture` then process with `magick`.
- On Linux under Wayland, X11 capture may fail; use `grim`/`gnome-screenshot` instead.
