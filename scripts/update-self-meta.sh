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

VERSION="$VERSION" SKILL_NOTE="$SKILL_NOTE" CHECKLIST_FILE="$CHECKLIST_FILE" node <<'EOF'
const fs = require("fs");

const file = process.env.CHECKLIST_FILE;
const version = process.env.VERSION;
const skillNote = process.env.SKILL_NOTE;

let text = fs.readFileSync(file, "utf8");
text = text.replace(/진단 시점: v[0-9.]+/g, `진단 시점: v${version}`);
text = text.replace(/\| SKILL\.md 품질 \| 6\/6 \| [^|]+ \|/g, `| SKILL.md 품질 | 6/6 | ${skillNote} |`);
fs.writeFileSync(file, text);
EOF

echo "[update-self-meta] version: $VERSION"
echo "[update-self-meta] skill note: $SKILL_NOTE"
