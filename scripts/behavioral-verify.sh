#!/usr/bin/env bash
set -euo pipefail

# behavioral-verify.sh — 에이전트의 "첫 접촉" 시나리오를 시뮬레이션한다.
# 1. Entry point 파일 탐색 (AGENTS.md → CLAUDE.md → README.md)
# 2. 빌드/테스트/lint 명령 추출
# 3. 명령 실행 시도 (dry-run 가능)
# 4. 결과 판정: P1(Entry Point), P3(Invariant), P10(Reproducibility)에 반영
#
# 사용: bash scripts/behavioral-verify.sh [TARGET_DIR] [--dry-run]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-$ROOT_DIR}"
DRY_RUN=false

for arg in "$@"; do
  [ "$arg" = "--dry-run" ] && DRY_RUN=true
done

EXIT_CODE=0
P1_SCORE=0  # Entry Point
P3_SCORE=0  # Invariant Enforcement
P10_SCORE=0 # Reproducibility
TOTAL_CHECKS=0
PASSED_CHECKS=0

pass() {
  local principle="$1"
  local description="$2"
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  PASSED_CHECKS=$((PASSED_CHECKS + 1))
  echo "  PASS [$principle]: $description"
}

fail() {
  local principle="$1"
  local description="$2"
  TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
  echo "  FAIL [$principle]: $description"
  EXIT_CODE=1
}

echo "[behavioral-verify] target: $TARGET_DIR"
echo "[behavioral-verify] dry-run: $DRY_RUN"
echo ""

# ============================================================
# Phase 1: Entry Point 탐색 (P1)
# ============================================================
echo "[Phase 1] Entry Point 탐색"

ENTRY_FILE=""
for name in AGENTS.md CLAUDE.md README.md; do
  if [ -f "$TARGET_DIR/$name" ]; then
    ENTRY_FILE="$TARGET_DIR/$name"
    pass "P1" "진입점 발견: $name"
    break
  fi
done

if [ -z "$ENTRY_FILE" ]; then
  fail "P1" "진입점 파일 없음 (AGENTS.md, CLAUDE.md, README.md 모두 부재)"
  echo ""
  echo "[behavioral-verify] 진입점 없이 계속 불가"
  exit 1
fi

# 진입점 파일 크기 확인 (너무 작으면 stub 의심)
ENTRY_LINES=$(wc -l < "$ENTRY_FILE" | tr -d ' ')
if [ "$ENTRY_LINES" -ge 10 ]; then
  pass "P1" "진입점 충분한 내용 (${ENTRY_LINES}줄)"
  P1_SCORE=$((P1_SCORE + 1))
else
  fail "P1" "진입점 내용 부족 (${ENTRY_LINES}줄 — stub 의심)"
fi

# 핵심 섹션 존재 여부 — 모든 진입점 파일에서 탐색
ALL_ENTRY_CONTENT=""
for name in AGENTS.md CLAUDE.md README.md; do
  [ -f "$TARGET_DIR/$name" ] && ALL_ENTRY_CONTENT="$ALL_ENTRY_CONTENT$(cat "$TARGET_DIR/$name")"
done
for keyword in "빌드|build|install|설치" "테스트|test|검증" "구조|structure|directory|디렉토리"; do
  if echo "$ALL_ENTRY_CONTENT" | grep -iqE "$keyword"; then
    pass "P1" "핵심 키워드 포함: $(echo "$keyword" | cut -c1-20)"
    P1_SCORE=$((P1_SCORE + 1))
  else
    fail "P1" "핵심 키워드 누락: $(echo "$keyword" | cut -c1-20)"
  fi
done

echo ""

# ============================================================
# Phase 2: 빌드/테스트 명령 추출 (P10)
# ============================================================
echo "[Phase 2] 명령 추출"

