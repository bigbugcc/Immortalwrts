#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENWRT_DIR="${OPENWRT_DIR:-openwrt}"
TARGET_CONFIG="${TARGET_CONFIG:-}"
APP_CONFIG="${APP_CONFIG:-}"

resolve_config() {
  local path="$1"
  [ -n "$path" ] || { echo "A configuration path is required." >&2; exit 1; }
  if [ -f "$path" ]; then printf '%s\n' "$path"; return; fi
  if [ -f "$ROOT_DIR/$path" ]; then printf '%s\n' "$ROOT_DIR/$path"; return; fi
  echo "Configuration file not found: $path" >&2
  exit 1
}

if [ ! -d "$OPENWRT_DIR" ] && [ -d "$ROOT_DIR/$OPENWRT_DIR" ]; then
  OPENWRT_DIR="$ROOT_DIR/$OPENWRT_DIR"
fi

TARGET_CONFIG_PATH="$(resolve_config "$TARGET_CONFIG")"
APP_CONFIG_PATH="$(resolve_config "$APP_CONFIG")"

if [ -d "$ROOT_DIR/files" ]; then
  mkdir -p "$OPENWRT_DIR/files"
  cp -R "$ROOT_DIR/files/." "$OPENWRT_DIR/files/"
fi

cat "$TARGET_CONFIG_PATH" "$APP_CONFIG_PATH" > "$OPENWRT_DIR/.config"
cd "$OPENWRT_DIR"
make defconfig

# Do not let upstream's LuCI default selections re-enable apps explicitly disabled here.
awk '
  /^CONFIG_DEFAULT_luci[^=]*=/ { sub(/=.*/, "", $0); print "# " $0 " is not set"; next }
  { print }
' .config > .config.tmp
mv .config.tmp .config
make defconfig
cat .config
