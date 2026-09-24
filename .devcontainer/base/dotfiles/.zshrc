if command -v mise >/dev/null 2>&1; then
	# eval "$($(which mise) activate zsh)"
	eval "$(mise activate zsh)"
fi

# Starship
eval "$(starship init zsh)"


# Clear the host tmux's yellow "Claude is working" badge (notify-attention
# --busy) whenever a prompt comes back, in case Claude died mid-turn.
precmd_functions+=(_claude_busy_clear)
_claude_busy_clear() { print -n '\e]7;\e\\' }
