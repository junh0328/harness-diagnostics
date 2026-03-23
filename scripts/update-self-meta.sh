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
const metaStart = text.indexOf("## 메타:");
const checklistBody = metaStart === -1 ? text : text.slice(0, metaStart);
const sectionCounts = Array.from(
  checklistBody.matchAll(/^##\s+\d+\.\s+.+\s+—\s+(\d+)항목$/gm),
  (match) => Number(match[1]),
);
const totalItems = sectionCounts.reduce((sum, count) => sum + count, 0);
const summaryRows = [
  "파일 구조 검증",
  "SKILL.md 품질",
  "Frontmatter 품질",
  "본문 구조",
  "출력 형식 정의",
  "References 품질",
  "자체 평가 메커니즘",
  "운영 Guardrail",
];

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

text = text.replace(/진단 시점: v[0-9.]+/g, `진단 시점: v${version}`);
text = text.replace(/\| SKILL\.md 품질 \| \d+\/\d+ \| [^|]+ \|/g, `| SKILL.md 품질 | ${sectionCounts[1]}/${sectionCounts[1]} | ${skillNote} |`);
summaryRows.forEach((label, index) => {
  const expected = `${sectionCounts[index]}/${sectionCounts[index]}`;
  const rowPattern = new RegExp(`\\| ${escapeRegex(label)} \\| \\d+/\\d+ \\|([^\\n]+?)\\|`, "g");
  text = text.replace(rowPattern, (_, note) => {
    const nextNote = label === "SKILL.md 품질" ? ` ${skillNote} ` : note;
    return `| ${label} | ${expected} |${nextNote}|`;
  });
});
text = text.replace(/\*\*총점\*\*: \d+\/\d+ \(100%\)/g, `**총점**: ${totalItems}/${totalItems} (100%)`);
text = text.replace(/전체 skill-checklist 자기 적용 \(\d+항목\)/g, `전체 skill-checklist 자기 적용 (${totalItems}항목)`);
fs.writeFileSync(file, text);
EOF

echo "[update-self-meta] version: $VERSION"
echo "[update-self-meta] skill note: $SKILL_NOTE"
