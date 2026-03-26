# 하니스 진단 리포트

- **진단 대상**: specific repository
- **모드**: Audit (Standard)
- **날짜**: 2026-03-26
- **기술 스택**: React 19 / TypeScript 5 / Vite 8 / MUI 7 / pnpm
- **진단 범위**: 코드베이스

---

## 요약

이 레포는 에이전트 친화성 관점에서 매우 높은 수준이다. **가장 강한 영역**은 Agent Entry Point(P1)와 Source of Truth(P9) — 루트 + 4개 하위 AGENTS.md, 11개 ADR, doc-governance, PR 템플릿이 모두 갖춰져 있다. **가장 약한 영역**은 Operations & Maintenance(차원 D) — 의존성 자동 업데이트, 에러 모니터링, 테스트 커버리지 임계값이 부재하나 pre-production foundation 레포 특성상 합리적이다. **즉시 개선 포인트**: 대형 파일 분할(SpreadsheetSection 1073줄), Renovate/Dependabot 도입, 테스트 커버리지 리포팅 추가.

---

## 1. 종합 평가

**종합 등급: L5 (Autonomous) / 종합 점수: 86.3/100**

---

## 2. 차원별 점수

| 차원                          | 포함 원칙       | 점수 | 가중치 | 기여도 |
| ----------------------------- | --------------- | ---- | ------ | ------ |
| A. Documentation & Navigation | P1, P2, P5, P12 | 9.00 | 0.30   | 2.70   |
| B. Enforcement & Consistency  | P3, P4, P10     | 8.67 | 0.30   | 2.60   |
| C. Architecture & Knowledge   | P6, P9, P11     | 8.67 | 0.20   | 1.73   |
| D. Operations & Maintenance   | P7, P8          | 8.00 | 0.20   | 1.60   |

```
종합 = (2.70 + 2.60 + 1.73 + 1.60) × 10 = 86.3
```

---

## 3. 12원칙 상세

| #   | 원칙                          | 점수 | 근거 요약                                                            |
| --- | ----------------------------- | ---- | -------------------------------------------------------------------- |
| 1   | Agent Entry Point             | 10   | 루트 AGENTS.md + 4개 하위 AGENTS.md, 모든 명령/구조/규칙 완비        |
| 2   | Map, Not Manual               | 9    | docs/index.md 작업유형별 탐색 맵, 풍부한 크로스 레퍼런스             |
| 3   | Invariant Enforcement         | 9    | ESLint 경계 규칙 + Prettier + TS strict + CI + pre-commit/push hooks |
| 4   | Convention Over Configuration | 9    | 60+ 코딩 규칙 문서화, 커스텀 ESLint 규칙으로 강제                    |
| 5   | Progressive Disclosure        | 9    | 3단계+ 정보 계층: AGENTS.md → docs/ → docs/adr/ → src/\*\*/AGENTS.md |
| 6   | Layered Architecture          | 9    | 5계층 + ESLint import 제한 + madge 순환 의존성 검증                  |
| 7   | Garbage Collection            | 8    | knip CI 통합, TODO 0건, doc-governance에 GC 기준 명시                |
| 8   | Observability                 | 8    | vitest 파일 단위 실행, pnpm verify 통합 검증, Playwright e2e         |
| 9   | Knowledge in Repo             | 9    | 11개 ADR, 전환 로드맵, PR 의도 리뷰 템플릿                           |
| 10  | Reproducibility               | 8    | .nvmrc + packageManager + lock + MSW mock + frozen-lockfile CI       |
| 11  | Modularity                    | 8    | 명확한 모듈 경계, ESLint import 강제, 일부 대형 파일 존재            |
| 12  | Self-Documentation            | 8    | 일관된 네이밍, 한글 테스트명+영어 기술 용어, TODO 0건                |

### 원칙별 상세

#### 원칙 1: Agent Entry Point

- **점수**: 10/10
- **강점**: 루트 AGENTS.md가 프로젝트 목적, 전 라우트, 모든 명령(설치~검증), 환경, CI, hook, 문서 탐색 경로, 코딩 규칙을 모두 포함. `src/app/`, `src/components/`, `src/shared/`, `src/entities/`에 각각 로컬 AGENTS.md 존재
- **근거**: `AGENTS.md`, `src/app/AGENTS.md`, `src/components/AGENTS.md`, `src/shared/AGENTS.md`, `src/entities/AGENTS.md`
- **개선 제안**: 현재 수준 유지. `src/features/AGENTS.md` 추가 고려

