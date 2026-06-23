#!/bin/zsh

echo "🚀 Applying post-create scripts..."

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

