git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm



/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install  make pkg-config gcc zplug stow lf eza bat fzf rg fd xclip procs btop neovim lazygit ripgrep yazi dmenu moreutils
brew install brave-browser transmission scroll-reverser kitty flameshot studio-3t  choose-gui
brew install --cask raycast
brew install --cask docker  
brew install rbenv ruby-build
rbenv install 3.2.2
rbenv global 3.2.2

## node
brew install fnm
fnm install v20.14.0
fnm use v20.14.0
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim

#pyehon
curl https://pyenv.run | bash
pyenv install 3.12 
pyenv global 3.12



brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
yabai --start-service
skhd --start-service

# create a new file for writing - visudo uses the vim editor by default.
# go read about this if you have no idea what is going on.

echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai


curl -sS https://starship.rs/install.sh | sh

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
