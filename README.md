# dotfiles

Configs for Neovim, [Herdr](https://herdr.dev),
[Ghostty](https://ghostty.org), and portable Agent Skills.

```
nvim/     -> ~/.config/nvim          (symlinked directory)
ghostty/  -> ~/.config/ghostty       (symlinked directory)
herdr/    -> ~/.config/herdr/config.toml only
.agents/skills/create-worktree-env/
           -> ~/.agents/skills/create-worktree-env
           -> ~/.config/agents/skills/create-worktree-env
           -> ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/create-worktree-env
           -> ${CODEX_HOME:-~/.codex}/skills/create-worktree-env
           -> ~/.config/opencode/skills/create-worktree-env
```

## Setup

```bash
git clone https://github.com/chtushar/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is idempotent — re-running it leaves correct symlinks in place and
backs up anything it would otherwise overwrite as `<name>.backup.<timestamp>`.

Only `config.toml` is symlinked for Herdr: the rest of `~/.config/herdr` is
runtime state (sockets, logs, `session.json`, installed plugin checkouts) that
does not belong in version control.

Skills use the open Agent Skills `SKILL.md` format and live under the neutral
`.agents/skills` convention. They are linked individually, so built-in and
separately installed skills remain untouched. To expose them globally to every
client supported by the [Skills CLI](https://github.com/vercel-labs/skills), run:

```bash
npx skills add ~/dotfiles --global --all
```

## Dependencies

| What | Why | Install |
| --- | --- | --- |
| [fzf](https://github.com/junegunn/fzf) | fzf-lua file/buffer search | `brew install fzf` |
| [Herdr](https://herdr.dev) ≥ 0.7.0 | terminal multiplexer; plugin actions | `brew install herdr` |
| herdr-splits (Herdr plugin) | Herdr side of the split navigation | `herdr plugin install lmilojevicc/herdr-splits.nvim` |

Neovim plugins bootstrap themselves — lazy.nvim installs itself on first launch
and pins versions from `nvim/lazy-lock.json`.

After changing `herdr/config.toml`, apply it with `herdr server reload-config`.

## Keybindings

Leader is `<Space>`, local leader is `\`.

### Navigation and windows

| Key | Action |
| --- | --- |
| `<C-p>` | Find files |
| `<C-q>` | Find buffers |
| `<C-h/j/k/l>` | Move between windows — and Herdr panes, inside a Herdr session |
| `<M-h/j/k/l>` | Resize window or Herdr pane |
| `<C-,>` / `<C-.>` | Shrink / grow split width by 1 column |
| `<leader>e` | Toggle file tree |

### Git

| Key | Action |
| --- | --- |
| `<leader>gt` | Changed files (git status tree) |
| `<leader>gd` | Preview hunk diff |
| `<leader>gb` | Full blame for current line |

Inside the git status tree: `ga` stage file, `gu` unstage file, `A` stage all.

### Coding agents

| Key | Action |
| --- | --- |
| `<leader>ac` | Toggle Claude Code |
| `<leader>ax` | Toggle Codex |
| `<leader>ao` | Toggle OpenCode |
| `<leader>as` | Send visual selection to active agent |
| `<Esc><Esc>` | Exit terminal mode (single `<Esc>` passes through to the agent) |

## Notes

Split navigation and resizing are unified across Neovim and Herdr by
[herdr-splits.nvim](https://github.com/lmilojevicc/herdr-splits.nvim). The
Neovim plugin is gated on `HERDR_ENV == "1"`, so outside a Herdr session
`<C-h/j/k/l>` fall back to plain Neovim window moves.

Ghostty sets `macos-option-as-alt = true` so `<M-hjkl>` reaches Herdr and
Neovim. The tradeoff is that Option no longer types composed characters
(`ø`, `å`, ...).

`nvim/decisions.log` records why things are the way they are — read it before
changing something that looks arbitrary.
