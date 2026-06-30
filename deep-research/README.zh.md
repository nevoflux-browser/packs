# deep-research

[English](README.md) · **中文**

![STORM 深度研究流水线](assets/storm.png)

一个用于 **STORM / Co-STORM 深度研究** 的 NevoFlux pack。它把一个开放式问题变成一份**多视角、矛盾感知、
经同行评审**的简报 —— 接地于真实网络来源,并**归档进用户的第二大脑(gbrain)**,成为一张可链接、可复用、
能跨未来研究复利的研究子图。

## STORM 是什么?

**STORM** —— *Synthesis of Topic Outlines through Retrieval and Multi-perspective Question Asking*
(经检索与多视角提问合成主题大纲)—— 是一种用 LLM 从零研究并撰写长篇维基百科式文章的方法,由 Shao 等人
提出(NAACL 2024,[arXiv:2402.14207](https://arxiv.org/abs/2402.14207))。其核心洞见是:难点在**写前的
研究**,所以它把这一阶段结构化:

1. **视角发现** —— 找出与主题相关的多元视角。
2. **多视角提问** —— 由各视角化身的"写作者"向"主题专家"提问,答案**接地于检索到的网络来源**。
3. **模拟对话** —— 这些视角制导的问答对话逐步累积带引用的信息。
4. **大纲 → 成文** —— 把收集到的信息整理成大纲,再据此成文。

STORM 在文章组织度与覆盖广度上胜过 RAG 基线,但作者指出两个弱点:**来源偏差传播**与**虚假事实关联**。

本 pack 把 STORM 的研究引擎搬到 NevoFlux,并正面修这两个弱点:五视角扫描 + 接地检索即 STORM 的视角制导
提问;而**矛盾地图**与**对抗式同行评审**两阶段专为抓来源偏差与事实错配而设。用户介入点借鉴了 **Co-STORM**
后续工作(带人在环的协作式讨论)。交付物不是维基文章,而是一份归档进你第二大脑的带引用简报。

- **Pack 名:** `deep-research`(本目录)· **namespace:** `research` · **skill:** `research`
  (触发 `/research`)· **protocol:** `pack-protocol/0.1`。
- 由 `nevoflux` CLI 安装与校验 —— 安装前先跑 **`nevoflux pack validate`**。
- 设计依据与完整决策日志在 `nevoflux/docs/research-pack/`(从 `storm-pack-DESIGN.md` 看起)。

## 前置依赖:`brain` pack

本 pack **硬依赖 `brain` pack** —— 每个阶段都经 gbrain 落页并 `skill_read('brain', …)`。`protocol/0.1`
没有清单级依赖机制,因此 skill 在 **Phase 0 做 preflight**:若 gbrain 工具不可达,立即停止并提示用户先装
`brain`。请先安装 `brain` 再装本 pack。

## 结构

```
deep-research/
  pack.toml                              # 清单:[pack] + [components.skills] + [components.protected]
  README.md
  components/skills/research/
    SKILL.md                             # /research 编排 skill(五阶段 STORM 流水线)
    conventions/
      perspectives.md                    # STORM Prompt 1 —— 五视角扫描
      retrieval.md                       # 检索分层 + run 级 fetch 封顶
      contradiction.md                   # STORM Prompt 2 —— 冲突 / 缺口地图
      brief-format.md                    # STORM Prompt 3 —— 综合简报
      review-rubric.md                   # STORM Prompt 4 —— 对抗式同行评审
      filing.md                          # gbrain slug 方案、typed link、状态门
```

skill 的 `allowed_tools` 只声明 `tool_search` + `tool_call_dynamic`;它在运行时经 `tool_call_dynamic`
(无 mode 门)触达所有 gbrain 工具、所有 `browser_*` 工具和 `ask_user`,因此在 Chat / Browser / Agent
任一 mode 下行为一致。生成的页落在 `research/` namespace 下,并标记 **protected**(卸载默认保留,除非
`--purge-data`)。

## 流水线

```
/research <主题>
  0 preflight     要求 brain;设定预期;建 index(status: in_progress)
  scan-1          把五视角框定到该主题(不检索)
   └─ ★ 介入点      ask_user 增删 / 替换视角(绝不为零)
  scan-2          每视角:提问 → web_search/web_fetch(+ 门控 Tier-2);落页
  map             gbrain think 在已接地子图上跑出矛盾地图
  brief           五段式综合;校验高风险断言;主交付物
  review          对抗式自评 → 收尾:连 --about--> 边、置 status: complete,
                  再用 create_artifact 出一份只读的 brief 快照
```

## v0.1 范围

- **Mode-无关**;默认 Chat 态。重门控 / 社交语料爬取(X / 知乎 / 小红书)用 Browser 态启动更顺,但任何
  mode 都能跑(navigate 可能弹权限框)。**绝不替用户登录** —— 复用其已有会话。
- **成本护栏是结构性的**:每视角 ≤4 问、每 run 去重后 ≤~15–20 次 `web_fetch`(`protocol/0.1` 禁 pack 配置)。
- **无 dashboard 组件**;简报经运行时 `create_artifact` 渲到 canvas tab。gbrain `brief` 页是唯一真相源 ——
  artifact 只是一次性只读视图。
- 跑到一半的 run 会留下一张孤立的 `status: in_progress` 草稿,对复利不可见;重跑同主题会幂等覆盖它。