#### 원칙 2: Map, Not Manual

- **점수**: 9/10
- **강점**: `docs/index.md`의 작업 유형별 탐색 맵이 매우 우수. 15개 작업 유형에 대해 "먼저 볼 문서 → 다음으로 볼 위치" 2단계 안내 제공
- **약점**: AGENTS.md(~400줄)와 README.md(22KB)가 상당히 길어 파싱 비용 존재
- **근거**: `docs/index.md`, `docs/doc-governance.md`
- **개선 제안**: AGENTS.md의 현재 라우트 목록을 docs/로 분리하고 포인터만 남기면 진입점 파싱 비용 감소

#### 원칙 3: Invariant Enforcement

- **점수**: 9/10
- **강점**: ESLint 경계 규칙(pages↛shared, components↛pages 등), 커스텀 `prefer-mui-typography` 규칙, Prettier pre-commit, commitlint, knip dead code, madge cycle. CI에서 lint:deadcode + verify(lint+cycles+format+test+build) 필수
- **약점**: 테스트 커버리지 임계값 미설정, 보안 스캔(의존성 취약점) 미설정, import 순서 규칙 도구 미강제
- **근거**: `eslint.config.js`, `.prettierrc.json`, `.husky/*`, `.github/workflows/ci.yml`, `commitlint.config.cjs`
- **개선 제안**: `eslint-plugin-import` 또는 `@trivago/prettier-plugin-sort-imports`로 import 순서 강제, `vitest --coverage` 임계값 추가

#### 원칙 4: Convention Over Configuration

- **점수**: 9/10
- **강점**: AGENTS.md에 60+ 코딩 규칙 명시(PascalCase 컴포넌트, camelCase hooks/utils, kebab-case 라우트, px 단위 Figma 측정값 등). 기존 코드 패턴이 매우 일관적
- **약점**: 새 feature/module 추가 시 따라갈 수 있는 코드 생성기/템플릿(scaffolding) 부재
- **근거**: `AGENTS.md` 현재 규칙 섹션, `eslint.config.js`
- **개선 제안**: 선택적으로 `plop` 등 scaffolding 도구 도입 가능하나 현재 규모에서는 낮은 우선순위

#### 원칙 5: Progressive Disclosure

- **점수**: 9/10
- **강점**: 4단계 정보 계층 — AGENTS.md(전역) → docs/(아키텍처/거버넌스) → docs/adr/(의사결정) → src/\*\*/AGENTS.md(로컬). doc-governance에서 분리 규칙까지 명시
- **약점**: 일부 docs 파일이 docs/ 루트에 평면적으로 공존하다가 최근 attachment/, view/ 서브디렉토리로 분리 시작
- **근거**: `docs/index.md`, `docs/doc-governance.md` 디렉터리 배치 규칙
- **개선 제안**: 현재 구조 유지. 문서 3개 이상이 되는 도메인은 서브디렉토리 신설(이미 거버넌스에 규칙화됨)

#### 원칙 6: Layered Architecture

- **점수**: 9/10
- **강점**: app → pages → components → features → entities → shared 5계층. ESLint로 import 방향 강제. madge로 순환 의존성 CI 검증
- **약점**: 일부 대형 파일(SpreadsheetSection 1073줄)이 단일 모듈 내 추가 분해 필요 시사
- **근거**: `eslint.config.js` (boundary rules), `package.json` (lint:cycles), `docs/architecture.md`
- **개선 제안**: SpreadsheetSection을 하위 컴포넌트로 분해

#### 원칙 7: Garbage Collection

- **점수**: 8/10
- **강점**: knip이 CI에 통합되어 dead code 자동 감지. TODO/FIXME/HACK 0건. 최근 커밋(`79f02ae`)에서 knip이 찾은 미사용 barrel export 제거. doc-governance에 GC 기준 명시
- **약점**: 의존성 자동 업데이트(Dependabot/Renovate) 미설정. CHANGELOG 부재
- **근거**: `.knip.json`, `package.json` (lint:deadcode), `docs/doc-governance.md`
- **개선 제안**: Renovate 또는 Dependabot 설정 추가

#### 원칙 8: Observability

