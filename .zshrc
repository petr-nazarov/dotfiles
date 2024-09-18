
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
if [ -f "$HOME/.secrets/secrets.zsh" ]; then
  source $HOME/.secrets/secrets.zsh
fi

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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
FNM_PATH="/home/peter/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/peter/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
