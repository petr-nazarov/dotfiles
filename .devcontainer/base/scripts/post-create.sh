#!/bin/zsh

echo "🚀 Applying post-create scripts..."

echo "🔑 Fixing ~/.ssh ownership..."
# ~/.ssh is auto-created by docker (root-owned) since only individual files
# inside it are bind-mounted, not the directory itself — without this,
# vscode can't write known_hosts and gets re-prompted every session
sudo chown vscode:vscode ~/.ssh

echo "🔑 Fixing ~/.config ownership..."
# Same story as ~/.ssh: bind-mounting ~/.config/ccstatusline makes docker
# auto-create the ~/.config parent as root, which would then make the
# _headless stow run (which writes ~/.config/zsh, ~/.config/mise, …) fail
sudo chown vscode:vscode ~/.config

echo "🔧 Applying dotfiles..."
# apply dotfiles
(
	.devcontainer/base/scripts/apply-dotfiles.sh
) || true

# install claude
echo "🤖 Installing Claude CLI..."
curl -fsSL https://claude.ai/install.sh | bash

# The Claude hooks ring the pane so tmux on the host flags the window. The hook
# script normally arrives via the ~/dotfiles mount (stowed to ~/.local/bin by
# install.sh). Without that mount there is nothing at ~/.local/bin, so drop in
# the bell-only fallback. Never overwrite: a stowed script is authoritative.
# -L as well as -e: a *dangling* stow symlink would otherwise make cp write
# straight through it into the mounted dotfiles repo.
if [ ! -e ~/.local/bin/notify-attention ] && [ ! -L ~/.local/bin/notify-attention ]; then
	echo "🔔 Installing fallback notify-attention (no dotfiles mount)"
	mkdir -p ~/.local/bin
	cp .devcontainer/base/dotfiles/notify-attention ~/.local/bin/notify-attention
	chmod +x ~/.local/bin/notify-attention
fi

# ccstatusline, Claude settings, skills and plugins are set up by
# refresh.sh, which post-start.sh runs right after this and on every start.
