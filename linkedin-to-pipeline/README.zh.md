# linkedin-to-pipeline

[English](README.md) · **中文**

一个把 LinkedIn 当作**销售管道基础设施**（而非品牌曝光信息流）来运营的 NevoFlux pack。它把一套
经过验证的内容体系——70/20/10 漏斗、hook 模式、五种格式、每周反馈回路——变成一组 skill，负责
规划、挖掘、写作、审核并交接帖子，并用受保护的种子页保存你的品牌档案与内容状态。

它落地的链路是：**内容 → 曝光 → 信任 → 对话 → 商机。** 内容不是漏斗的顶端，内容本身就是整个漏斗。

## 做什么 / 不做什么

- **做：** 规划内容日历、从你自己的来源挖掘灵感、写帖子（hook 优先、格式感知）、质检、并产出
  可直接粘贴的正文加视觉简报。
- **不做：** 自动发帖（只定稿并交接，你自己按 Post）、渲染图片或视频（只写视觉简报并指向渲染
  工具）、读取你的 LinkedIn 数据（每周数字由你提供）。外部来源（reddit、GitHub、打开的标签页）
  仅作只读灵感。
- **软集成** [`stop-slop`](https://nevoflux.app/packs/a4999593-96e1-47af-b392-3025db41eb15/)
  pack 的 `no-slop` skill 去掉 AI 写作味。未安装时会给出安装提示——不阻塞流程。

## 快速上手

1. 运行 `/linkedin-to-pipeline`。
2. 填写 `linkedin-to-pipeline/brand-profile`（定位、ICP、报价、语气、战绩）与
   `linkedin-to-pipeline/idea-sources`（灵感从哪来）。
3. 运行 `/linkedin-calendar-planning` 铺出 arc、开出 70/20/10 空槽位。
4. 然后 `/linkedin-idea-mining` → `/linkedin-post-write` → `/linkedin-post-review` →
   `/linkedin-post-publish`。每周用 `/linkedin-weekly-review` 复盘。

## Skills

| Skill | 命令 | 作用 |
| --- | --- | --- |
| `linkedin-to-pipeline` | `/linkedin-to-pipeline` | 宿主/路由。检查地基页，指引你进入闭环里正确的一步。 |
| `linkedin-calendar-planning` | `/linkedin-calendar-planning` | 战略入口：铺一次性的 定位→权威→转化 arc，并在滚动窗口上开出 70/20/10 槽位。 |
| `linkedin-idea-mining` | `/linkedin-idea-mining` | 用内部知识、你配置的来源（含打开的标签页）与数据反馈，定向填满空槽位。 |
| `linkedin-post-write` | `/linkedin-post-write` | 写帖：选格式（利用/探索）、给 2-3 个 hook 变体、写正文、去 AI 味、并给视觉简报。 |
| `linkedin-post-review` | `/linkedin-post-review` | 硬质检门——语气、战绩、hook、去 AI 味复检。可把稿子打回重写。 |
| `linkedin-post-publish` | `/linkedin-post-publish` | 定稿可粘贴正文 + 视觉简报 + 建议时段，回写状态并交接（不自动发帖）。 |
| `linkedin-post-repurpose` | `/linkedin-post-repurpose` | 把表现好的帖子复用成新格式（文字 → 轮播 → 视频）。 |
| `linkedin-weekly-review` | `/linkedin-weekly-review` | 分析每周数字，维护「What's working」，把洞察回喂日历与灵感。 |

## 种子页

| 页面 | 存放 |
| --- | --- |
| `linkedin-to-pipeline/brand-profile` | 定位、ICP、报价、语气/禁用词、节奏旋钮、战绩库。 |
| `linkedin-to-pipeline/idea-sources` | 社交监听 + 产品信号来源及每来源的挖掘规则。 |
| `linkedin-to-pipeline/idea-backlog` | 灵感及其流水线状态（Idea → Draft → Review → Scheduled → Live）。 |
| `linkedin-to-pipeline/content-calendar` | arc 与 70/20/10 空槽位。 |
| `linkedin-to-pipeline/weekly-review-log` | 每周表现记录 + 蒸馏的「What's working」。 |

所有种子页均受保护——卸载 pack 时保留你的数据。
