# stop-slop

[English](README.md) · **中文**

去掉文字里 **AI 写作味**的双语 NevoFlux pack —— 中文、英文各一套规则。装上后用 `/no-slop` 调用。

## 用法

```
/no-slop 把这段改写得别一股 AI 味：<你的文本>
/no-slop 写一篇关于 X 的帖子
```

`/no-slop` 会自动：

- **判语言** —— 中文走中文规则集，英文走英文规则集，两套绝不混用；
- **判模式** —— 已有文本 → 改写（不改事实和立场）；写作指令 → 从头生成；
- **判文体强度** —— 正式邮件 / 技术文档 / 公告不会被硬塞口语词或乱改标点；
- 写完跑一遍**质检**，附一份紧凑报告。

## 工作原理

`/no-slop` 加载 `no-slop` skill。skill 先判目标语言，读对应规则集，据此改写或生成，再按硬规则自检。
完整的禁用词 / 禁结构清单在 `references/` 里，调用时按需加载（见结构）。

## 结构

```
stop-slop/
  pack.toml
  skills/no-slop/
    SKILL.md
    references/
      en-phrases.md  en-structures.md  en-examples.md
      zh-banned-words.md  zh-banned-punctuation.md  zh-banned-structures.md
      zh-phrases.md  zh-examples.md
```

硬规则 reference 在 `/no-slop` 调用时加载：SKILL 正文按语言用 `skill_read` 读对应规则集（原生 agent
路径靠这个）；部分运行时（ACP 桥接）还会按 frontmatter `dependencies` eager 注入。examples 按需读。

## 致谢

中英规则分别改编自两个 MIT 项目，详见 `NOTICE` 和 `LICENSE`。

- [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) —— 英文规则
- [pencil20388-eng/stop-slop-zh](https://github.com/pencil20388-eng/stop-slop-zh) —— 中文规则

## License

MIT
