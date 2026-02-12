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
alias tmux="TERM=screen-256color-bce tmux"
alias ls="eza -la --git -F --icons --group-directories-first"
alias ps="procs"
alias cat="bat"
# Use single quotes to prevent the shell from treating ? as a wildcard
alias '??'='ai_bat'
alias '???'='ai "???"'
