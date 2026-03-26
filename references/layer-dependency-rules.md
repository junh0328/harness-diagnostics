# 레이어 의존성 규칙

> harness-diagnostics skill 내부의 디렉토리 간 의존성 방향과 규칙.

---

## 레이어 정의

```
SKILL.md (진입점)
  ↓ 참조
references/ (기준 정의 레이어)
  ↓ 참조
examples/ (구현 예시 레이어)
scripts/ (실행 도구 레이어)
logs/ (이력 레이어)
```

## 의존성 방향 규칙

| 출발 | → 도착 | 허용 | 설명 |
|------|--------|------|------|
| SKILL.md | → references/ | O | 진입점이 기준 문서를 참조 |
| SKILL.md | → examples/ | O | 진입점이 예시를 참조 |
| SKILL.md | → scripts/ | O | 진입점이 실행 명령을 안내 |
| references/ | → references/ | △ | 동일 레이어 내 교차 참조 (최소화, 순환 금지) |
| references/ | → SKILL.md | X | 기준 문서가 진입점에 역참조 금지 |
| references/ | → examples/ | X | 기준이 예시에 의존하면 안 됨 |
| examples/ | → references/ | O | 예시가 기준을 참조하여 일관성 유지 |
| scripts/ | → references/ | O | 스크립트가 기준 파일을 검증 대상으로 읽기 |
| scripts/ | → scripts/ | △ | 오케스트레이터(self-audit.sh)만 다른 스크립트 호출 |
| scripts/ | → logs/ | O | 스크립트가 로그에 기록 |
| logs/ | → * | X | 로그는 읽기 전용 출력. 다른 레이어에 영향 없음 |

**범례**: O = 허용, △ = 조건부 허용, X = 금지

## 오케스트레이터 패턴

`scripts/self-audit.sh`와 `scripts/release-sync.sh`는 다른 스크립트를 호출하는 오케스트레이터 역할을 한다. 이 패턴의 규칙:

1. 오케스트레이터는 최대 2개만 유지 (현재: self-audit.sh, release-sync.sh)
2. 개별 스크립트는 다른 개별 스크립트를 직접 호출하지 않음
3. 오케스트레이터 간 상호 호출 금지

## 순환 참조 관리

- references/ 내 교차 참조는 허용하되, A→B→A 순환은 금지
- adversarial-verify.sh가 순환 참조를 자동 탐지 (현재 허용 임계값: 2건 이하)
