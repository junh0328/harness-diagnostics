#!/usr/bin/env bash
set -euo pipefail

# adversarial-verify.sh — 반증(disprove) 관점에서 체크리스트를 재검증한다.
# 각 항목을 "통과했다"가 아니라 "실패 증거가 있는가?"로 접근한다.
# 결과: Score, Confidence, Bias Delta 지표 출력.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$ROOT_DIR/SKILL.md"
EXIT_CODE=0

PASS=0
FAIL=0
LOW_CONFIDENCE=0
TOTAL=0

check() {
  local id="$1"
  local description="$2"
  local result="$3"       # PASS or FAIL
  local confidence="$4"   # high, medium, low

  TOTAL=$((TOTAL + 1))

  if [ "$result" = "PASS" ]; then
    PASS=$((PASS + 1))
    if [ "$confidence" = "low" ]; then
      LOW_CONFIDENCE=$((LOW_CONFIDENCE + 1))
      echo "  PASS (low confidence): [$id] $description"
    else
      echo "  PASS: [$id] $description"
    fi
  else
    FAIL=$((FAIL + 1))
    echo "  FAIL: [$id] $description"
    EXIT_CODE=1
  fi
}

echo "[adversarial-verify] target: $ROOT_DIR"

# --- 1. 파일 구조 반증 ---
echo "[adversarial] 1. 파일 구조"

# 1-1: SKILL.md 유일 진입점 — 다른 SKILL 파일이 없어야 함
OTHER_SKILLS=$(find "$ROOT_DIR" -name "SKILL.md" -not -path "$SKILL_FILE" 2>/dev/null | head -5)
if [ -z "$OTHER_SKILLS" ]; then
  check "1-2" "SKILL.md가 유일한 진입점" "PASS" "high"
else
  check "1-2" "SKILL.md가 유일한 진입점 — 다른 SKILL.md 발견: $OTHER_SKILLS" "FAIL" "high"
fi

# 1-6: kebab-case 위반 탐지
NON_KEBAB=$(find "$ROOT_DIR/references" "$ROOT_DIR/examples" "$ROOT_DIR/scripts" -type f 2>/dev/null \
  | xargs -I{} basename {} \
  | grep -vE '^[a-z0-9][a-z0-9.-]*$' || true)
if [ -z "$NON_KEBAB" ]; then
  check "1-6" "파일명 kebab-case 준수" "PASS" "high"
else
  check "1-6" "kebab-case 위반: $NON_KEBAB" "FAIL" "high"
fi

# 1-7: 임시/빈 파일 탐지
EMPTY_FILES=$(find "$ROOT_DIR/references" "$ROOT_DIR/examples" "$ROOT_DIR/scripts" -type f -empty 2>/dev/null | head -5)
TEMP_FILES=$(find "$ROOT_DIR" -maxdepth 3 -name "*.tmp" -o -name "*.bak" -o -name "*~" 2>/dev/null | head -5)
if [ -z "$EMPTY_FILES" ] && [ -z "$TEMP_FILES" ]; then
  check "1-7" "임시/빈 파일 없음" "PASS" "high"
else
  check "1-7" "임시/빈 파일 발견: ${EMPTY_FILES}${TEMP_FILES}" "FAIL" "high"
fi

# 1-8: 깊이 3단계 이상 파일 탐지
DEEP_FILES=$(find "$ROOT_DIR/references" "$ROOT_DIR/examples" "$ROOT_DIR/scripts" -mindepth 2 -type f 2>/dev/null | head -5)
if [ -z "$DEEP_FILES" ]; then
  check "1-8" "디렉토리 깊이 2단계 이내" "PASS" "high"
else
  check "1-8" "깊이 초과 파일: $DEEP_FILES" "FAIL" "high"
fi

# --- 2. SKILL.md 품질 반증 ---
echo "[adversarial] 2. SKILL.md 품질"

