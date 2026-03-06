# Setup Mode Workflow

> 새로운 프로젝트에서 에이전트 협업 환경을 초기화하기 위한 워크플로우.

---

## 권장 적용 시퀀스

새 프로젝트에서 Setup 모드는 아래 순서로 적용하는 것을 기본값으로 한다.

1. 프레임워크 공식 명령으로 최소 스캐폴드 생성
2. 현재 레포를 read-only로 스캔하여 실제 상태를 파악
3. 사용자가 제공한 요구사항을 별도 입력으로 수집
4. 레포 근거와 사용자 요구사항을 분리한 Setup 리포트 생성
5. 해당 리포트를 기준으로 초기 harness 파일과 규칙을 구현 단계에서 반영

예:

- Next.js: `npx create-next-app@latest` -> Setup -> 요구사항 반영 -> 구현
- Python: `uv init` 또는 `poetry new` -> Setup -> 요구사항 반영 -> 구현
- Go: `go mod init` -> Setup -> 요구사항 반영 -> 구현

이 시퀀스의 목적은 "진단"과 "구현"을 분리하는 데 있다. Setup 단계에서는 현재 상태와 목표 상태를 정렬하고, 실제 파일 생성/수정은 그 다음 단계에서 수행하는 것이 원칙이다.

## 사용자 요구사항 처리 규칙

사용자가 별도로 제공하는 요구사항은 Setup 모드에서 유효한 입력이다. 단, 다음 규칙을 따른다.

- 요구사항은 현재 상태를 평가하는 **증거**로 사용하지 않는다.
- 요구사항은 목표 상태를 설계하기 위한 **설계 입력**으로 사용한다.
- 리포트에는 `레포 근거`, `사용자 요구사항`, `추론`을 구분해 표시한다.
- 레포에서 확인되지 않은 내용은 점수 근거에 포함하지 않는다.
- 초기 스캐폴드 직후 프로젝트는 미구현 상태가 많으므로, 부족한 항목은 결함이라기보다 **우선 구축 대상**으로 해석한다.

## Phase 1: 현황 스캔

프로젝트의 현재 상태를 파악한다.

### Tech Stack 감지

- `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml` 등 의존성 파일 탐색
- 사용 중인 언어, 프레임워크, 빌드 도구 식별
- 프로젝트 유형 분류: web app / library / CLI / monorepo / 기타

### 기존 문서 스캔

- `README.md`, `docs/`, `AGENTS.md`, `CLAUDE.md` 존재 여부 확인
- 문서의 최신성 및 완성도 파악

### 기존 도구 확인

- Linter 설정 (ESLint, Pylint, golangci-lint 등)
- Formatter 설정 (Prettier, Black, gofmt 등)
- CI/CD 파이프라인 (GitHub Actions, GitLab CI 등)
- Pre-commit hooks, type checking 설정

### 사용자 요구사항 수집

- 제품 목적, 주요 사용자, 핵심 기능 요구사항 정리
- 기술 스택 제약, 배포 환경, 팀 운영 규칙 확인
- 문서, 테스트, CI, 아키텍처에 대한 기대 수준 수집
- 요구사항은 현황 스캔 결과와 별도 섹션으로 관리

---

## Phase 2: Gap 분석

현재 상태를 12원칙 기준으로 비교 평가한다.

- 각 원칙별 충족 여부 판단
- 누락 요소를 구체적으로 식별
- Impact가 높은 항목부터 우선순위 정렬
- 구현 난이도 대비 효과 평가
- 초기 스캐폴드 단계에서는 "현재 없음"과 "향후 반드시 필요"를 구분
- 사용자 요구사항으로 인해 필요한 항목은 목표 상태 gap으로 별도 표기

---

## Phase 3: 제안 생성

Tech stack에 맞는 구체적 개선안을 생성한다.

### AGENTS.md / CLAUDE.md 템플릿 생성

- Tech stack 기반 맞춤형 템플릿 제공
- 프로젝트 컨벤션, 빌드 명령어, 테스트 방법 포함

### docs/ 구조 제안

- ADR 디렉토리, API 문서, 가이드 등 권장 구조
- `examples/sample-docs-structure.md` 참조

### 우선순위별 실행 계획

| 시간대 | 작업 | 예시 |
|--------|------|------|
| **Immediate** (< 1시간) | 에이전트 진입점 + 기본 도구 | AGENTS.md 작성, linting 설정 |
| **Short-term** (< 1일) | 문서 구조 + CI | docs/ 구축, CI 설정 |
| **Medium-term** (< 1주) | 프로세스 + 테스트 | ADR 도입, 포괄적 테스트 환경 |

### 구현 단계로 넘길 입력 생성

- 실제 파일 생성/수정에 바로 사용할 수 있도록 우선순위와 산출물 정의
- `AGENTS.md`, `docs/`, lint/test/CI, 구조 규칙의 초기 초안 포함
- 기능 구현 전에 먼저 반영해야 할 harness baseline 명시

---

## Phase 4: 리포트 출력

`references/report-template.md`의 Setup 리포트 형식으로 출력한다.

### 리포트 형식 검증

리포트 생성 후 출력 전 다음 사항을 검증한다:

- [ ] 공통 헤더(진단 대상, 모드, 날짜, 기술 스택, 진단 범위)가 포함되어 있는가
- [ ] 현황 요약 테이블(기술 스택, 문서, 도구/설정)이 빠짐없이 작성되어 있는가
- [ ] 사용자 요구사항이 별도 섹션으로 정리되어 있는가
- [ ] 레포 근거와 사용자 요구사항, 추론이 구분되어 있는가
- [ ] Gap 분석이 12원칙 모두를 커버하는가
- [ ] 실행 계획이 시간대별(Immediate/Short-term/Medium-term)로 분류되어 있는가
- [ ] 생성 제안 파일 목록에 우선순위가 부여되어 있는가
- [ ] 자체 점검 부록이 포함되어 있는가

---

## Tech Stack별 권장 사항

### Node.js / TypeScript

- `AGENTS.md`에 `npm`/`yarn`/`pnpm` 명령어 명시
- ESLint + Prettier 설정 확인 및 권장
- `tsconfig.json` strict 모드 권장
- Jest 또는 Vitest 테스트 프레임워크 설정
- `.nvmrc` 또는 `engines` 필드로 Node 버전 고정

### Python

- `AGENTS.md`에 가상환경 활성화 방법 명시
- Ruff 또는 Pylint + Black 설정 권장
- `pyproject.toml` 기반 프로젝트 구성 권장
- pytest 설정, mypy type hints 권장

### Go

- `AGENTS.md`에 `go build`, `go test` 명령어 명시
- golangci-lint 설정 권장
- 테이블 기반 테스트 패턴 권장
- 모듈 구조 및 패키지 레이아웃 가이드 포함

### General / 기타

- 언어별 표준 linter 및 formatter 설정
- 빌드/실행 방법을 AGENTS.md에 명확히 기술
- CI 파이프라인 최소 구성 (lint, test, build)
