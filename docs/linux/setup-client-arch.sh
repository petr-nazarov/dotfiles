PLATFORM=arch #arch | deb

mkdir ~/apps

# First class packages
yay -S --noconfirm linux-headers linux-headers-generic cronie stow openssh 

# Second class packages
yay -S --noconfirm zsh fd ripgrep exa bat fzf xclip procs btop diff-so-fancy lf pistol-git neovim layzygit

# Ntfs support
yay -S --noconfirm fuse fuse 

## zsh 
sudo chsh -s $(which zsh) 
chsh -s $(which zsh) 
git clone https://github.com/mattmc3/antidote.git /usr/share/zsh-antidote 
cd ~/apps/ 
curl -sS https://starship.rs/install.sh | sh 


# Install languages

## Python
### arch
yay -S --noconfirm python-pip

## Ruby
cd ~/
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
exec $SHELL
rbenv install 3.2.2
rbenv global 3.2.2

## node
curl -fsSL https://fnm.vercel.app/install | bash
fnm install v18.16.0
fnm use v18.16.0
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim


## Rust 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## tmux
yay -S --noconfirm tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
## tmuxinator
gem install tmuxinator
