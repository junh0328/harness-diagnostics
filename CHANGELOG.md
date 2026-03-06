# 변경 이력

이 문서는 `harness-diagnostics`의 주요 변경 사항을 기록합니다.

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
