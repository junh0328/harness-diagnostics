# 검증 워크플로우

> `harness-diagnostics` 변경 후 무엇을 어떻게 검증해야 하는지 고정하는 운영 문서.

---

## 목적

이 workflow는 "리포트를 잘 썼는가"가 아니라, "에이전트가 변경 결과를 직접 검증했는가"를 확인하기 위한 기준이다.

검증은 아래 세 층으로 수행한다.

1. **구조**: 파일 구조, 포인터, 템플릿, 경로 무결성
2. **런타임**: 스크립트 실행 가능성, 점수 계산, 동기화 루프
3. **Self**: `$harness-diagnostics self` 결과를 로그로 남겨 추이를 기록

---

## 필수 명령

레포 루트에서 아래 순서로 실행한다.

```bash
bash scripts/self-audit.sh
bash scripts/maintenance-scan.sh
node scripts/calculate-score.js references/score-template.json
```

릴리즈/동기화 동작을 수정했거나 `.codex` 반영까지 검증해야 하면 추가로 실행한다.

```bash
bash scripts/release-sync.sh
```

---

## 수행한 검증 섹션 규칙

Audit, Maintenance, Self 결과를 남길 때는 아래 항목을 항상 포함한다.

```markdown
## 수행한 검증

- `bash scripts/self-audit.sh`
- `bash scripts/maintenance-scan.sh`
- `node scripts/calculate-score.js references/score-template.json`
- 추가 실행이 있으면 별도 기록
```

---

## 실패 시 처리

### 구조 실패

- 문서 포인터, 템플릿, 경로 누락을 먼저 수정한다.
- 새 파일을 추가했다면 `SKILL.md`, `README.md`, `scripts/sync-to-codex.sh` 반영 여부를 같이 확인한다.

### 런타임 실패

- 실패한 스크립트를 단독 재실행해 원인을 좁힌다.
- `release-sync.sh`가 실패하면 source/target 경로와 복사 대상 manifest를 확인한다.

### Self 실패

- 점수 하락 자체보다 하락 원인과 변경 내용을 `logs/self-audit-log.md`에 요약한다.
- 점수만 남기지 말고, 어떤 guardrail 또는 verification loop가 바뀌었는지 함께 적는다.

---

## 완료 기준

- 필수 명령이 모두 성공한다.
- `logs/self-audit-log.md`에 이번 변경의 self 요약이 추가된다.
- PR에는 검증 명령과 self 점수 요약이 포함된다.
