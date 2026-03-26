# GitHub 레포지토리용 AGENTS

이 문서는 `harness-diagnostics` GitHub 레포지토리를 수정하는 에이전트를 위한 운영 가이드다.
스킬 런타임 지침은 [SKILL.md](./SKILL.md), 사람용 설명은 [README.md](./README.md)를 기준으로 본다.

## 역할

- 이 standalone 레포는 `harness-diagnostics`의 source of truth다.
- `$HOME/.codex/skills/harness-diagnostics`는 배포 대상 복사본이며 직접 수정하지 않는다.
- 이 문서는 GitHub 레포지토리 운영용이다. issue, PR, CI, release sync 같은 저장소 작업 규칙을 다룬다.

## 시작 순서

- 스킬 런타임 계약은 [SKILL.md](./SKILL.md)에서 확인한다.
- 로컬 작업 전 [`.nvmrc`](./.nvmrc) 기준으로 Node 20을 맞추고 `bash scripts/install-hooks.sh`로 local pre-commit을 설치한다.
- 검증과 self 로그 운영 규칙은 [references/verification-workflow.md](./references/verification-workflow.md)에서 확인한다.
- 릴리즈와 동기화 흐름은 [README.md](./README.md)의 설치/동기화 및 버전 관리 섹션을 따른다.

## 작업 규칙

- `SKILL.md`는 짧고 map 지향적으로 유지하고, 상세 설명은 `references/`, `examples/`, `scripts/`로 내린다.
- 새 runtime 파일을 추가하면 `SKILL.md`, `README.md`, `scripts/sync-to-codex.sh`를 함께 갱신한다.
- 의미 있는 변경 뒤에는 반드시 로컬 검증을 수행하고 [logs/self-audit-log.md](./logs/self-audit-log.md)에 `skill-self` 요약을 남긴다.
- GitHub 템플릿과 workflow를 수정하면 `.codex` 복사본에서도 같은 self-audit가 통과하는지 확인한다.

## 필수 검증

레포 루트에서 아래 명령을 실행한다.

```bash
bash scripts/check-node-version.sh
bash scripts/self-audit.sh
bash scripts/maintenance-scan.sh
bash scripts/adversarial-verify.sh
node scripts/calculate-score.js references/score-template.json
```

릴리즈 동작이나 sync manifest를 수정했으면 아래도 실행한다.

```bash
bash scripts/release-sync.sh
```

## 릴리즈 절차

1. 문서, 스크립트, 템플릿을 함께 갱신한다.
2. `SKILL.md` version과 [CHANGELOG.md](./CHANGELOG.md)를 업데이트한다.
3. 검증 명령을 실행한다.
4. self 점수와 변경 메모를 [logs/self-audit-log.md](./logs/self-audit-log.md)에 기록한다.
5. 브랜치에서 커밋하고 PR을 생성한 뒤 체크 통과 후 머지한다.
