#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVMRC_FILE="$ROOT_DIR/.nvmrc"

if [ ! -f "$NVMRC_FILE" ]; then
  echo "[node-version] FAIL: missing .nvmrc"
  exit 1
fi

REQUIRED_RAW="$(tr -d '[:space:]' < "$NVMRC_FILE")"
REQUIRED="${REQUIRED_RAW#v}"
REQUIRED_MAJOR="${REQUIRED%%.*}"

if [ -z "$REQUIRED_MAJOR" ]; then
  echo "[node-version] FAIL: .nvmrc must declare a Node version"
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[node-version] FAIL: node is not installed"
  echo "[node-version] Use the version declared in .nvmrc before running repository scripts."
  exit 1
fi

INSTALLED_RAW="$(node -v)"
INSTALLED="${INSTALLED_RAW#v}"
INSTALLED_MAJOR="${INSTALLED%%.*}"

if [ "$INSTALLED_MAJOR" != "$REQUIRED_MAJOR" ]; then
  echo "[node-version] FAIL: expected Node major $REQUIRED_MAJOR from .nvmrc, found $INSTALLED_RAW"
  echo "[node-version] If you use nvm: source ~/.nvm/nvm.sh && nvm install $REQUIRED_RAW && nvm use $REQUIRED_RAW"
  exit 1
fi

echo "[node-version] PASS: $INSTALLED_RAW matches .nvmrc"
