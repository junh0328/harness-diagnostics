# harness-diagnostics

`harness-diagnostics` is a Codex skill for evaluating and improving agent-facing harness quality in codebases and skills.

It audits a target against 12 harness principles, supports `Setup`, `Audit`, `Maintenance`, and `Self` workflows, and includes templates, examples, and lightweight automation for self-checks.

## What this repo contains

- `SKILL.md`: the skill entry point
- `references/`: principles, workflows, templates, and scoring framework
- `examples/`: sample reports and sample `AGENTS.md`
- `scripts/`: self-audit and support scripts
- `logs/`: self-audit history

## Modes

- `Setup`: bootstrap harness structure for a new project
- `Audit`: score current harness maturity and produce a roadmap
- `Maintenance`: detect drift and propose cleanup
- `Self`: audit the skill itself

## Usage

Use this skill from Codex by referencing `SKILL.md` and invoking one of the modes above.

Example:

```text
$harness-diagnostics self
```

```text
Setup: /path/to/project
```

## Local validation

Run the built-in checks from the repo root:

```bash
bash scripts/self-audit.sh
bash scripts/update-self-meta.sh
node scripts/calculate-score.js references/score-template.json
```

## Source of truth

This repository is intended to be the standalone home for the `harness-diagnostics` skill.
