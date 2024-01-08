/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install brave-browser transmission scroll-reverser stow kitty gcc antidote
brew install lf eza bat fzf rg fd xclip procs btop authy flameshot studio-3t neovim lazygit

brew install --cask raycast
brew install rbenv ruby-build
rbenv install 3.2.2
rbenv global 3.2.2

## node
curl -fsSL https://fnm.vercel.app/install | bash
fnm install v18.16.0
fnm use v18.16.0
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim



brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
yabai --start-service
skhd --start-service

# create a new file for writing - visudo uses the vim editor by default.
# go read about this if you have no idea what is going on.

sudo visudo -f /private/etc/sudoers.d/yabai

# input the line below into the file you are editing.
#  replace <yabai> with the path to the yabai binary (output of: which yabai).
#  replace <user> with your username (output of: whoami). 
#  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
#   this hash must be updated manually after running brew upgrade.

<user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa

curl -sS https://starship.rs/install.sh | sh

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
