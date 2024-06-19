
### Paths ###
source $HOME/.config/zsh/paths.zsh

### Plugins ###
source $HOME/.config/zsh/plugins.zsh

### Theme ###
source $HOME/.config/zsh/theme.zsh

### Aliases ###
source $HOME/.config/zsh/aliases.zsh

### Variables ###
source $HOME/.config/zsh/variables.zsh

### Secrets ###
source $HOME/.secrets/secrets.zsh

### Key Binds ###
source $HOME/.config/zsh/bind-keys.zsh



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

