#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOK_FILE="$ROOT_DIR/.githooks/pre-commit"

if [ ! -f "$HOOK_FILE" ]; then
  echo "[install-hooks] FAIL: missing $HOOK_FILE"
  exit 1
fi

chmod +x "$HOOK_FILE"
git -C "$ROOT_DIR" config core.hooksPath .githooks

echo "[install-hooks] core.hooksPath=$(git -C "$ROOT_DIR" config --get core.hooksPath)"
echo "[install-hooks] enabled: .githooks/pre-commit"
