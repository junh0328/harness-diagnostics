# 자동화 도구 목록

> harness-diagnostics skill의 검증, 동기화, 로깅에 사용하는 스크립트와 템플릿.

---

## 검증 스크립트

| 스크립트 | 역할 |
|----------|------|
| `scripts/self-audit.sh` | Self 진단 오케스트레이터 (구조 + 런타임) |
| `scripts/check-node-version.sh` | `.nvmrc` 기준 Node 런타임 계약 검증 |
| `scripts/self-audit-structure.sh` | 파일 존재, 참조 경로, SKILL.md 라인 수 검증 |
| `scripts/self-audit-runtime.sh` | doc-lint, 예시 커버리지, 체크리스트 일관성 검증 |
| `scripts/doc-lint.sh` | 문서/포인터/링크 유효성 검증 |
| `scripts/maintenance-scan.sh` | 고아 파일 탐지, sync manifest 검증 |
| `scripts/adversarial-verify.sh` | 반증 관점 체크리스트 재검증 (Bias Delta 산출) |
| `scripts/semantic-verify.sh` | 문서 내 명령어 실행 가능성 검증 |
| `scripts/behavioral-verify.sh` | 에이전트 첫 접촉 시뮬레이션 (P1, P3, P10) |

## 점수 계산

| 파일 | 역할 |
|------|------|
| `scripts/calculate-score.js` | JSON 입력 기반 차원/종합 점수 계산 |
| `references/score-template.md` | 점수 계산 마크다운 템플릿 |
| `references/score-template.json` | 자동 계산 입력 JSON 스키마 |

## 동기화/릴리즈

| 스크립트 | 역할 |
|----------|------|
| `scripts/release-sync.sh` | 릴리즈 동기화 오케스트레이터 |
| `scripts/sync-to-codex.sh` | `.codex/skills/` 디렉토리 동기화 |
| `scripts/install-hooks.sh` | 로컬 Git pre-commit hook 설치 |

## 로깅/메타

| 스크립트 | 역할 |
|----------|------|
| `scripts/update-self-meta.sh` | skill-checklist.md 메타 섹션 동기화 |
| `scripts/append-self-audit-log.sh` | `logs/self-audit-log.md` 기록 추가 |
| `scripts/log-skill-self.sh` | 직접 Self 실행 요약 기록 |

## 로그

| 파일 | 역할 |
|------|------|
| `logs/self-audit-log.md` | 분기 점검 및 Self 실행 이력 |
