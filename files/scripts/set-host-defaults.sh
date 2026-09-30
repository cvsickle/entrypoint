#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "entrypoint" > /etc/hostname
ln -snf /usr/share/zoneinfo/America/New_York /etc/localtime