
# ssh 
sudo pacman -S openssh
sudo systemctl enable sshd
sudo systemctl start sshd


# Install yay
sudo pacman -Syy --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git ~/apps/yay
cd ~/apps/yay
makepkg -si

# Install base packages
yay -Syy --noconfirm base-devel linux-headers linux-headers-generic cronie stow fuse less zsh unzip wget curl fd ripgrep bat fzf xclip procs btop  pistol-git neovim layzygit asciidoctor libmagic-dev ffmpegthumbnailer unrar poppler less vi vim nvim tmux tmuxinator


## if firewall present
sudo ufw allow ssh
sudo ufw enable
# Cron jobs
sudo systemctl enable --now cronie.service

# Docker 
yay -Syy --noconfirm docker docker-compose
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
newgrp docker
source ~/.zshrc

