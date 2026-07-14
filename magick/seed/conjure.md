# ImageMagick — `magick conjure`

Execute image-processing scripts written in MSL (Magick Scripting Language, XML-based).
Rarely needed — multi-step pipelines are usually clearer as plain `magick` commands.

## Syntax

```
magick conjure [options] script.msl
magick conjure -dimensions 400x400 msl:incantation.msl   # pass parameters
```

## MSL script structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<image>
  <read filename="input.gif" />
  <resize geometry="300x300" />
  <write filename="output.png" />
</image>
```

Root elements are `<image>` or `<group>`; children are action statements with attributes.

## Key MSL elements

| Element | Purpose |
|---------|---------|
| `<read>` / `<write>` | load / save images |
| `<resize>`, `<scale>`, `<sample>` | sizing |
| `<composite>` | layer images |
| `<annotate>` | draw text |
| `<get>` / `<print>` | read properties / output messages |
| `<query-font-metrics>` | measure text dimensions |

Command-line parameters are referenced inside the script via `%[name]` substitution
(e.g. `%[dimensions]` for `-dimensions`).

## Options

`-debug events`, `-verbose`, `-quiet`, `-monitor`, `-seed value`.

## Agent notes

Prefer a plain `magick` one-liner or a shell loop over MSL unless the user specifically has
`.msl` scripts. See magick/command-line-processing for the equivalent stack syntax.