- **점수**: 8/10
- **강점**: vitest로 파일 단위 빠른 테스트 실행(`pnpm exec vitest run <path>`), Playwright e2e, pnpm verify로 전체 검증. 테스트 비율 40/156(25.6%) — foundation 레포로서 적정
- **약점**: 테스트 커버리지 리포트 미설정, 독립 type-check 명령 부재(`pnpm tsc --noEmit` 없음), 에러 모니터링 미연동(pre-production)
- **근거**: `vite.config.ts`, `playwright.config.ts`, `package.json`
- **개선 제안**: `pnpm typecheck` 스크립트 추가(`tsc --noEmit`), vitest coverage 리포트 도입

#### 원칙 9: Knowledge in Repo

- **점수**: 9/10
- **강점**: 11개 ADR이 결정 배경과 대안을 상세히 기록. ERP 전환 로드맵이 레포 내 관리. PR 템플릿에 의도 리뷰(문제, 목표, 비목표, 접근, 리뷰 포인트) 필수
- **약점**: CHANGELOG 부재, 외부 의존성 선택 이유가 ADR에 부분적으로만 기록
- **근거**: `docs/adr/*` (11개), `docs/erp-transition-roadmap.md`, `.github/pull_request_template.md`
- **개선 제안**: 주요 의존성 선택 이유를 ADR로 보완(예: React 19 선택 배경)

#### 원칙 10: Reproducibility

- **점수**: 8/10
- **강점**: .nvmrc(24.14.0), packageManager(pnpm 10.32.1), pnpm-lock.yaml, CI frozen-lockfile, MSW 기반 mock API로 결정적 개발 환경
- **약점**: Docker/컨테이너 미제공(완전 환경 재현 불가), 테스트 커버리지 임계값 미설정
- **근거**: `.nvmrc`, `package.json`, `.github/workflows/ci.yml`
- **개선 제안**: Dockerfile 또는 devcontainer 설정 추가 고려

#### 원칙 11: Modularity

- **점수**: 8/10
- **강점**: features/ 아래 attachments, spreadsheet, vouchers가 독립 모듈. entities/에 도메인 계약 집중. ESLint로 모듈 간 import 제한
- **약점**: barrel export 최근 제거(knip) — 모듈 public API 정의가 다소 불명확. SpreadsheetSection(1073줄), ReadOnlySpreadsheetViewer(687줄) 등 대형 파일
- **근거**: `src/features/`, `src/entities/`, `eslint.config.js`
- **개선 제안**: 대형 파일을 하위 컴포넌트/유틸로 분해, 필요 시 모듈별 index.ts 재도입

#### 원칙 12: Self-Documentation

- **점수**: 8/10
- **강점**: PascalCase 컴포넌트, camelCase hooks/utils 일관 적용. 한글 테스트 설명 + 영어 기술 용어. TODO/FIXME 0건
- **약점**: 대형 파일(1073줄)은 코드 자체만으로 의도 파악이 어려움. theme tokens 등에 매직 넘버 가능성
- **근거**: `src/` 전반 네이밍 패턴, 테스트 파일 패턴
- **개선 제안**: 300줄 초과 파일 분해, 매직 넘버 상수 추출 점검

---

## 4. 체크리스트 결과

| 카테고리             | 충족   | 전체   | 비율    |
| -------------------- | ------ | ------ | ------- |
| 1. Agent Entry Point | 15     | 15     | 100%    |
| 2. 문서 구조         | 10     | 12     | 83%     |
| 3. Invariant 강제    | 11     | 15     | 73%     |
| 4. 아키텍처          | 10     | 12     | 83%     |
| 5. Source of Truth   | 10     | 10     | 100%    |
| 6. 운영/유지보수     | 3      | 10     | 30%     |
| 7. Agent 가독성      | 9      | 10     | 90%     |
| **합계**             | **68** | **84** | **81%** |

### 주요 미충족 항목

**문서 구조**: API 문서(OpenAPI/JSDoc) 부재, CHANGELOG 미관리
**Invariant 강제**: 테스트 커버리지 임계값 미설정, 보안 스캔 미설정, import 순서 도구 미강제, branch protection 미확인
**운영/유지보수**: Dependabot/Renovate 미설정, 에러 모니터링 미연동, Docker 미구성 — 다만 pre-production SPA foundation 특성상 logging/health check/Docker는 현 단계에서 낮은 우선순위

---

## 5. 빠른 개선 항목

