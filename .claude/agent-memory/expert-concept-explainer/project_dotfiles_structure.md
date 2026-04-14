---
name: Dotfiles project structure
description: Architecture and layout of the /home/nazarov/dotfiles repo — GNU Stow symlink farm with OS-layered directories
type: project
---

The dotfiles repo uses GNU Stow as a symlink farm manager. Three content directories mirror `$HOME` structure and are stowed into it on demand.

**Directory layout:**
- `_common/` — cross-platform configs (zsh, nvim, tmux, kitty, ghostty, mise, starship, yazi, SSH, git, custom scripts, Claude state)
- `_linux/` — Linux-only configs (Hyprland, Waybar, swaync, tofi, walker)
- `_mac/` — macOS-only configs (yabai, skhd)

**Toolchain:**
- `just` — task runner (`sync`, `unsync`, `lint`, `format`, `fix`, `ci`)
- GNU Stow — `stow -t "$HOME" <dir>` / `stow -D -t "$HOME" <dir>` for install/remove
- `mise` — manages all dev tool versions (stylua, taplo, yamllint, shfmt, prettier, node, python, dagger, etc.)
- `pre-commit` — two hooks: gitleaks (secret scanning) + `just fix` (lint + format)
- Dagger — containerized CI pipeline for linting and secret scanning

**Sync is OS-conditional in justfile** using `[linux]` / `[macos]` attributes — same `sync`/`unsync` recipe names, different stow targets.

**Notable contents in `_common/`:**
- `.config/nvim/` — Neovim config with lazy.nvim, LSP, cmp, fzf-lua, treesitter, gitsigns, neogit
- `.config/zsh/` — modular zsh config (aliases, bindings, plugins, theme, variables, settings)
- `.local/bin/` — custom scripts including ai_bat, ai_codegen, ai_git, unfabric, sunshine stream scripts
- `.config/fabric_custom_patterns/` — fabric AI prompt patterns
- `.claude/` — Claude Code state (projects, history, agents, keybindings) — this is version-controlled

**Why:** Enables bootstrapping a fresh Arch or macOS machine with one `just sync`. Platform split avoids conditional logic inside configs.
