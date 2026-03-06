#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/SKILL.md"
EXIT_CODE=0

echo "[self-audit] target: $ROOT_DIR"

LINE_COUNT="$(wc -l < "$SKILL_FILE" | tr -d ' ')"
echo "[check] SKILL.md lines: $LINE_COUNT"
if [ "$LINE_COUNT" -le 120 ]; then
  echo "  PASS: line count <= 120"
else
  echo "  FAIL: line count exceeds 120"
  EXIT_CODE=1
fi

echo "[check] referenced paths"
while IFS= read -r rel; do
  if [ -f "$ROOT_DIR/$rel" ]; then
    echo "  PASS: $rel"
  else
    echo "  FAIL: missing $rel"
    EXIT_CODE=1
  fi
done < <(
  rg -o 'references/[a-z0-9-]+\.(md|json)|examples/[a-z0-9-]+\.md|scripts/[a-z0-9-]+\.sh|logs/[a-z0-9-]+\.md' "$SKILL_FILE" | sort -u
)

echo "[check] required directories"
for d in references examples scripts logs; do
  if [ -d "$ROOT_DIR/$d" ]; then
    echo "  PASS: $d/"
  else
    echo "  FAIL: missing $d/"
    EXIT_CODE=1
  fi
done

echo "[check] setup example coverage"
for heading in "## 2. 요구사항 오버레이" "## 6. 목표 AGENTS.md 초안 구조"; do
  if rg -Fq "$heading" "$ROOT_DIR/references/report-template.md" && rg -Fq "$heading" "$ROOT_DIR/examples/sample-setup-report.md"; then
    echo "  PASS: $heading"
  else
    echo "  FAIL: missing setup heading $heading"
    EXIT_CODE=1
  fi
done

echo "[check] score calculator"
if node "$ROOT_DIR/scripts/calculate-score.js" "$ROOT_DIR/references/score-template.json" >/dev/null; then
  echo "  PASS: scripts/calculate-score.js"
else
  echo "  FAIL: scripts/calculate-score.js"
  EXIT_CODE=1
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[result] PASS"
else
  echo "[result] FAIL"
fi

exit "$EXIT_CODE"
