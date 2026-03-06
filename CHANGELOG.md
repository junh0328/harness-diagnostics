# Changelog

이 문서는 `harness-diagnostics`의 주요 변경 사항을 기록합니다.

## [1.4.1] - 2026-03-06

### Added

- 버전 관리 원칙을 설명하는 `README.md` 섹션 추가
- 레포 전용 `CHANGELOG.md` 추가

### Changed

- canonical version을 `SKILL.md` 기준으로 관리하도록 레포 문서화
- `SKILL.md` version을 `1.4.1`로 업데이트

## [1.4.0] - 2026-03-06

### Added

- `Setup` 요구사항 오버레이를 반영한 문서 흐름
- `examples/sample-setup-report.md` 추가
- `scripts/update-self-meta.sh` 추가
- `scripts/calculate-score.js` 추가
- `scripts/self-audit.sh`에 setup example coverage / score calculator 검증 추가

### Changed

- `README.md`를 사람용 진입점으로 재작성
- `references/report-template.md`에 `요구사항 오버레이`와 `목표 AGENTS.md 초안 구조` 추가
- `references/setup-workflow.md`에 초기 스캐폴드 -> Setup -> 구현 흐름 명시
- `references/skill-checklist.md`와 `logs/self-audit-log.md`를 최신 self 평가 기준에 맞게 갱신
