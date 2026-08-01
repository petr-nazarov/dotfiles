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

echo "📊 Setting up ccstatusline..."
# The statusline binary is npm-only (no standalone release artifacts), so it
# needs the node feature declared in devcontainer.json. Installing it globally
# puts it on the feature's PATH, which `devcontainer exec zsh -c` inherits —
# mise's node only activates in interactive shells, so it can't be used here.
if command -v npm >/dev/null 2>&1; then
	npm i -g ccstatusline@latest
else
	echo "⚠️  npm not found — add ghcr.io/devcontainers/features/node to devcontainer.json"
fi

# ~/.config/ccstatusline is normally bind-mounted from the host so the widget
# layout stays in sync. When that mount is omitted, seed it from the dotfiles
# repo copy instead.
if [ ! -f ~/.config/ccstatusline/settings.json ]; then
	CCSL_SRC="$HOME/dotfiles/_claude/.config/ccstatusline/settings.json"
	if [ -f "$CCSL_SRC" ]; then
		echo "  ↳ seeding ccstatusline settings from dotfiles"
		mkdir -p ~/.config/ccstatusline
		cp "$CCSL_SRC" ~/.config/ccstatusline/settings.json
	fi
fi

# ~/.claude is normally bind-mounted from the host, which brings the real
# settings.json with it. When that mount is omitted (e.g. to keep host auth
# out of the container), generate a minimal settings.json so the statusline,
# vim mode, remote control and TUI still match the host setup. Never overwrite
# an existing file — a mounted ~/.claude is authoritative.
if [ ! -f ~/.claude/settings.json ]; then
	echo "  ↳ ~/.claude/settings.json not mounted, generating defaults"
	mkdir -p ~/.claude
	cp .devcontainer/base/dotfiles/claude-settings.json ~/.claude/settings.json
fi

# Installing superpowers:
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install superpowers@claude-plugins-official
