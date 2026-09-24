#!/usr/bin/env bash

set -euo pipefail


usage() {
  cat <<'EOF'
Create a Git linked worktree and symlink local environment files into it.

Usage:
  create-worktree-with-env.sh --branch BRANCH --path PATH [options]

Required:
  --branch BRANCH       Branch to create or check out
  --path PATH           Destination path for the linked worktree

Options:
  --source PATH         Source repository/worktree (default: current directory)
  --start-point REF     Start point for a new branch (default: HEAD)
  --existing            Check out an existing branch instead of creating it
  --dry-run             Print planned actions without changing anything
  -h, --help            Show this help

Linked filenames:
  .local.env  .env  .env.local  .dev.vars

Files are discovered recursively under the source repository. Their relative
paths are preserved in the new worktree. Existing destinations are never
overwritten.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

source_arg=.
branch=
target_arg=
start_point=HEAD
existing=false
dry_run=false

while (($# > 0)); do
  case "$1" in
    --source)
      (($# >= 2)) || die '--source requires a path'
      source_arg=$2
      shift 2
      ;;
    --branch)
      (($# >= 2)) || die '--branch requires a value'
      branch=$2
      shift 2
      ;;
    --path)
      (($# >= 2)) || die '--path requires a value'
      target_arg=$2
      shift 2
      ;;
    --start-point)
      (($# >= 2)) || die '--start-point requires a ref'
      start_point=$2
      shift 2
      ;;
    --existing)
      existing=true
      shift
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

[[ -n "$branch" ]] || die '--branch is required'
[[ -n "$target_arg" ]] || die '--path is required'

source_root=$(git -C "$source_arg" rev-parse --show-toplevel 2>/dev/null) ||
  die "not a Git worktree: $source_arg"
source_root=$(cd "$source_root" && pwd -P)

target_parent_arg=$(dirname "$target_arg")
target_name=$(basename "$target_arg")
[[ "$target_name" != . && "$target_name" != .. && "$target_name" != / ]] ||
  die "invalid target path: $target_arg"

if [[ "$dry_run" == true ]]; then
  target_parent=$(cd "$target_parent_arg" 2>/dev/null && pwd -P) ||
    die "dry-run requires the target parent to exist: $target_parent_arg"
else
  mkdir -p "$target_parent_arg"
  target_parent=$(cd "$target_parent_arg" && pwd -P)
fi
target_path=$target_parent/$target_name

case "$target_path/" in
  "$source_root/"*) die 'target path must be outside the source worktree' ;;
esac

if [[ -e "$target_path" || -L "$target_path" ]]; then
  die "target already exists: $target_path"
fi

if [[ "$existing" == true ]]; then
  git -C "$source_root" show-ref --verify --quiet "refs/heads/$branch" ||
    die "local branch does not exist: $branch"
  worktree_command=(git -C "$source_root" worktree add "$target_path" "$branch")
else
  git -C "$source_root" show-ref --verify --quiet "refs/heads/$branch" &&
    die "local branch already exists; use --existing: $branch"
  git -C "$source_root" rev-parse --verify --quiet "$start_point^{commit}" >/dev/null ||
    die "start point is not a commit: $start_point"
  worktree_command=(git -C "$source_root" worktree add -b "$branch" "$target_path" "$start_point")
fi

printf 'Source: %s\nTarget: %s\nBranch: %s\n' "$source_root" "$target_path" "$branch"

if [[ "$dry_run" == true ]]; then
  printf 'Would run:'
  printf ' %q' "${worktree_command[@]}"
  printf '\n'
else
  "${worktree_command[@]}"
fi

link_command=("$(dirname "${BASH_SOURCE[0]}")/link-worktree-env.sh" --source "$source_root" --target "$target_path")
if [[ "$dry_run" == true ]]; then
  link_command+=(--dry-run)
fi
exec "${link_command[@]}"
