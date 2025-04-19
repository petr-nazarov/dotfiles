
# ssh 
sudo pacman -S openssh



# Install yay
sudo pacman -Syy --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git ~/apps/yay
cd ~/apps/yay
makepkg -si

# Install base packages
yay -Syy --noconfirm github-cli git base-devel linux-headers linux-headers-generic cronie stow fuse less zsh unzip wget curl fd ripgrep bat fzf xclip procs btop  pistol-git neovim layzygit asciidoctor libmagic-dev ffmpegthumbnailer unrar poppler less vi vim nvim tmux tmuxinator lazygit lazydocker


# Fonts
yay -Syy --noconfirm ttf-fira-code ttf-nerd-fonts-symbols

# Docker 
yay -Syy --noconfirm docker docker-compose
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
newgrp docker
source ~/.zshrc

