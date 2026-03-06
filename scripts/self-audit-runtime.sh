#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXIT_CODE=0

has_heading() {
  local heading="$1"
  local file="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -Fq "$heading" "$file"
  else
    grep -Fq "$heading" "$file"
  fi
}

echo "[runtime] doc lint"
if bash "$ROOT_DIR/scripts/doc-lint.sh"; then
  echo "  PASS: scripts/doc-lint.sh"
else
  echo "  FAIL: scripts/doc-lint.sh"
  EXIT_CODE=1
fi

echo "[runtime] setup example coverage"
for heading in "## 2. 요구사항 오버레이" "## 6. 목표 AGENTS.md 초안 구조"; do
  if has_heading "$heading" "$ROOT_DIR/references/report-template.md" && has_heading "$heading" "$ROOT_DIR/examples/sample-setup-report.md"; then
    echo "  PASS: $heading"
  else
    echo "  FAIL: missing setup heading $heading"
    EXIT_CODE=1
  fi
done

echo "[runtime] score calculator"
if node "$ROOT_DIR/scripts/calculate-score.js" "$ROOT_DIR/references/score-template.json" >/dev/null; then
  echo "  PASS: scripts/calculate-score.js"
else
  echo "  FAIL: scripts/calculate-score.js"
  EXIT_CODE=1
fi

echo "[runtime] maintenance scan"
if bash "$ROOT_DIR/scripts/maintenance-scan.sh"; then
  echo "  PASS: scripts/maintenance-scan.sh"
else
  echo "  FAIL: scripts/maintenance-scan.sh"
  EXIT_CODE=1
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[runtime] PASS"
else
  echo "[runtime] FAIL"
fi

exit "$EXIT_CODE"
