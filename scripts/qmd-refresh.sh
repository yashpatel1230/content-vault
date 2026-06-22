#!/usr/bin/env bash
# Refresh the qmd local-search index: re-scan collections, embed only the delta.
# Safe to run any time. The auto-sync post-commit hook calls this in the
# background; run scripts/qmd-setup.sh first to create collections + the hook.
set -euo pipefail

if ! command -v qmd >/dev/null 2>&1; then
  echo "qmd not found on PATH. Run scripts/qmd-setup.sh first." >&2
  exit 127
fi

qmd update   # re-scan collections; detect new/changed/removed by content hash
qmd embed    # vectorize only the delta ('qmd embed -f' forces a full rebuild)
