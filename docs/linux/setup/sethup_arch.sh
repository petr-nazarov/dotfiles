
# ssh 
sudo pacman -S openssh
sudo systemctl enable sshd
sudo systemctl start sshd


# Install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git ~/apps/yay
cd ~/apps/yay
makepkg -si

# Install base packages
yay -S --noconfirm linux-headers linux-headers-generic cronie stow fuse less zsh unzip
# terminal programs
yay -S --noconfirm fd ripgrep bat fzf xclip procs btop  pistol-git neovim layzygit asciidoctor libmagic-dev ffmpegthumbnailer unrar poppler less


## if firewall present
sudo ufw allow ssh
sudo ufw enable

sudo systemctl enable --now cronie.service
