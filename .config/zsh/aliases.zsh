unameOut="$(uname -s)"
alias x="startx"
alias sttysmall="stty cols 132 rows 45"
alias vim="nvim"
alias v="nvim"
alias g="git"
#alias gcb="git checkout $(git branch | fzf)"
alias cdD="cd ~/Downloads"
alias cdd="cd ~/dotfiles"
alias cddn="cd ~/dotfiles/nixos"
alias cds="cd ~/.secrets"
alias cdv="cd ~/Projects/Personal/Vault"
alias tx="tmuxinator"
alias tt="tmuxinator list | tail -1 | tr ' ' '\n' | grep -v '^[[:space:]]*$' | fzf | xargs tmuxinator"
alias cc="xclip -selection clipboard"
alias killnode="pkill -f node"
alias tmux="TERM=screen-256color-bce tmux"
alias ls="eza -la --git -F --icons --group-directories-first" 
alias ps="procs"
alias hh="$HOME/.config/scripts/cheat.sheat.sh"
alias clip="base64 | xargs -0 printf '\e]52;c;%s\007'"
alias sss="ssh -x dev-server-tmux"
alias cs="google-chrome-stable --profile-directory=Default --app-id=lmgleiefhogfcpmhlkeipbnaddhjeajj"
alias btry="cat /sys/class/power_supply/BAT0/capacity"
alias cat="bat"
alias jp="joplin"
alias hsl="hcloud server list"
alias hon="hcloud server poweron dev-server"
alias hoff="hcloud server poweroff dev-server"
alias bc="/home/nazarov/dotfiles/scripts/bookmarks-copy"
alias bo="/home/nazarov/dotfiles/scripts/bookmarks-open"
alias ch="/home/nazarov/dotfiles/scripts/clipboard-history"
