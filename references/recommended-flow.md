# 권장 사용 흐름

> 초기 프로젝트에서 이 skill을 사용할 때 권장하는 순서.

---

## 기본 흐름

1. 프레임워크 공식 스캐폴드로 최소 프로젝트 생성
2. **Setup** 모드로 현재 레포 상태 진단
3. 사용자가 별도로 제공한 요구사항을 목표 상태 설계 입력으로 반영
4. Setup 리포트를 기준으로 `AGENTS.md`, `docs/`, lint/test/CI, 구조 규칙을 먼저 정리
5. 그 다음 실제 기능 구현 진행

## 프레임워크별 예시

- Next.js: `npx create-next-app@latest ...` 이후 Setup 실행
- Python: `uv init` 또는 `poetry new` 이후 Setup 실행
- Go: `go mod init` 이후 Setup 실행

## 주의사항

- Setup은 기본적으로 **read-only 진단/제안** 단계다.
- 사용자 요구사항은 **현재 상태의 근거**가 아니라 **목표 상태를 위한 설계 입력**으로 취급한다.
- 구현 요청이 함께 들어오더라도, 가능하면 먼저 Setup 리포트로 초기 harness 구조를 고정한 뒤 구현 단계로 넘어간다.
