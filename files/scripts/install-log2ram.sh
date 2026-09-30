#!/usr/bin/env bash
set -euo pipefail

# renovate: datasource=github-releases depName=azlux/log2ram
LOG2RAM_VERSION="1.7.2"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL "https://github.com/azlux/log2ram/archive/refs/tags/${LOG2RAM_VERSION}.tar.gz" \
  | tar -xz --strip-components=1 -C "$tmpdir"

(
  cd "$tmpdir"
  bash ./install.sh
)