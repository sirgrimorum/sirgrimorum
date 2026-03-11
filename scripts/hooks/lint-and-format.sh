#!/usr/bin/env bash
# Canonical post-edit format hook. Keep this tool-agnostic and best-effort.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.mjs|*.jsx)
    npx eslint --fix "$FILE_PATH" >/dev/null 2>&1 || true
    npx prettier --write "$FILE_PATH" >/dev/null 2>&1 || true
    ;;
  *.json|*.md|*.yml|*.yaml|*.css|*.html)
    npx prettier --write "$FILE_PATH" >/dev/null 2>&1 || true
    ;;
esac

exit 0
