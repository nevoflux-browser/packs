---
name: no-slop
description: Remove AI writing tells from prose in Chinese or English. Use when writing, rewriting, editing, or reviewing any prose so it reads like a sharp human wrote it, not a model. Detects the target language and applies the matching ruleset. 去掉中英文 AI 写作味，写稿改稿审稿时用。
version: "0.1.0"
author: dorisgyl
tags:
  - writing
  - editing
  - zh
  - en
triggers:
  - rewrite this so it doesn't sound like AI
  - 去掉 AI 味
  - 把这段改写得像人写的
  - remove AI writing patterns
  - de-slop
dependencies:
  - no-slop:references/zh-banned-words.md
  - no-slop:references/zh-banned-punctuation.md
  - no-slop:references/zh-banned-structures.md
  - no-slop:references/zh-phrases.md
  - no-slop:references/en-phrases.md
  - no-slop:references/en-structures.md
---

# No Slop

去掉 AI 写作味。让输出读起来像一个有判断力的人在认真聊，而不是模型在输出信息。
Remove AI writing tells so prose reads like a sharp human wrote it.

中英文的 AI 味是两套不同特征，所以这个 skill 先判语言，再套对应规则。绝不把两套规则混用。
Chinese and English AI tells are different. Detect the language first, apply one ruleset, never merge them.

## Step 1 — 判语言 / Detect language

看 args 里要处理的目标文本（改写模式）或写作任务（生成模式）的主体语言：

- 主体中文 → 走 **ZH 规则集**
- 主体英文 → 走 **EN 规则集**
- 中英混排 → 按主体语言定，少量内嵌另一种语言不切换
- 产品名 / 代码 / 工具名 / 命令永远保留英文原文，不翻译、不算进语言判定

## Step 2 — 判模式 / Detect mode

| args 形态 | 模式 | 做什么 |
|---|---|---|
| 一段已有文本（明显是成稿、邮件、帖子、段落） | 改写 Rewrite | 在不改变事实和立场的前提下去味重写 |
| 一个写作指令（「写一篇…」「帮我起草…」） | 生成 Generate | 从头按规则写 |

模式判不准时默认改写，宁可保守。

## Step 3 — 判文体强度 / Intensity guard

不是所有文本都该被改成口语博客腔。先定文体再决定规则强度：

| 文体 | 适用规则 |
|---|---|
| 随笔 / 博客 / 营销 / 社媒 | 全量规则，包括 ZH 的强制口语词组和禁标点 |
| 正式邮件 / 技术文档 / 公告 / 合同类 | **关掉**强制口语词组，**放宽**禁标点（允许冒号），只保留：禁用词、禁套话结构、主动语态、具体化、节奏 |

判不准文体时按「正式」处理，不硬塞口语词，避免把正经文本改坏。

## 核心规则 / Core rules

下面只是**骨架**，完整禁用清单在 reference 文件里。**先按 Step 1 判出的语言，用 `skill_read` 把对应规则集读进来再动手**：`skill_read('no-slop', 'references/<file>.md')` —— ZH 读 `zh-banned-words` / `zh-banned-punctuation` / `zh-banned-structures` / `zh-phrases`；EN 读 `en-phrases` / `en-structures`；需要范例再读 `zh-examples` / `en-examples`。（部分运行时会按 frontmatter `dependencies` 把这些 reference eager 注入上下文 —— 若已在上下文，跳过重复读取，别白读两遍。）

Read first via `skill_read`, then apply the skeleton below.

### ZH 目标文本

1. **禁用词全文 0 命中**。综上所述、值得注意的是、说白了、本质上、在当今…的时代 等，见 zh-banned-words 全清单。
2. **禁套话结构**。「第一/第二/第三」编号、大段 bullet、不必要小标题、过度加粗，见 zh-banned-structures。改自然过渡和散文。
3. **标点**（仅博客/营销文体）。冒号换逗号，破折号换逗号或句号，弯引号换「」或去掉，见 zh-banned-punctuation。
4. **口语词组**（仅博客/营销文体）。自然融入 zh-phrases 里 8-10 个不同词组，在合适位置用，不硬塞。
5. **不编案例**。「某团队跟我们聊过」「比如有一次」是大忌。空泛工具名换成具体名称。
6. **切入角度**。写分析型 + 实操型，不写报道型。实操内容给可直接复制的命令 / 代码 / prompt 模板。

### EN 目标文本

1. **Cut filler.** Throat-clearing openers, emphasis crutches, business jargon, all adverbs. See en-phrases.
2. **Break formulaic structures.** Binary contrasts ("not X, it's Y"), negative listing, dramatic fragmentation, rhetorical setups, false agency. See en-structures.
3. **Active voice.** Every sentence has a human subject doing something. No inanimate things performing human verbs.
4. **Be specific.** Name the thing. No vague declaratives, no lazy "every/always/never".
5. **Vary rhythm.** Mix sentence lengths. Two items beat three. No em dashes.
6. **Trust the reader.** State facts directly. Cut quotable pull-quote lines.

## Step 4 — 质检 / QC（每次写完强制跑）

### ZH 四层质检

- **L1 硬规则扫描**：逐项统计命中数 — 禁用词 / 编号结构 / 空泛工具名，博客文体再加冒号 / 破折号 / 弯引号。非 0 必须返工。
- **L2 风格**：开头从具体当下切入、长短句交替、至少 3 处一句话独立成段、博客文体用了 8-10 个口语词组。
- **L3 内容**：每个观点有具体数据 / 人物 / 场景支撑，知识点顺手带出不是教科书罗列。
- **L4 活人感**：通读一遍，分不清是人写的还是 AI 写的才算过。

### EN scoring（1-10 each, below 35/50 means revise）

| Dimension | Question |
|---|---|
| Directness | Statements or announcements |
| Rhythm | Varied or metronomic |
| Trust | Respects reader intelligence |
| Authenticity | Sounds human |
| Density | Anything cuttable |

结构性大改（新增段 / 删段 / 重排）之后必须重跑全部质检，不能依赖上一次结果。

## 输出格式 / Output contract

先给成品，再给一份紧凑质检报告。报告别喧宾夺主。

```
[去味后的正文 / cleaned or generated prose]

---
质检 / QC
语言 <zh|en> · 文体 <博客|正式> · 模式 <改写|生成>
L1 硬规则 ✓/✗（命中：禁用词 N，编号 N，标点 N…）
L2 风格 ✓/✗   L3 内容 ✓/✗   L4 活人感 ✓/✗
返工项：<最该修的 1-3 个，若全过写 无>
```

正式文体把 L1 标点项标 N/A，把口语词组项标 N/A。
