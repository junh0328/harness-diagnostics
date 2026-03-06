#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCORE="${1:?usage: bash scripts/log-skill-self.sh <score> <grade> [note] [result]}"
GRADE="${2:?usage: bash scripts/log-skill-self.sh <score> <grade> [note] [result]}"
NOTE="${3:-직접 \$harness-diagnostics self 실행 결과}"
RESULT="${4:-PASS}"

bash "$ROOT_DIR/scripts/append-self-audit-log.sh" \
  "직접 Self 실행" \
  "$RESULT" \
  "$NOTE" \
  "skill-self" \
  "$SCORE" \
  "$GRADE"

echo "[log-skill-self] score: $SCORE"
echo "[log-skill-self] grade: $GRADE"
echo "[log-skill-self] result: $RESULT"
