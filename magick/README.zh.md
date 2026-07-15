# magick

[English](README.md) · **中文**

一个把 ImageMagick `magick` CLI 变成**图片浏览器 + 处理器**的 NevoFlux pack。把一个目录浏览成缩略图
画廊,对单张图或整个目录做转换 / 缩放 / 裁剪 / 加特效,并且——针对 Gemini/Imagen 图片——用 **AI
修复去掉那个星形水印**。用 `/magick` 调用。

## 需要 magick CLI

magick 通过 `bash` 直接调用 `magick` 二进制(ImageMagick 7),所以需要 **ImageMagick 在 PATH 上**。
Step 0 会跑 `magick --version`,若缺失则按你的系统打印安装命令(`winget` / `brew` / `apt` / `dnf`)。
交互式画廊和前后对比预览通过 `create_artifact` 渲染成 artifact。**Mode E**(去水印)额外需要
**IOPaint** —— 一次性可选安装,见 `seed/gemini-watermark.md`。

## 用法

用 `/magick` 调用,可带一个目录或图片路径。触发词包括 `/magick`、`magick`、`imagemagick`、browse
images、image browser、处理图片、图像处理、图片浏览、图片转换、缩略图。

### 按任务举例

| 任务 | 例子 |
| --- | --- |
| 浏览一个目录 | `/magick 浏览 ./photos` |
| 处理单张图 | `/magick 把 ./a.jpg 缩到宽 800px,质量 85` |
| 批量处理目录 | `/magick 给 ./photos 里每张 jpg 生成 200px 缩略图` |
| 转换格式 | `/magick 把 ./logo.png 转成 webp` |
| 去 Gemini 水印 | `/magick 去掉 ./gemini_*.png 的水印` |
| English | `/magick batch-convert everything in ./photos to webp` |

## 模式

magick 按你的诉求路由到五种模式之一:

1. **浏览(A)** —— glob 一个图片目录,生成 base64 缩略图,渲染成交互式画廊 artifact:点缩略图 →
   处理面板 → 选快捷操作或手输自定义 flag → **Generate Command**。让 agent 跑生成的命令,就切到
   Mode B。
2. **处理(B)** —— 跑一次 `magick` 操作,展示前后对比(两张图以 data URL 内嵌)。
3. **批处理(C)** —— 对目录跑 `mogrify`;当会覆盖原文件时(没有 `-path` / `-format`)先确认。
4. **转换(D)** —— 单文件或整目录的格式转换。
5. **去水印(E)** —— 用 **LaMa 修复**(经 IOPaint)抹掉 Gemini/Imagen 右下角的 ✦ 水印,针对普通
   magick 补丁会留接缝的复杂背景。magick 造角锚定蒙版,LaMa 合成匹配的纹理。

**参考页按需路由。** SKILL.md 自带一张常用 flag 的内联速查表;超出它的部分,路由到 brain 里 13 个
seed 页之一——核心语法、常见操作配方、以及每个 sub-command 一页(`identify`、`mogrify`、`montage`、
`composite`、`compare`、`animate`、`display`、`import`、`conjure`、`stream`)——让 skill 保持精简,
只在需要时才查具体细节。

## 结构

```
magick/
  pack.toml
  skills/magick/SKILL.md            # 5 种模式、路由表、速查表、运行规则
  seed/
    command-line-processing.md      # geometry、settings vs operators、( ) 堆栈、输出模式
    common-operations.md            # 任务配方:缩放/裁剪/色彩/特效/文字/动画
    identify.md mogrify.md montage.md composite.md compare.md   # 高频 sub-command
    animate.md display.md import.md conjure.md stream.md        # 小众 / 交互式工具
    gemini-watermark.md             # 水印放置规律 + LaMa/IOPaint 去水印流程
  .provenance.json                  # 合成 seed 内容的来源清单
```

## 说明

- **`mogrify` 会覆盖原文件**,除非用 `-path` 或 `-format` 重定向输出 —— Mode C 在任何破坏性批处理前
  先警告并确认。
- **参考页按需加载** —— 常用 flag 走内联速查表(零查找);只有具体细节(sub-command 的确切选项、
  geometry 边角情况)才触发读 brain 页,保持 SKILL.md 精简。
- **水印位置是实测规律** —— Gemini/Imagen 星形水印是固定像素、锚定右下角(96×96 px、192 px 边距;
  小图减半),所以一张角锚定的 magick 蒙版就能覆盖所有比例——不内置任何按比例的静态资产。
- **Mode E 默认 `--device=cpu`** —— 实测 CUDA 对小批量 LaMa 不提速(crop strategy + 固定预热开销);
  GPU 只在大批量或更重的扩散模型上划算。IOPaint 由可移植解析器定位(环境变量 / PATH / home venv)。
- **seed 内容为合成** —— 来自 ImageMagick 官方文档(改写,非照搬)加原创测量;来源记录在
  `.provenance.json`。

## License

MIT
