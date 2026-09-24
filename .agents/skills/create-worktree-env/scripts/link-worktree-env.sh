#!/usr/bin/env bash

set -euo pipefail

ENV_NAMES=(.local.env .env .env.local .dev.vars)

usage() {
  cat <<'USAGE'
Symlink local environment files from a source checkout into a linked worktree.

Usage:
  link-worktree-env.sh --target PATH [options]

Required:
  --target PATH         Linked worktree to receive the symlinks

Options:
  --source PATH         Checkout that owns the env files
                        (default: the repository's main worktree)
  --dry-run             Print planned links without changing anything
  -h, --help            Show this help

Linked filenames:
  .local.env  .env  .env.local  .dev.vars

Files are discovered recursively under the source checkout. Their relative
paths are preserved in the target. Existing destinations are never
overwritten; each one is reported as a conflict and the script exits 2.
USAGE
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

source_arg=
target_arg=
dry_run=false

while (($# > 0)); do
  case "$1" in
    --source)
      (($# >= 2)) || die '--source requires a path'
      source_arg=$2
      shift 2
      ;;
    --target)
      (($# >= 2)) || die '--target requires a path'
      target_arg=$2
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ -n "$target_arg" ]] || die '--target is required'

if [[ -d "$target_arg" ]]; then
  target_path=$(cd "$target_arg" && pwd -P)
elif [[ "$dry_run" == true && -n "$source_arg" ]]; then
  # A dry run of create-worktree-with-env.sh plans links for a checkout that
  # does not exist yet.
  target_path=$target_arg
else
  die "target does not exist: $target_arg"
fi

# The first entry of `git worktree list` is always the main worktree, which is
# where untracked env files normally live.
if [[ -z "$source_arg" ]]; then
  source_arg=$(git -C "$target_path" worktree list --porcelain 2>/dev/null |
    sed -n '1s/^worktree //p') ||
    true
  [[ -n "$source_arg" ]] || die "cannot find the main worktree for: $target_path"
fi

source_root=$(git -C "$source_arg" rev-parse --show-toplevel 2>/dev/null) ||
  die "not a Git worktree: $source_arg"
source_root=$(cd "$source_root" && pwd -P)

[[ "$source_root" != "$target_path" ]] ||
  die 'source and target are the same checkout'

printf 'Source: %s\nTarget: %s\n' "$source_root" "$target_path"

linked=0
conflicts=0

while IFS= read -r -d '' source_file; do
  relative_path=${source_file#"$source_root"/}
  destination=$target_path/$relative_path

  if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'conflict: destination exists, not replaced: %s\n' "$destination" >&2
    conflicts=$((conflicts + 1))
    continue
  fi

  if [[ "$dry_run" == true ]]; then
    printf 'Would link: %s -> %s\n' "$destination" "$source_file"
  else
    mkdir -p "$(dirname "$destination")"
    ln -s "$source_file" "$destination"
    printf 'Linked: %s -> %s\n' "$destination" "$source_file"
  fi
  linked=$((linked + 1))
done < <(
  find "$source_root" \
    \( -path "$source_root/.git" -o -path '*/node_modules' -o -path '*/.pnpm-store' \) -prune -o \
    \( -type f -o -type l \) \
    \( -name "${ENV_NAMES[0]}" -o -name "${ENV_NAMES[1]}" -o -name "${ENV_NAMES[2]}" -o -name "${ENV_NAMES[3]}" \) \
    -print0
)

printf 'Environment links: %d created, %d conflict(s)\n' "$linked" "$conflicts"
if ((conflicts > 0)); then
  exit 2
fi
