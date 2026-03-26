# 진단 깊이 프로필

> 모델 능력과 진단 목적에 따라 진단 깊이를 조절하기 위한 3단계 프로필.
> 기본값은 Standard이며, 사용자가 트리거 키워드로 변경할 수 있다.

---

## 프로필 요약

| 프로필 | 트리거 | 평가 범위 | 체크리스트 | 예상 소요 |
|--------|--------|-----------|-----------|-----------|
| **Quick** | "빠른 점검", "간단히", 소규모 변경 후 | P1, P3, P10 (핵심 3원칙) | skip | 짧음 |
| **Standard** | 기본값, "진단", "점검" | P1-P12 (전체 12원칙) | 전체 실행 | 보통 |
| **Deep** | "정밀 진단", "deep", 메이저 리팩터링 | P1-P12 + 코드 샘플링 + adversarial verify | 전체 실행 | 김 |

---

## Quick 프로필

빠른 상태 확인용. 소규모 변경 후 regression 여부만 확인할 때 사용한다.

### 평가 대상

- **P1 Agent Entry Point**: 진입점 파일 존재 + 핵심 섹션 확인
- **P3 Invariant Enforcement**: lint/formatter/CI 동작 여부
- **P10 Reproducibility**: 빌드/테스트 명령 실행 가능 여부

### 생략 항목

- 나머지 9개 원칙 (P2, P4-P9, P11-P12)
- 체크리스트 (codebase/skill 모두)
- 코드 샘플링
- 차원 점수 산출 (핵심 3원칙 점수만 보고)

### 출력 형식

공통 헤더 + 3원칙 점수 + 요약. 차원 점수와 종합 등급은 생략한다.

---

## Standard 프로필

기본 진단 모드. 현재의 Audit 워크플로우와 동일하다.

### 평가 대상

- P1-P12 전체 12원칙 (0-10 점수)
- 4차원 가중 점수 산출
- 대상별 체크리스트 전체 실행
- 코드 샘플링 (audit-workflow.md 기준)

### 출력 형식

`references/report-template.md`의 Audit 리포트 전체 형식.

---

## Deep 프로필

정밀 진단용. 메이저 리팩터링, 아키텍처 변경, 또는 L5 도달 여부 판단 시 사용한다.

### 평가 대상

Standard의 모든 항목에 추가:

- **Adversarial Verification**: `scripts/adversarial-verify.sh` 실행으로 체크리스트 반증 검증
- **확장 코드 샘플링**: 주요 파일 20개의 import 구조, 5개 디렉토리의 네이밍 패턴
- **Dead code 탐지**: 미사용 import, 주석 처리 코드, 빈 파일
- **이력 분석**: 최근 30일 커밋 패턴, 문서-코드 변경 동기화 비율

### 출력 형식

Standard 리포트에 추가 섹션:

- **신뢰도 분석**: adversarial-verify 결과 (Score, Confidence, Bias Delta)
- **코드 품질 심층**: 확장 샘플링 결과
- **이력 동기화**: 문서-코드 변경 비율

---

## 프로필 선택 규칙

1. 사용자가 명시적으로 지정하면 해당 프로필을 사용한다.
2. 트리거 키워드가 없으면 **Standard**를 기본으로 사용한다.
3. Self 진단은 항상 **Deep**을 권장한다 (자기 평가 편향 보정 목적).
4. 모드가 애매하면 사용자에게 확인한다.

---

## 설계 근거

Anthropic 블로그 "[Harness design for long-running apps](https://www.anthropic.com/engineering/harness-design-long-running-apps)"에서 모델 능력 향상에 따라 하네스 컴포넌트를 제거한 사례(V1→V2: 스프린트 분해 제거)에서 착안. 각 하네스 컴포넌트는 "모델이 이것을 할 수 없다"는 가정을 인코딩하므로, 그 가정이 유효하지 않으면 컴포넌트를 생략할 수 있다. Quick 프로필은 이 원칙의 실현이다.
