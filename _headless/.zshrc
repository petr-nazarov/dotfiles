### Settings ###
source $HOME/.config/zsh/settings.zsh

### Variables ###
source $HOME/.config/zsh/variables.zsh

### Plugins ###
source $HOME/.config/zsh/plugins.zsh

### Theme ###
source $HOME/.config/zsh/theme.zsh

### Aliases ###
source $HOME/.config/zsh/aliases.zsh

### Secrets ###
if [ -f "$HOME/.secrets/secrets.zsh" ]; then
  source $HOME/.secrets/secrets.zsh
fi

### Key Binds ###
source $HOME/.config/zsh/bind-keys.zsh

### tmux ###
source $HOME/.config/zsh/tmux.zsh



# opencode
export PATH=/home/nazarov/.opencode/bin:$PATH
export PATH=$PATH:$HOME/.maestro/bin

# maestro-runner
export PATH="$HOME/.maestro-runner/bin:$PATH"
