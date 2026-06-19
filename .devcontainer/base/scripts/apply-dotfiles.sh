#!/bin/zsh
START_DIR=$(pwd)
DOTFILES_DIR="$HOME/dotfiles"

if [[ -d "$DOTFILES_DIR" && -x "$DOTFILES_DIR/install.sh" ]]; then
    echo "Applying host dotfiles from $DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    ./install.sh
    cd "$START_DIR"
else
    echo "No dotfiles found, applying defaults"
    ./.devcontainers/base/dotfiles/install.sh
fi
