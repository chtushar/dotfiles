#!/usr/bin/env bash
# Symlink configs from this repo into ~/.config. Safe to re-run: existing
# symlinks pointing here are left alone, anything else is backed up first.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
CODEX="${CODEX_HOME:-$HOME/.codex}"
CLAUDE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
    local src="$1" dest="$2"

    if [ ! -e "$src" ]; then
        echo "skip    $dest (missing $src)"
        return
    fi

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "ok      $dest"
            return
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        mv "$dest" "$dest.backup.$STAMP"
        echo "backup  $dest -> $dest.backup.$STAMP"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "link    $dest -> $src"
}

brew install fzf herdr || true
herdr plugin install lmilojevicc/herdr-splits.nvim --yes || true

link "$DOTFILES/nvim" "$CONFIG/nvim"
link "$DOTFILES/ghostty" "$CONFIG/ghostty"

# Herdr keeps runtime state in its config dir (sockets, logs, session.json,
# installed plugin checkouts), so only config.toml is linked — not the dir.
mkdir -p "$CONFIG/herdr"
link "$DOTFILES/herdr/config.toml" "$CONFIG/herdr/config.toml"

# Keep one agent-neutral skill implementation and expose it through the global
# locations used by the universal Agent Skills convention and our primary
# clients. Other Agent Skills-compatible clients can install the same source
# with: npx skills add "$DOTFILES" --global --all
SKILL="$DOTFILES/.agents/skills/create-worktree-env"
link "$SKILL" "$HOME/.agents/skills/create-worktree-env"
link "$SKILL" "$CONFIG/agents/skills/create-worktree-env"
link "$SKILL" "$CLAUDE/skills/create-worktree-env"
link "$SKILL" "$CODEX/skills/create-worktree-env"
link "$SKILL" "$CONFIG/opencode/skills/create-worktree-env"
