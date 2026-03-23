#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ROOT_DIR="$ROOT_DIR" node <<'EOF'
const fs = require("fs");
const path = require("path");

const root = process.env.ROOT_DIR;
const skill = fs.readFileSync(path.join(root, "SKILL.md"), "utf8");
const readme = fs.readFileSync(path.join(root, "README.md"), "utf8");
const agents = fs.readFileSync(path.join(root, "AGENTS.md"), "utf8");
const syncScript = fs.readFileSync(path.join(root, "scripts", "sync-to-codex.sh"), "utf8");

let failed = false;

function scan(dir, matcher, owner) {
  const names = fs.readdirSync(path.join(root, dir)).sort();
  for (const name of names) {
    const rel = `${dir}/${name}`;
    if (!matcher(rel, name, owner)) {
      failed = true;
      console.error(`[maintenance] ORPHAN: ${rel}`);
    } else {
      console.log(`[maintenance] PASS: ${rel}`);
    }
  }
}

scan("references", (rel) => skill.includes(rel), "SKILL");
scan("examples", (rel) => skill.includes(rel), "SKILL");
scan("scripts", (rel, name) => skill.includes(rel) || ["sync-to-codex.sh"].includes(name), "SKILL");
scan("logs", (rel) => skill.includes(rel) || readme.includes(rel), "README");
scan(".githooks", () => readme.includes("scripts/install-hooks.sh") || agents.includes("scripts/install-hooks.sh"), "README/AGENTS");

if (!readme.includes(".nvmrc") && !agents.includes(".nvmrc")) {
  failed = true;
  console.error("[maintenance] ORPHAN: .nvmrc");
} else {
  console.log("[maintenance] PASS: .nvmrc");
}

for (const rel of [".github", ".githooks", ".nvmrc", "AGENTS.md", "README.md", "CHANGELOG.md", "SKILL.md"]) {
  if (!syncScript.includes(`"${rel}"`)) {
    failed = true;
    console.error(`[maintenance] UNSYNCED: ${rel}`);
  } else {
    console.log(`[maintenance] PASS: sync manifest includes ${rel}`);
  }
}

if (failed) {
  process.exit(1);
}

console.log("[maintenance] PASS");
EOF
