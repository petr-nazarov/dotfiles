# Dotfiles

A portable, automated configuration suite managed with **Stow**, powered by **Mise**, and validated by **Dagger**.

```bash
git clone git@github.com:petr-nazarov/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Usage

This repo uses **`just`** as the command runner for everyday tasks.

| Command | Description |
| :--- | :--- |
| `just sync` | Detects OS and symlinks all relevant config layers using GNU Stow. |
| `just unsync` | Safely removes symlinks without deleting config files. |
| `just sync-headless` | Symlinks only the headless (terminal) config layer. |
| `just sync-claude` | Symlinks only the Claude config layer. |
| `just fix` | Run linting and formatting on files. |
| `just ci` | Runs the Dagger pipeline (linting + secret scanning) locally. |

## Tech Stack

- **[Stow](https://www.gnu.org/software/stow/)**: Maps repo folders to `$HOME` via symlinks.
- **[Mise](https://mise.jdx.dev/)**: Manages tool dependencies (runtimes, CLIs, etc.).
- **[Just](https://github.com/casey/just)**: Task runner for common repo operations.
- **[Dagger](https://dagger.io/)**: Containerized CI/CD pipeline for secret scanning and linting.

## Structure

Configs are split into layers to stay platform-agnostic:

| Folder | Description |
| :--- | :--- |
| `_headless/` | Shell, `nvim`, `tmux`, and all other terminal configs. No GUI. Synced everywhere. |
| `_claude/` | Claude Code config (`~/.claude`). |
| `_common_gui/` | GUI configs that are cross-platform (e.g. `kitty`, `ghostty`). |
| `_linux_gui/` | Linux-only configs (e.g. Hyprland, `rofi`). |
| `_mac_gui/` | macOS-only configs (e.g. `yabai`, `skhd`). |

## Bootstrap (bare Arch system)

```bash
sudo pacman -S git openssh github-cli just stow mise zsh
gh auth login -s admin:public_key
gh repo clone dotfiles ~/dotfiles
cd ~/dotfiles
just sync
```

## Gotchas

- **Tmux plugins**: After syncing, open tmux and press `Ctrl+a` then `I` (capital I) to fetch plugins.
- **PATH**: Ensure `~/.local/bin` is in your `$PATH` to use the custom scripts.
- **Monitor config (Linux)**: `just sync` auto-links the correct `monitors.conf` based on hostname (`home-desktop` or `matebook`).
