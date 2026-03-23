#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ROOT_DIR="$ROOT_DIR" node <<'EOF'
const fs = require("fs");
const path = require("path");

const root = process.env.ROOT_DIR;

function read(rel) {
  return fs.readFileSync(path.join(root, rel), "utf8");
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

const skill = read("SKILL.md");
const readme = read("README.md");
const changelog = read("CHANGELOG.md");
const agents = read("AGENTS.md");
const syncScript = read("scripts/sync-to-codex.sh");
const prTemplate = read(".github/pull_request_template.md");
const skillVersionMatch = skill.match(/^version:\s*([0-9.]+)$/m);

assert(skillVersionMatch, "SKILL.md must declare a version");

const skillVersion = skillVersionMatch[1];

const requiredFiles = [
  "AGENTS.md",
  ".github/workflows/self-audit.yml",
  ".github/workflows/docs-consistency.yml",
  ".github/ISSUE_TEMPLATE/harness-improvement.yml",
  ".github/pull_request_template.md",
  "references/verification-workflow.md",
  "scripts/self-audit-structure.sh",
  "scripts/self-audit-runtime.sh",
  "scripts/doc-lint.sh",
  "scripts/maintenance-scan.sh",
];

for (const rel of requiredFiles) {
  assert(fs.existsSync(path.join(root, rel)), `Missing required file: ${rel}`);
}

assert(skill.includes("references/verification-workflow.md"), "SKILL.md must reference verification-workflow.md");
assert(readme.includes("verification-workflow.md"), "README.md must mention verification-workflow.md");
assert(readme.includes("AGENTS.md"), "README.md must mention AGENTS.md");
assert(agents.includes("source of truth"), "AGENTS.md must state source of truth policy");
assert(changelog.includes(`## [${skillVersion}]`), `CHANGELOG.md must include current version ${skillVersion}`);
assert(prTemplate.includes("하니스 Self"), "PR template must include 하니스 Self section");
assert(prTemplate.includes("logs/self-audit-log.md"), "PR template must mention self-audit log");

for (const rel of [".github", "AGENTS.md", "README.md", "CHANGELOG.md"]) {
  assert(syncScript.includes(`"${rel}"`), `sync-to-codex.sh must sync ${rel}`);
}

const referenceFiles = fs.readdirSync(path.join(root, "references")).sort();
for (const file of referenceFiles) {
  assert(skill.includes(`references/${file}`), `SKILL.md is missing reference pointer for references/${file}`);
}

const exampleFiles = fs.readdirSync(path.join(root, "examples")).sort();
for (const file of exampleFiles) {
  assert(skill.includes(`examples/${file}`), `SKILL.md is missing example pointer for examples/${file}`);
}

function assertLocalLinksResolve(relPath) {
  const content = read(relPath);
  const baseDir = path.dirname(path.join(root, relPath));
  const linkPattern = /\[[^\]]+\]\(([^)]+)\)/g;

  for (const match of content.matchAll(linkPattern)) {
    const rawTarget = match[1].trim();
    if (!rawTarget || rawTarget.startsWith("#") || /^(https?:|mailto:)/.test(rawTarget)) {
      continue;
    }

    const [fileTarget] = rawTarget.split("#");
    if (!fileTarget) {
      continue;
    }

    const resolved = path.isAbsolute(fileTarget)
      ? fileTarget
      : path.resolve(baseDir, fileTarget);

    assert(fs.existsSync(resolved), `${relPath} has a broken local link: ${rawTarget}`);
  }
}

for (const rel of ["AGENTS.md", "README.md"]) {
  assertLocalLinksResolve(rel);
}

console.log("[doc-lint] PASS");
EOF
