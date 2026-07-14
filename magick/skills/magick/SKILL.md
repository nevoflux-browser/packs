---
name: magick
description: ImageMagick command-line image processing and interactive image browser. Browse image directories as thumbnail galleries (click-to-select, processing panel, preview, back navigation), convert image formats, resize, crop, blur, rotate, add effects, batch-process entire folders, and run custom magick commands. Use when user wants to process/edit/convert images, browse an image folder, generate thumbnails, or says "magick", "/magick", "处理图片", "图像处理", "图片浏览", "图片转换", "缩略图", "image browser", "convert image".
version: "0.3.2"
author: "NevoFlux"
tags: [imagemagick, magick, image-processing, thumbnails, convert, resize, image-browser, 图像处理]
enabled: true
triggers:
  - "/magick"
  - "magick"
  - "imagemagick"
  - "处理图片"
  - "图像处理"
  - "图片浏览"
  - "图片转换"
  - "缩略图"
  - "browse images"
  - "image browser"
dependencies:
  - "magick/command-line-processing"
  - "magick/common-operations"
  - "magick/identify"
  - "magick/mogrify"
  - "magick/montage"
  - "magick/composite"
  - "magick/compare"
  - "magick/animate"
  - "magick/display"
  - "magick/import"
  - "magick/conjure"
  - "magick/stream"
  - "magick/gemini-watermark"
# allowed_tools is an availability gate only — list tools in every mode's catalog.
# bash / glob / read are called DIRECTLY at runtime (never via tool_call_dynamic).
# create_artifact and browser_* are reached via tool_search -> tool_call_dynamic.
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# magick — ImageMagick image browser & processor

Process images using the `magick` CLI. Three modes: **Browse** (interactive thumbnail gallery),
**Process** (single-image operations with before/after preview), **Batch** (directory-wide transforms).

## Step 0 — Verify installation

```bash
magick --version
```

If not found, tell the user:
- **Windows**: `winget install ImageMagick.Q16-HDRI` or download from https://imagemagick.org
- **macOS**: `brew install imagemagick`
- **Linux**: `sudo apt install imagemagick` or `sudo dnf install ImageMagick`

## Reference pages — read from the brain on demand

This pack installs 12 reference pages under the `magick/` namespace. The **Quick reference
table** below covers routine flags — use it directly, zero lookups. For anything beyond it
(exact option arguments, sub-command specifics, geometry edge cases), **read the matching
page instead of guessing flags from memory**: `tool_search` for the brain page-read tool,
then `tool_call_dynamic` with the page slug.

| When the task involves... | Read page |
|---------------------------|-----------|
| Geometry syntax, settings vs operators, `\( \)` stacks, frame selection, output patterns, piping | `magick/command-line-processing` |
| Task recipes: resize, crop, rotate, color, effects, borders, text, quality, animation GIFs | `magick/common-operations` |
| Image metadata, dimensions, format info, corruption checks | `magick/identify` |
| Batch in-place transforms, `-path` / `-format` semantics | `magick/mogrify` |
| Contact sheets, grids, side-by-side comparison strips | `magick/montage` |
| Watermarks, overlays, blending two images, masks | `magick/composite` |
| Diffing two images, similarity metrics, subimage search | `magick/compare` |
| MSL (`.msl`) script execution | `magick/conjure` |
| Streaming raw pixels from very large images | `magick/stream` |
| Animated display in a window — interactive, X11 only | `magick/animate` |
| Showing images in a window — interactive, X11 only | `magick/display` |
| X11 screen capture (not Windows) | `magick/import` |
| Removing the Gemini/Imagen sparkle watermark (AI inpainting) | `magick/gemini-watermark` |

### Key tool distinctions

| Tool | Output | Overwrites originals? |
|------|--------|-----------------------|
| `magick` | new file(s) | no |
| `magick mogrify` | same file(s) | **yes** (unless `-path` or `-format`) |
| `magick montage` | single composite | no |
| `magick compare` | difference image | no |

### Capability checks

```bash
magick -list format     # supported read/write formats
magick -list delegate   # external delegates (ghostscript, webp, ...)
magick -list font       # available fonts
```

Exit codes: `0` success, `1` any error — **except** `magick compare`: `0` similar,
`1` dissimilar, `2` error.

## Mode A — Interactive image browser (看板 / gallery dashboard)

Launch when user provides a directory path or says "browse images".

### A1. Discover images

