
# Install firs class packages
## For debian
sudo apt install -y wget make gcc git vim gcc build-essential unzip libevent-dev ncurses-dev bison pkg-config ninja-build gettext libtool libtool-bin autoconf automake cmake g++ curl gnupg2 dirmngr git-core zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev postfix  stow zsh


# Install languages


## Go
install golang
cd ~/apps/
wget https://golang.org/dl/go1.17.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.5.linux-amd64.tar.gz

## Ruby
cd ~/
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
~/.rbenv/bin/rbenv install 3.4.2
~/.rbenv/bin/rbenv global 3.4.2

# Install terminal programs
## Debian
sudo apt install -y  ripgrep fzf xclip  btop   asciidoctor libmagic-dev

# Debian
sudo apt install -y ffmpegthumbnailer unrar poppler

## tmux and tmuxinator
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
gem install tmuxinator

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p




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

