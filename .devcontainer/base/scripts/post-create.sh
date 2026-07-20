#!/bin/zsh

echo "🚀 Applying post-create scripts..."

echo "🔑 Fixing ~/.ssh ownership..."
# ~/.ssh is auto-created by docker (root-owned) since only individual files
# inside it are bind-mounted, not the directory itself — without this,
# vscode can't write known_hosts and gets re-prompted every session
sudo chown vscode:vscode ~/.ssh

echo "🔧 Applying dotfiles..."
# apply dotfiles
(
  .devcontainer/base/scripts/apply-dotfiles.sh
) || true

# install claude
echo "🤖 Installing Claude CLI..."
curl -fsSL https://claude.ai/install.sh | bash

# Installing superpowers:
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install superpowers@claude-plugins-official

