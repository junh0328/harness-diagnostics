# 모범 AGENTS.md 예시

가상의 Next.js + TypeScript e-commerce 프로젝트를 위한 AGENTS.md 예시.
이 파일은 harness-diagnostics의 12원칙을 잘 반영한 모범 사례를 보여준다.

---

```markdown
# AGENTS.md

## 프로젝트 개요

Next.js 14 기반 e-commerce 플랫폼. App Router 사용, TypeScript strict mode.

## 기술 스택

| 항목 | 기술 |
|------|------|
| 프레임워크 | Next.js 14 (App Router) |
| 언어 | TypeScript 5.3 (strict mode) |
| 스타일링 | Tailwind CSS 3.4 |
| 상태관리 | Zustand |
| API | tRPC + Prisma |
| DB | PostgreSQL 15 |
| 테스트 | Vitest + Playwright |
| 패키지 매니저 | pnpm 8 |

## 빌드 및 실행

```bash
# 의존성 설치
pnpm install

# 개발 서버
pnpm dev

# 빌드
pnpm build

# 타입 체크
pnpm typecheck

# 린트
pnpm lint

# 테스트
pnpm test          # 단위 테스트
pnpm test:e2e      # E2E 테스트

# DB 마이그레이션
pnpm db:migrate
pnpm db:seed
```

## 디렉토리 구조

```
src/
├── app/              # Next.js App Router 페이지
│   ├── (auth)/       # 인증 관련 라우트 그룹
│   ├── (shop)/       # 쇼핑 관련 라우트 그룹
│   └── api/          # API 라우트
├── components/       # 재사용 UI 컴포넌트
│   ├── ui/           # 기본 UI (Button, Input, Modal)
│   └── domain/       # 도메인별 (ProductCard, CartItem)
├── lib/              # 공유 유틸리티 및 설정
│   ├── db/           # Prisma 클라이언트 및 스키마
│   ├── trpc/         # tRPC 라우터 및 프로시저
│   └── utils/        # 순수 유틸리티 함수
├── hooks/            # 커스텀 React 훅
├── stores/           # Zustand 스토어
└── types/            # 공유 타입 정의
```

## 코딩 컨벤션

### 파일명
- 컴포넌트: PascalCase (`ProductCard.tsx`)
- 유틸리티/훅: camelCase (`useCart.ts`, `formatPrice.ts`)
- 라우트: kebab-case 디렉토리 (`app/order-history/page.tsx`)

### 컴포넌트 패턴
- Server Component 우선. 클라이언트 상태 필요 시에만 `'use client'`
- Props 타입은 컴포넌트 파일 내 정의 (`interface ProductCardProps {}`)
- 재사용 컴포넌트는 `components/ui/`, 도메인 한정은 `components/domain/`

### API 패턴
- tRPC 프로시저는 `lib/trpc/routers/` 아래 도메인별 분리
- 입력 검증은 Zod 스키마 사용 (`.input(z.object({...}))`)
- 에러는 `TRPCError`로 throw

### 테스트 패턴
- 단위 테스트: `__tests__/` 디렉토리, `.test.ts` 확장자
- E2E: `e2e/` 디렉토리, `.spec.ts` 확장자
- 테스트 데이터: `tests/fixtures/`에서 관리

## 의존성 방향 규칙

```
app/ → components/ → hooks/ → lib/ → types/
                   → stores/ → lib/ → types/
```

- `lib/`는 React에 의존하지 않음
- `components/ui/`는 도메인 로직에 의존하지 않음
- 순환 의존 금지

## 주의사항

- `.env.local`은 커밋 금지. `.env.example` 참조
- DB 스키마 변경 시 반드시 마이그레이션 생성 (`pnpm db:migrate`)
- `main` 브랜치 직접 push 금지. PR + 리뷰 필수
- API 변경 시 `docs/api/` 문서 동시 업데이트

## 관련 문서

- [아키텍처 결정 기록](docs/adr/)
- [API 문서](docs/api/)
- [개발 가이드](docs/guides/development.md)
```

---

## 이 예시가 반영하는 원칙

| 원칙 | 반영 내용 |
|------|----------|
| P1. Agent Entry Point | AGENTS.md가 명확한 진입점 역할 |
| P2. 구조화된 문서 | 섹션별 정리, 관련 문서 링크 |
| P3. Invariant 강제 | lint, typecheck 명령어 명시 |
| P5. 탐색 가능한 구조 | 디렉토리 구조 + 역할 설명 |
| P6. 아키텍처 결정 기록 | ADR 디렉토리 참조 |
| P9. 코드 의존성 가독성 | 의존성 방향 규칙 명시 |
| P10. 컨벤션 일관성 | 네이밍, 패턴 컨벤션 상세 기술 |
| P12. 에이전트 가독성 | 기계가 파싱 가능한 테이블/코드블록 활용 |
