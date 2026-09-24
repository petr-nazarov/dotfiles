# Keep the tmux window name pointed at the git worktree / repo we are in.
#
# The tmux hooks in .tmux.conf cover window creation; this covers `cd` inside a
# window that already exists. ~/.local/bin/tmux-window-name is the one that
# decides whether the window is still auto-named and what to call it.
if [[ -n $TMUX ]] && (( $+commands[tmux-window-name] )); then
  _tmux_window_name() { tmux-window-name --apply "$TMUX_PANE" }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _tmux_window_name
  _tmux_window_name
fi

# A Claude killed mid-turn never runs its Stop hook, so the pane would keep the
# yellow "working" badge (notify-attention --busy) forever. Getting a prompt
# back means nothing in this pane is working any more: clear it. Not only under
# $TMUX - over ssh or in a devcontainer the tmux holding the badge is on the
# far side of the pty.
if [[ -n $TMUX || -n $SSH_TTY || -f /.dockerenv ]]; then
  _claude_busy_clear() { print -n '\e]7;\e\\' }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _claude_busy_clear
fi
