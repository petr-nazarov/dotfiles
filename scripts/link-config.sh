#!/bin/sh

# Create dirrectories
mkdir -p ~/.ssh

# Unlink files if exist
rm ~/.zshrc \
~/.gitconfig \
~/.ssh/config \
~/.tmux.conf \
~/.antigenrc \
~/.yabairc \
~/.warp/keybindings.yaml

rm -rf ~/.warp


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  rm ~/.local/share/code-server/User/keybindings.json  ~/.local/share/code-server/User/settings.json
if [[ "$OSTYPE" == "darwin"* ]]; then
  rm ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/keybindings.json
fi

# Link files 
ln -s ~/.config/zsh/.zshrc ~/.zshrc 
ln -s ~/.config/git/.gitconfig ~/.gitconfig
ln -s ~/.config/ssh/config ~/.ssh/config
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.config/zsh/antigen/.antigenrc ~/.antigenrc
ln -s ~/.config/yabai/.yabairc ~/.yabairc
ln -s ~/.config/.warp ~/.warp


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ln -s ~/.config/code-server/conf/keybindings.json ~/.local/share/code-server/User/keybindings.json
  ln -s ~/.config/code-server/conf/settings.json ~/.local/share/code-server/User/settings.json
if [[ "$OSTYPE" == "darwin"* ]]; then
  ln -s ~/.config/code-server/conf/settings.json ~/Library/Application\ Support/Code/User/settings.json
  ln -s ~/.config/code-server/conf/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
fi


