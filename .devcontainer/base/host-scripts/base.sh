#!/bin/zsh
set -e
# Ensure ssh-agent is running with a fixed socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    ssh-agent -D -a "$SSH_AUTH_SOCK" &
    sleep 0.5
fi

# Add keys if none loaded
if ! ssh-add -l &>/dev/null; then
    ssh-add
fi

docker context use default
devcontainer up --workspace-folder . 
# devcontainer up --remove-existing-container --workspace-folder . 

