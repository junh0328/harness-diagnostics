# harness-diagnostics

`harness-diagnostics`는 코드베이스와 Codex skill의 에이전트 친화도(harness)를 진단하고, 개선 방향을 제안하기 위한 독립 스킬 레포지토리입니다.

이 레포는 사람을 위한 안내 문서, 예시, 진단 기준, 보조 스크립트를 함께 제공합니다. 실제 에이전트 진입점은 [SKILL.md](/Users/junhee/playground/harness-diagnostics/SKILL.md)입니다.

## 이 레포의 목적

- 새 프로젝트에서 에이전트 협업 환경을 어떻게 시작할지 정리
- 기존 프로젝트의 harness 성숙도를 점수화하고 개선 로드맵 제안
- 시간이 지나며 생기는 문서/설정 drift를 점검
- 스킬 자기 자신도 같은 기준으로 진단

## README와 SKILL의 역할 차이

이 레포에는 `README.md`와 `SKILL.md`가 모두 존재합니다. 둘은 비슷해 보일 수 있지만 역할이 다릅니다.

- `README.md`
  사람용 진입점입니다. 이 레포가 무엇인지, 왜 존재하는지, 어떻게 활용하면 되는지, 어떤 파일이 들어있는지 설명합니다.
- `SKILL.md`
  에이전트용 진입점입니다. 짧고 구조화된 실행 지침, 모드, 참조 문서 포인터를 제공합니다.

즉, `README.md`는 이해를 돕는 문서이고, `SKILL.md`는 실제 실행을 위한 작업 명세입니다.

## 지원 모드

- `Setup`
  새 프로젝트에서 초기 harness 구조를 제안합니다.
- `Audit`
  현재 상태를 12개 원칙 기준으로 점수화하고 개선 로드맵을 제안합니다.
- `Maintenance`
  drift, stale 문서, 정리 대상 등을 점검합니다.
- `Self`
  이 스킬 자체를 같은 기준으로 다시 진단합니다.

## 레포 구조

- `SKILL.md`
  에이전트가 직접 읽는 진입점
- `references/`
  원칙, 성숙도 프레임워크, 워크플로우, 리포트 템플릿, 점수 계산 템플릿
- `examples/`
  Setup/Audit 예시 리포트와 샘플 `AGENTS.md`
- `scripts/`
  self-audit, 메타 동기화, 점수 계산 스크립트
- `logs/`
  self-audit 기록

## 사용 방식

Codex에서 이 스킬을 사용할 때는 `SKILL.md`를 기준으로 모드를 선택해 실행합니다.

예시:

```text
$harness-diagnostics self
```

```text
Setup: /path/to/project
```

```text
Audit: /path/to/project
```

## 로컬 검증

레포 루트에서 아래 명령으로 기본 검증을 실행할 수 있습니다.

```bash
bash scripts/self-audit.sh
bash scripts/update-self-meta.sh
node scripts/calculate-score.js references/score-template.json
```

## 버전 관리

이 레포는 `package.json` 없이 버전을 관리합니다. 기준 버전은 [SKILL.md](/Users/junhee/playground/harness-diagnostics/SKILL.md)의 frontmatter `version` 필드입니다.

운영 원칙:

- canonical version은 `SKILL.md`에만 둡니다.
- 사람이 읽는 변경 이력은 `CHANGELOG.md`에 기록합니다.
- 릴리즈 지점은 Git tag(`vX.Y.Z`)로 남깁니다.
- 관련 메타 문서가 있으면 버전 변경 후 함께 동기화합니다.

권장 흐름:

1. 기능/문서/스크립트 변경
2. `SKILL.md` version 업데이트
3. `CHANGELOG.md` 갱신
4. 메타 동기화 및 self-audit 실행
5. 커밋
6. `git tag vX.Y.Z`
7. 원격 push

## Source of Truth

이 레포는 `harness-diagnostics` 스킬의 독립 소스 저장소로 사용합니다. 다른 프로젝트나 로컬 skill 디렉토리에 복사된 버전이 있더라도, 기준은 이 레포를 우선합니다.
