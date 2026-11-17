#!/usr/bin/env bash
set -euo pipefail

case "${1:?select a source check}" in
  syntax)
    find scripts -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
    bash -n install-macos.sh
    ;;
  shell)
    find scripts -type f -name '*.sh' -print0 |
      xargs -0 -n1 shellcheck -x -e SC1090,SC1091,SC2034,SC2086
    shellcheck -x -e SC1090,SC1091,SC2034,SC2086 install-macos.sh
    ;;
  links-offline)
    git ls-files -z -- '*.md' | xargs -0 lychee --offline --no-progress
    ;;
  links)
    git ls-files -z -- '*.md' | xargs -0 lychee --no-progress --max-concurrency 8
    ;;
  *)
    echo "Unknown source check: $1" >&2
    exit 2
    ;;
esac
