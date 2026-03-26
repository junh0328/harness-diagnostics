#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXIT_CODE=0

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
