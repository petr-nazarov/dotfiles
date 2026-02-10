export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SHELL=zsh
export EDITOR=nvim
export BROWSER=zen-browser

export STARSHIP_CONFIG=~/.config/starship/starship.toml

# FZF
## Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

### GAMING
export LIBVA_DRIVER_NAME=radeonsi
export XDG_SESSION_TYPE=wayland