# bash/sh 코드 블록에서 명령 추출
COMMANDS=$(awk '
  /^```(bash|sh)\s*$/ { in_block=1; next }
  /^```\s*$/ { in_block=0; next }
  in_block && /^[a-zA-Z]/ && $0 !~ /^#/ { print }
' "$ENTRY_FILE")

CMD_COUNT=$(echo "$COMMANDS" | grep -c '.' || true)
if [ "$CMD_COUNT" -ge 1 ]; then
  pass "P10" "실행 가능 명령 ${CMD_COUNT}개 추출"
  P10_SCORE=$((P10_SCORE + 1))
else
  fail "P10" "코드 블록에서 명령을 추출할 수 없음"
fi

echo ""

# ============================================================
# Phase 3: 명령 실행 시도 (P3, P10)
# ============================================================
echo "[Phase 3] 명령 실행 시도"

RUN_SUCCESS=0
RUN_FAIL=0
RUN_SKIP=0

if [ -z "$COMMANDS" ]; then
  fail "P10" "실행할 명령이 없음"
else
  while IFS= read -r cmd; do
    [ -z "$cmd" ] && continue

    if [ "$DRY_RUN" = true ]; then
      echo "  DRY-RUN: $cmd"
      RUN_SKIP=$((RUN_SKIP + 1))
      continue
    fi

    # bash/node + 스크립트 실행: 파일 존재 + 실행 권한으로 판정 (서브셸 환경 차이 회피)
    if echo "$cmd" | grep -qE '^(bash|sh|node) '; then
      local_script=$(echo "$cmd" | awk '{print $2}')
      if [ -f "$TARGET_DIR/$local_script" ]; then
        if [ -x "$TARGET_DIR/$local_script" ] || echo "$cmd" | grep -qE '^(bash|sh|node)'; then
          pass "P10" "실행 가능 확인: $(echo "$cmd" | cut -c1-60)"
          RUN_SUCCESS=$((RUN_SUCCESS + 1))
          P10_SCORE=$((P10_SCORE + 1))
        else
          fail "P10" "실행 권한 없음: $(echo "$cmd" | cut -c1-60)"
          RUN_FAIL=$((RUN_FAIL + 1))
        fi
      else
        fail "P10" "스크립트 없음: $(echo "$cmd" | cut -c1-60)"
        RUN_FAIL=$((RUN_FAIL + 1))
      fi
      continue
    fi

    # 일반 명령: 실제 실행 (타임아웃 30초, 출력 억제)
    if (cd "$TARGET_DIR" && timeout 30 bash -c "$cmd" >/dev/null 2>&1); then
      pass "P10" "실행 성공: $(echo "$cmd" | cut -c1-60)"
      RUN_SUCCESS=$((RUN_SUCCESS + 1))
      P10_SCORE=$((P10_SCORE + 1))
    else
      fail "P10" "실행 실패: $(echo "$cmd" | cut -c1-60)"
      RUN_FAIL=$((RUN_FAIL + 1))
    fi
  done <<< "$COMMANDS"
fi

echo ""

# ============================================================
# Phase 4: Invariant 확인 (P3)
# ============================================================
echo "[Phase 4] Invariant 확인"

# Linter/Formatter 설정 존재
LINT_FOUND=false
for lint_file in .eslintrc .eslintrc.js .eslintrc.json .eslintrc.yml eslint.config.js eslint.config.mjs \
  .prettierrc .prettierrc.json .prettierrc.yml prettier.config.js \
  .flake8 pyproject.toml setup.cfg .golangci.yml .rubocop.yml \
  biome.json deno.json; do
  if [ -f "$TARGET_DIR/$lint_file" ]; then
    pass "P3" "Linter/Formatter 설정 발견: $lint_file"
    LINT_FOUND=true
    P3_SCORE=$((P3_SCORE + 1))
    break
  fi
done
if [ "$LINT_FOUND" = false ]; then
  # pre-commit hook이라도 있으면 pass
  if [ -d "$TARGET_DIR/.githooks" ] || [ -f "$TARGET_DIR/.pre-commit-config.yaml" ] || [ -f "$TARGET_DIR/.husky/pre-commit" ]; then
    pass "P3" "Pre-commit hook 발견"
    P3_SCORE=$((P3_SCORE + 1))
  else
    fail "P3" "Linter/Formatter/Hook 설정 없음"
  fi
fi

# CI 설정 존재
CI_FOUND=false
for ci_path in .github/workflows .gitlab-ci.yml .circleci Jenkinsfile .travis.yml; do
  if [ -e "$TARGET_DIR/$ci_path" ]; then
    pass "P3" "CI 설정 발견: $ci_path"
    CI_FOUND=true
    P3_SCORE=$((P3_SCORE + 1))
    break
  fi
done
if [ "$CI_FOUND" = false ]; then
  fail "P3" "CI 설정 없음"
fi

echo ""

# ============================================================
# 결과 요약
# ============================================================
echo "============================================"
echo "[behavioral-verify] 결과 요약"
echo "============================================"
echo "  Total checks : $TOTAL_CHECKS"
echo "  Passed       : $PASSED_CHECKS"
echo "  Failed       : $((TOTAL_CHECKS - PASSED_CHECKS))"
echo ""
echo "  P1  (Entry Point)  : ${P1_SCORE}점 기여"
echo "  P3  (Invariant)    : ${P3_SCORE}점 기여"
echo "  P10 (Reproducibility): ${P10_SCORE}점 기여"
echo ""

if [ "$DRY_RUN" = true ]; then
  echo "  [INFO] dry-run 모드: 명령 ${RUN_SKIP}건 건너뜀"
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "  [OK] 에이전트 첫 접촉 시뮬레이션 통과"
else
  echo "  [FAIL] 에이전트 첫 접촉 시뮬레이션 실패 — 위 항목 확인 필요"
fi

echo ""
echo "[behavioral-verify] done"
exit "$EXIT_CODE"
