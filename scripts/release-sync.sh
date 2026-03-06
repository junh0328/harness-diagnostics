#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-${CODEX_SKILL_TARGET:-$HOME/.codex/skills/harness-diagnostics}}"

on_error() {
  status=$?
  if [ "$status" -ne 0 ]; then
    bash "$ROOT_DIR/scripts/append-self-audit-log.sh" "Release sync to .codex" "FAIL" "Sync failed before completion" "script"
  fi
  exit "$status"
}

trap on_error EXIT

bash "$ROOT_DIR/scripts/update-self-meta.sh"
bash "$ROOT_DIR/scripts/self-audit.sh"
bash "$ROOT_DIR/scripts/sync-to-codex.sh" "$TARGET_DIR"

bash "$TARGET_DIR/scripts/update-self-meta.sh"
bash "$TARGET_DIR/scripts/self-audit.sh"
bash "$ROOT_DIR/scripts/append-self-audit-log.sh" "Release sync to .codex" "PASS" "Synchronized to $TARGET_DIR" "script"

trap - EXIT

echo "[release-sync] completed"
echo "[release-sync] target: $TARGET_DIR"
