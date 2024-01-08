# Load Antigen
#source "$HOME/.config/zsh/antigen/antigen.zsh"

# Load Antigen configurations
#antigen init ~/.antigenrc

#Atidote

if [[ "$OSTYPE" == "darwin"* ]]; then
  source ${ZDOTDIR:-~}/.antidote/antidote.zsh
else 
  source '/usr/share/zsh-antidote/antidote.zsh'
fi
antidote load

# fnm
export PATH="/home/nazarov/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"



# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

