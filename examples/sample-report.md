# Audit 리포트 예시

실제 프론트엔드 코드베이스에 대한 Audit 리포트 예시.
점수화, 빠른 개선 항목, 위험 공개, 수행한 검증을 함께 포함한 출력 형태를 보여준다.

---

# 하니스 진단 리포트

- **진단 대상**: specific repository
- **모드**: Audit
- **날짜**: 2026-03-23
- **기술 스택**: React 19, TypeScript 5, Vite 8, pnpm 10, MUI 7, TanStack Query/Form, Vitest, Playwright
- **진단 범위**: 코드베이스

---

## 요약

강점은 진입점 문서, 레이어 경계, 레포 내부 지식화다. 약점은 운영 자동화와 self-documenting 밀도이며, 특히 루트 `AGENTS.md`가 스스로 선언한 "포인터 중심" 원칙보다 상세 규칙을 많이 품고 있어 문서 drift 리스크가 있다.

---

## 1. 종합 평가

**종합 등급: L4 / 종합 점수: 77.3/100**

---

## 2. 차원별 점수

| 차원                          | 포함 원칙    | 점수 | 가중치 | 기여도 |
| ----------------------------- | ------------ | ---: | -----: | -----: |
| A. Documentation & Navigation | P1,P2,P5,P12 |  8.0 |   0.30 |   2.40 |
| B. Enforcement & Consistency  | P3,P4,P10    |  7.7 |   0.30 |   2.30 |
| C. Architecture & Knowledge   | P6,P9,P11    |  8.7 |   0.20 |   1.73 |
| D. Operations & Maintenance   | P7,P8        |  6.5 |   0.20 |   1.30 |

---

## 3. 12원칙 상세

| #   | 원칙                          | 점수 | 근거 요약                                                                                       |
| --- | ----------------------------- | ---: | ----------------------------------------------------------------------------------------------- |
| P1  | Agent Entry Point             |    9 | 루트/하위 `AGENTS.md`, 명령, 구조, handoff 검증 순서가 명확함                                   |
| P2  | Map, Not Manual               |    8 | `README` quick links + `docs/index.md` 작업별 탐색 맵이 좋음, 다만 루트 문서 중복이 큼          |
| P3  | Invariant Enforcement         |    8 | ESLint, Prettier, Husky, Knip, Madge, CI, strict TS가 작동함                                    |
| P4  | Convention Over Configuration |    8 | 파일명, route, MUI usage, token usage 규칙이 상세히 문서화됨                                    |
| P5  | Progressive Disclosure        |    8 | `README -> docs/index -> architecture/ADR -> local AGENTS` 흐름이 있음                          |
| P6  | Layered Architecture          |    9 | `pages/components/features/entities/shared` 경계와 restricted imports가 선명함                  |
| P7  | Garbage Collection            |    6 | knip과 문서 GC 기준은 있으나 dependency/TODO 관리 자동화는 약함                                 |
| P8  | Observability                 |    7 | verify, unit test, e2e scaffold는 좋지만 runtime 관측성과 bundle budget은 없음                  |
| P9  | Knowledge in Repo             |    9 | ADR, roadmap, doc governance, PR template로 배경 지식이 레포 안에 있음                          |
| P10 | Reproducibility               |    7 | `.nvmrc`, `packageManager`, CI, verify는 좋지만 branch protection/coverage/security 근거는 없음 |
| P11 | Modularity                    |    8 | 도메인/feature 분리는 좋지만 일부 큰 playground 컴포넌트가 모듈성 한계를 드러냄                 |
| P12 | Self-Documentation            |    7 | 네이밍/JSDoc은 좋지만 300줄 이상 파일이 7개라 가독성 손실이 있음                                |

---

## 4. 체크리스트 결과

