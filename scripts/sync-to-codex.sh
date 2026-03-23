#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-${CODEX_SKILL_TARGET:-$HOME/.codex/skills/harness-diagnostics}}"

mkdir -p "$TARGET_DIR"

ROOT_DIR="$ROOT_DIR" TARGET_DIR="$TARGET_DIR" node <<'EOF'
const fs = require("fs");
const path = require("path");

const root = process.env.ROOT_DIR;
const target = process.env.TARGET_DIR;
const managedPaths = [
  ".github",
  ".githooks",
  ".nvmrc",
  "AGENTS.md",
  "README.md",
  "CHANGELOG.md",
  "SKILL.md",
  "examples",
  "references",
  "scripts",
  "logs",
];

for (const rel of managedPaths) {
  const src = path.join(root, rel);
  const dst = path.join(target, rel);
  if (!fs.existsSync(src)) {
    continue;
  }

  fs.rmSync(dst, { recursive: true, force: true });
  fs.cpSync(src, dst, { recursive: true });
}
EOF

echo "[sync-to-codex] synced to: $TARGET_DIR"
