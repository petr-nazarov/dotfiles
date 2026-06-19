#!/bin/zsh

echo "🔧 Applying default dotfils..."
rm -f ~/.zshrc
cp ./.devcontainer/dotfiles/.zshrc ~/.zshrc
rm -f ~/.gitconfig
cp ./.devcontainer/dotfiles/.gitconfig ~/.gitconfig
