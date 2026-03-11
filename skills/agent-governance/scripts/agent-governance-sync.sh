#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  agent-governance-sync.sh bootstrap [options]

Modes:
  bootstrap   Copy missing governance files from bundled skill template

Options:
  --target <path>      Target repository root (default: current git root or cwd)
  --template <path>    Template directory override (default: bundled skill template)
  --dry-run            Show operations without writing changes
  --quiet              Reduce output
  -h, --help           Show help

Examples:
  ./agent-governance-sync.sh bootstrap
  ./agent-governance-sync.sh bootstrap --target /path/to/repo
  ./agent-governance-sync.sh bootstrap --dry-run
USAGE
}

MODE="${1:-}"
if [[ -z "$MODE" || "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  usage
  exit 0
fi
shift || true

if [[ "$MODE" != "bootstrap" ]]; then
  echo "Unsupported mode: $MODE" >&2
  echo "Use skill-guided workflows for adapt/upgrade/finalize." >&2
  usage
  exit 1
fi

TARGET=""
TEMPLATE=""
DRY_RUN=0
QUIET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="$2"
      shift 2
      ;;
    --template)
      TEMPLATE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --quiet)
      QUIET=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

log() {
  if [[ "$QUIET" -eq 0 ]]; then
    echo "$*"
  fi
}

resolve_target() {
  if [[ -n "$TARGET" ]]; then
    TARGET="$(cd "$TARGET" && pwd)"
    return
  fi

  if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    TARGET="$git_root"
  else
    TARGET="$(pwd)"
  fi
}

resolve_template() {
  if [[ -n "$TEMPLATE" ]]; then
    TEMPLATE="$(cd "$TEMPLATE" && pwd)"
    return
  fi

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local bundled
  bundled="$(cd "$script_dir/.." && pwd)/assets/project-bootstrap-template"

  if [[ -d "$bundled" ]]; then
    TEMPLATE="$bundled"
    return
  fi

  echo "Bundled template not found at: $bundled" >&2
  echo "Provide --template explicitly." >&2
  exit 1
}

bootstrap_missing() {
  if ! command -v rsync >/dev/null 2>&1; then
    echo "rsync is required for bootstrap." >&2
    exit 1
  fi

  local dry_flag=""
  if [[ "$DRY_RUN" -eq 1 ]]; then
    dry_flag="-n"
  fi

  rsync -a ${dry_flag} --ignore-existing --exclude ".DS_Store" "$TEMPLATE/" "$TARGET/"
}

main() {
  resolve_target
  resolve_template

  log "target: ${TARGET}"
  log "template: ${TEMPLATE}"

  bootstrap_missing

  log "Bootstrap complete (missing files only)."
}

main
