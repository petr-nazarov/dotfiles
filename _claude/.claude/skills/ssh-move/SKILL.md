---
name: ssh-move
description: Use when the user types /ssh-move, or wants a project folder moved or copied between this machine and another one over SSH ("move tadam from home-desktop", "bring my FrrCode folder to the mac", "copy Personal to macmom") — git repos are re-cloned from their remotes, everything else is rsynced, keeping the folder layout, unpushed work and devcontainer homes.
argument-hint: "<folder> from|to <ssh host>"
allowed-tools: [Bash, Read, AskUserQuestion]
---

# /ssh-move — move a folder between machines

`$ARGUMENTS`: a folder, `from` or `to`, and a host from `~/.ssh/config`.
`tadam from home-desktop` copies home-desktop's folder here; `tadam to macmom` copies ours there.
Missing pieces → ask. One end is always this machine.

**Source** is where the folder is now, **dest** where it goes. Run commands on the remote end with
`ssh <host> '…'` (scripts: `ssh <host> bash -s -- args < script`). Never read SSH keys on either
machine (`ls`/`test -e` on names only). Never change or delete anything on the source except the
temporary refs and bundles named below; tell the user the source is untouched at the end.

## 1. Find the folder

- Paths are matched relative to `$HOME` (macOS `/Users/nazarov` ↔ Linux `/home/nazarov`).
- A bare name (`tadam`): on the source run
  `find ~/Projects -maxdepth 4 -type d -name '<name>' -not -path '*/node_modules/*'`. Several
  hits → ask. None → check whether `~/Projects/FrrCode` is an unmounted vault (empty folder /
  `mountpoint -q` fails on Linux) and tell the user to run `mount-work` there.
- The dest path is the same home-relative path. If the folder lies under `~/Projects/FrrCode`,
  the vault must be mounted on **both** ends before going on — otherwise the copy lands
  unencrypted under the mountpoint. Check, and stop with a `mount-work` hint if not.
- Dest folder exists and is not empty → ask: merge into it, or stop.

## 2. Inventory the source

```bash
bash scripts/inventory.sh <path>                                 # source is here
ssh <host> bash -s -- <path> < scripts/inventory.sh              # source is remote
```

The script's header documents every record. Show the user a short summary: repos, which have
unpushed branches, dirty files, stashes, worktrees, repos without a remote, devcontainer homes and
containers.

## 3. Ask (one `AskUserQuestion` call, only the questions that apply)

- **Worktrees** — always ask, per repo that has them (multiSelect: which repos get their
  worktrees recreated). Unselected worktrees are skipped; warn if one has dirty files, since those
  are lost (their branches still move — branches live in the main repo).
- **Stashes** — carry them as branches `moved-stash-<n>`, or skip.
- **Running devcontainers** inside the folder — stop them first so their home folder is copied
  in a consistent state (recommended), or copy while running.

## 4. Decide how each repo travels

For each `remote` record of a repo, the clone happens **on the dest**, through the dest's own ssh
config. The URL's host may be an alias (`git@tadam-github:org/repo.git`, alias → `github.com` with
a specific key). On the dest:

1. `ssh -G <alias> | awk '/^hostname /{print $2}'` — if it resolves to the same real host as on
   the source (last column of the `remote` record), try the URL as-is.
2. Otherwise, collect the dest's other `Host` entries with that `HostName`
   (`awk` over `~/.ssh/config` and its `Include`s) and try each, and finally the bare real host.
3. "Try" = `GIT_SSH_COMMAND='ssh -o BatchMode=yes' git ls-remote <url> HEAD` on the dest. The
   first one that works is the URL to clone with. Keep the original URL when it works; a rewritten
   one replaces it in the clone's `origin`.
4. `https://` remotes: try as-is.

Repos where no URL works, repos with no remote, and repos whose `origin` is a local path travel
by rsync **with** `.git` (step 6). Show the user the plan table (repo → clone URL / rsync) before
copying; ask only if a repo the user probably cares about fell back to rsync because the dest
lacks a key — they may prefer to add the `Host` block and key on the dest first.

