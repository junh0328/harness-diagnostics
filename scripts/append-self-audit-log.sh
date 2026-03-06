#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/SKILL.md"
LOG_FILE="$ROOT_DIR/logs/self-audit-log.md"

TRIGGER="${1:-수동 실행}"
RESULT="${2:-PASS}"
NOTE="${3:-}"
DATE_VALUE="${DATE_VALUE:-$(date +%F)}"
VERSION="$(awk '/^version:/ {print $2; exit}' "$SKILL_FILE")"

DATE_VALUE="$DATE_VALUE" VERSION="$VERSION" TRIGGER="$TRIGGER" RESULT="$RESULT" NOTE="$NOTE" LOG_FILE="$LOG_FILE" node <<'EOF'
const fs = require("fs");

const file = process.env.LOG_FILE;
const row = `| ${process.env.DATE_VALUE} | v${process.env.VERSION} | ${process.env.TRIGGER} | ${process.env.RESULT} | ${process.env.NOTE} |`;

const text = fs.readFileSync(file, "utf8");
const lines = text.split("\n");
const insertAt = lines.findIndex((line) => line.startsWith("|------|"));

if (insertAt === -1) {
  throw new Error("self-audit log table header not found");
}

const existing = lines.some((line) => line.trim() === row.trim());
if (!existing) {
  lines.splice(insertAt + 1, 0, row);
  fs.writeFileSync(file, lines.join("\n"));
}
EOF

echo "[append-self-audit-log] version: $VERSION"
echo "[append-self-audit-log] trigger: $TRIGGER"
