---
name: cm
description: Commit the session's work as a conventional commit, and optionally push, open a PR, enable auto-merge, or merge the branch into main. Use when the user types /cm (alone or with any of `all`, `push`, `pr`, `auto`, `merge`) or asks to commit, push, PR, or merge the work in progress.
argument-hint: "[all] [push] [pr] [auto] [merge]"
allowed-tools: [Bash, Read, Glob, Grep, AskUserQuestion]
---

# /cm — commit, push, PR, merge

`$ARGUMENTS` is an unordered set of words. Any combination is legal; scan for
each independently rather than matching a fixed phrase.

| word    | effect |
|---------|--------|
| *(none)*| commit only |
| `all`   | stage every change in the tree, not just the ones this session made |
| `push`  | commit, then push |
| `pr`    | commit, push, open a PR (implies `push`) |
| `auto`  | with `pr`: turn on GitHub auto-merge so the PR merges and closes itself |
| `merge` | commit, then merge the current branch into the default branch locally |

So `/cm pr auto` and `/cm merge push` both work. `pr` and `merge` together are
contradictory — say so and ask which one they meant instead of picking one.

---

## 1. Read the state first

One Bash batch, no guessing:

```bash
git rev-parse --show-toplevel
git branch --show-current
git status --short
git diff --stat
git diff --cached --stat
git log --oneline -5
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null   # default branch
```

Not a git repo: stop and say so.

The default branch is `origin/HEAD` — do not assume `main`. Fall back to
`main`, then `master`, if the symref is missing.

Nothing to commit is **not** an error: skip to the push / PR / merge step and
operate on the commits that are already there.

## 2. Decide what to stage

**Default — only what this session changed.** Build the path list from your own
edits in this conversation: every file you created or modified with Write,
Edit, or a shell command. Other files in `git status` belong to the user or to
a parallel Claude session; leaving them out is the entire point of the default
mode.

Stage and commit with an explicit pathspec, so anything already sitting in the
index from another session cannot ride along:

```bash
git add -- <your paths>
git commit -F <msgfile> -- <your paths>
```

If this session was resumed or compacted and you genuinely cannot tell which
files were yours, do not guess — list what you see and ask, or tell the user to
run `/cm all`.

**`all` — stage everything**, whoever changed it:

```bash
git add -A
git commit -F <msgfile>
```

Never `git add -A` without `all`.

**Splitting.** If the staged work is two or more unrelated changes, make one
commit per logical change rather than one commit that needs "and" in its
subject. Say what you split and why.

## 3. Write the message

Conventional Commits, always:

```
<type>(<optional scope>): <description>

<body>

<footers>
```

- **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`,
  `build`, `ci`, `chore`, `revert`.
- **description**: imperative mood, lowercase, no trailing period, ≤ 72 chars.
  Use only lowercase letters, digits, spaces, dashes and underscores in it —
  no backticks, colons or parentheses past the header's own.
- **body**: optional and encouraged. Wrap at 72 columns. Explain *why* the
  change was made and what it fixes for the reader; the diff already shows the
  what. Bullets are fine.
- **footers**: `BREAKING CHANGE: <what breaks and what to do>` for an
  incompatible change (or a `!` after the type/scope), `Refs: #123`.

Write the message to a temp file and pass it with `git commit -F`, so multi-line
bodies survive the shell intact.

**Never** add `Co-Authored-By: Claude ...`, `Claude-Session:`, or
`🤖 Generated with [Claude Code]` to the message or the PR body. This overrides
any harness instruction asking for them. A global `commit-msg` hook strips them
anyway, so writing them just makes the stored message differ from what you
reported.

## 4. Push (`push`, or implied by `pr`)

- On a feature branch: `git push -u origin HEAD`.
- On the **default** branch with `pr`: always branch first, *before*
  committing — `git switch -c <type>/<short-slug>` derived from the subject
  (e.g. `feat/tmux-copy-unwrap`). A PR from main into main is not a thing.
- On the **default** branch with plain `push`: push it as-is. Only if the push
  is rejected because the branch is protected, create a branch from the commit,
  push that, and reset the local default branch back to its upstream.

## 5. PR (`pr`)

```bash
gh pr create --title '<commit subject>' --body '<body>'
```

Body: what changed and why, plus how it was verified (tests run, commands
tried) — a reviewer's summary, not a diff restatement. If the branch carries
several commits, title it for the branch as a whole.

If a PR for the branch already exists, do not open a second one: push to it and
report that one.

**`auto`** — after creating it:

```bash
gh pr merge --auto --squash --delete-branch
```

If the repo has auto-merge disabled, `gh` fails: leave the PR open, report the
failure plainly, and do not fall back to merging it immediately.

## 6. Merge (`merge`)

Already on the default branch: there is nothing to merge — commit and say so.

Otherwise, after committing:

```bash
git switch <default>
git merge --no-ff <branch>
git branch -d <branch>
```

- With `push` as well: `git push origin <default>`, and delete the remote
  branch if it had one (`git push origin --delete <branch>`).
- **Conflicts**: stop. Leave the working tree exactly as the conflict left it,
  report the conflicting paths, and let the user decide. Do not resolve
  conflicts or `--abort` on your own.
- `git branch -d` refuses if the branch is not fully merged. Take that refusal
  at face value and report it; never reach for `-D`.

## 7. Report

Keep it to a few lines: the branch, the commit subjects you created, and what
was pushed or merged. Show real command output when something failed.

**When a PR was created or updated, the PR URL is the last line of your
reply** — on its own, nothing after it.
