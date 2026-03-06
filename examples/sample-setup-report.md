# Setup 리포트 예시

가상의 초기화 직후 프로젝트 "Acme Dashboard"에 대한 Setup 리포트 예시.
사용자 요구사항을 별도 입력으로 받아 현재 상태와 목표 상태를 분리해 출력하는 형태를 보여준다.

---

# 하니스 진단 리포트

- **진단 대상**: Acme Dashboard
- **모드**: Setup
- **날짜**: 2026-03-06
- **기술 스택**: Next.js 16, React 19, TypeScript, pnpm
- **진단 범위**: 코드베이스

---

## 1. 현황 요약

| 항목 | 감지 결과 |
|------|-----------|
| 언어 | TypeScript |
| 프레임워크 | Next.js |
| 빌드 도구 | Next.js built-in |
| 패키지 매니저 | pnpm |

| 문서 | 존재 여부 | 상태 |
|------|-----------|------|
| README.md | Y | create-next-app 기본 문서 |
| AGENTS.md | N | 미구축 |
| docs/ | N | 미구축 |

| 도구/설정 | 존재 여부 | 상태 |
|-----------|-----------|------|
| Linter | Y | 기본 ESLint 설정 존재 |
| Formatter | N | 별도 Prettier 미구성 |
| CI pipeline | N | 미구성 |

---

## 2. 요구사항 오버레이

| 항목 | 내용 | 분류 |
|------|------|------|
| 제품/서비스 목적 | B2B 운영 대시보드 | 사용자 요구사항 |
| 기술 스택 제약 | Next.js App Router, TypeScript strict, pnpm | 사용자 요구사항 |
| 팀 운영 규칙 | PR 필수, main 직접 push 금지 | 사용자 요구사항 |
| 품질 기준 | lint, typecheck, test, CI 필수 | 사용자 요구사항 |
| 문서 요구사항 | AGENTS.md, docs/adr, docs/guides 필요 | 사용자 요구사항 |
| 테스트/CI 요구사항 | Vitest + Playwright, GitHub Actions | 사용자 요구사항 |

- **레포 근거**: `package.json`, `tsconfig.json`, `README.md`, `.eslintrc*` 또는 Next.js 기본 lint 설정
- **사용자 요구사항**: "TypeScript strict, PR 필수, Vitest + Playwright, AGENTS.md와 docs 필요"
- **추론**: 기능 구현 전에 에이전트 진입점과 최소 품질 게이트를 먼저 세우는 것이 적절함

---

## 3. Gap 분석

| # | 원칙 | 현재 상태 | 누락 요소 | 심각도 |
|---|------|-----------|-----------|--------|
| 1 | Agent Entry Point | README만 존재 | AGENTS.md, 하위 문서 포인터 | High |
| 2 | Map, Not Manual | 기본 README 중심 | docs 구조, 크로스 레퍼런스 | High |
| 3 | Invariant Enforcement | 기본 lint만 존재 | typecheck/test/CI 강제 | High |
| 4 | Convention Over Configuration | 기본 스캐폴드 수준 | 네이밍/구조 규칙 문서화 | Medium |
| 5 | Progressive Disclosure | 루트 수준 정보만 있음 | docs/guides, ADR 계층 | Medium |
| 6 | Layered Architecture | 구조 미정 | 레이어 경계 정의 | Medium |
| 7 | Garbage Collection | 초기 상태 | 유지보수 규칙 미정 | Low |
| 8 | Observability | 기본 상태 | 검증 명령어, CI 결과 가시화 | Medium |
| 9 | Knowledge in Repo | 외부 요구사항만 존재 | 요구사항의 레포 내 정착 필요 | High |
| 10 | Reproducibility | 스캐폴드 기본값 | 버전 고정, 반복 가능한 명령 정의 | Medium |
| 11 | Modularity | 기본 app 구조만 존재 | feature/domain 단위 구조 정의 | Medium |
| 12 | Self-Documentation | 기본 템플릿 코드 | 의도 중심 문서와 예시 부족 | Medium |

