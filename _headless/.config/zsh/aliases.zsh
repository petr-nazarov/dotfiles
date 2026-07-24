unameOut="$(uname -s)"
alias sttysmall="stty cols 132 rows 45"
alias vim="nvim"
alias v="nvim"
alias sz="source ~/.zshrc"
alias cdD="cd ~/Downloads"
alias cdp="cd ~/Projects"
alias cdpp="cd ~/Projects/Personal"
alias cdd="cd ~/dotfiles"
alias cds="cd ~/.secrets"
alias tx="tmuxinator"
alias tt="tmuxinator list | tail -1 | tr ' ' '\n' | grep -v '^[[:space:]]*$' | fzf | xargs tmuxinator"
# checkout branch
gbs () {
  git checkout $(git branch --format='%(refname:short)' | fzf)
}

# create git worktree 
alias 'gwc'='git-worktree-create'
# select git worktree
gws() {
  local dir
  dir=$(git-worktree-select) && [[ -n "$dir" ]] && cd "$dir"
}
# delete git worktree (and its folder)
gwd() {
  local dir unpushed
  dir=$(git-worktree-select)
  [[ -n "$dir" ]] || return
  if [[ "$dir" != */worktrees/* ]]; then
    echo "refusing to remove the main worktree: $dir"
    return 1
  fi

  # commits reachable from HEAD but on no remote-tracking branch
  unpushed=$(git -C "$dir" rev-list --count HEAD --not --remotes)
  if [[ "$unpushed" -gt 0 ]]; then
    echo "refusing to remove $dir: $unpushed commit(s) not pushed to any remote"
    return 1
  fi

  read -q "REPLY?Remove worktree $dir? [y/N] "
  echo
  [[ "$REPLY" == [Yy] ]] || return
  # --force: worktrees are created with untracked files (.env, node_modules, etc.)
  # copied in, which git worktree remove otherwise refuses to delete
  git worktree remove --force "$dir"
  rm -rf "$dir"
}


alias tmux="TERM=screen-256color-bce tmux"
alias ls="eza -la --git -F --icons --group-directories-first"
alias ps="procs"
alias cat="bat"
alias lg="lazygit"
alias ld="lazydocker"
# Use single quotes to prevent the shell from treating ? as a wildcard
alias '??'='ai_bat'
alias '???'='ai "???"'
alias 'cg'='ai_codegen'
