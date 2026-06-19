if command -v mise >/dev/null 2>&1; then
	# eval "$($(which mise) activate zsh)"
	eval "$(mise activate zsh)"
fi

# Starship
eval "$(starship init zsh)"

