mkdir -p ~/apps
mkdir -p ~/apps/bin

# Create user if needed
useradd -m nazarov \
	passwd nazarov \ 
apt-get install sudo -y \
	usermod -aG sudo nazarov

# Install firs class packages
## For debian
sudo apt install -y wget make gcc git vim gcc build-essential unzip libevent-dev ncurses-dev bison pkg-config ninja-build gettext libtool libtool-bin autoconf automake cmake g++ curl gnupg2 dirmngr git-core zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev postfix  stow
## For arch
sudo pacman -S openssh
sudo systemctl enable sshd
sudo systemctl start sshd
yay -S --noconfirm linux-headers linux-headers-generic cronie stow fuse

## if firewall present
sudo ufw allow ssh
sudo ufw enable

systemctl enable --now cronie.service

## zsh
sudo apt-get install -y zsh
sudo chsh -s $(which zsh) \
	chsh -s $(which zsh) \
	cd ~/apps/ \
	curl -sS https://starship.rs/install.sh | sh

# Install languages

## Python
curl https://pyenv.run | bash
source ~/.zshrc
pyenv install 3.11.9
pyenv global 3.11.9
curl -sSL https://install.python-poetry.org | python 

## Ruby
cd ~/
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
~/.rbenv/bin/rbenv install 3.2.2
~/.rbenv/bin/rbenv global 3.2.2

## node
curl -fsSL https://fnm.vercel.app/install | bash
fnm install v20.9.0
fnm use v20.9.0
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim @biomejs/biome
## bun
curl -fsSL https://bun.sh/install | bash

## Go
install golang
cd ~/apps/
wget https://golang.org/dl/go1.17.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz

## Rust (Cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install terminal programs
## Debian
sudo apt install -y  ripgrep fzf xclip  btop   asciidoctor libmagic-dev
## Arch
yay -S --noconfirm fd ripgrep bat fzf xclip procs btop  pistol-git neovim layzygit asciidoctor libmagic-dev

# Yazi
## Both
cargo install --locked yazi-fm
## Arch
yay -S --noconfirm ffmpegthumbnailer unrar poppler
## Debian
sudo apt install -y ffmpegthumbnailer unrar poppler

# pistol
sudo apt-get install go install github.com/doronbehar/pistol/cmd/pistol@latest


## lazygit 
cd ~/apps
wget https://github.com/jesseduffield/lazygit/releases/download/v0.44.0/lazygit_0.44.0_Linux_x86_64.tar.gz
tar -xzvf lazygit_0.44.0_Linux_x86_64.tar.gz 
sudo cp lazygit /usr/bin/

## fd
cargo install fd-find
## procs 
cargo install procs
## sheldon
cargo install sheldon
## eza
cargo install eza
## bat
cargo install bat
## tmux and tmuxinator
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
gem install tmuxinator

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

## docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
zsh

# pulumi and google cloud
curl -fsSL https://get.pulumi.com | sh
sudo apt-get install -y apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-sdk

# heroku
curl https://cli-assets.heroku.com/install.sh | sh
# Doppler
curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sudo sh

## Firewall
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable


#Nvim debian
cd ~/apps
sudo apt update
sudo apt install fuse
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

