#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/SKILL.md"
CHECKLIST_FILE="$ROOT_DIR/references/skill-checklist.md"

VERSION="$(awk '/^version:/ {print $2; exit}' "$SKILL_FILE")"
LINE_COUNT="$(wc -l < "$SKILL_FILE" | tr -d ' ')"

if [ "$LINE_COUNT" -le 120 ]; then
  SKILL_NOTE="120줄 기준 충족"
else
  SKILL_NOTE="라인 수 초과: ${LINE_COUNT}줄"
fi

VERSION="$VERSION" SKILL_NOTE="$SKILL_NOTE" perl -0pi -e '
  s/진단 시점: v[0-9.]+/진단 시점: v$ENV{VERSION}/g;
  s/\| SKILL\.md 품질 \| 6\/6 \| [^|]+ \|/| SKILL.md 품질 | 6\/6 | $ENV{SKILL_NOTE} |/g;
' "$CHECKLIST_FILE"

echo "[update-self-meta] version: $VERSION"
echo "[update-self-meta] skill note: $SKILL_NOTE"
