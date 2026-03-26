#!/usr/bin/env bash
set -euo pipefail

# semantic-verify.sh — 에이전트 지시 문서(AGENTS.md, CLAUDE.md, README.md)에서
# 코드 블록 내 명령어를 추출하고 실제 실행 가능 여부를 검증한다.
# 결과: 명령어별 runnable / missing / ambiguous 판정.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXIT_CODE=0

RUNNABLE=0
MISSING=0
AMBIGUOUS=0
SKIPPED=0
TOTAL=0

# 실행 대상 디렉토리 (기본: 자기 자신 레포)
TARGET_DIR="${1:-$ROOT_DIR}"

echo "[semantic-verify] target: $TARGET_DIR"

# --- 1. 에이전트 지시 문서 탐색 ---
ENTRY_FILES=()
for name in AGENTS.md CLAUDE.md README.md; do
  if [ -f "$TARGET_DIR/$name" ]; then
    ENTRY_FILES+=("$TARGET_DIR/$name")
  fi
done

if [ "${#ENTRY_FILES[@]}" -eq 0 ]; then
  echo "  FAIL: 에이전트 지시 문서 없음 (AGENTS.md, CLAUDE.md, README.md)"
  exit 1
fi

echo "[semantic-verify] 탐지된 문서: ${ENTRY_FILES[*]}"

# --- 2. 코드 블록에서 명령어 추출 ---
extract_commands() {
  local file="$1"
  # bash/sh 코드 블록 내의 명령어를 추출 (text 블록은 산문이 많으므로 제외)
  awk '
    /^```(bash|sh)\s*$/ { in_block=1; next }
    /^```\s*$/ { in_block=0; next }
    in_block && /^[a-zA-Z$]/ {
      # 주석, 빈 줄, 변수 할당 전용 줄 제외
      if ($0 !~ /^#/ && $0 !~ /^[A-Z_]+=.*[^;]$/) {
        print
      }
    }
  ' "$file"
}

# --- 3. 명령어 판정 ---
check_command() {
  local cmd_line="$1"
  local base_cmd

  # 환경변수 접두사 제거 (VAR=val cmd ...)
  local stripped
  stripped=$(echo "$cmd_line" | sed -E 's/^([A-Z_]+=[^ ]+ )+//')

  # 첫 토큰 추출
  base_cmd=$(echo "$stripped" | awk '{print $1}')

  # 특수 케이스 무시
  case "$base_cmd" in
    '$'*|'>'|'|'|'#'|'cd'|'export'|'source'|'.'|'echo'|'cat')
      return 2  # skip
      ;;
  esac

  TOTAL=$((TOTAL + 1))

  # bash/node + 스크립트 경로인 경우 파일 존재 여부 확인
  if echo "$stripped" | grep -qE '^(bash|sh|node) '; then
    local script_path
    script_path=$(echo "$stripped" | awk '{print $2}')
    if [ -f "$TARGET_DIR/$script_path" ]; then
      echo "  RUNNABLE: $cmd_line"
      RUNNABLE=$((RUNNABLE + 1))
      return 0
    else
      echo "  MISSING:  $cmd_line (파일 없음: $script_path)"
      MISSING=$((MISSING + 1))
      return 1
    fi
  fi

  # npm/npx/yarn/pnpm 명령 — package.json scripts 확인
  if echo "$base_cmd" | grep -qE '^(npm|npx|yarn|pnpm)$'; then
    local subcmd
    subcmd=$(echo "$stripped" | awk '{print $2}')
    if [ "$subcmd" = "run" ]; then
      subcmd=$(echo "$stripped" | awk '{print $3}')
    fi
    if [ -f "$TARGET_DIR/package.json" ] && [ -n "$subcmd" ]; then
      if grep -q "\"$subcmd\"" "$TARGET_DIR/package.json" 2>/dev/null; then
        echo "  RUNNABLE: $cmd_line"
        RUNNABLE=$((RUNNABLE + 1))
        return 0
      else
        echo "  MISSING:  $cmd_line (package.json에 '$subcmd' 스크립트 없음)"
        MISSING=$((MISSING + 1))
        return 1
      fi
    fi
    # package.json 없거나 subcmd 판별 불가
    echo "  AMBIGUOUS: $cmd_line"
    AMBIGUOUS=$((AMBIGUOUS + 1))
    return 0
  fi

  # make 명령 — Makefile target 확인
  if [ "$base_cmd" = "make" ]; then
    local target
    target=$(echo "$stripped" | awk '{print $2}')
    if [ -f "$TARGET_DIR/Makefile" ] && [ -n "$target" ]; then
      if grep -qE "^${target}:" "$TARGET_DIR/Makefile" 2>/dev/null; then
        echo "  RUNNABLE: $cmd_line"
        RUNNABLE=$((RUNNABLE + 1))
        return 0
      else
        echo "  MISSING:  $cmd_line (Makefile에 '$target' 타깃 없음)"
        MISSING=$((MISSING + 1))
        return 1
      fi
    fi
    echo "  AMBIGUOUS: $cmd_line"
    AMBIGUOUS=$((AMBIGUOUS + 1))
    return 0
  fi

  # git 명령 — 항상 runnable
  if [ "$base_cmd" = "git" ]; then
    echo "  RUNNABLE: $cmd_line"
    RUNNABLE=$((RUNNABLE + 1))
    return 0
  fi

  # 일반 명령 — PATH에서 찾기
  if command -v "$base_cmd" >/dev/null 2>&1; then
    echo "  RUNNABLE: $cmd_line"
    RUNNABLE=$((RUNNABLE + 1))
    return 0
  else
    echo "  AMBIGUOUS: $cmd_line ($base_cmd 미확인)"
    AMBIGUOUS=$((AMBIGUOUS + 1))
    return 0
  fi
}

# --- 4. 실행 ---
echo ""
for file in "${ENTRY_FILES[@]}"; do
  echo "[semantic-verify] $(basename "$file")"
  while IFS= read -r cmd; do
    [ -z "$cmd" ] && continue
    check_command "$cmd" || true
  done < <(extract_commands "$file")
  echo ""
done

# --- 5. 결과 요약 ---
echo "============================================"
echo "[semantic-verify] 결과 요약"
echo "============================================"
echo "  Total    : $TOTAL"
echo "  Runnable : $RUNNABLE"
echo "  Missing  : $MISSING"
echo "  Ambiguous: $AMBIGUOUS"
echo ""

if [ "$MISSING" -gt 0 ]; then
  echo "  [FAIL] 실행 불가 명령 ${MISSING}건 탐지"
  EXIT_CODE=1
elif [ "$AMBIGUOUS" -gt 2 ]; then
  echo "  [WARN] 판정 불확실 명령 ${AMBIGUOUS}건"
else
  echo "  [OK] 모든 명령어 실행 가능 확인"
fi

echo ""
echo "[semantic-verify] done"
exit "$EXIT_CODE"