Use `glob` directly to find image files:

```
glob: <directory>/*.jpg
glob: <directory>/*.jpeg
glob: <directory>/*.png
glob: <directory>/*.gif
glob: <directory>/*.bmp
glob: <directory>/*.webp
glob: <directory>/*.tiff
```

Combine results, remove duplicates, cap at 60 for performance. If >60 images, tell the user.

### A2. Generate thumbnails as base64

For each image, run (use `bash` directly — NOT via tool_call_dynamic):

```bash
magick "<image_path>" -auto-orient -thumbnail 200x200 -gravity center -extent 200x200 -quality 72 jpg:- | base64 -w 0
```

On Windows the `-w 0` flag may not be needed; join all output lines into one string.

Collect into a JSON array: `[{"name":"file.jpg","path":"/full/path/file.jpg","b64":"<base64string>"},...]`

If magick is unavailable, set `b64` to empty string — the gallery will show a placeholder.

### A3. Render the gallery via create_artifact

Call `tool_search("create_artifact")` then `tool_call_dynamic` with the following HTML artifact.
Substitute `__DIR__` with the directory display name and `__IMAGES__` with the JSON array string.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Image Browser</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:system-ui,sans-serif;background:#0d1117;color:#e6edf3;height:100vh;display:flex;flex-direction:column;overflow:hidden}
.hdr{background:#161b22;border-bottom:1px solid #30363d;padding:10px 16px;display:flex;align-items:center;gap:10px;flex-shrink:0}
.hdr-title{font-size:14px;font-weight:600;color:#58a6ff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.back{background:#21262d;border:1px solid #30363d;color:#e6edf3;padding:4px 12px;border-radius:6px;cursor:pointer;font-size:12px;display:none;flex-shrink:0}
.back:hover{background:#30363d;border-color:#8b949e}
.count{font-size:12px;color:#8b949e;margin-left:auto;flex-shrink:0}
#gallery{display:grid;grid-template-columns:repeat(auto-fill,minmax(148px,1fr));gap:10px;padding:14px;overflow-y:auto;flex:1}
.card{background:#161b22;border:1px solid #30363d;border-radius:8px;overflow:hidden;cursor:pointer;transition:border-color .15s,transform .15s}
.card:hover{border-color:#58a6ff;transform:translateY(-2px)}
.card img{width:100%;height:128px;object-fit:cover;background:#21262d;display:block}
.card .nm{padding:5px 8px;font-size:11px;color:#8b949e;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
#proc{display:none;flex:1;overflow-y:auto;padding:16px}
.proc-inner{max-width:860px;margin:0 auto}
.preview-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:14px}
.pbox{background:#161b22;border:1px solid #30363d;border-radius:8px;padding:12px;text-align:center}
.pbox h3{font-size:11px;color:#8b949e;margin-bottom:8px;text-transform:uppercase;letter-spacing:.06em}
.pbox img{max-width:100%;max-height:240px;object-fit:contain;border-radius:4px;background:#0d1117}
.pbox .info{font-size:11px;color:#6e7681;margin-top:6px;word-break:break-all}
.sec-label{font-size:12px;color:#58a6ff;font-weight:600;margin:12px 0 6px;padding-bottom:4px;border-bottom:1px solid #21262d}
.ops{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:10px}
.op{background:#21262d;border:1px solid #30363d;color:#c9d1d9;padding:4px 10px;border-radius:5px;cursor:pointer;font-size:12px;transition:border-color .1s,color .1s}
.op:hover,.op.active{border-color:#58a6ff;color:#58a6ff;background:#1c2d40}
.cmd-input{width:100%;background:#0d1117;border:1px solid #30363d;color:#e6edf3;padding:7px 10px;border-radius:6px;font-family:'SF Mono',Consolas,monospace;font-size:12px}
.cmd-input:focus{outline:none;border-color:#58a6ff}
.btn-row{display:flex;gap:8px;margin-top:8px;align-items:center}
.btn{background:#1f6feb;border:1px solid #388bfd;color:#fff;padding:6px 16px;border-radius:6px;cursor:pointer;font-size:13px;font-weight:600}
.btn:hover{background:#388bfd}
.cmd-out{background:#0d1117;border:1px solid #30363d;border-radius:6px;padding:8px 10px;font-family:'SF Mono',Consolas,monospace;font-size:12px;color:#7ee787;margin-top:8px;display:none;word-break:break-all;line-height:1.5}
.note{font-size:11px;color:#6e7681}
</style>
</head>
<body>
<div class="hdr">
  <button class="back" id="backBtn" onclick="showGallery()">← Gallery</button>
  <span class="hdr-title" id="hdrTitle">Image Browser</span>
  <span class="count" id="countLbl"></span>
</div>
<div id="gallery"></div>
<div id="proc">
  <div class="proc-inner">
    <div class="preview-row">
      <div class="pbox">
        <h3>Original</h3>
        <img id="origImg" src="" alt="original">
        <div class="info" id="origInfo"></div>
      </div>
      <div class="pbox">
        <h3>After (preview)</h3>
        <img id="procImg" src="" alt="processed" style="opacity:.3">
        <div class="info" id="procInfo">Select an operation, then click Generate Command</div>
      </div>
    </div>
    <div class="sec-label">Quick operations</div>
    <div class="ops" id="opsGrid"></div>
    <div class="sec-label">Custom options <span class="note">(flags appended after input path)</span></div>
    <input class="cmd-input" id="customOpts" placeholder="-resize 800x600 -quality 85 -strip">
    <div class="btn-row">
      <button class="btn" onclick="genCmd()">Generate Command</button>
      <span class="note">Copy &amp; run, or ask the agent to run it and show the result</span>
    </div>
    <div class="cmd-out" id="cmdOut"></div>
  </div>
</div>
<script>
const DIR = "__DIR__";
const images = __IMAGES__;
let cur = null;
const QUICK_OPS = [
  {l:"Resize 800x600",v:"-resize 800x600"},
  {l:"Resize 1200x",v:"-resize 1200x"},
  {l:"Scale 50%",v:"-resize 50%"},
  {l:"Thumbnail 200",v:"-thumbnail 200x200 -gravity center -extent 200x200"},
  {l:"Quality 85",v:"-quality 85 -strip"},
  {l:"Blur",v:"-blur 0x4"},
  {l:"Sharpen",v:"-sharpen 0x1"},
  {l:"Rotate 90",v:"-rotate 90"},
  {l:"Rotate 180",v:"-rotate 180"},
  {l:"Flip (V)",v:"-flip"},
  {l:"Mirror (H)",v:"-flop"},
  {l:"Grayscale",v:"-grayscale Rec709Luma"},
  {l:"Negate",v:"-negate"},
  {l:"Normalize",v:"-normalize"},
  {l:"Auto-orient",v:"-auto-orient"},
  {l:"Sepia",v:"-sepia-tone 80%"},
  {l:"Charcoal",v:"-charcoal 2"},
  {l:"Emboss",v:"-emboss"},
  {l:"Enhance",v:"-enhance"},
  {l:"Strip metadata",v:"-strip"},
  {l:"-> PNG",v:"[output as .png]"},
  {l:"-> WebP",v:"[output as .webp]"},
  {l:"-> JPEG",v:"-quality 85 [output as .jpg]"},
];
function ph(n){return'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="148" height="128"><rect width="100%" height="100%" fill="%2321262d"/><text x="50%" y="52%" fill="%236e7681" font-size="11" font-family="system-ui" text-anchor="middle" dy=".3em">'+encodeURIComponent(n.split('.').pop().toUpperCase())+'</text></svg>';}
function renderGallery(){
  document.getElementById('hdrTitle').textContent='Image Browser — '+DIR;
  document.getElementById('countLbl').textContent=images.length+' images';
  const g=document.getElementById('gallery');
  g.innerHTML=images.map((img,i)=>'<div class="card" onclick="selectImg('+i+')"><img src="'+(img.b64?'data:image/jpeg;base64,'+img.b64:ph(img.name))+'" alt="'+img.name+'"><div class="nm" title="'+img.name+'">'+img.name+'</div></div>').join('');
  const ops=document.getElementById('opsGrid');
  ops.innerHTML=QUICK_OPS.map((op,i)=>'<button class="op" onclick="pickOp('+i+')" data-i="'+i+'">'+op.l+'</button>').join('');
}
function selectImg(i){
  cur=images[i];
  document.getElementById('gallery').style.display='none';
  document.getElementById('proc').style.display='block';
  document.getElementById('backBtn').style.display='inline-block';
  document.getElementById('origImg').src=cur.b64?'data:image/jpeg;base64,'+cur.b64:ph(cur.name);
  document.getElementById('origInfo').textContent=cur.name;
  document.getElementById('procImg').src='';
  document.getElementById('procImg').style.opacity='.3';
  document.getElementById('procInfo').textContent='Select an operation, then click Generate Command';
  document.getElementById('cmdOut').style.display='none';
  document.querySelectorAll('.op').forEach(function(b){b.classList.remove('active');});
  document.getElementById('customOpts').value='';
}
function showGallery(){
  document.getElementById('gallery').style.display='grid';
  document.getElementById('proc').style.display='none';
  document.getElementById('backBtn').style.display='none';
}
function pickOp(i){
  var op=QUICK_OPS[i];
  document.getElementById('customOpts').value=op.v;
  document.querySelectorAll('.op').forEach(function(b){b.classList.remove('active');});
  document.querySelector('.op[data-i="'+i+'"]').classList.add('active');
}
function genCmd(){
  if(!cur)return;
  var opts=document.getElementById('customOpts').value.trim();
  var ext=cur.name.split('.').pop().toLowerCase();
  var outExt=ext;
  if(opts.includes('[output as .png]')){opts=opts.replace('[output as .png]','').trim();outExt='png';}
  else if(opts.includes('[output as .webp]')){opts=opts.replace('[output as .webp]','').trim();outExt='webp';}
  else if(opts.includes('[output as .jpg]')){opts=opts.replace('[output as .jpg]','').trim();outExt='jpg';}
  var outName=cur.name.replace(/\.[^.]+$/,'_out.'+outExt);
  var outPath=cur.path.replace(/[^/\\]+$/,outName);
  var cmd='magick "'+cur.path+'" '+opts+' "'+outPath+'"';
  var out=document.getElementById('cmdOut');
  out.textContent=cmd;
  out.style.display='block';
  document.getElementById('procInfo').textContent='Command ready. Run it, then ask agent: show result for '+outName;
}
renderGallery();
</script>
</body>
</html>
```

After rendering the artifact, tell the user:
- Click a thumbnail to open the processing panel
- Pick a quick operation or type custom magick flags
- Click **Generate Command** to see the full `magick` command
- Ask me: *"run that command"* — I'll execute it and show a before/after comparison

## Mode B — Process single image and show result

When the user specifies an image and operation (or says "run that command"):

### B1. Run the operation (bash, direct)

```bash
magick "<input_path>" <options> "<output_path>"
```

### B2. Generate before/after preview

```bash
# Original thumbnail
magick "<input_path>" -auto-orient -resize 500x -quality 80 jpg:- | base64 -w 0

# Processed thumbnail
magick "<output_path>" -auto-orient -resize 500x -quality 80 jpg:- | base64 -w 0
```

### B3. Render before/after via create_artifact

Use `tool_search("create_artifact")` → `tool_call_dynamic` to show a comparison HTML with both
images embedded as `data:image/jpeg;base64,...` data URLs.

## Mode C — Batch processing (mogrify)

```bash
# Resize all JPGs in-place — CONFIRM BEFORE RUNNING (overwrites originals)
magick mogrify -resize 1200x -quality 85 -auto-orient "<dir>/*.jpg"

# Convert all PNGs to WebP into ./webp/ subfolder (safe — no overwrite)
mkdir -p "<dir>/webp"
magick mogrify -format webp -path "<dir>/webp" "<dir>/*.png"

# Generate 200px thumbnails into ./thumbs/ (safe)
mkdir -p "<dir>/thumbs"
magick mogrify -auto-orient -thumbnail 200x200 -gravity center -extent 200x200 -quality 75 -path "<dir>/thumbs" "<dir>/*.jpg"

# Strip metadata from all images in-place
magick mogrify -strip "<dir>/*.jpg"
```

**Always warn and confirm before `mogrify` without `-path`** — it overwrites originals destructively.

## Mode D — Format conversion

```bash
# Single file
magick "<input.bmp>" "<output.png>"

# All files in directory
magick mogrify -format webp -path "<dir>/out" "<dir>/*.jpg"
```

## Mode E — Remove the Gemini/Imagen sparkle watermark (AI inpainting)

Launch when the user wants to remove the bottom-right ✦ watermark from Gemini/Imagen images.
This needs content-aware inpainting (LaMa via IOPaint), not magick's clone/patch — magick
alone only works on flat backgrounds and leaves a seam on grass/bokeh/textured scenes.

**Read `magick/gemini-watermark` for the full placement rule, mask math, and one-time IOPaint
setup.** Summary of the workflow:

### E1. Locate IOPaint (portable — no hardcoded path)

Resolve the binary in priority order: `$IOPAINT_BIN` override → `iopaint` on PATH →
home-relative venv (Windows `.exe`, then Unix). Sets `$IOPAINT` for the later steps.

```bash
IOPAINT="${IOPAINT_BIN:-$(command -v iopaint || true)}"
[ -z "$IOPAINT" ] && [ -x "$HOME/iopaint-env/Scripts/iopaint.exe" ] && IOPAINT="$HOME/iopaint-env/Scripts/iopaint.exe"
[ -z "$IOPAINT" ] && [ -x "$HOME/iopaint-env/bin/iopaint" ]        && IOPAINT="$HOME/iopaint-env/bin/iopaint"
[ -z "$IOPAINT" ] && { echo "IOPaint not found — see magick/gemini-watermark for setup"; exit 1; }
```

If not found, point the user to the setup in `magick/gemini-watermark` (needs a Python
3.10/3.11 venv at `$HOME/iopaint-env` — IOPaint won't build on 3.13).

### E2. Build a corner-anchored mask with magick (per image)

The watermark is fixed-pixel, anchored to the bottom-right corner: **96×96 px at a 192 px
margin** for standard renders (`s=1`), half that for small ones (`s=0.5` when the shorter side
< ~1200). One circle covers any aspect ratio:

```bash
read W H < <(magick identify -format "%w %h" "<input>")
s=1; [ "$(( W<H ? W : H ))" -lt 1200 ] && s=0.5   # compute s as 1 or 0.5
# integer form: cx=W-240*s, cy=H-240*s, r=62*s
magick -size ${W}x${H} xc:black -fill white -draw "circle $cx,$cy $cx,$((cy-r))" -blur 0x1 full-mask.png
```

Same-resolution batch → one mask for all; mixed resolutions → one mask per image (name masks
to match images and pass a mask **directory**).

### E3. Erase with LaMa (headless CLI, no web server)

```bash
"$IOPAINT" run --model=lama --device=cpu \
  --image=<input_dir> --mask=full-mask.png --output=<output_dir>
```

~6 s/image on CPU. First run downloads the model (~196 MB).

### E4. Show before/after

Reuse Mode B's preview (base64 thumbnails of input vs output in a create_artifact comparison).

## Quick reference table

| Goal | Flags |
|------|-------|
| Resize (max bounds, keep ratio) | `-resize 800x600` |
| Resize (exact, distort) | `-resize 800x600!` |
| Resize by percent | `-resize 75%` |
| Shrink only if larger | `-resize 800x600>` |
| Crop from top-left | `-crop 400x300+0+0 +repage` |
| Crop centered | `-gravity center -crop 400x300+0+0 +repage` |
| Rotate | `-rotate 90` |
| Blur | `-blur 0x4` |
| Sharpen | `-sharpen 0x1.5` |
| Unsharp mask | `-unsharp 0x1+1.5+0.05` |
| Grayscale | `-grayscale Rec709Luma` |
| JPEG quality | `-quality 85` |
| Strip EXIF/metadata | `-strip` |
| Auto-orient from EXIF | `-auto-orient` |
| Add white border 10px | `-bordercolor white -border 10` |
| Sepia effect | `-sepia-tone 80%` |
| Negate colors | `-negate` |
| Adjust levels | `-level 10%,90%` |

For anything not in this table, read `magick/common-operations` (recipes) or
`magick/command-line-processing` (syntax) from the brain — don't improvise flags.

## Error handling

- `magick: command not found` — install ImageMagick (see Step 0)
- `no decode delegate for this image format` — format not supported; check `magick -list format`
- Permission denied — check file/directory permissions
- Out of memory for large images — reduce via `-limit memory 512MB` or process in chunks
- On Windows: quote all paths; use `^` for line continuation (not `\`)

## Operating rules

- Run `magick`, `ls`, `mkdir` and all shell commands via `bash` **directly** (never tool_call_dynamic)
- Use `glob` **directly** to discover image files
- Reach `create_artifact` via `tool_search("create_artifact")` → `tool_call_dynamic`
- Embed images inline as `data:image/jpeg;base64,<b64>` so no external file references needed
- Generate thumbnails one at a time (sequential bash calls) to avoid timeout on large batches
- Before any `mogrify` that overwrites originals, confirm with user first
- Inform user of progress when processing >10 images
