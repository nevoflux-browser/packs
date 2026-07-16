# voxcpm

[English](README.md) · **中文**

一个围绕 `voxcpm` 命令行语音合成工具的 NevoFlux pack:从一段文字描述做音色设计、从参考音频克隆
音色、批量生成,以及微调支持(manifest 准备、校验、生成配置)。两个 skill:`/voxcpm` 管合成,
`/voxcpm-finetune` 管微调。

## 需要 VoxCPM —— 本 pack 不装它

本 pack **不会安装** VoxCPM。你需要先在本机装好 `voxcpm` CLI:

```bash
pip install voxcpm
# 或
uv pip install voxcpm
```

微调需要的东西比 pip wheel 提供的更多——见下面「微调」一节。完整的依赖与安装细节(PyTorch、
FFmpeg、CUDA、Python 版本说明、HF 镜像)在 `voxcpm/installation`,两个 skill 都会按需路由过去。

## 快速上手

```bash
voxcpm design -t "Hello, this is a test." -o out.wav
```

`design` 从文字提示合成语音,不需要参考音频(音色来自可选的 `--control` 描述)。`clone` 做同样
的事,但会匹配 `--reference-audio` 样本的音色。`batch` 对输入文本文件的每一行各跑一次合成。
完整 flag 表见 `voxcpm/cli-reference`。

## Skills

| Skill | 命令 | 干什么 |
| --- | --- | --- |
| `voxcpm` | `/voxcpm` | 合成:在 `design`(文字描述音色)、`clone`(参考音频音色)、`batch`(多行文本,每行一个输出文件)之间路由。先解析本机环境(判断安装与否的测试是 `voxcpm` 可执行文件本身,不是 `import voxcpm`),再跑 CLI,汇报输出路径、时长和用到的参数。 |
| `voxcpm-finetune` | `/voxcpm-finetune` | 微调支持:帮忙准备 JSONL 训练 manifest,跑 `voxcpm validate` 校验它,生成 LoRA 或全量微调配置,并在有 checkpoint 之后跑 LoRA 推理。真正的训练命令交给用户自己跑——skill 不会去启动或盯着一个可能跑好几小时的训练任务。 |

## 已知限制

以下是对已安装 CLI 的实测事实(针对 voxcpm 2.0.3 验证过),不是本 pack 的取舍——上游 README
记载了这套 CLI 实际并不支持的 flag:

- **任何子命令上都没有 `--seed` flag。** CLI 没有办法强制复现输出——同样的命令、同样的输入跑
  两次,**不保证**产出同一段音频。如果某一条效果好,那一条就是你手上有的东西;再跑一次是重新
  掷一次骰子,不是复现它的办法。
- **`--timestamps`(以及 `--timestamp-level`、`--timestamp-language`)在这套 CLI 上不存在**,
  尽管上游 README 里写了它们。命令行没有办法拿到时间戳/对齐输出。
- `--retry-badcase` 是 Python API 的参数,不是 CLI flag;`--version` 也不存在(改用
  `python -c "import importlib.metadata; print(importlib.metadata.version('voxcpm'))"`)。
  完整细节见 `voxcpm/cli-reference`。

## 微调

- **训练需要源码 checkout。** `scripts/train_voxcpm_finetune.py` 和 `conf/*.yaml` 配置文件不
  在 pip/uv wheel 里——微调模型需要 `git clone` 源码仓库。manifest 校验
  (`voxcpm validate`)和对已训练 checkpoint 的 LoRA 推理,两者都能在普通 pip 安装下跑,不需要
  checkout。
- **显存预算**(VoxCPM 2,按 `batch_size=16`、`max_batch_tokens=8192` 估算):LoRA 大约需要
  **20GB**,全量微调大约需要 **40GB**。完整表格(含 VoxCPM 1.5)、超参数、启动命令、过拟合
  应对见 `voxcpm/finetune-config`。
- `voxcpm-finetune` skill 驱动 manifest 准备、校验、生成配置,并在训练完成后跑 LoRA 推理——
  它不会去启动或盯着训练本身。

## 结构

```
voxcpm/
  pack.toml
  skills/
    voxcpm/SKILL.md                 # 合成:design/clone/batch 路由、环境探测、汇报
    voxcpm-finetune/SKILL.md        # 微调:数据 → 校验 → 配置 → (用户训练) → 推理
  seed/
    cli-reference.md                # 每个子命令的确切 flag 表,以及不存在的 flag 清单
    environment.md                  # 探测结果模板(agent 填写,用户可改)
    installation.md                 # 装法、依赖、Python 版本说明
    troubleshooting.md              # 环境类故障排查
    synthesis.md                    # design/clone/batch 选择、调参、参考音频要求
    text-prep.md                    # 文本准备 cookbook
    finetune-data.md                # manifest 格式、validate、尾静音裁剪
    finetune-config.md              # 显存预算、超参数、启动命令、监控
  scripts/
    check-cli-reference.sh          # 开发期校验:seed/skill 里的 flag 与 cli-reference.md 一致
                                     # (不被 pack.toml 引用,不会被安装)
```

## 说明

- **参考页按需加载。** 两个 SKILL.md 都自带一段内联的环境探测流程,只有具体细节(确切 flag、
  调参范围、manifest 格式)才路由到 seed 页,让 skill 保持精简。
- **判断是否装好的测试是 `voxcpm --help` 能不能跑通,而不是 `import voxcpm` 能不能跑通**——
  `voxcpm` 可执行文件是个在安装时就绑定好解释器的 shim,运行时不查 `PATH`/`VIRTUAL_ENV`。实测
  验证过:激活一个空 venv,`python -c "import voxcpm"` 会报 `ModuleNotFoundError`,而同一个
  shell 里 `voxcpm --help` 照常能跑。
- **seed 页和两个 SKILL.md 里的每个 flag 都会在开发期被 `voxcpm/scripts/check-cli-reference.sh`
  拿真实 `voxcpm --help` 校验一遍。** 这个脚本不扫描 README,所以这里提到的 flag 是手工核对
  `voxcpm/cli-reference.md` 得到的。

## License

MIT
