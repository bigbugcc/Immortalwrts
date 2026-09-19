#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-master}"
CLONE_DIR="${1:-openwrt}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_URL="$(node "$ROOT_DIR/scripts/openwrts.mjs" source-url)"

if [ -d "$CLONE_DIR" ]; then
  echo "Error: directory '$CLONE_DIR' already exists." >&2
  exit 1
fi

echo "Cloning ImmortalWrt branch $UPSTREAM_BRANCH from $UPSTREAM_URL"
git clone --depth 1 --branch "$UPSTREAM_BRANCH" "$UPSTREAM_URL" "$CLONE_DIR"
