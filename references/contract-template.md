# 개선 계약 템플릿 (Sprint Contract)

> Remediate 모드에서 사용자와 에이전트가 개선 목표를 합의하기 위한 계약 형식.
> Anthropic 블로그의 "Sprint Contract" 패턴에서 착안.

---

## 계약 형식

```markdown
## 개선 계약

- **대상**: [프로젝트명 / Skill명]
- **날짜**: YYYY-MM-DD
- **시작 점수**: [현재 종합 점수] / [현재 등급]
- **목표 점수**: [합의된 목표 점수] / [목표 등급]
- **집중 원칙**: [P1, P3, P10 등 — 우선 개선 대상]
- **최대 반복**: [3회] (기본 3회, 최대 5회)

### 자동 적용 범위

에이전트가 사용자 동의 하에 직접 생성/수정할 수 있는 범위:

- [ ] 파일 생성 (AGENTS.md, .editorconfig 등)
- [ ] 설정 추가 (lint, formatter, CI 등)
- [ ] 문서 보완 (README, 용어집, 구조 설명 등)
- [ ] 스크립트 추가 (setup, hook 등)

### 제외 사항

사용자가 직접 판단/수행해야 하는 항목:

- [ ] 코드 리팩터링
- [ ] 아키텍처 변경
- [ ] 도메인 로직 수정
- [ ] 외부 도구 도입 결정

### 성공 기준

- [ ] 목표 점수 달성
- [ ] 집중 원칙 모두 [N]점 이상
- [ ] semantic-verify Missing 0건
- [ ] behavioral-verify 전체 PASS
```

---

## 계약 협상 프로토콜

### 1단계: 현황 공유

에이전트가 Audit 결과를 요약하고 현재 점수/등급을 공유한다.

```
현재 상태: L3 / 52점
가장 약한 원칙: P1 (3점), P10 (4점)
가장 강한 원칙: P3 (8점), P6 (7점)
```

### 2단계: 목표 제안

에이전트가 fix-catalog을 기반으로 달성 가능한 목표를 제안한다.

```
제안: L4 / 65점 (현재 대비 +13점)
집중 원칙: P1 (3→7), P10 (4→7)
예상 Auto 액션: 4건
예상 Semi 액션: 2건
```

### 3단계: 사용자 조정

사용자가 목표를 조정하거나 제외 사항을 추가한다.

- 목표 점수 상향/하향
- 자동 적용 범위 축소/확대
- 특정 원칙 제외
- 최대 반복 횟수 변경

### 4단계: 합의

양측이 최종 계약에 동의하면 Remediate 실행을 시작한다.

---

## Loop State 형식

대상 레포에 `.harness/loop-state.json`으로 반복 상태를 추적한다.

```json
{
  "contract": {
    "target": "project-name",
    "date": "2026-03-26",
    "startScore": 52,
    "startGrade": "L3",
    "targetScore": 65,
    "targetGrade": "L4",
    "focusPrinciples": ["P1", "P10"],
    "maxIterations": 3,
    "autoScope": ["file-creation", "config-addition", "doc-enhancement"],
    "exclusions": ["code-refactoring", "architecture-change"]
  },
  "iterations": [
    {
      "round": 1,
      "score": 52,
      "grade": "L3",
      "fixes": [
        "P1: AGENTS.md 초안 생성",
        "P10: .nvmrc 추가"
      ],
      "delta": 0
    },
    {
      "round": 2,
      "score": 61,
      "grade": "L4",
      "fixes": [
        "P1: 빌드/테스트 명령 보완",
        "P3: .editorconfig 추가"
      ],
      "delta": 9
    }
  ],
  "status": "in-progress",
  "result": null
}
```

### 상태 값

| status | 의미 |
|--------|------|
| `in-progress` | 반복 진행 중 |
| `achieved` | 목표 점수 달성 |
| `max-iterations` | 최대 반복 도달, 목표 미달성 |
| `user-stopped` | 사용자가 중단 |

---

## 결과 리포트 형식

Remediate 완료 후 아래 형식으로 결과를 보고한다.

```markdown
## Remediate 결과

- **시작**: [시작 점수] / [시작 등급]
- **종료**: [종료 점수] / [종료 등급]
- **변화**: +[N]점 / [등급 변화]
- **반복 횟수**: [N]회
- **적용된 액션**: [N]건

### 원칙별 변화

| 원칙 | 시작 | 종료 | 변화 | 적용 액션 |
|------|------|------|------|-----------|

### 남은 과제

- 목표 미달 원칙과 사유
- Manual 항목 중 미처리 건
- 다음 Remediate 세션 권장 시점
```
