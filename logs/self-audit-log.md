# Self Audit 기록

| 날짜       | 버전   | 실행 유형  | 트리거                                            | 결과         | 점수 | 등급 | 메모                                                                                               |
| ---------- | ------ | ---------- | ------------------------------------------------- | ------------ | ---- | ---- | -------------------------------------------------------------------------------------------------- |
| 2026-03-23 | v1.8.0 | skill-self | Self guardrail refresh | PASS | 87.3 | L5 | 1.8.0: Node 20 runtime pin과 local pre-commit guardrail 추가, release-sync 및 .codex self-audit 통과 |
| 2026-03-23 | v1.8.0 | script | Release sync to .codex | PASS | - | - | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics |
| 2026-03-23 | v1.7.3 | skill-self | 직접 Self 실행 | PASS | 85.3 | L5 | 1.7.3: 링크 portable화, checklist self-consistency 추가, standalone/.codex release-sync self-audit 통과 |
| 2026-03-23 | v1.7.3 | script | Release sync to .codex | PASS | - | - | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics |
| 2026-03-23 | v1.7.2 | script     | Audit 예시 갱신                                   | PASS         | -    | -    | 1.7.2: 실제 Audit 샘플 반영과 audit example coverage 검증 추가                                      |
| 2026-03-10 | v1.7.1 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.7.1 | skill-self | 직접 Self 실행                                    | PASS         | 97   | L5   | 1.7.1 fallback 수정이 release-sync 이후 runtime copy에서도 통과                                    |
| 2026-03-06 | v1.7.1 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.7.1 | skill-self | 직접 Self 실행                                    | PASS         | 97   | L5   | 1.7.1: self-audit scripts에 rg 미설치 환경 fallback 추가                                           |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 96   | L5   | 한글화된 Markdown과 로그 파서 수정이 release-sync 이후 runtime copy에서도 통과                     |
| 2026-03-06 | v1.7.0 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 96   | L5   | 영문 Markdown 템플릿/샘플/워크플로우 섹션명을 한글로 정리하고 로그 헤더 파서를 보강                |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 96   | L5   | AGENTS.md를 한국어화하고 GitHub 레포지토리 운영용 문서 역할을 명시                                 |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 96   | L5   | OpenAI alignment 최종 반영: release-sync와 .codex runtime copy self-audit까지 통과                 |
| 2026-03-06 | v1.7.0 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 95   | L5   | OpenAI alignment 2차 반영: .codex sync manifest에 .github 포함, runtime copy self-audit 일치화     |
| 2026-03-06 | v1.7.0 | script     | Release sync to .codex                            | FAIL         | -    | -    | Sync failed before completion                                                                      |
| 2026-03-06 | v1.7.0 | skill-self | 직접 Self 실행                                    | PASS         | 94   | L5   | OpenAI alignment 1차 반영: AGENTS, verification workflow, self-audit 분리, CI/템플릿 추가          |
| 2026-03-06 | v1.6.0 | skill-self | 직접 Self 실행                                    | PASS         | 91   | L5   | standalone repo 기준 Self 평가 완료                                                                |
| 2026-03-06 | v1.6.0 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.5.0 | script     | Release sync to .codex                            | PASS         | -    | -    | Synchronized to /Users/junhee/.codex/skills/harness-diagnostics                                    |
| 2026-03-06 | v1.4.0 | script     | Setup 요구사항 분리 + Quick Wins 자동화 후 재평가 | PASS (40/40) | -    | -    | `sample-setup-report.md`, `update-self-meta.sh`, `calculate-score.js`, 확장된 `self-audit.sh` 반영 |
| 2026-03-03 | v1.3.0 | script     | Quick Wins 적용 후 재평가                         | PASS (40/40) | -    | -    | `scripts/self-audit.sh` 도입, 점수 템플릿/로그 추가                                                |

## 운영 규칙

- 최소 분기 1회 Self Audit 수행
- 구조 변경(references/examples/scripts/logs) 시 즉시 기록
- 점수 체계 변경 시 결과와 근거를 함께 남김
- 직접 `$harness-diagnostics self`를 실행한 경우 `skill-self` 타입으로 점수/등급 요약 기록
