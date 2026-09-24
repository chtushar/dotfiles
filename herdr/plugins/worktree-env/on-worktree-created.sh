#!/usr/bin/env bash
# Runs on worktree.created. Reuses the create-worktree-env skill's linker so
# worktrees made by Herdr and by agents get identical env symlinks.

set -euo pipefail

# The plugin is linked from the dotfiles checkout, so the skill sits at a fixed
# path relative to it.
linker="$HERDR_PLUGIN_ROOT/../../../.agents/skills/create-worktree-env/scripts/link-worktree-env.sh"

target=$(jq -r '[.. | objects | .worktree? | objects | .path? | strings] | first // empty' \
  <<<"${HERDR_PLUGIN_EVENT_JSON:-}")

if [[ -z "$target" ]]; then
  printf 'error: no worktree path in event payload: %s\n' "${HERDR_PLUGIN_EVENT_JSON:-}" >&2
  exit 1
fi

exec "$linker" --target "$target"
