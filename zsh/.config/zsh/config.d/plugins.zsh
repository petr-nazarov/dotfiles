# Load Antigen
#source "$HOME/.config/zsh/antigen/antigen.zsh"

# Load Antigen configurations
#antigen init ~/.antigenrc

#Atidote
source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

# fnm
export PATH="/home/nazarov/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"


# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

