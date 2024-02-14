
#Atidote

if [[ "$OSTYPE" == "darwin"* ]]; then
  source ${ZDOTDIR:-~}/.antidote/antidote.zsh
  export PATH="/Users/nazarov/Library/Application Support/fnm:$PATH"
  ~/.config/yabai/.yabairc 
else 
  source "$HOME/apps/zsh-antidote/antidote.zsh"
  export PATH="/home/nazarov/.local/share/fnm:$PATH"
fi
eval "$(fnm env --use-on-cd)"
antidote load


# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# yazi 
function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/nazarov/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/nazarov/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/nazarov/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/nazarov/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<



