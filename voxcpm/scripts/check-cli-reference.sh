#!/bin/bash
# check-cli-reference.sh — 校验本 pack 全部文档只提到真实存在的 CLI flag，双向比对
# seed/cli-reference.md 的别名配对与实测 voxcpm --help。
#
# 上游 README 记载了实际不存在的 flag（--seed / --timestamps）。本脚本确保本 pack
# 的文档只描述真实存在的 flag，且「已知不存在」清单不会悄悄过期。长 flag 存在性检查
# 覆盖 seed/*.md 与 skills/*/SKILL.md 的全部文件——不止 cli-reference.md，因为编造的
# flag 一样可能出现在 troubleshooting.md 之类的散文页里，且同样危险。别名配对检查
# （-t/-o/-i/-od/-ra/-pa/-pt/-m/-v 与其长 flag 的配对）只对 cli-reference.md 的表格
# 格式有意义，继续只作用于该文件，不强加到散文页上。
#
# 用法: bash voxcpm/scripts/check-cli-reference.sh
# 退出: 0 = 一致, 1 = 不一致, 2 = 环境不可用（无法校验）

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
CLI_DOC="seed/cli-reference.md"
[ -f "$CLI_DOC" ] || { echo "FAIL: $CLI_DOC 不存在" >&2; exit 1; }

# 校验长 flag 存在性的文件集合：全部 seed 页 + 全部技能页。nullglob 防止目录为空
# （如 skills/voxcpm/、skills/voxcpm-finetune/ 目前还没有 SKILL.md）时把字面 glob
# 字符串当成文件名。
shopt -s nullglob
DOCS=(seed/*.md skills/*/SKILL.md)
shopt -u nullglob

command -v voxcpm >/dev/null 2>&1 || {
  echo "SKIP: voxcpm 不在 PATH 上，无法校验 flag。此检查需要可用的 VoxCPM 环境。" >&2
  exit 2
}

TMPDIR="$(mktemp -d)"; trap 'rm -rf "$TMPDIR"' EXIT

# 实测 help 的全集（顶层 + 四个子命令），stdout+stderr 都收。5 次调用彼此独立、
# 无共享状态，并行跑（每次约 13~15s，主要花在加载 torch 上；串行约 70s，并行后
# 墙钟约等于单次调用耗时）。
voxcpm --help          >"$TMPDIR/top"      2>&1 &
voxcpm design --help   >"$TMPDIR/design"   2>&1 &
voxcpm clone --help    >"$TMPDIR/clone"    2>&1 &
voxcpm batch --help    >"$TMPDIR/batch"    2>&1 &
voxcpm validate --help >"$TMPDIR/validate" 2>&1 &
wait
LIVE="$TMPDIR/live"
cat "$TMPDIR/top" "$TMPDIR/design" "$TMPDIR/clone" "$TMPDIR/batch" "$TMPDIR/validate" > "$LIVE"

# 抽长 flag：一行一个，去重。前导 [^-a-zA-Z0-9] 防止把 "--foo" 从 "---foo" 里抠出来
extract_long() { grep -oE '(^|[^-a-zA-Z0-9])--[a-z][a-z0-9-]*' "$1" | grep -oE '\-\-[a-z][a-z0-9-]*' | sort -u; }

# 抽「长flag:短别名」配对，输出形如 "--output-dir:-od"。
#   实测 help: argparse 把长短选项写在同一行 "--flag, -x"（后面跟 METAVAR 或换行），
#     这是 argparse 固定的渲染格式，只有真正的别名声明才会命中。
#   文档: markdown 表格行 "| `--flag` | `-x` |"，只从反引号包裹的表格单元格里抽，
#     不会被中文排版、`--config_path`、数字区间 1.0-3.0、列表项 "- " 等噪音误触发。
extract_pairs_live() { grep -oE -- '--[a-z][a-z0-9-]*, -[a-zA-Z][a-zA-Z0-9-]*' "$1" | sed -E 's/, /:/' | sort -u; }
extract_pairs_doc()  { grep -oE -- '`--[a-z][a-z0-9-]*`[[:space:]]*\|[[:space:]]*`-[a-zA-Z][a-zA-Z0-9-]*`' "$1" | sed -E 's/`//g; s/[[:space:]]*\|[[:space:]]*/:/' | sort -u; }

extract_long "$LIVE" > "$TMPDIR/live_long"
extract_pairs_live "$LIVE" > "$TMPDIR/live_pairs"
extract_pairs_doc  "$CLI_DOC" > "$TMPDIR/doc_pairs"

# 精确成员判定：-x 整行匹配，避免 --seed 误匹配 --seed-value
in_file() { grep -qxF -- "$1" "$2"; }

FAIL=0
KNOWN_ABSENT="--seed --timestamps --timestamp-level --timestamp-language --retry-badcase --version"

# 方向 1: 某个文档文件写了某 flag，但实测 help 里没有 → 该文件在编造
# （README 就是这么错的）。覆盖 DOCS 里的每个文件，不止 cli-reference.md——
# 编造的 flag 一样可能出现在散文页（troubleshooting.md 等）里。
# 例外: 「已知不存在」清单里的 flag 本就该出现在文档里（作为不存在的记录）
for docfile in "${DOCS[@]}"; do
  extract_long "$docfile" > "$TMPDIR/doc_long_current"
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case " $KNOWN_ABSENT " in *" $f "*) continue ;; esac
    in_file "$f" "$TMPDIR/live_long" || { echo "FAIL: $docfile 写了 $f，但实测 --help 里没有" >&2; FAIL=1; }
  done < "$TMPDIR/doc_long_current"
done

# 方向 2: 「已知不存在」清单过期 → 上游加了这个 flag，文档该更新
for f in $KNOWN_ABSENT; do
  if in_file "$f" "$TMPDIR/live_long"; then
    echo "FAIL: $f 被列为「不存在」，但实测 --help 里有了 —— 上游已新增，文档需更新" >&2
    FAIL=1
  fi
done

# 方向 3: 文档给出的「长flag:短别名」配对，实测里查无此配对 → 别名写错或挂错子命令
while IFS= read -r p; do
  [ -n "$p" ] || continue
  in_file "$p" "$TMPDIR/live_pairs" || { echo "FAIL: 文档写的别名配对 $p，实测 --help 中查无此配对" >&2; FAIL=1; }
done < "$TMPDIR/doc_pairs"

# 方向 4: 实测里有的「长flag:短别名」配对，文档没写 → 别名漏文档或文档配对写错
while IFS= read -r p; do
  [ -n "$p" ] || continue
  in_file "$p" "$TMPDIR/doc_pairs" || { echo "FAIL: 实测 --help 里有别名配对 $p，但文档没写（或写错）" >&2; FAIL=1; }
done < "$TMPDIR/live_pairs"

if [ "$FAIL" = 0 ]; then
  echo "PASS: 全部文档（${#DOCS[@]} 个文件）与实测 voxcpm --help 一致"
  exit 0
fi
exit 1
