# learn

[English](README.md) · **中文**

一个**从任意来源学习、生成另一个 pack** 的 NevoFlux pack。把它指向当前页、一个 URL、多个 tab、GitHub
skill 仓库、web skill 门户、本地文件,或你的 GBrain —— 它就在你指定的目录里写出一个**过 capability 校验、
可安装的 NevoFlux pack**。它是**纯生成器**:只写文件,不安装。用 `/learn` 调用。

## 需要 agent 模式

learn 要写文件(`read`/`write`/`glob`/`bash` 是 agent 态工具),所以必须在 **agent 模式**下运行。若它看不到
这些工具,会停下并让你切换。它也**从不安装** —— 生成的 pack 由你用现成的 NevoFlux pack 工具自行安装。

## 用法

在 **agent 模式**下用 `/learn` 调用,说明"从哪学"以及(可选)"生成到哪"。触发词包括 `/learn`、"learn a
skill…"、"turn this into a pack"、学一个、把这个做成 pack。

### 按来源举例

| 从哪学 | 例子 |
| --- | --- |
| 当前页 | `/learn 把这个页面做成一个 pack，生成到 ./packs` |
| 指定 URL | `/learn 从 https://example.com/guide 学，做成一个 pack` |
| 本地文件/目录 | `/learn 用 ./notes/scraping/ 里的内容做个 pack，输出到 ./packs` |
| 多个已开 tab | `/learn 把我开着的这几个 tab 合成一个 research pack` |
| 指定的 GitHub skill | `/learn 学 anthropics/skills/pdf,生成到 ./packs` |
| 按意图找 skill | `/learn 学一个爬 Airbnb 的 skill` |
| 你的 GBrain | `/learn 用我知道的向量数据库知识做个 pack` |
| English | `/learn learn a skill that scrapes Airbnb, save it to ./packs` |

### 一次运行长什么样

1. **输出目录** —— 没给就问你,绝不擅自选目录。
2. **(仅主动搜索)** learn 在内置 skill 站点 + GitHub 仓库里搜,列出几个候选,每个带 license 标注,让你选或
   "都不用":
   ```
   帮你找到这些相关 skill:
   1. anthropics/skills/pdf        [MIT]         ✅ 可改写承继 + attribution
   2. skills.sh/…/airbnb-search    [Apache-2.0]  ✅ 可改写承继 + attribution
   3. some-portal/…/airbnb         [未标注]      ⚠️ 默认纯学习
   [ 都不用 ]
   ```
3. **License** —— 逐源判定;无/未知 → 纯学习(不改写)。
4. **组件规划** —— learn 对每个组件(skills / seed / …)逐个提问 + 给建议,**双方无异议后才生成**。
5. **生成 + 校验** —— 写出 pack,跑真 `nevoflux pack validate`,不合规就回去重生成修好。
6. **安装提示** —— 打印生成目录路径 + 怎么用现成 pack 工具安装。**learn 从不安装。**

之后由你自己安装,例如 `nevoflux pack install <输出目录>/<pack-name>/pack.toml`。

## 工作原理

learn 分四步:

1. **采集(Ingest)** —— 从你指向的任何来源汇集素材(被动:当前页/多 tab、URL、本地文件、GBrain;主动:在
   内置 skill 站点 + GitHub 仓库内做 **`site:` 定向**的 `web_search`,每个候选都标注 license)。选定的 GitHub
   skill 用一次 codeload 整包**一次拿全**,不会只抓半个。
2. **License 分流** —— 判定每个来源的 license(最具体者优先;任一层未知即回落纯学习)。宽松 → 改写 + 保留
   attribution;copyleft → 改写 + 警告传染;无/未知 → 只学习不改写。
3. **收敛(Synthesize)** —— **和你逐个确认** pack 的组件构成;把工具名重映射到 NevoFlux;逐条满足 5 条
   capability 不变式。
4. **产出(Emit)** —— 写出 pack,然后**跑真 `nevoflux pack validate`** 作交付门(CLI 缺失时回落到自带的 bash
   校验器),写一份 `.provenance.json` 来源清单,再告诉你怎么安装。它不安装。

## 结构

```
learn/
  pack.toml
  components/skills/learn/
    SKILL.md
    references/pack-authoring.md   # pack.toml 规则、5 条 capability 不变式、工具映射、license、provenance
    scripts/validate-pack.sh       # 兜底校验器(capability.rs 的 bash 镜像),CLI 不在 PATH 时用
```

## 说明

- **纯生成器,不安装** —— learn 只写合规文件,安装由你自己做。
- **真校验器把关交付** —— 它跑 `nevoflux pack validate`(和安装时同一套检查),不是心里过一遍清单,所以生成的
  pack 真能装上。
- **License 诚实** —— 读不到/缺失 → `unknown` → 纯学习,绝不瞎猜;每个来源的 license 及"读自哪里"都记进
  `.provenance.json`。
- **绝不生成 `[components.knowledge]`**(安装会硬拒)—— 领域知识走 seed。

## License

MIT
