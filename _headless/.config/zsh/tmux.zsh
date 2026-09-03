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
