!/bin/sh
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --update
nix-shell '<home-manager>' -A install
sudo reboot 
