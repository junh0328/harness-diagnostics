---
name: harness-diagnostics
description: |
  코드베이스와 Codex skill의 에이전트 친화도(harness)를 12개 원칙으로 진단하고 개선안을 제안합니다.
  사용 상황: 신규 환경 구축(Setup), 현 상태 점검(Audit), drift 정리(Maintenance), skill 품질 검사(Self).
version: 2.0.0
---

# 하니스 진단

에이전트 협업 환경의 성숙도를 평가하고 실행 가능한 리포트를 생성합니다.

## 핵심 원칙
1. **Read-only**: 기본 동작은 진단/제안만 수행
2. **Evidence-first**: 모든 판단은 파일 경로 근거 포함
3. **Principle-driven**: 12원칙 + 성숙도 프레임워크 기반 채점
4. **Self-referential**: 이 skill 자체도 동일 기준으로 진단 가능
## 모드 선택

| 모드 | 트리거 | 목적 | 깊이 | 워크플로우 |
|------|--------|------|------|-----------|
| **Setup** | 새 프로젝트, "환경 구축" | 초기 harness 구성 제안 | Standard | `references/setup-workflow.md` |
| **Audit** | "진단", "점검" | 점수화 + 개선 로드맵 | Quick/Standard/Deep | `references/audit-workflow.md` |
| **Maintenance** | "drift", "정리" | 변경 감지 + GC 제안 | Standard | `references/maintenance-workflow.md` |
| **Remediate** | "개선", "자동 수정", "loop" | Audit→Fix→Re-Audit 루프 | Standard/Deep | `references/remediate-workflow.md` |

깊이 프로필 상세는 `references/depth-profiles.md`를 참조한다.
Remediate 모드는 read-only 기본 원칙의 예외로, 명시적 사용자 동의 후에만 파일을 수정한다.
모드가 애매하면 사용자에게 확인한다.

## 권장 사용 흐름

초기 프로젝트에서 이 skill을 사용할 때는 다음 순서를 권장한다.

1. 프레임워크 공식 스캐폴드로 최소 프로젝트 생성
2. **Setup** 모드로 현재 레포 상태 진단
3. 사용자가 별도로 제공한 요구사항을 목표 상태 설계 입력으로 반영
4. Setup 리포트를 기준으로 `AGENTS.md`, `docs/`, lint/test/CI, 구조 규칙을 먼저 정리
5. 그 다음 실제 기능 구현 진행

예:
- Next.js: `npx create-next-app@latest ...` 이후 Setup 실행
- Python: `uv init` 또는 `poetry new` 이후 Setup 실행
- Go: `go mod init` 이후 Setup 실행
중요:
- Setup은 기본적으로 **read-only 진단/제안** 단계다.
- 사용자 요구사항은 **현재 상태의 근거**가 아니라 **목표 상태를 위한 설계 입력**으로 취급한다.
- 구현 요청이 함께 들어오더라도, 가능하면 먼저 Setup 리포트로 초기 harness 구조를 고정한 뒤 구현 단계로 넘어간다.

## 진단 대상

| 대상 | 판별 기준 | 체크리스트 |
|------|----------|-----------|
| **코드베이스** | git repo + 소스 존재 | `references/codebase-checklist.md` |
| **Skill** | `.codex/skills/*/SKILL.md` | `references/skill-checklist.md` |
| **Self** | 본 skill 자체 | `references/skill-checklist.md` |

## 12개 하니스 원칙

`references/principles.md`를 기준으로 P1~P12를 0-10점으로 평가한다.
P1 Agent Entry Point, P2 Map, P3 Invariant, P4 Convention, P5 Progressive Disclosure,
P6 Layered, P7 Garbage Collection, P8 Observability, P9 Knowledge, P10 Reproducibility, P11 Modularity, P12 Self-Documentation.

## 성숙도 등급

| 등급 | 점수 | 의미 |
|------|------|------|
| L1 | 0-19 | None |
| L2 | 20-39 | Basic |
| L3 | 40-59 | Structured |
| L4 | 60-79 | Optimized |
| L5 | 80-100 | Autonomous |

가중치/산식은 `references/maturity-framework.md`를 따른다.

## 실행 절차

1. 모드 결정
2. 대상 판별 (코드베이스/Skill/Self)
3. 해당 워크플로우 실행
4. `references/report-template.md` 형식으로 리포트 출력

## 자동화 도구

전체 스크립트/템플릿 목록은 `references/tools-index.md`를 참조한다.

핵심 검증 명령:
- `bash scripts/self-audit.sh` — 구조 + 런타임 통합 검증
- `bash scripts/adversarial-verify.sh` — 반증 기반 신뢰도 검증
- `node scripts/calculate-score.js references/score-template.json` — 점수 계산

## 참조 문서

| 파일 | 역할 |
|------|------|
| `references/principles.md` | 12원칙 판단 기준 |
| `references/maturity-framework.md` | 차원/가중치/점수 산식 |
| `references/codebase-checklist.md` | 코드베이스 체크리스트 (84항목) |
| `references/skill-checklist.md` | Skill 체크리스트 (51항목) |
| `references/setup-workflow.md` | Setup 워크플로우 |
| `references/audit-workflow.md` | Audit 워크플로우 |
| `references/maintenance-workflow.md` | Maintenance 워크플로우 |
| `references/verification-workflow.md` | 검증/로그 운영 워크플로우 |
| `references/report-template.md` | 리포트 출력 형식 |
| `references/remediate-workflow.md` | Remediate 워크플로우 |
| `references/fix-catalog.md` | 원칙별 개선 액션 카탈로그 |
| `references/contract-template.md` | Sprint Contract 형식 |
| `references/score-template.md` | 차원/종합 점수 계산 표 |
| `references/score-template.json` | 자동 계산 입력 스키마 |

## 예시

| 파일 | 내용 |
|------|------|
| `examples/sample-agents-md.md` | AGENTS.md 예시 |
| `examples/sample-setup-report.md` | Setup 리포트 예시 |
| `examples/sample-report.md` | Audit 리포트 예시 |
| `examples/sample-docs-structure.md` | 권장 docs 구조 |