초기 스캐폴드 직후이므로, 다수의 "없음" 항목은 결함이라기보다 우선 구축 대상으로 해석한다.

---

## 4. 실행 계획

#### Immediate (< 1시간)

| 순서 | 작업 | 관련 원칙 | 예상 소요 | 산출물 |
|------|------|-----------|-----------|--------|
| 1 | `AGENTS.md` 초안 작성 | P1,P2,P10 | 30분 | `AGENTS.md` |
| 2 | `tsconfig.json` strict 기준 확인 및 정리 | P3,P10 | 15분 | strict 기준 명시 |
| 3 | 기본 품질 명령어 합의 | P3,P8 | 15분 | `pnpm lint`, `pnpm typecheck`, `pnpm test` |

#### Short-term (< 1일)

| 순서 | 작업 | 관련 원칙 | 예상 소요 | 산출물 |
|------|------|-----------|-----------|--------|
| 1 | `docs/` 구조 생성 | P2,P5,P9 | 1시간 | `docs/adr`, `docs/guides` |
| 2 | Vitest + Playwright 설정 | P3,P8 | 2-3시간 | 테스트 러너 구성 |
| 3 | GitHub Actions 최소 CI 구성 | P3,P8,P10 | 1시간 | lint/typecheck/test workflow |

#### Medium-term (< 1주)

| 순서 | 작업 | 관련 원칙 | 예상 소요 | 산출물 |
|------|------|-----------|-----------|--------|
| 1 | feature/domain 구조 정착 | P4,P6,P11 | 1-2일 | 구조 규칙 문서 |
| 2 | ADR 작성 프로세스 도입 | P5,P9 | 반나절 | ADR 템플릿 + 첫 의사결정 기록 |
| 3 | E2E 핵심 시나리오 확보 | P3,P8 | 1-2일 | Playwright smoke suite |

---

## 5. 생성 제안 파일 목록

| 파일 경로 | 유형 | 설명 | 우선순위 |
|-----------|------|------|----------|
| `AGENTS.md` | 신규 | 에이전트 진입점, 명령어, 구조, 규칙 | P0 |
| `docs/adr/0001-initial-architecture.md` | 신규 | 초기 구조 결정 기록 | P1 |
| `docs/guides/development.md` | 신규 | 로컬 개발/검증 가이드 | P1 |
| `.github/workflows/ci.yml` | 신규 | 최소 CI | P1 |
| `vitest.config.ts` | 신규 | 단위 테스트 설정 | P1 |
| `playwright.config.ts` | 신규 | E2E 테스트 설정 | P2 |

---

## 6. 목표 AGENTS.md 초안 구조

| 섹션 | 포함 내용 | 출처 |
|------|-----------|------|
| 프로젝트 개요 | B2B 운영 대시보드, 핵심 사용자 | 사용자 요구사항 |
| 빌드/실행 명령어 | `pnpm install`, `pnpm dev`, `pnpm lint`, `pnpm test` | 레포 근거 + 추론 |
| 디렉토리 구조 | `app/`, `components/`, `lib/`, `features/` 목표 구조 | 레포 근거 + 추론 |
| 코딩 컨벤션 | Server Component 우선, strict TS, feature 단위 분리 | 사용자 요구사항 + 추론 |
| 운영 규칙 | PR 필수, main 직접 push 금지, 문서 동시 갱신 | 사용자 요구사항 |

---

## 부록: 자체 점검

이 진단 리포트 자체의 품질:
- [x] 모든 원칙에 대해 근거가 제시되었는가?
- [x] 점수가 일관된 기준으로 부여되었는가?
- [x] 제안 사항이 구체적이고 실행 가능한가?
- [x] 우선순위가 명확한가?
- [x] 리포트가 읽기 쉬운가?
