#!/usr/bin/env bash
# Claude adapter: delegates to canonical tool-agnostic hook script.

set -euo pipefail
exec bash scripts/hooks/lint-and-format.sh
