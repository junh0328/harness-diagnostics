#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXIT_CODE=0

# --log 옵션: 실행 결과를 logs/ 하위에 timestamped 파일로 보존한다.
# 왜 필요한가: 기본 실행은 stdout만 출력하여 이력이 남지 않는다.
# 이 옵션으로 과거 실행 결과를 비교하고 회귀를 추적할 수 있다.
LOG_FILE=""
if [ "${1:-}" = "--log" ]; then
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  LOG_FILE="$ROOT_DIR/logs/self-audit-${TIMESTAMP}.log"
  exec > >(tee "$LOG_FILE") 2>&1
  echo "[self-audit] logging to: $LOG_FILE"
fi

echo "[self-audit] target: $ROOT_DIR"

echo "[self-audit] runtime contract"
if bash "$ROOT_DIR/scripts/check-node-version.sh"; then
  echo "  PASS: node version audit"
else
  echo "  FAIL: node version audit"
  EXIT_CODE=1
fi

echo "[self-audit] structure"
if bash "$ROOT_DIR/scripts/self-audit-structure.sh"; then
  echo "  PASS: structure audit"
else
  echo "  FAIL: structure audit"
  EXIT_CODE=1
fi

echo "[self-audit] runtime"
if bash "$ROOT_DIR/scripts/self-audit-runtime.sh"; then
  echo "  PASS: runtime audit"
else
  echo "  FAIL: runtime audit"
  EXIT_CODE=1
fi

echo "[self-audit] adversarial verify"
if bash "$ROOT_DIR/scripts/adversarial-verify.sh"; then
  echo "  PASS: adversarial verify"
else
  echo "  FAIL: adversarial verify"
  EXIT_CODE=1
fi

echo "[self-audit] semantic verify"
if bash "$ROOT_DIR/scripts/semantic-verify.sh"; then
  echo "  PASS: semantic verify"
else
  echo "  FAIL: semantic verify"
  EXIT_CODE=1
fi

echo "[self-audit] behavioral verify"
if bash "$ROOT_DIR/scripts/behavioral-verify.sh"; then
  echo "  PASS: behavioral verify"
else
  echo "  FAIL: behavioral verify"
  EXIT_CODE=1
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "[result] PASS"
else
  echo "[result] FAIL"
fi

exit "$EXIT_CODE"
