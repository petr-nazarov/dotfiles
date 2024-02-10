# My dotfiles 
This dotfiles uses stow to create symlinks. 

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
 

