#!/bin/zsh

echo "🔧 Applying default dotfils..."
rm -f ~/.zshrc
cp ./.devcontainer/base/dotfiles/.zshrc ~/.zshrc
rm -f ~/.gitconfig
cp ./.devcontainer/base/dotfiles/.gitconfig ~/.gitconfig
