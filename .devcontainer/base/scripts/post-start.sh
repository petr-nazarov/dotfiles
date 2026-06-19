#!/bin/zsh

echo "🚀 Applying post-start scripts..."

echo "🔧 Fixing worktrees..."
# fix worktrees
(
  .devcontainer/base/scripts/repair-worktrees.sh
) || true

echo "📦 Installing system dependencies..."
# install project deps
mise install
