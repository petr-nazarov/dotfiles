# /devcontainers add [path]

Set up a devcontainer in a project that has none. The result is the same layout `update.md`
maintains: `.devcontainer/base/` (verbatim copy), `.devcontainer/devcontainer.json` (the project's
own, starting from the base), `.devcontainer/configs/ssh.config`.

## 1. Look at the target

`path` defaults to the current folder. Collect, in one Bash batch (`command ls`: `ls` may be aliased to `eza`):

```bash
cd <path> && pwd -P
command ls -A .devcontainer 2>/dev/null                # exists → stop, offer `update` instead
git rev-parse --show-toplevel --git-common-dir 2>&1     # repo? linked worktree?
git remote -v 2>/dev/null
command ls -d */.git 2>/dev/null                        # a client folder holding several repos?
stat -f -c %i . ..; findmnt -T . -o TARGET -n           # same filesystem as the parent?
command ls -1 ~/.secrets/home/.ssh/ | grep '\.pub$'     # key NAMES only
command ls -1 ~/.ssh/                                   # private key NAMES only
```

Stop and explain if:

- **It's a linked worktree:** the container belongs on the main worktree root (the parent of
  `--git-common-dir`); that's what `devshell` mounts.
- **It's the root of a mount** (`findmnt` target is the folder itself, e.g. the FrrCode vault):
  the home folder `../.devcontainer-home/<name>` would land outside it, and `prepare-home.sh`
  refuses. Use a folder one level down.

## 2. Ask

One `AskUserQuestion` call, these questions:

1. **Claude login** (single select)
   - **Own login (Recommended for client work):** the container logs in by itself, usually with
     the client's account. Its sessions, settings and skills are its own; the dotfiles skills
     still reach it through `refresh.sh`. The login lives in the project's home folder.
   - **Host's login:** bind-mount the host's `~/.claude` and `~/.claude.json`, as the dotfiles
     repo's own container does. Same account, sessions and settings as the host; anything Claude
     changes inside changes the host's too.
2. **SSH keys to mount** (multiSelect). Options are the `.pub` names from step 1, those matching
   the folder or client name first (up to 4; the rest via "Other"). Description per key: the
   host it suggests (`*-github` → github.com, `*-bitbucket` → bitbucket.org, `*-gitlab` →
   gitlab.com) and whether a private key with that name exists in `~/.ssh` (only
   that one is loaded into the agent by `base.sh`; without it the mount is useless). Say that
   only the public key is mounted and signing stays in the host's agent.
3. **Git tracking**, only when the folder is a git repo (single select):
   - **Keep it out of git (Recommended for client repos):** add `.devcontainer/` to
     `.git/info/exclude`. Nobody else sees it.
   - **Commit it:** for your own projects. `configs/ssh.config` stays ignored either way.
4. **Start it now** (single select): build and start the container after writing the files
   (takes a few minutes), or leave it for `devshell` / `shell.sh`.

When a key's host can't be guessed from its name, ask for the host name as a follow-up.

## 3. Write the files

```bash
mkdir -p .devcontainer/configs
cp -r ~/dotfiles/.devcontainer/base .devcontainer/base
cp ~/dotfiles/.devcontainer/configs/{.gitignore,ssh.config.example} .devcontainer/configs/
cp .devcontainer/base/devcontainer.json .devcontainer/devcontainer.json
```

Don't copy `~/dotfiles/.devcontainer/configs/ssh.config`: it's the dotfiles repo's own.

Then edit `.devcontainer/devcontainer.json` (it's JSONC: keep the comments):

- **Keys:** replace the `KEY.pub` mount line with one line per chosen key,
  `source=${localEnv:HOME}/.secrets/home/.ssh/<name>.pub,target=/home/vscode/.ssh/<name>.pub,...`.
  No keys chosen: delete the line.
- **Host's Claude login:** add, as in `~/dotfiles/.devcontainer/devcontainer.json`,
  ```
  "source=${localEnv:HOME}/.claude/,target=/home/vscode/.claude/,type=bind,consistency=cached",
  "source=${localEnv:HOME}/.claude.json,target=/home/vscode/.claude.json,type=bind,consistency=cached",
  ```
  and prepend `mkdir -p $HOME/.claude && touch $HOME/.claude.json && ` to `initializeCommand`.
  Keep the home folder mount: other tools' logins still need it.

Write `.devcontainer/configs/ssh.config`, one block per key, alias = key name:

```
Host <name>
    HostName <github.com>
    User git
    IdentityFile ~/.ssh/<name>
    IdentitiesOnly yes
```

`IdentityFile` names a private key that isn't in the container: ssh finds `<name>.pub` next to
it and asks the forwarded agent to sign with the matching key.

Git tracking: append `.devcontainer/` to `$(git rev-parse --git-common-dir)/info/exclude` if
chosen. Check the config:

```bash
devcontainer read-configuration --workspace-folder . 2>/dev/null | jq '.configuration | {mounts, containerEnv}'
```

## 4. Start (if chosen)

```bash
./.devcontainer/base/host-scripts/base.sh
```

The last line is JSON with `"outcome":"success"`. `base.sh` loads every private key in `~/.ssh`
into the host agent and may need a passphrase. Without a terminal it can't ask, so a key with
a passphrase may stay unloaded: then the user runs `shell.sh` once from their own terminal.

Verify:

```bash
devcontainer exec --workspace-folder . zsh -lc 'ssh -T git@<alias>; echo $WAYLAND_DISPLAY'
```

`ssh -T` to GitHub prints `Hi <account>!` and exits 1; that's success.

## 5. Report

- Files written, chosen options.
- **Remotes:** a key works only through its alias. List `git remote -v` remotes that point at the
  real host (`git@github.com:org/repo.git`) and offer to change them to the alias
  (`git@<alias>:org/repo.git`). In a folder of several repos, do it per repo. Change nothing
  without a yes.
- **Own Claude login:** the user logs in once inside: `devshell`, then `claude` and `/login`.
- Next steps: `devshell` (from anywhere in the project) or `.devcontainer/base/host-scripts/claude.sh`.