# 2-1: Map vs Manual — SKILL.md에 상세 설명(5줄 이상 연속 산문)이 있으면 Manual 의심
LONG_PROSE=$(awk '
  /^[^|#\-`>]/ && length > 20 { count++ }
  /^$/ || /^[|#\-`>]/ { if (count >= 5) found++; count=0 }
  END { print found+0 }
' "$SKILL_FILE")
if [ "$LONG_PROSE" -eq 0 ]; then
  check "2-1" "SKILL.md가 Map 역할 (장문 산문 없음)" "PASS" "medium"
else
  check "2-1" "SKILL.md에 장문 산문 ${LONG_PROSE}건 — Manual 경향" "PASS" "low"
fi

# 2-4: 정보 중복 탐지 — SKILL.md와 references 간 동일 문장 존재 여부
SKILL_LINES=$(grep -v '^$\|^#\|^-\|^|\|^>\|^`' "$SKILL_FILE" | grep -E '.{30,}' | head -20)
DUPLICATION=0
if [ -n "$SKILL_LINES" ]; then
  while IFS= read -r line; do
    escaped=$(printf '%s' "$line" | sed 's/[[\.*^$()+?{}|]/\\&/g')
    if grep -rFq "$line" "$ROOT_DIR/references/" 2>/dev/null; then
      DUPLICATION=$((DUPLICATION + 1))
    fi
  done <<< "$SKILL_LINES"
fi
if [ "$DUPLICATION" -le 2 ]; then
  check "2-4" "SKILL.md-references 간 정보 중복 최소" "PASS" "medium"
else
  check "2-4" "중복 문장 ${DUPLICATION}건 탐지" "PASS" "low"
fi

# --- 3. Frontmatter 반증 ---
echo "[adversarial] 3. Frontmatter"

# 3-3: 트리거 조건 구체성 — description에 트리거 키워드가 있는지
TRIGGER_KEYWORDS=$(head -10 "$SKILL_FILE" | grep -cE '(Setup|Audit|Maintenance|Self|진단|점검|drift|정리|환경 구축)' || true)
if [ "$TRIGGER_KEYWORDS" -ge 2 ]; then
  check "3-3" "트리거 조건 구체적 (${TRIGGER_KEYWORDS}개 키워드)" "PASS" "high"
else
  check "3-3" "트리거 조건 부족 (${TRIGGER_KEYWORDS}개 키워드)" "FAIL" "high"
fi

# --- 4. 본문 구조 반증 ---
echo "[adversarial] 4. 본문 구조"

# 4-6: references 파일 경로 정확성 — SKILL.md에 기재된 경로가 실제 존재하는지
REF_PATTERN='references/[a-z0-9-]+\.(md|json)'
if command -v rg >/dev/null 2>&1; then
  REFS=$(rg -o "$REF_PATTERN" "$SKILL_FILE" | sort -u)
else
  REFS=$(grep -Eo "$REF_PATTERN" "$SKILL_FILE" | sort -u)
fi
BROKEN_REFS=0
while IFS= read -r ref; do
  [ -z "$ref" ] && continue
  if [ ! -f "$ROOT_DIR/$ref" ]; then
    BROKEN_REFS=$((BROKEN_REFS + 1))
    echo "    broken ref: $ref"
  fi
done <<< "$REFS"
if [ "$BROKEN_REFS" -eq 0 ]; then
  check "4-6" "references 파일 경로 모두 유효" "PASS" "high"
else
  check "4-6" "깨진 참조 ${BROKEN_REFS}건" "FAIL" "high"
fi

# --- 5. 출력 형식 반증 ---
echo "[adversarial] 5. 출력 형식"

# 5-5: 수행한 검증 섹션이 report-template과 예시 모두에 존재하는지
VERIFY_TEMPLATE=$(grep -c "수행한 검증" "$ROOT_DIR/references/report-template.md" || true)
VERIFY_EXAMPLE=$(grep -c "수행한 검증" "$ROOT_DIR/examples/sample-report.md" || true)
if [ "$VERIFY_TEMPLATE" -ge 1 ] && [ "$VERIFY_EXAMPLE" -ge 1 ]; then
  check "5-5" "수행한 검증 섹션 — 템플릿+예시 일치" "PASS" "high"
else
  check "5-5" "수행한 검증 섹션 누락 (template:${VERIFY_TEMPLATE}, example:${VERIFY_EXAMPLE})" "FAIL" "high"
fi

# --- 6. References 반증 ---
echo "[adversarial] 6. References"

# 6-4: 순환 의존성 탐지 — 단순 교차 참조 패턴
CIRCULAR=0
for ref_file in "$ROOT_DIR"/references/*.md; do
  basename_ref=$(basename "$ref_file")
  while IFS= read -r linked; do
    [ -z "$linked" ] && continue
    if grep -Fq "$basename_ref" "$ROOT_DIR/references/$linked" 2>/dev/null; then
      CIRCULAR=$((CIRCULAR + 1))
    fi
  done < <(grep -oE 'references/[a-z0-9-]+\.md' "$ref_file" 2>/dev/null | sed 's|references/||' | sort -u)
done
if [ "$CIRCULAR" -le 2 ]; then
  check "6-4" "순환 의존성 없음 또는 최소 (${CIRCULAR}건)" "PASS" "medium"
else
  check "6-4" "순환 참조 ${CIRCULAR}건 탐지" "FAIL" "medium"
fi

# --- 7. 자체 평가 메커니즘 반증 ---
echo "[adversarial] 7. 자체 평가"

# 7-7: self-audit-log에 최근 기록이 있는지 (30일 이내)
LOG_FILE="$ROOT_DIR/logs/self-audit-log.md"
if [ -f "$LOG_FILE" ]; then
  LATEST_DATE=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$LOG_FILE" | tail -1)
  if [ -n "$LATEST_DATE" ]; then
    DAYS_AGO=$(( ($(date +%s) - $(date -j -f "%Y-%m-%d" "$LATEST_DATE" +%s 2>/dev/null || date -d "$LATEST_DATE" +%s 2>/dev/null || echo 0)) / 86400 ))
    if [ "$DAYS_AGO" -le 30 ]; then
      check "7-7" "self-audit-log 최근 기록 (${DAYS_AGO}일 전)" "PASS" "high"
    else
      check "7-7" "self-audit-log 오래됨 (${DAYS_AGO}일 전)" "PASS" "low"
    fi
  else
    check "7-7" "self-audit-log 날짜 파싱 실패" "PASS" "low"
  fi
else
  check "7-7" "self-audit-log 파일 없음" "FAIL" "high"
fi

# --- 8. 운영 Guardrail 반증 ---
echo "[adversarial] 8. 운영 Guardrail"

# 8-1: CI workflow가 실제로 self-audit를 호출하는지
CI_CALLS_AUDIT=0
for wf in "$ROOT_DIR"/.github/workflows/*.yml; do
  [ -f "$wf" ] || continue
  if grep -q "self-audit" "$wf"; then
    CI_CALLS_AUDIT=$((CI_CALLS_AUDIT + 1))
  fi
done
if [ "$CI_CALLS_AUDIT" -ge 1 ]; then
  check "8-1" "CI workflow가 self-audit 호출 (${CI_CALLS_AUDIT}건)" "PASS" "high"
else
  check "8-1" "CI workflow에서 self-audit 미호출" "FAIL" "high"
fi

# 8-6: .nvmrc와 CI 연동 여부
NVMRC_VERSION=$(cat "$ROOT_DIR/.nvmrc" 2>/dev/null | tr -d '[:space:]')
CI_USES_NVMRC=$(grep -rl 'node-version-file.*\.nvmrc\|node-version-file:.*\.nvmrc' "$ROOT_DIR/.github/workflows/" 2>/dev/null | wc -l | tr -d ' ')
CI_NODE=$(grep -rh 'node-version:' "$ROOT_DIR/.github/workflows/" 2>/dev/null | grep -v 'file' | grep -oE '[0-9]+' | head -1 || true)
if [ -n "$NVMRC_VERSION" ] && [ "$CI_USES_NVMRC" -ge 1 ]; then
  check "8-6" ".nvmrc(${NVMRC_VERSION}) — CI가 .nvmrc 참조 (${CI_USES_NVMRC}건)" "PASS" "high"
elif [ -n "$NVMRC_VERSION" ] && [ -n "$CI_NODE" ]; then
  if echo "$NVMRC_VERSION" | grep -q "^${CI_NODE}"; then
    check "8-6" ".nvmrc(${NVMRC_VERSION})와 CI(${CI_NODE}) 일치" "PASS" "high"
  else
    check "8-6" ".nvmrc(${NVMRC_VERSION})와 CI(${CI_NODE}) 불일치" "FAIL" "high"
  fi
else
  check "8-6" "버전 비교 불가 (nvmrc:${NVMRC_VERSION:-없음}, CI:${CI_NODE:-없음})" "PASS" "low"
fi

# --- 결과 요약 ---
echo ""
echo "============================================"
echo "[adversarial-verify] 결과 요약"
echo "============================================"

CONFIDENT=$((TOTAL - LOW_CONFIDENCE))
BIAS_DELTA=$((PASS - CONFIDENT))

echo "  Score    : ${PASS}/${TOTAL}"
echo "  Confidence: ${CONFIDENT}/${TOTAL}"
echo "  Bias Delta: ${BIAS_DELTA} (낮을수록 좋음)"
echo ""

if [ "$BIAS_DELTA" -ge 5 ]; then
  echo "  [WARN] Bias Delta >= 5: 긍정 편향 의심. low-confidence 항목을 수동 검증하세요."
elif [ "$BIAS_DELTA" -ge 3 ]; then
  echo "  [INFO] Bias Delta >= 3: 일부 항목의 신뢰도가 낮습니다."
else
  echo "  [OK] Bias Delta < 3: 신뢰도 양호."
fi

echo ""
echo "[adversarial-verify] done"
exit "$EXIT_CODE"
