
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




# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nazarov/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nazarov/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nazarov/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nazarov/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<





# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nazarov/apps/google-cloud-sdk/path.zsh.inc' ]; then . '/home/nazarov/apps/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nazarov/apps/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/nazarov/apps/google-cloud-sdk/completion.zsh.inc'; fi


