---
name: devcontainers
description: Use when the user types /devcontainers (alone, `update` or `add`), asks which devcontainers exist on this machine, wants one or more recreated, rebuilt or updated to the latest devcontainer definition without losing the logins, history and tools inside them, or wants a devcontainer set up in a project that has none.
argument-hint: "[update | add [path]]"
allowed-tools: [Bash, Read, Edit, Write, AskUserQuestion]
---

# Devcontainers

Every project uses the base from `~/dotfiles/.devcontainer/base`. Its `README.md` is the reference
for how the home folder, mounts, SSH agent and refresh work. Read the sections you need from it
instead of guessing.

| argument | do |
|---|---|
| `update`, or none | follow `update.md` in this folder: list, pick, update definitions, recreate safely |
| `add [path]` | follow `add.md` in this folder: set up a devcontainer in a project (default: the current folder) |

Read the whole file for the command before running anything.

Applies to both:

- Ask with `AskUserQuestion`. Never pick containers, keys or login modes for the user.
- **Never read SSH keys.** Not the private keys, not the `.pub` files: no `cat`, `ssh-keygen`,
  `head` or `Read` on them. Listing file *names* (`ls`) and `test -e` are the only operations
  allowed on `~/.ssh` and `~/.secrets/home/.ssh`.
- `~/dotfiles` local files are newer than GitHub; copy from them, not with `degit`.
- Commands that build or recreate run from the project folder, in the foreground, with a long
  timeout.
- Report uncommitted changes left in `~/dotfiles` at the end.
