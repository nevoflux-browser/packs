#!/bin/bash
# validate-pack.sh — FALLBACK capability check for a generated NevoFlux pack.
#
# Best-effort bash mirror of crates/pack/src/capability.rs::validate (the 5 invariants)
# plus manifest.rs field rules. Use only when `nevoflux pack validate` is not on PATH —
# the CLI runs the exact same Rust validator and is AUTHORITATIVE. This script is lexical:
# it does not fully parse TOML (multi-line arrays / inline tables may be missed).
#
# Usage: bash validate-pack.sh <pack-dir-or-pack.toml>
# Exit:  0 = clean, 1 = violation(s) printed to stderr.

set -uo pipefail

ARG="${1:-}"
[ -n "$ARG" ] || { echo "Usage: bash validate-pack.sh <pack-dir-or-pack.toml>" >&2; exit 1; }
if [ -d "$ARG" ]; then TOML="$ARG/pack.toml"; else TOML="$ARG"; fi
[ -f "$TOML" ] || { echo "FAIL: pack.toml not found at $TOML" >&2; exit 1; }

FAIL=0
err() { echo "FAIL: $*" >&2; FAIL=1; }

# first "key = \"value\"" (single-valued)
field()  { grep -oE "^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"[^\"]*\"" "$TOML" 2>/dev/null | head -1 | sed -E 's/.*"([^"]*)".*/\1/'; }
# all "key = \"value\"" values (repeated singular key, e.g. seed slug/from)
fields() { grep -oE "^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"[^\"]*\"" "$TOML" 2>/dev/null | sed -E 's/.*"([^"]*)".*/\1/'; }
# quoted entries of an array line "key = [ \"a\", \"b\" ]"
arr()    { grep -E "^[[:space:]]*$1[[:space:]]*=" "$TOML" 2>/dev/null | grep -oE '"[^"]*"' | tr -d '"'; }
has()    { grep -qE "$1" "$TOML" 2>/dev/null; }

NAME="$(field name)"; VERSION="$(field version)"; PROTOCOL="$(field protocol)"
MIN="$(field min_nevoflux)"; NS="$(field namespace)"; [ -n "$NS" ] || NS="$NAME"

# ---- manifest.rs field rules ----
[ -n "$NAME" ]     || err "pack.name missing"
[ -n "$VERSION" ]  || err "pack.version missing"
[ -n "$PROTOCOL" ] || err "pack.protocol missing"
[ -n "$MIN" ]      || err "pack.min_nevoflux missing"
[ -z "$NAME" ]     || echo "$NAME" | grep -qE '^[a-z0-9-]+$'        || err "pack.name '$NAME' must match [a-z0-9-]+"
[ -z "$PROTOCOL" ] || [ "$PROTOCOL" = "pack-protocol/0.1" ]          || err "unsupported protocol '$PROTOCOL'"
[ -z "$VERSION" ]  || echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+' || err "pack.version '$VERSION' is not semver"
[ -z "$MIN" ]      || echo "$MIN" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+'     || err "pack.min_nevoflux '$MIN' is not semver"

# ---- invariant 2: [components.config] forbidden ; knowledge rejected at install ----
if has '^\[components\.config\]';    then err "[components.config] is forbidden (invariant 2)"; fi
if has '^\[components\.knowledge\]'; then err "[components.knowledge] is rejected at install — do not generate it"; fi

# ---- invariant 1: source paths must be safe-relative ----
while IFS= read -r p; do
  [ -n "$p" ] || continue
  case "$p" in
    /*|\\*)      err "source path '$p' is absolute (invariant 1)" ;;
    [A-Za-z]:*)  err "source path '$p' has a drive prefix (invariant 1)" ;;
    *..*)        err "source path '$p' contains '..' — traversal (invariant 1)" ;;
  esac
done < <( { fields dir; fields from; fields files_from; arr files; } )

# ---- invariants 4 + 5: slug namespace + seed coverage ----
in_ns() { [ "$1" = "$NS" ] && return 0; case "$1" in "$NS"/*) return 0 ;; *) return 1 ;; esac; }
PROT_SLUGS="$(arr slugs)"
PROT_PREFIXES="$(arr prefixes)"

while IFS= read -r s; do
  [ -n "$s" ] || continue
  in_ns "$s" || err "seed slug '$s' outside namespace '$NS' (invariant 4)"
  covered=0
  while IFS= read -r x; do [ -n "$x" ] && [ "$s" = "$x" ] && covered=1; done < <(printf '%s\n' "$PROT_SLUGS")
  if [ "$covered" = 0 ]; then
    while IFS= read -r pre; do [ -n "$pre" ] || continue; case "$s" in "$pre"*) covered=1 ;; esac; done < <(printf '%s\n' "$PROT_PREFIXES")
  fi
  [ "$covered" = 1 ] || err "seed slug '$s' not covered by protected.slugs/prefixes (invariant 5)"
done < <(fields slug)

while IFS= read -r pr; do
  [ -n "$pr" ] || continue
  in_ns "$pr" || err "protected '$pr' outside namespace '$NS' (invariant 4)"
done < <(printf '%s\n%s\n' "$PROT_SLUGS" "$PROT_PREFIXES")

# ---- invariant 6: dashboard artifact_id must start with pack name ----
AID="$(field artifact_id)"
if [ -n "$AID" ]; then
  case "$AID" in "$NAME"*) : ;; *) err "dashboard artifact_id '$AID' must start with pack name '$NAME' (invariant 6)" ;; esac
fi

if [ "$FAIL" = 0 ]; then
  echo "PASS: $TOML — capability invariants OK (bash approximation; 'nevoflux pack validate' is authoritative)"
  exit 0
else
  echo "INVALID: $TOML has the violation(s) above." >&2
  exit 1
fi
