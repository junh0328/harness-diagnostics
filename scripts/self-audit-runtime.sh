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

echo "[runtime] audit example coverage"
for section in "요약" "2. 차원별 점수" "빠른 개선 항목" "개선 로드맵" "근거" "위험 요소" "수행한 검증"; do
  if has_heading "$section" "$ROOT_DIR/references/report-template.md" && has_heading "$section" "$ROOT_DIR/examples/sample-report.md"; then
    echo "  PASS: $section"
  else
    echo "  FAIL: missing audit section $section"
    EXIT_CODE=1
  fi
done

echo "[runtime] skill checklist consistency"
if ROOT_DIR="$ROOT_DIR" node <<'EOF'
const fs = require("fs");
const path = require("path");

const root = process.env.ROOT_DIR;
const checklist = fs.readFileSync(path.join(root, "references", "skill-checklist.md"), "utf8");
const skill = fs.readFileSync(path.join(root, "SKILL.md"), "utf8");
const version = skill.match(/^version:\s*([0-9.]+)$/m)?.[1];

if (!version) {
  throw new Error("missing SKILL version");
}

const metaStart = checklist.indexOf("## 메타:");
if (metaStart === -1) {
  throw new Error("missing checklist meta section");
}

const checklistBody = checklist.slice(0, metaStart);
const sectionMatches = Array.from(
  checklistBody.matchAll(/^##\s+\d+\.\s+(.+?)\s+—\s+(\d+)항목$/gm),
  (match) => ({ title: match[1], expected: Number(match[2]), items: 0 }),
);

if (sectionMatches.length !== 8) {
  throw new Error(`expected 8 checklist sections, found ${sectionMatches.length}`);
}

let sectionIndex = -1;
for (const line of checklistBody.split("\n")) {
  if (/^##\s+\d+\.\s+.+\s+—\s+\d+항목$/.test(line)) {
    sectionIndex += 1;
    continue;
  }
  if (sectionIndex >= 0 && /^- \[ \]/.test(line.trim())) {
    sectionMatches[sectionIndex].items += 1;
  }
}

for (const section of sectionMatches) {
  if (section.expected !== section.items) {
    throw new Error(`section count mismatch: ${section.title} expected ${section.expected}, found ${section.items}`);
  }
}

const totalItems = sectionMatches.reduce((sum, section) => sum + section.items, 0);
const summaryRows = Array.from(
  checklist.matchAll(/^\| (파일 구조 검증|SKILL\.md 품질|Frontmatter 품질|본문 구조|출력 형식 정의|References 품질|자체 평가 메커니즘|운영 Guardrail) \| (\d+)\/(\d+) \|/gm),
  (match) => ({ label: match[1], score: Number(match[2]), total: Number(match[3]) }),
);

if (summaryRows.length !== sectionMatches.length) {
  throw new Error(`expected ${sectionMatches.length} summary rows, found ${summaryRows.length}`);
}

summaryRows.forEach((row, index) => {
  const expected = sectionMatches[index].items;
  if (row.score !== expected || row.total !== expected) {
    throw new Error(`summary row mismatch: ${row.label} expected ${expected}/${expected}, found ${row.score}/${row.total}`);
  }
});

const metaVersion = checklist.match(/진단 시점: v([0-9.]+)/)?.[1];
if (metaVersion !== version) {
  throw new Error(`checklist meta version mismatch: v${metaVersion} !== v${version}`);
}

const totalMatch = checklist.match(/\*\*총점\*\*: (\d+)\/(\d+) \(100%\)/);
if (!totalMatch) {
  throw new Error("missing total score summary");
}
if (Number(totalMatch[1]) !== totalItems || Number(totalMatch[2]) !== totalItems) {
  throw new Error(`total summary mismatch: expected ${totalItems}/${totalItems}`);
}

const quarterlyMatch = checklist.match(/전체 skill-checklist 자기 적용 \((\d+)항목\)/);
if (!quarterlyMatch || Number(quarterlyMatch[1]) !== totalItems) {
  throw new Error(`quarterly checklist count mismatch: expected ${totalItems}`);
}
EOF
then
  echo "  PASS: references/skill-checklist.md"
else
  echo "  FAIL: references/skill-checklist.md"
  EXIT_CODE=1
fi

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