| 카테고리          | 전체 | 통과 | 실패 | 통과율 |
| ----------------- | ---: | ---: | ---: | -----: |
| Agent Entry Point |   15 |   14 |    1 |    93% |
| 문서 구조         |   12 |    9 |    3 |    75% |
| Invariant 강제    |   15 |   11 |    4 |    73% |
| 아키텍처          |   12 |   10 |    2 |    83% |
| Source of Truth   |   10 |    9 |    1 |    90% |
| 운영/유지보수     |   10 |    3 |    7 |    30% |
| Agent 가독성      |   10 |    5 |    5 |    50% |

---

## 5. 빠른 개선 항목

| 순위 | 항목                                                                            | 관련 원칙    | 예상 소요 | 예상 점수 향상 |
| ---- | ------------------------------------------------------------------------------- | ------------ | --------- | -------------- |
| 1    | 루트 `AGENTS.md`를 포인터 중심으로 축약하고 `src/features/e2e` 로컬 가이드 추가 | P2,P5,P9,P12 | 0.5-1일   | +3~5           |
| 2    | CI에 coverage, security audit, bundle size budget 추가                          | P3,P7,P8,P10 | 1-2일     | +4~6           |
| 3    | `MuiPalettePlayground` 등 대형 컴포넌트 분해                                    | P11,P12      | 1-2일     | +2~4           |
| 4    | TODO/deprecation/dependency maintenance 자동화 도입                             | P7,P10       | 0.5-1일   | +2~3           |
| 5    | entity/API contract 레퍼런스 문서 추가                                          | P5,P9,P12    | 0.5-1일   | +2~3           |

---

## 6. 개선 로드맵

- 단기 (1-2주): 문서 source-of-truth 정리, 로컬 AGENTS 보강, coverage/security/bundle budget 추가.
- 중기 (1-2개월): 대형 playground 컴포넌트 분해, feature/entity public API 정리, TODO/deprecation 관리 규칙 자동화.
- 장기 (3개월+): runtime observability, release note/changelog 운영, 배포 후 health/perf 모니터링 체계 도입.

---

## 근거

- 진입점과 전역 규칙: `AGENTS.md:25`, `AGENTS.md:68`, `AGENTS.md:119`
- 탐색 맵과 progressive disclosure: `README.md:5`, `docs/index.md:5`, `docs/index.md:20`
- 문서 source-of-truth 규칙과 현재 drift 포인트: `docs/doc-governance.md:8`, `docs/doc-governance.md:23`, `docs/doc-governance.md:60`
- 레이어 구조와 라우터 단일 브랜치: `docs/architecture.md:5`, `src/app/router.tsx:112`, `src/app/router.tsx:173`
- 강제 규칙: `eslint.config.js:121`, `package.json:9`, `.github/workflows/ci.yml:1`, `.husky/pre-commit`, `commitlint.config.cjs:1`
- self-documenting 샘플과 한계: `src/shared/hooks/useLocaleRouting.ts:11`, `src/pages/vouchers/[voucherId]/index.tsx:6`, `src/components/playground/mui/MuiPalettePlayground.tsx:45`

---

## 위험 요소

- 현재 워크트리는 dirty 상태였습니다: `M docs/index.md`, `?? docs/attachment-composer-plan.md`. 이 리포트는 clean checkout이 아니라 현재 작업중 상태를 기준으로 작성했습니다.
- `pnpm verify` 최종 통과 후에도 build 단계에서 500kB 초과 chunk 경고가 남았습니다. 품질 게이트에는 없지만 장기적으로는 P8/P11 리스크입니다.
- branch protection, coverage threshold, security/dependency automation은 레포 내부 근거가 없어 보수적으로 감점했습니다.

---

## 수행한 검증

- `git log --oneline --decorate -n 12`
- `pnpm lint:deadcode` 통과
- `pnpm format:check` 통과
- `pnpm lint` 통과
- `pnpm verify` 통과
- `vitest`: 29 files, 103 tests passed
- `vite build`: 성공, chunk size warning 존재
- `pnpm test:e2e`는 실행하지 않았습니다.