| 순위 | 항목                                             | 관련 원칙 | 예상 소요 | 예상 점수 향상 |
| ---- | ------------------------------------------------ | --------- | --------- | -------------- |
| 1    | `pnpm typecheck` 스크립트 추가 (`tsc --noEmit`)  | P8        | 5분       | +0.3           |
| 2    | Renovate 또는 Dependabot 설정                    | P7        | 15분      | +0.5           |
| 3    | vitest coverage 리포팅 + CI 임계값               | P3, P8    | 30분      | +0.5           |
| 4    | import 순서 플러그인 추가                        | P3, P4    | 20분      | +0.3           |
| 5    | SpreadsheetSection 파일 분해 (1073줄→300줄 이하) | P11, P12  | 2시간     | +0.5           |

---

## 6. 개선 로드맵

### 단기 (1-2주)

| 항목                           | 관련 원칙 | 예상 효과                            |
| ------------------------------ | --------- | ------------------------------------ |
| `pnpm typecheck` 스크립트 추가 | P8        | 독립 타입 체크로 빠른 피드백 루프    |
| Renovate/Dependabot 설정       | P7        | 의존성 자동 업데이트 시작            |
| vitest --coverage + CI 임계값  | P3, P8    | 테스트 커버리지 가시성 + 품질 게이트 |
| import 순서 ESLint 플러그인    | P3, P4    | import 일관성 도구 강제              |

### 중기 (1-2개월)

| 항목                                                  | 관련 원칙 | 예상 효과                    | 선행 조건 |
| ----------------------------------------------------- | --------- | ---------------------------- | --------- |
| 대형 파일 분해 (SpreadsheetSection 등 300줄 초과 5개) | P11, P12  | Agent 가독성 + 모듈성 향상   | 없음      |
| `src/features/AGENTS.md` 추가                         | P1, P5    | features 계층 로컬 규칙 명시 | 없음      |
| npm audit / Snyk 보안 스캔 CI 통합                    | P3        | 의존성 취약점 자동 감지      | 없음      |
| AGENTS.md 라우트 목록 docs/로 분리                    | P2        | 진입점 파싱 비용 감소        | 없음      |

### 장기 (3개월+)

| 항목                           | 관련 원칙 | 예상 효과                | 선행 조건          |
| ------------------------------ | --------- | ------------------------ | ------------------ |
| Devcontainer/Docker 환경 구성  | P10       | 완전 재현 가능 개발 환경 | product 단계 진입  |
| 에러 모니터링 연동 (Sentry 등) | P8        | 런타임 에러 가시성       | production 배포    |
| API 문서 자동 생성 (OpenAPI)   | P2, P9    | 백엔드 계약 문서화       | 실제 API 연동 시점 |

---

## 근거

- 점수 판단에 사용한 핵심 파일: `AGENTS.md`, `docs/index.md`, `docs/doc-governance.md`, `eslint.config.js`, `package.json`, `.github/workflows/ci.yml`, `.husky/*`, `vite.config.ts`
- 소스 파일 156개, 테스트 파일 40개(unit 37 + e2e 3), 테스트 비율 25.6%
- 가장 큰 파일: `SpreadsheetSection.tsx`(1073줄), `ReadOnlySpreadsheetViewer.tsx`(687줄)
- TODO/FIXME/HACK: 0건

## 위험 요소

- 운영/유지보수(차원 D) 점수가 8.0으로 가장 낮음. product 단계 진입 시 모니터링/로깅/Docker 미비가 병목될 수 있음
- branch protection 규칙 확인 불가(GitHub 설정은 로컬에서 접근 불가)
- 대형 파일 5개가 300줄을 초과하여 에이전트의 코드 이해 비용 증가

## 수행한 검증

- AGENTS.md, README.md, docs/ 전체 구조 읽기
- eslint.config.js, package.json, CI workflow, husky hooks 설정 확인
- 소스/테스트 파일 수 카운트, 파일 크기 분포 분석
- TODO/FIXME/HACK 전수 검색 (0건 확인)
- 하위 AGENTS.md 4개 존재 확인
- ADR 11개 존재 확인

---

## 부록: 자체 점검

- [x] 모든 원칙에 대해 근거가 제시되었는가?
- [x] 점수가 일관된 기준으로 부여되었는가?
- [x] 제안 사항이 구체적이고 실행 가능한가?
- [x] 우선순위가 명확한가?
- [x] 리포트가 읽기 쉬운가?
