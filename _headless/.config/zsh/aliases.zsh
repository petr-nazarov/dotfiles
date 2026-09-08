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
alias fd="fd --hidden --unrestricted"
alias rg="rg --hidden --unrestricted"
alias tt="tmuxinator list | tail -1 | tr ' ' '\n' | grep -v '^[[:space:]]*$' | fzf | xargs tmuxinator"

# fdv / rgv - the two searches above, wired through fzf into nvim.
#
# Both pass --ansi to fzf. Beyond colouring the list, it makes fzf print the
# ANSI-STRIPPED line back on selection, so rg's `file:line:column:` fields
# parse cleanly even though rg coloured them.
#
# bat is called by name, not through the `cat` alias: fzf runs the preview in
# a non-interactive shell where aliases do not exist.

# fdv [fd-args...] - pick files by name, open them in nvim tabs (tab to multi-select)
fdv() {
  emulate -L zsh
  # Two arg-dependent defaults, decided in one pass:
  #
  # --type f   fd's --type is additive, so only default to plain files when the
  #            caller has not asked for a type of their own (`fdv --type d`
  #            should mean dirs, not dirs *and* files).
  #
  # --full-path  fd matches the BASENAME only, so a pattern containing a slash
  #            (`cm/SKILL`) can never match anything - and fd, unlike rg's
  #            --glob, does not turn on full-path matching by itself. An
  #            argument with an interior slash that is not an existing path is
  #            therefore a path pattern, and gets --full-path. A search
  #            directory is a real path (and usually written with a trailing
  #            slash), so `fdv zsh _headless/` keeps matching basenames and
  #            does not suddenly return everything under .config/zsh/.
  local -a scope=(--type f) fullpath=()
  local a has_p=0 wants_p=0
  for a in "$@"; do
    case $a in
      -t | --type | --type=*) scope=() ;;
      -p | --full-path) has_p=1 ;;
      -*) ;;
      */*) [[ ${a%/} != */* || -e $a ]] || wants_p=1 ;;
    esac
  done
  (( has_p || ! wants_p )) || fullpath=(--full-path)

  local -a picks
  picks=(${(f)"$(fd --hidden --unrestricted $scope $fullpath "$@" |
    fzf --ansi --multi --height=80% --border --prompt='files > ' \
      --preview='bat --color=always --style=numbers {}' \
      --preview-window='right,60%,border-left' \
      --bind='ctrl-/:toggle-preview')"})
  picks=(${picks:#})
  (( ${#picks} )) || return 0

  nvim -p -- $picks
}

# rgv <rg-args...> - pick a match by content, open nvim on that line and column
rgv() {
  emulate -L zsh
  (( $# )) || { print -ru2 'usage: rgv <ripgrep args...>'; return 2 }

  local -a picks
  picks=(${(f)"$(rg --hidden --unrestricted --smart-case \
      --line-number --column --no-heading --color=always "$@" |
    fzf --ansi --multi --height=80% --border --prompt='grep > ' \
      --delimiter=: \
      --preview='bat --color=always --style=numbers --highlight-line {2} {1}' \
      --preview-window='up,60%,border-bottom,+{2}+3/3' \
      --bind='ctrl-/:toggle-preview')"})
  picks=(${picks:#})
  (( ${#picks} )) || return 0

  # One tab per distinct file, cursor parked on the first pick's match.
  local -a files
  local p rest
  for p in $picks; do files+=(${p%%:*}); done
  rest=${picks[1]#*:}
  local line=${rest%%:*}
  rest=${rest#*:}
  local col=${rest%%:*}

  nvim -p "+call cursor($line, $col)" -- ${(u)files}
}
# devshell now lives in ~/.local/bin/devshell
# checkout branch
gbs () {
  git checkout $(git branch --format='%(refname:short)' | fzf)
}

# create git worktree (and cd into it)
gwc() {
  local dir
  dir=$(git-worktree-create "$@") && [[ -n "$dir" ]] && cd "$dir"
}
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
