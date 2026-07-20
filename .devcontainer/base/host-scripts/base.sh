#!/bin/zsh
set -e
# Ensure ssh-agent is running with a fixed socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    ssh-agent -D -a "$SSH_AUTH_SOCK" &
    sleep 0.5
fi

# Add any private key not already loaded (skip ones already in the agent
# so we don't re-prompt for their passphrase on every devcontainer launch)
loaded_fingerprints="$(ssh-add -l 2>/dev/null | awk '{print $2}')"
for key in ~/.ssh/*; do
    # skip non-key files
    case "$(basename "$key")" in
        *.pub|config|known_hosts|known_hosts.old|authorized_keys) continue ;;
    esac
    [[ -f "$key" ]] || continue

    # only consider files that are actually private keys
    head -c 64 "$key" 2>/dev/null | grep -q "PRIVATE KEY" || continue

    fingerprint="$(ssh-keygen -lf "$key" 2>/dev/null | awk '{print $2}')"
    if [[ -n "$fingerprint" ]] && grep -qF "$fingerprint" <<< "$loaded_fingerprints"; then
        continue
    fi

    ssh-add "$key" 2>/dev/null || true
done
docker context use default
# devcontainer up --workspace-folder . 
devcontainer up --remove-existing-container --workspace-folder . 

