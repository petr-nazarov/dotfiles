autoload -Uz compinit
compinit -i
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# my scripts
export PATH="$HOME/dotfiles/scripts:$PATH"
# builded apps
export PATH="$HOME/apps/bin:$PATH"
# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

#ruby
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval "$(rbenv init -)"

# rust
export PATH="$HOME/.cargo/bin:$PATH"
#python 
source $HOME/anaconda3/bin/activate

# Go
export PATH="$HOME/go/bin:$PATH"
export GOBIN="$HOME/go/bin"
export PATH=$PATH:/usr/local/go/bin

# GNU sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# add snap to path
export PATH="$PATH:/snap/bin"

# conda
export PATH="/home/mrzueck/miniconda3/bin:$PATH"


# fly
export FLYCTL_INSTALL="/home/nazarov/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/nazarov/.bun/_bun" ] && source "/home/nazarov/.bun/_bun"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
export PATH="/home/nazarov/.local/share/fnm:$PATH"
eval "`fnm env`"




#apps
export PATH="$HOME/neovim/bin:$PATH"
export PATH="$PATH:$HOME/apps/bin"
export PATH="$PATH:$HOME/.local/bin"

