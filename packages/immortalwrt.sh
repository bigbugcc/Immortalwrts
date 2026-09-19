#!/usr/bin/env bash
set -euo pipefail

clone_package() {
  local repo_url="$1"
  local dest="$2"

  if [ -d "$dest" ]; then
    echo "Package path already exists, skipping: $dest"
    return
  fi

  git clone --depth 1 "$repo_url" "$dest"
}

mkdir -p package/otherapp

# 自定义软件包
# clone_package https://github.com/vernesong/OpenClash.git package/luci-app-openclash
