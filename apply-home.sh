rm /home/nazarov/.mozilla/firefox/personal/search.json.mozlz4.backup
rm /home/nazarov/.mozilla/firefox/personal/containers.json.backup

home-manager switch -f $HOME/dotfiles/nixos/user/home.nix -b backup
