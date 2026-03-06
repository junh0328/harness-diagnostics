# 권장 docs/ 디렉토리 구조

프로젝트 규모에 따른 문서 디렉토리 구조 권장안.
Setup 모드에서 제안의 참조 자료로 사용한다.

---

## 소규모 프로젝트 (1-3명, 단일 서비스)

```
docs/
├── README.md              # docs 디렉토리 안내
├── getting-started.md     # 개발 환경 설정 가이드
├── architecture.md        # 아키텍처 개요 (단일 파일)
└── adr/                   # 아키텍처 결정 기록
    ├── README.md          # ADR 목차 및 작성 가이드
    ├── 001-framework.md
    └── 002-database.md
```

**핵심 포인트**:
- 과도한 구조화 지양. 파일 수 최소화
- `architecture.md` 하나로 전체 구조 설명
- ADR은 처음부터 도입 (나중에 추가하기 어려움)

---

## 중규모 프로젝트 (4-10명, 복수 모듈)

```
docs/
├── README.md              # docs 디렉토리 안내 및 탐색 가이드
├── getting-started.md     # 개발 환경 설정
├── architecture/
│   ├── overview.md        # 전체 아키텍처 개요
│   ├── data-flow.md       # 데이터 흐름
│   └── module-boundary.md # 모듈 경계 및 의존성 규칙
├── guides/
│   ├── development.md     # 개발 프로세스 가이드
│   ├── testing.md         # 테스트 작성 가이드
│   ├── deployment.md      # 배포 절차
│   └── code-review.md     # 코드 리뷰 체크리스트
├── api/
│   ├── README.md          # API 개요
│   └── endpoints.md       # 엔드포인트 명세 (또는 OpenAPI spec 참조)
├── adr/
│   ├── README.md          # ADR 목차 및 템플릿
│   ├── 001-framework.md
│   ├── 002-database.md
│   └── 003-auth-strategy.md
└── runbooks/
    ├── incident-response.md  # 장애 대응 절차
    └── rollback.md           # 롤백 절차
```

**핵심 포인트**:
- 주제별 디렉토리 분리 시작
- guides/ 디렉토리로 프로세스 문서화
- runbooks/ 디렉토리로 운영 절차 문서화
- API 문서는 자동 생성 도구(Swagger/OpenAPI)와 병행 권장

---

## 대규모 프로젝트 (10명+, 모노레포 또는 마이크로서비스)

```
docs/
├── README.md               # 전체 문서 탐색 가이드
├── getting-started.md      # 신규 팀원 온보딩
├── architecture/
│   ├── overview.md         # 시스템 전체 아키텍처
│   ├── data-flow.md        # 데이터 흐름 및 이벤트
│   ├── module-boundary.md  # 모듈/서비스 경계
│   ├── security.md         # 보안 아키텍처
│   └── infrastructure.md   # 인프라 구성
├── guides/
│   ├── development.md      # 개발 프로세스
│   ├── testing.md          # 테스트 전략 및 가이드
│   ├── deployment.md       # 배포 절차
│   ├── code-review.md      # 코드 리뷰 체크리스트
│   ├── contributing.md     # 기여 가이드
│   └── troubleshooting.md  # 자주 발생하는 문제 해결
├── api/
│   ├── README.md           # API 설계 원칙
│   ├── internal/           # 내부 API 명세
│   └── external/           # 외부 공개 API 명세
├── adr/
│   ├── README.md           # ADR 프로세스 및 템플릿
│   ├── 001-monorepo.md
│   ├── 002-event-driven.md
│   └── ...
├── runbooks/
│   ├── incident-response.md
│   ├── rollback.md
│   ├── scaling.md          # 스케일링 절차
│   └── data-migration.md   # 데이터 마이그레이션
└── rfcs/                   # 설계 제안서 (Request for Comments)
    ├── README.md
    └── 001-new-auth-system.md
```

**핵심 포인트**:
- rfcs/ 디렉토리로 큰 변경 사항의 논의 기록 관리
- API 내부/외부 분리
- 보안, 인프라 문서 별도 관리
- 자동화된 문서 생성 파이프라인 권장 (CI에서 docs 빌드)

---

## ADR (Architecture Decision Record) 템플릿

```markdown
# ADR-NNN: [제목]

## 상태

[제안됨 / 수락됨 / 폐기됨 / 대체됨(by ADR-XXX)]

## 맥락

어떤 문제를 해결해야 하는지, 왜 결정이 필요한지 설명.

## 결정

무엇을 결정했는지 명확히 기술.

## 결과

이 결정으로 인한 긍정적/부정적 영향.

## 대안

고려했으나 선택하지 않은 대안과 그 이유.
```

---

## 문서 관리 원칙

| 원칙 | 설명 |
|------|------|
| **코드 옆에 문서** | 문서를 코드와 같은 저장소에 관리. 외부 위키 최소화 |
| **DRY** | 같은 정보를 두 곳에 쓰지 않음. 참조 링크 사용 |
| **최신성 우선** | 오래된 문서는 없는 것보다 나쁨. 정기 점검 |
| **점진적 확장** | 소규모 구조에서 시작, 필요할 때 확장 |
| **자동 생성 활용** | API 문서, 타입 문서 등은 코드에서 자동 생성 |
