
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



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
FNM_PATH="/home/peter/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/peter/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# fnm
FNM_PATH="/home/nazarov/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/nazarov/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/home/nazarov/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
