# brew
if [ -d "/opt/homebrew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## mise
if command -v mise >/dev/null 2>&1; then
	# eval "$($(which mise) activate zsh)"
	eval "$(mise activate zsh)"
fi

# Starship
eval "$(starship init zsh)"

# direnv
eval "$(direnv hook zsh)"

# yazi
function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Set up fzf key bindings and fuzzy completion
if command -v fzf >/dev/null 2>&1; then
	source <(fzf --zsh)
fi

#zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zsh-users/zsh-autosuggestions
zinit wait lucid for \
	atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions

# zsh-users/zsh-syntax-highlighting
zinit wait lucid for \
	atload"ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)" \
	zsh-users/zsh-syntax-highlighting

# zsh-users/zsh-completions
zinit wait lucid for \
	zsh-users/zsh-completions

# zsh-users/zsh-history-substring-search
zinit wait lucid for \
	zsh-users/zsh-history-substring-search

# unixorn/fzf-zsh-plugin
zinit wait lucid for \
	unixorn/fzf-zsh-plugin

# Aloxaf/fzf-tab
zinit wait lucid for \
	trigger-load"fzf-tab" \
	Aloxaf/fzf-tab
