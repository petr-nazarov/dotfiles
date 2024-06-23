

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"


# zplug
source ~/.zplug/init.zsh 
zplug "plugins/zsh-completions", from:oh-my-zsh
zplug "plugins/zsh-history-substring-search", from:oh-my-zsh
zplug "plugins/zsh-autosuggestions", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug  "plugins/command-not-found", from:oh-my-zsh
zplug  "unixorn/fzf-zsh-plugin"
zplug  "Aloxaf/fzf-tab"
zplug  "plugins/zsh-autosuggestions", from:oh-my-zsh
zplug  "plugins/zsh-syntax-highlighting", from:oh-my-zsh



# yazi 
function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#fnm 
eval "$(fnm env --use-on-cd)"

#pyenv 
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"




