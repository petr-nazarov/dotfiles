# My dotfiles 
This dotfiles uses stow to create symlinks. 

```sh
git clone  git@github.com:petr-nazarov/dotfiles.git
```

# TODO 
- [ ] Use nix shell for vim debug
# Install github cli to login for the first time 
```sh
nix-shell -p gitAndTools.gh
```

# Nix change chanels:
```bash
# check chanels 
sudo nix-channel --list 
# remove chanels
sudo nix-channel --remove nixos
sudo nix-channel --remove home-manager
# add chanels

# nixos
sudo nix-channel --add  https://nixos.org/channels/nixos-unstable nixos 
# or 
sudo nix-channel --add  https://nixos.org/channels/nixos-23.11 nixos 

# home-manager
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# or  
sudo nix-channel --add  https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager




```
# Nix first install
```sh
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --update
sudo reboot 
nix-shell '<home-manager>' -A install
```

# First ssh key 
```sh
kitty +kitten  ssh user@host
```
# Nix rebuild
```sh 

```

# Included configurations 
 - `bat` as a replacement for `cat`
 - `btop` as a replacement for htop 
 - `display` has configurations for my desktop managers. The most up to date are `awsome` for x11 and `hyprland` for wayland. Also includes `waybar` as the bar.  And `yabai` for mac.
 - `docs` contain instructions to set up the installations and drivers 
 - `git` my git configuration 
 - `kitty` is my terminal emulator 
 - `yazi` my terminal file manager 
 - `nvim` my old config for neovim. New one is in lvim 
 - `scripts` are just some of my bash scripts
 - `ssh` my ssh config 
 - `starship` for the promt configuration 
 - `tmux` my tmux config 
 - `zsh` Is my whole zsh config, it is breaken up into files. Uses `antidote` as a plugin manager. It expects that you have a `$HOME/.secrets/secrets.zsh`, which is not included in this repo for security reasons 


# Linking 
To link all the configs run `./sync.sh`
 

