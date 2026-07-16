#!/bin/bash
# check-cli-reference.sh — 双向比对 seed/cli-reference.md 与实测 voxcpm --help。
#
# 上游 README 记载了实际不存在的 flag（--seed / --timestamps）。本脚本确保本 pack
# 的文档只描述真实存在的 flag，且「已知不存在」清单不会悄悄过期。
#
# 用法: bash voxcpm/scripts/check-cli-reference.sh
# 退出: 0 = 一致, 1 = 不一致, 2 = 环境不可用（无法校验）

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2
DOC="seed/cli-reference.md"
[ -f "$DOC" ] || { echo "FAIL: $DOC 不存在" >&2; exit 1; }

command -v voxcpm >/dev/null 2>&1 || {
  echo "SKIP: voxcpm 不在 PATH 上，无法校验 flag。此检查需要可用的 VoxCPM 环境。" >&2
  exit 2
}

# 实测 help 的全集（顶层 + 四个子命令），stdout+stderr 都收
LIVE="$(mktemp)"; DOCF="$(mktemp)"; trap 'rm -f "$LIVE" "$LIVE.flags" "$DOCF"' EXIT
{ voxcpm --help; for c in design clone batch validate; do voxcpm "$c" --help; done; } >"$LIVE" 2>&1

# 抽 flag：一行一个，去重。前导 [^-a-zA-Z0-9] 防止把 "--foo" 从 "---foo" 里抠出来
extract() { grep -oE '(^|[^-a-zA-Z0-9])--[a-z][a-z0-9-]*' "$1" | grep -oE '\-\-[a-z][a-z0-9-]*' | sort -u; }
extract "$LIVE" > "$LIVE.flags"
extract "$DOC"  > "$DOCF"

# 精确成员判定：-x 整行匹配，避免 --seed 误匹配 --seed-value
in_live() { grep -qxF -- "$1" "$LIVE.flags"; }

FAIL=0
KNOWN_ABSENT="--seed --timestamps --timestamp-level --timestamp-language --retry-badcase --version"

# 方向 1: 文档写了但实测 help 里没有 → 文档在编造（README 就是这么错的）
# 例外: 「已知不存在」清单里的 flag 本就该出现在文档里（作为不存在的记录）
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case " $KNOWN_ABSENT " in *" $f "*) continue ;; esac
  in_live "$f" || { echo "FAIL: 文档写了 $f，但实测 --help 里没有" >&2; FAIL=1; }
done < "$DOCF"

# 方向 2: 「已知不存在」清单过期 → 上游加了这个 flag，文档该更新
for f in $KNOWN_ABSENT; do
  if in_live "$f"; then
    echo "FAIL: $f 被列为「不存在」，但实测 --help 里有了 —— 上游已新增，文档需更新" >&2
    FAIL=1
  fi
done

if [ "$FAIL" = 0 ]; then
  echo "PASS: cli-reference.md 与实测 voxcpm --help 一致"
  exit 0
fi
exit 1
