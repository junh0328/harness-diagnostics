## 요약

- 무엇이 바뀌었는가?
- 왜 필요한 변경이었는가?

## 하니스 Self

- 최신 `$harness-diagnostics self` 점수:
- `logs/self-audit-log.md`에 남긴 변경 메모:

## 검증

- [ ] `bash scripts/check-node-version.sh`
- [ ] `bash scripts/self-audit.sh`
- [ ] `bash scripts/maintenance-scan.sh`
- [ ] `bash scripts/doc-lint.sh`
- [ ] `node scripts/calculate-score.js references/score-template.json`
- [ ] 릴리즈 동작이 바뀌었다면 `bash scripts/release-sync.sh`

## 위험 요소

- 남아 있는 gap 또는 후속 작업:
