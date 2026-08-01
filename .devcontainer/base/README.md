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
| `$HOME/.config/ccstatusline/` | Statusline widget layout — mounted into `/home/vscode/.config/ccstatusline/`. |
| SSH agent socket | Forwarded via `$SSH_AUTH_SOCK` for git/SSH operations inside the container. |

The `initializeCommand` in `devcontainer.json` creates `$HOME/dotfiles`, `$HOME/.claude` and
`$HOME/.config/ccstatusline` automatically if they are missing.

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

## Claude Code Statusline (ccstatusline)

The statusline is [`ccstatusline`](https://github.com/sirmalloc/ccstatusline), configured on the host
with `npx -y ccstatusline@latest`. Two pieces have to reach the container: the **binary** and the
**widget layout**.

### The binary

`ccstatusline` ships as an npm package only (no standalone release artifacts), so `devcontainer.json`
declares the `ghcr.io/devcontainers/features/node` feature and `post-create.sh` runs
`npm i -g ccstatusline@latest`.

The node feature is used deliberately instead of the mise-managed node that the dotfiles install.
`host-scripts/claude.sh` launches Claude via `devcontainer exec ... zsh -c "claude …"`, and `zsh -c`
is **non-interactive** — it never sources `.zshrc`, so `mise activate` never runs and mise's shims
are not on `PATH`. The feature instead exports its bin directory through `containerEnv`, which
lifecycle scripts and `devcontainer exec` both inherit, so `ccstatusline` resolves in every shell.

### The widget layout

The layout lives in the dotfiles repo at `_claude/.config/ccstatusline/settings.json` and is stowed
to the host by `just sync-claude`. `devcontainer.json` then bind-mounts the host directory in, so the
host stays the single live source of truth:

```
repo   _claude/.config/ccstatusline/settings.json
         │ stow --no-folding  (just sync-claude)
         ▼
host   ~/.config/ccstatusline/settings.json   (symlink)
         │ bind mount
         ▼
cntr   /home/vscode/.config/ccstatusline/settings.json
```

Reconfiguring with `npx ccstatusline` on the host writes straight back into the repo — ccstatusline
resolves symlinks before its atomic write (`lstat` → `realpath` → write-through), so the stow link
survives and the change shows up as a normal git diff.

Note this config deliberately lives in the `_claude` package, **not** `_headless`. `install.sh` runs
`stow --no-folding -t $HOME _headless` *inside* the container; if the file were in that package, stow
would see the bind-mounted `settings.json` as a foreign regular file, report a conflict, and abort
the entire `_headless` run. The container never stows `_claude`, so there is nothing to collide with.

### Running without the `~/.claude` mount

To keep host Claude credentials out of a container, drop the `.claude/` and `.claude.json` mount
lines from the project's `devcontainer.json`. `post-create.sh` then generates
`~/.claude/settings.json` from `dotfiles/claude-settings.json`, preserving the parts of the host
setup that aren't auth: statusline, `editorMode: vim`, `remoteControlAtStartup` and the default TUI
renderer. It only writes when the file is absent — a mounted `~/.claude` is always authoritative.

The same fallback applies to the layout: if the `ccstatusline` mount is omitted, `post-create.sh`
seeds it from `~/dotfiles/_claude/.config/ccstatusline/settings.json` instead.

### `~/.config` ownership

Bind-mounting `~/.config/ccstatusline` makes Docker auto-create the `~/.config` parent as `root`,
exactly like the `~/.ssh` case above. Left alone, the `_headless` stow run (which writes
`~/.config/zsh`, `~/.config/mise`, …) fails. `post-create.sh` runs `sudo chown vscode:vscode
~/.config` before applying dotfiles.

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

### `--recreate`

`shell.sh` and `claude.sh` forward their arguments to `base.sh`, which understands a single flag:

```bash
.devcontainer/base/host-scripts/shell.sh --recreate
```

This runs `devcontainer up --remove-existing-container` instead of a plain `devcontainer up`, so the
container is torn down and rebuilt from scratch — use it after changing the `Dockerfile`, `features`,
`mounts`, or anything else that only takes effect on creation (`postCreateCommand` included). The
workspace and every bind mount live on the host, so nothing there is lost; anything written *only*
to the container filesystem is.

To force-recreate the container, pass `--recreate` (see below).

## Lifecycle Scripts

| Script | When it runs | What it does |
| :--- | :--- | :--- |
| `scripts/post-create.sh` | On container creation | Fixes `~/.ssh` and `~/.config` ownership, applies dotfiles via `apply-dotfiles.sh`, installs Claude CLI, installs `ccstatusline` and seeds Claude/ccstatusline settings if they aren't mounted. |
| `scripts/post-start.sh` | On every container start | Repairs worktree paths, runs `mise install` for project deps. |