## 5. Move each cloned repo

Work through repos parent-first (a repo nested in another is skipped by the parent's overlay and
handled on its own). `$S`/`$D` = the repo on source/dest, run on that machine.

1. **Unpushed commits** — on the source:
   `git -C $S bundle create /tmp/ssh-move-<repo>.bundle --branches --tags --not --remotes`
   ("refusing to create an empty bundle" = nothing unpushed, skip). Stashes, if chosen: first
   `git -C $S branch moved-stash-<n> stash@{<n>}` for each, include them, delete those branches
   right after bundling. Move the bundle to the dest's `/tmp` with rsync (through this machine
   when both ends differ from here).
2. **Clone** on the dest: `git clone --no-checkout [--recurse-submodules] <url> $D`, then
   `git -C $D fetch --update-head-ok /tmp/ssh-move-<repo>.bundle '+refs/heads/*:refs/heads/*'`.
   Every `branch` record still missing on the dest points at a pushed commit: create it with
   `git -C $D branch <name> <sha>`. Then `git -C $D checkout <source head>` and set each branch's
   upstream to match the `branch` records. Other remotes: add with the same URL logic. Restored
   stashes show up as `moved-stash-<n>` branches; mention them, don't apply them.
3. **LFS** (`extra lfs`): `git -C $D lfs pull`.
4. **Working tree** — overlay the source's files onto the clone, so uncommitted edits, untracked
   files and ignored files (`.env`, local configs) arrive:
   `rsync -a --exclude=.git <EXCLUDES> --exclude=<nested repo/worktree paths> $S/ $D/`
   and delete on the dest what `git -C $S ls-files --deleted` lists.
5. **Repo-local state**: `extra hooks` → rsync `.git/hooks/` (non-sample files);
   `extra localconfig` → copy those `git config --local` entries (user.*, include.*, …) across.
6. **Worktrees** (selected repos): `git -C $D worktree add <same relative path> <branch>`, then
   the same working-tree overlay for each. A worktree outside the folder keeps its home-relative
   path.
7. Remove the bundle on both machines.

`<EXCLUDES>` — rebuildable and machine-specific (macOS ↔ Linux binaries differ):
`--exclude=node_modules --exclude=.venv --exclude=venv --exclude=__pycache__ --exclude=.next
--exclude=.nuxt --exclude=.turbo --exclude=target`. Tell the user which projects need an install
afterwards.

## 6. Rsync everything else

One rsync of the folder that skips every cloned repo and every worktree (`--exclude=/<path>/`
per repo, anchored), plus `<EXCLUDES>`. Repos chosen for rsync in step 4 are **not** excluded, so
they travel whole with their `.git`. `-a` keeps modes; `.devcontainer-home/*` (container logins,
mode 700) must arrive intact — rerun with `--rsync-path='sudo rsync'` on the dest if files are
owned by another uid and the user agrees.

Direction from this machine: `rsync -a … <host>:<src>/ <dst>/` (from) or `… <src>/ <host>:<dst>/`
(to). Trailing slashes matter.

## 7. Devcontainers

The project's `.devcontainer/` came with the repo or the rsync, and `.devcontainer-home/<name>`
keeps the logins, so a container built on the dest starts logged in. On the dest:

- `devcontainer.json` mounts `.pub` files and a `configs/ssh.config` — `test -e` each mounted
  `${localEnv:HOME}/…` source on the dest and list the missing ones (names only).
- `~/dotfiles` must exist on the dest.
- Containers are not moved. Offer `/devcontainers` on the dest to build them; don't build
  unasked.

## 8. Verify and report

On the dest, rerun the inventory for the same path and compare with the source: every branch
present with the same sha, same dirty counts per repo (minus skipped worktrees), every
devcontainer home present. Report a table: repo → how it moved (clone URL / rsync), unpushed
commits carried, dirty files carried, anything skipped or failed. Then: excluded dirs needing an
install, missing keys or `.pub` files, the source left as it was (offer nothing destructive; the
user deletes it themselves when happy).
