#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Pre-cache stitch-mcp so it's available without downloading each time
npx --yes @_davideast/stitch-mcp --help > /dev/null 2>&1 || true
