#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/SKILL.md"
EXIT_CODE=0

list_referenced_paths() {
  local pattern='references/[a-z0-9-]+\.(md|json)|examples/[a-z0-9-]+\.md|scripts/[a-z0-9-]+\.sh|logs/[a-z0-9-]+\.md'
  if command -v rg >/dev/null 2>&1; then
    rg -o "$pattern" "$SKILL_FILE" | sort -u
  else
    grep -Eo "$pattern" "$SKILL_FILE" | sort -u
  fi
}

echo "[structure] target: $ROOT_DIR"

LINE_COUNT="$(wc -l < "$SKILL_FILE" | tr -d ' ')"
echo "[structure] SKILL.md lines: $LINE_COUNT"
if [ "$LINE_COUNT" -le 120 ]; then
  echo "  PASS: line count <= 120"
else
  echo "  FAIL: line count exceeds 120"
  EXIT_CODE=1
fi

echo "[structure] required roots"
for rel in AGENTS.md README.md CHANGELOG.md SKILL.md .github .githooks .nvmrc references examples scripts logs; do
  if [ -e "$ROOT_DIR/$rel" ]; then
    echo "  PASS: $rel"
  else
    echo "  FAIL: missing $rel"
    EXIT_CODE=1
  fi
done

echo "[structure] referenced paths"
while IFS= read -r rel; do
  if [ -e "$ROOT_DIR/$rel" ]; then
    echo "  PASS: $rel"
  else
    echo "  FAIL: missing $rel"
    EXIT_CODE=1
  fi
done < <(
  list_referenced_paths
)

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[structure] PASS"
else
  echo "[structure] FAIL"
fi

exit "$EXIT_CODE"
