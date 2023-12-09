
### Paths ###
source $HOME/.config/zsh/config.d/paths.zsh

### Plugins ###
source $HOME/.config/zsh/config.d/plugins.zsh

### Theme ###
source $HOME/.config/zsh/config.d/theme.zsh

### Aliases ###
source $HOME/.config/zsh/config.d/aliases.zsh

### Variables ###
source $HOME/.config/zsh/config.d/variables.zsh

### Secrets ###
source $HOME/.secrets/secrets.zsh

### Key Binds ###
source $HOME/.config/zsh/config.d/bind-keys.zsh


# Load GUI configs
if [[ "$OSTYPE" == "darwin"* ]]; then
 ~/.config/yabai/.yabairc 
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -s /home/nazarov/.rsvm/rsvm.sh ]] && . /home/nazarov/.rsvm/rsvm.sh # This loads RSVM

# fnm
export PATH="/home/nazarov/.local/share/fnm:$PATH"
eval "`fnm env`"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nazarov/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nazarov/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nazarov/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nazarov/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# fnm
export PATH="/home/nazaov/.local/share/fnm:$PATH"
eval "`fnm env`"

# bun completions
[ -s "/home/nazarov/.bun/_bun" ] && source "/home/nazarov/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
export PATH="/home/nazarov/.local/share/fnm:$PATH"
eval "`fnm env`"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nazarov/apps/google-cloud-sdk/path.zsh.inc' ]; then . '/home/nazarov/apps/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nazarov/apps/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/nazarov/apps/google-cloud-sdk/completion.zsh.inc'; fi
