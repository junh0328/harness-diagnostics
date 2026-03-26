# 변경 이력

이 문서는 `harness-diagnostics`의 주요 변경 사항을 기록합니다.

## [2.1.0] - 2026-03-26

### 추가됨

- `references/recommended-flow.md` — SKILL.md에서 분리한 권장 사용 흐름 상세 (P2 Map 순도 향상)
- `references/adr-001-scoring-weights.md` — 차원 가중치 30/30/20/20 결정 근거 ADR
- `references/adr-002-checklist-item-counts.md` — 체크리스트 항목 수(51/84) 결정 근거 ADR
- `references/layer-dependency-rules.md` — 레이어 간 의존성 방향 규칙과 오케스트레이터 패턴 정의
- `scripts/self-audit.sh`에 `--log` 옵션 추가 — 실행 결과를 `logs/self-audit-YYYYMMDD-HHMMSS.log`로 보존

### 변경됨

- `SKILL.md`의 "권장 사용 흐름" 산문(12줄)을 `references/recommended-flow.md`로 분리하여 1줄 포인터로 대체 (118줄 → 107줄)
- `SKILL.md` 참조 테이블에 recommended-flow, layer-dependency-rules, adr-001, adr-002 추가
- `scripts/adversarial-verify.sh`에 함수/섹션별 "왜" 주석 6건 추가 (P12 Self-Documentation 향상)
- adversarial-verify Bias Delta: 1 → 0 (low-confidence 항목 해소)
- `SKILL.md` version을 `2.1.0`으로 업데이트

## [2.0.0] - 2026-03-26

### 추가됨

- `references/fix-catalog.md` — 12원칙 × 점수 구간별 구체적 개선 액션 카탈로그 (Auto/Semi/Manual 분류)
- `references/contract-template.md` — Remediate 모드의 Sprint Contract 형식, 협상 프로토콜, Loop State JSON 스키마
- `references/remediate-workflow.md` — Audit→Fix→Re-Audit closed feedback loop 워크플로우 (5-Phase)

### 변경됨

- `SKILL.md`에 **Remediate** 모드 추가 (트리거: "개선", "자동 수정", "loop")
- `SKILL.md` 참조 테이블에 fix-catalog, contract-template, remediate-workflow 추가
- Read-only 원칙의 명시적 예외 규칙 추가 (Remediate 모드는 사용자 동의 후 파일 수정)
- `SKILL.md` version을 `2.0.0`으로 업데이트

## [1.9.5] - 2026-03-26

### 추가됨

- `scripts/semantic-verify.sh` — 에이전트 지시 문서의 코드 블록에서 명령어를 추출하고 실행 가능 여부를 검증하는 스크립트 추가
- `scripts/behavioral-verify.sh` — 에이전트 첫 접촉 시나리오를 시뮬레이션하여 Entry Point, Invariant, Reproducibility를 행동으로 검증하는 스크립트 추가

### 변경됨

- `references/audit-workflow.md`에 Phase 2.5(행동 검증) 추가 — semantic-verify + behavioral-verify 결과를 P1, P3, P10 점수에 반영
- `references/maturity-framework.md` L4→L5 전환 조건에 semantic-verify/behavioral-verify PASS 필수화
- `scripts/self-audit.sh`에 semantic-verify, behavioral-verify 단계 통합
- `SKILL.md` version을 `1.9.5`로 업데이트

## [1.9.0] - 2026-03-26

### 추가됨

- `scripts/adversarial-verify.sh` — 반증(disprove) 관점에서 체크리스트를 재검증하고 Bias Delta 지표를 산출하는 스크립트 추가
- `references/depth-profiles.md` — Quick/Standard/Deep 3단계 진단 깊이 프로필 정의
- `references/tools-index.md` — SKILL.md에서 분리한 전체 자동화 도구 목록

### 변경됨

- `SKILL.md`의 도구 목록을 `references/tools-index.md`로 분리하여 113줄로 경량화, 모드 테이블에 깊이(Depth) 컬럼 추가
- `references/skill-checklist.md` Meta에 Confidence/Bias Delta 지표와 Adversarial Verification 섹션 추가
- `references/report-template.md` Audit 리포트에 신뢰도 분석 섹션(4번) 추가, 기존 섹션 번호 조정
- `scripts/self-audit.sh`에 adversarial-verify 단계 통합
- `scripts/self-audit-runtime.sh` audit example 검증에서 번호 접두사 제거하여 섹션 번호 변경에 강건하게 수정
- `scripts/maintenance-scan.sh`가 `references/tools-index.md`를 스크립트 참조 소스로 함께 사용하도록 확장
- `SKILL.md` version을 `1.9.0`으로 업데이트

## [1.8.0] - 2026-03-23

### 추가됨

- `.nvmrc`, `.githooks/pre-commit`, `scripts/check-node-version.sh`, `scripts/install-hooks.sh`를 추가해 Node 20 런타임 계약과 local pre-commit guardrail을 도입

### 변경됨

- `scripts/self-audit.sh`가 구조/런타임 검사 전에 Node 버전 계약을 먼저 검증하도록 확장
- `.github/workflows/*.yml`이 `.nvmrc`를 기준으로 Node 버전을 맞추도록 변경
- `scripts/doc-lint.sh`, `scripts/maintenance-scan.sh`, `scripts/self-audit-structure.sh`, `scripts/sync-to-codex.sh`가 runtime pin과 hook 자산을 필수 구성으로 검사하도록 확장
- `AGENTS.md`, `README.md`, `references/skill-checklist.md`를 런타임 pin과 local hook bootstrap 흐름에 맞게 갱신
- `SKILL.md` version을 `1.8.0`으로 업데이트

