
# My dotfiles 
This dotfiles uses stow to create symlinks. 
```sh
git clone  git@github.com:petr-nazarov/dotfiles.git
```
## Use:
```bash
just sync # syncs the dotfiles
just unsync # unsync dotfiles

```
## Tec stack:
- mise to install required dependencies
- just to run simple commands
- stow to symlinks
## Structure:
- '_common' - the content of this folder will be linked to your home repo. Platform independent configs are stored here.
- '_linux' - the content of this folder will be linked to your home repo. Only configs specific to linux os will be stored here
- '_macos' - the content of this folder will be linked to your home repo. Only configs specific to MacOS os will be stored here
## Gotchas
- Dont forget to install tmux plugins In tmux click `ctrl+a I`






# 🛠️ Dotfiles 

A portable, automated configuration suite managed with **Stow**, powered by **Mise**, and validated by **Dagger**.

```bash
git clone git@github.com:petr-nazarov/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

## 🚀 Usage

This repo uses **`just`** as the command runner for everyday tasks.

| Command | Description |
| :--- | :--- |
| `just sync` | Automatically detects OS and symlinks relevant configs using GNU Stow. |
| `just unsync` | Safely removes symlinks without deleting config files. |
| `just fix` | Run linting and formatting on files |
| `just ci` | Runs the Dagger pipeline (Linting + Secret Scanning) locally. |

---

## 🛠️ Tech Stack

* **[Stow](https://www.gnu.org/software/stow/)**: Manages symlink  to map repo folders to `$HOME`.
* **[Mise](https://mise.jdx.dev/)**: Manages dependencies, like linters, formatters, etc.
* **[Just](https://github.com/casey/just)**: Tool to run tasks from the repo.
* **[Dagger](https://dagger.io/)**: Containerized CI/CD pipeline for secret scanning and linting.

---

## 📂 Structure

The configuration is split into layers to remain platform-agnostic:

* **`_common/`**: Shell aliases, `nvim`, `tmux`, and other cross-platform configs.
* **`_linux/`**: Linux-specific tools (e.g., `hyperland`).
* **`_macos/`**: Mac-specific settings (e.g., `skhd`, `yabai` ).


---

## ⚠️ Gotchas

* **Tmux Plugins**: After syncing, open tmux and press `Ctrl + a` followed by `I` (capital I) to fetch plugins.
* **Pathing**: Ensure `~/.local/bin` is in your `$PATH` to use the custom scripts.
