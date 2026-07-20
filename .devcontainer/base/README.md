# Devcontainer — Base Template

A reusable devcontainer base that forwards your dotfiles, Claude config, and SSH agent into the container on startup.

## Using This as a Template (degit)

Copy this base into any project with [degit](https://github.com/Rich-Harris/degit):

```bash
npx degit petr-nazarov/dotfiles/.devcontainer/base .devcontainer/base
```

Then run the init script to wire it up to your project:

```bash
.devcontainer/base/host-scripts/init.sh
```

`init.sh` copies `base/devcontainer.json` into `.devcontainer/devcontainer.json` and installs `@devcontainers/cli` (via mise or npm) if not already present.

## Host Requirements

The following must exist on the host before starting the container:

| Path | Purpose |
| :--- | :--- |
| `$HOME/dotfiles/` | Dotfiles repo — mounted and applied inside the container via `install.sh`. |
| `$HOME/.claude/` | Claude config directory — mounted into `/home/vscode/.claude/`. |
| `$HOME/.claude.json` | Claude auth file — mounted into `/home/vscode/.claude.json`. |
| SSH agent socket | Forwarded via `$SSH_AUTH_SOCK` for git/SSH operations inside the container. |

The `initializeCommand` in `devcontainer.json` creates `$HOME/dotfiles` and `$HOME/.claude` automatically if they are missing.

## SSH Agent Forwarding

`host-scripts/base.sh` ensures an SSH agent is running on a fixed socket (`$XDG_RUNTIME_DIR/ssh-agent.socket`) before bringing the container up. Every private key under `~/.ssh/` (on the host) is added automatically, skipping any whose fingerprint is already loaded in the agent — so keys added in earlier sessions aren't re-prompted for their passphrase, but new keys still get picked up on the next start. The socket is then forwarded into the container as `/ssh-agent`; signing always happens on the host, so no private key material ever enters the container.

### Multiple SSH/GitHub identities

Since only the agent socket is forwarded, `ssh` inside the container still needs *some* file
on disk at `IdentityFile` to know which key to request from the agent for a given `Host` — but
only the **public** key is required for that (it's not secret, so mounting it isn't a security
concern the way mounting a private key would be).

To add an identity beyond your default key:

1. Add a `Host` block to a `configs/ssh.config` in your project (bind-mounted to
   `/home/vscode/.ssh/config` in the project's `devcontainer.json`), e.g.:

   ```
   Host example
       HostName github.com
       IdentityFile ~/.ssh/example
       IdentitiesOnly yes
   ```

2. Bind-mount the matching `.pub` file explicitly in `devcontainer.json`'s `mounts`:

   ```
   "source=${localEnv:HOME}/.ssh/example.pub,target=/home/vscode/.ssh/example.pub,type=bind,consistency=cached"
   ```

Docker mount sources aren't glob-expanded, so there's no `*.pub` shortcut — each identity needs
its own explicit mount line.

### `~/.ssh` ownership and `known_hosts`

Because only individual files under `~/.ssh` get bind-mounted (not the directory itself),
Docker auto-creates `~/.ssh` owned by `root`. Left alone, `vscode` can't write `known_hosts`,
so every session re-prompts to accept a host key. `scripts/post-create.sh` runs
`sudo chown vscode:vscode ~/.ssh` after container creation to fix this.

## Git Worktree Integration

The repo must be cloned as a **non-bare** repository. Worktrees are expected to live under a `worktrees/` directory. On container start, `post-start.sh` runs `repair-worktrees.sh` to fix any stale worktree paths.

## Commands

| Command | Description |
| :--- | :--- |
| `.devcontainer/base/host-scripts/init.sh` | First-time setup: copies `devcontainer.json` into the project and installs `devcontainer-cli`. |
| `.devcontainer/base/host-scripts/base.sh` | Starts SSH agent and brings the container up (`devcontainer up`). |
| `.devcontainer/base/host-scripts/shell.sh` | Opens a `zsh` shell inside the running container. |
| `.devcontainer/base/host-scripts/claude.sh` | Runs Claude CLI inside the container with `--dangerously-skip-permissions`. |
| `.devcontainer/base/host-scripts/down.sh` | Stops and removes a running container (interactive picker via fzf). |

To force-recreate the container:

```bash
devcontainer up --remove-existing-container --workspace-folder .
```

## Lifecycle Scripts

| Script | When it runs | What it does |
| :--- | :--- | :--- |
| `scripts/post-create.sh` | On container creation | Applies dotfiles via `apply-dotfiles.sh`, installs Claude CLI. |
| `scripts/post-start.sh` | On every container start | Repairs worktree paths, runs `mise install` for project deps. |