## [1.7.3] - 2026-03-23

### 추가됨

- `scripts/doc-lint.sh`에 README/AGENTS 로컬 링크 타깃 검증과 current version changelog 검증 추가
- `scripts/self-audit-runtime.sh`에 skill checklist 카운트/메타 일관성 검증 추가

### 변경됨

- `AGENTS.md`와 `README.md`의 레포 내부 링크를 상대 경로로 교체해 standalone/.codex 복사본 모두에서 동일하게 동작하도록 수정
- `README.md`에 Audit 결과물 축약 미리보기와 전체 예시 링크를 추가해 출력 형식을 더 빠르게 이해할 수 있도록 개선
- `scripts/update-self-meta.sh`가 checklist 메타 요약의 버전, 카테고리 점수, 총점, 정기 점검 항목 수를 함께 동기화하도록 확장
- `references/skill-checklist.md`의 섹션 항목 수 표기와 self-maintenance 기준을 실제 49항목 구조에 맞게 정리
- `SKILL.md` version을 `1.7.3`로 업데이트

## [1.7.2] - 2026-03-23

### 추가됨

- `examples/sample-report.md`를 실제 코드베이스 기반 Audit 예시로 교체하고 근거/위험 요소/수행한 검증 섹션을 포함

### 변경됨

- `scripts/self-audit-runtime.sh`가 Audit 예시의 핵심 섹션도 함께 검증하도록 확장
- `SKILL.md` version을 `1.7.2`로 업데이트

## [1.7.1] - 2026-03-06

### 추가됨

- `self-audit` 스크립트가 `rg` 미설치 환경에서도 `grep` fallback으로 동작하도록 보강

### 변경됨

- `scripts/self-audit-structure.sh`와 `scripts/self-audit-runtime.sh`가 GitHub Actions 기본 환경에서도 동일하게 통과하도록 수정
- `SKILL.md` version을 `1.7.1`로 업데이트

## [1.7.0] - 2026-03-06

### 추가됨

- 레포 운영용 `AGENTS.md` 추가
- `references/verification-workflow.md` 추가
- `scripts/doc-lint.sh`, `scripts/self-audit-structure.sh`, `scripts/self-audit-runtime.sh`, `scripts/maintenance-scan.sh` 추가
- `.github`의 이슈 템플릿, PR 템플릿, CI 워크플로우 추가

### 변경됨

- `scripts/self-audit.sh`를 구조/런타임 orchestrator로 재구성
- `scripts/sync-to-codex.sh`가 `AGENTS.md`, `README.md`, `CHANGELOG.md`까지 동기화하도록 확장
- `references/report-template.md`, `references/maintenance-workflow.md`, `references/skill-checklist.md`를 verification/guardrail 중심으로 강화
- `README.md`와 `SKILL.md`를 OpenAI harness 운영 의도에 맞게 업데이트
- `SKILL.md` version을 `1.7.0`으로 업데이트

## [1.6.0] - 2026-03-06

### 추가됨

- `scripts/log-skill-self.sh` 추가
- `logs/self-audit-log.md`에 `Run Type`, `Score`, `Grade` 컬럼 추가

### 변경됨

- `scripts/append-self-audit-log.sh`가 `script`와 `skill-self` 실행을 모두 기록할 수 있도록 확장
- `README.md`에 직접 `$harness-diagnostics self` 실행 결과를 로그에 남기는 절차 추가
- `SKILL.md` version을 `1.6.0`으로 업데이트

## [1.5.0] - 2026-03-06

### 추가됨

- `scripts/append-self-audit-log.sh` 추가
- `scripts/sync-to-codex.sh` 추가
- `scripts/release-sync.sh` 추가

### 변경됨

- standalone 레포를 source of truth로 고정하고 `.codex` 복사본을 스크립트로 동기화하는 흐름 추가
- `README.md`에 릴리즈/동기화 운영 절차와 `.codex` 동기화 경로 문서화
- `SKILL.md` version을 `1.5.0`으로 업데이트

## [1.4.1] - 2026-03-06

### 추가됨

- 버전 관리 원칙을 설명하는 `README.md` 섹션 추가
- 레포 전용 `CHANGELOG.md` 추가

### 변경됨

- canonical version을 `SKILL.md` 기준으로 관리하도록 레포 문서화
- `SKILL.md` version을 `1.4.1`로 업데이트

## [1.4.0] - 2026-03-06

### 추가됨

- `Setup` 요구사항 오버레이를 반영한 문서 흐름
- `examples/sample-setup-report.md` 추가
- `scripts/update-self-meta.sh` 추가
- `scripts/calculate-score.js` 추가
- `scripts/self-audit.sh`에 setup example coverage / score calculator 검증 추가

### 변경됨

- `README.md`를 사람용 진입점으로 재작성
- `references/report-template.md`에 `요구사항 오버레이`와 `목표 AGENTS.md 초안 구조` 추가
- `references/setup-workflow.md`에 초기 스캐폴드 -> Setup -> 구현 흐름 명시
- `references/skill-checklist.md`와 `logs/self-audit-log.md`를 최신 self 평가 기준에 맞게 갱신
