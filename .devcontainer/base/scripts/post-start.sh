#!/bin/zsh

echo "🚀 Applying post-start scripts..."

echo "📦 Installing system dependencies..."
# install project deps
mise install

# Pick up whatever changed in the dotfiles since the container was created.
# The mounted dotfiles copy is the newest; the project's copy is the fallback
# when the dotfiles aren't mounted.
REFRESH="$HOME/dotfiles/.devcontainer/base/scripts/refresh.sh"
[ -x "$REFRESH" ] || REFRESH=".devcontainer/base/scripts/refresh.sh"
"$REFRESH"
