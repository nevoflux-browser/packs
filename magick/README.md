# magick

**English** · [中文](README.zh.md)

A NevoFlux pack that turns the ImageMagick `magick` CLI into an **image browser and
processor**. Browse a folder as a thumbnail gallery, convert / resize / crop / effect a single
image or a whole directory, and — for Gemini/Imagen images — **remove the sparkle watermark
with AI inpainting**. Invoke with `/magick`.

## Requires the magick CLI

magick calls the `magick` binary (ImageMagick 7) via `bash` directly, so it needs **ImageMagick
on PATH**. Step 0 runs `magick --version` and, if missing, prints the install command for your
OS (`winget` / `brew` / `apt` / `dnf`). The interactive gallery and before/after previews render
as artifacts via `create_artifact`. **Mode E** (watermark removal) additionally needs
**IOPaint** — an optional, one-time setup covered in `seed/gemini-watermark.md`.

## Usage

Invoke `/magick`, optionally with a directory or an image path. Trigger phrases include
`/magick`, `magick`, `imagemagick`, browse images, image browser, 处理图片, 图像处理, 图片浏览,
图片转换, 缩略图.

### Examples by task

| Task | Example |
| --- | --- |
| Browse a folder | `/magick browse ./photos` |
| Process one image | `/magick resize ./a.jpg to 800px wide, quality 85` |
| Batch a directory | `/magick make 200px thumbnails of every jpg in ./photos` |
| Convert format | `/magick convert ./logo.png to webp` |
| Remove Gemini watermark | `/magick remove the watermark from ./gemini_*.png` |
| 中文 | `/magick 把 ./photos 里的图批量转成 webp` |

## Modes

magick routes to one of five modes by what you ask:

1. **Browse (A)** — glob an image folder, generate base64 thumbnails, and render an interactive
   gallery artifact: click a thumbnail → processing panel → pick a quick op or type custom
   flags → **Generate Command**. Ask the agent to run a generated command and it switches to
   Mode B.
2. **Process (B)** — run one `magick` operation and show a before/after comparison (both images
   embedded inline as data URLs).
3. **Batch (C)** — `mogrify` across a directory; confirms first when it would overwrite
   originals (no `-path` / `-format`).
4. **Convert (D)** — single-file or directory format conversion.
5. **Remove watermark (E)** — erase the Gemini/Imagen bottom-right ✦ watermark with **LaMa
   inpainting** (via IOPaint), for detailed backgrounds where a plain magick clone/patch leaves
   a seam. magick builds a corner-anchored mask; LaMa synthesizes matching texture.

**Reference pages routed on demand.** SKILL.md keeps an inline quick-reference for routine
flags and, for anything beyond it, routes to one of 13 seed pages in the brain — core syntax,
common-operation recipes, and one page per sub-command (`identify`, `mogrify`, `montage`,
`composite`, `compare`, `animate`, `display`, `import`, `conjure`, `stream`) — so the skill
stays small and looks up specifics only when needed.

## Structure

```
magick/
  pack.toml
  skills/magick/SKILL.md            # 5 modes, route table, quick-reference, operating rules
  seed/
    command-line-processing.md      # geometry, settings vs operators, ( ) stacks, output patterns
    common-operations.md            # task recipes: resize/crop/color/effects/text/animation
    identify.md mogrify.md montage.md composite.md compare.md   # high-frequency sub-commands
    animate.md display.md import.md conjure.md stream.md        # niche / interactive tools
    gemini-watermark.md             # watermark placement rule + LaMa/IOPaint removal workflow
  .provenance.json                  # source manifest for the synthesized seed content
```

## Notes

- **`mogrify` overwrites originals** unless `-path` or `-format` redirects output — Mode C
  warns and confirms before any destructive batch.
- **Reference pages load on demand** — routine flags come from the inline quick-reference (zero
  lookups); only specifics (exact sub-command options, geometry edge cases) trigger a brain
  page read, keeping SKILL.md lean.
- **Watermark placement is a measured rule** — the Gemini/Imagen sparkle is fixed-pixel,
  anchored to the bottom-right corner (96×96 px at a 192 px margin; half for small renders), so
  one corner-anchored magick mask covers every aspect ratio — no per-ratio assets shipped.
- **Mode E defaults to `--device=cpu`** — measured, CUDA doesn't speed up LaMa on small batches
  (crop strategy + fixed warmup); GPU pays off only for large batches or heavier diffusion
  models. IOPaint is located by a portable resolver (env override / PATH / home venv).
- **Seed content is synthesized** from the official ImageMagick docs (paraphrased, not copied)
  plus original measurement; sources are recorded in `.provenance.json`.

## License

MIT
