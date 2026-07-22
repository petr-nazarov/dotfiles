# Safe TERM config
if [ -z "$TMUX" ]; then
	export TERM="xterm-256color"
fi
unsetopt NOMATCH
setopt INTERACTIVE_COMMENTS # allow trailing "# comment" at the prompt

# Location of your history file
HISTFILE=~/.zsh_history

# Number of lines to keep in memory
HISTSIZE=10000

# Number of lines to save to file
SAVEHIST=10000

# Ensure zsh appends, not overwrites
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY # Write history incrementally
setopt SHARE_HISTORY      # Share history between sessions
setopt HIST_IGNORE_DUPS   # Don’t save duplicates
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks
