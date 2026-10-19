#!/bin/zsh
set -e

# --recreate tears the container down and builds it again from scratch, instead
# of reusing whatever is already running. Callers (shell.sh, claude.sh) forward
# their own arguments here, so `./shell.sh --recreate` reaches this.
RECREATE=0
for arg in "$@"; do
    case "$arg" in
        --recreate) RECREATE=1 ;;
        *)
            echo "unknown option: $arg (expected --recreate)" >&2
            exit 1
            ;;
    esac
done

# Ensure ssh-agent is running with a fixed socket. On macOS launchd already runs
# one; colima (forwardAgent: true) exposes it inside its VM, where the bind
# mount source is resolved, at /run/host-services/ssh-auth.sock.
if [[ "$(uname)" == Darwin ]]; then
    CONTAINER_AUTH_SOCK=/run/host-services/ssh-auth.sock
    # No Wayland here; the devcontainer still bind-mounts $XDG_RUNTIME_DIR, so give it a dir.
    export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.cache/xdg-runtime}"
    mkdir -p "$XDG_RUNTIME_DIR"
else
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    CONTAINER_AUTH_SOCK="$SSH_AUTH_SOCK"
fi

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
if [[ "$(uname)" == Darwin ]]; then
    docker context use colima
else
    docker context use default
fi
export SSH_AUTH_SOCK="$CONTAINER_AUTH_SOCK"
if [[ "$RECREATE" -eq 1 ]]; then
    echo "♻️  Recreating devcontainer from scratch (existing container will be removed)..."
    devcontainer up --remove-existing-container --workspace-folder .
else
    devcontainer up --workspace-folder .
fi

