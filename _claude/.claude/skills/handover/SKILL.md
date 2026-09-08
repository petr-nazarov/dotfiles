---
name: handover
description: Write or resume a session handover document. Use when the user is switching sessions, logging off for the day, moving to another computer, or handing work to another agent or person - and when they ask to pick up where a previous session left off. Offer it when the user signals they are wrapping up ("done for today", "continue tomorrow", "switching to my laptop"), but never write one unprompted.
argument-hint: "[resume] [theme]"
allowed-tools: [Bash, Read, Write, Glob, AskUserQuestion]
---

# Session Handover

Two modes, chosen from `$ARGUMENTS`:

- Starts with `resume` (or `pickup`, `continue`) -> **Resume mode**.
- Anything else (including empty) -> **Write mode**. A non-`resume` argument is the theme slug.

The reader of everything you write here is a fresh Claude session with zero
context, sometimes weeks later, sometimes on another machine. Write for that
reader, not for yourself.

---

## Write mode

### 1. Gather state

One Bash batch, no guessing:

```bash
git rev-parse --show-toplevel 2>/dev/null
git branch --show-current
git status --short
git log --oneline -10
git diff --stat
git stash list
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
```

Not a git repo: say so, write the file to `docs/handover/` relative to the
current directory, and skip every commit and push step. Do not write outside
the project directory.

### 2. Derive the theme

A kebab-case slug of 2-4 words describing what this session was actually about
(`clip-edit-binding`, `auth-token-refresh`). Use `$ARGUMENTS` verbatim if a
theme was passed. Not the branch name unless the branch name happens to say it.

### 3. Compose the document

Fixed template, every time, so resume mode can parse it. Target one page. If it
needs more than a page, the "Next step" is too vague - sharpen it instead of
writing more.

```markdown
# Handover: <theme>

<YYYY-MM-DD HH:MM> · <repo name> · branch `<branch>` · HEAD `<short sha>`

## Goal

What we are trying to achieve. One to three sentences. The why, not the diff.

## Current state

What is done and verified, versus done but untested. Name the verification that
actually ran ("hyprctl binds confirms modmask 69"), not the intent to run one.

## Changed files

Uncommitted:
- `path/to/file` - one line on why it changed

Committed this session:
- `<sha>` <subject>

## Next step

One concrete action. The literal thing to do first, not a list of everything
remaining.

## Blockers & open decisions

Anything waiting on the user, an external system, or an unmade decision.
Include questions already asked and still unanswered. Omit the section when
there are none.

## How to verify

The exact command(s) that check the work, and what a good result looks like.
```

Rules for the content:

- Report only what git output and this session actually show. No invented
  progress, no "should work", no summarising code you did not read.
- Never paste secrets, tokens, `.env` values, or credentials into the document.
- Every file in `git status` gets a line. If you cannot say why a file changed,
  say that - an unexplained modification is exactly what the next session needs
  flagged.

### 4. Handle the dirty tree

If the tree is dirty, the handover document will be pushed but the work it
describes will not be. Ask (AskUserQuestion) before writing anything:

- **WIP-commit everything + handover** - `git add -A`, commit as `wip: <theme>`,
  then the handover as its own commit. The other machine gets the actual code.
- **Handover only** - commit just the document. The notes travel, the code does
  not.

Always two separate commits, so the WIP commit stays trivial to drop, amend, or
rebase away later.

### 5. Write, commit, push

- Path: `docs/handover/YYYY-MM-DD-HHMM_<slug>.md` (24-hour local time). Create
  the directory if missing.
- Commit the document as `docs: handover - <theme>`.
- Push when an upstream exists. When there is no remote or no upstream, say so
  plainly - the user needs to know the handover did not leave the machine.
- Follow whatever commit-attribution rules the session already has; do not add
  trailers of your own.

### 6. Report

Print the file path, whether it was pushed, and the pickup line for the other
end:

```
/handover resume
```

---

## Resume mode

### 1. Find the handover

`ls -1 docs/handover/*.md` and take the newest by filename (they sort
chronologically). If `$ARGUMENTS` names a theme, take the newest matching it.
List the other available handovers in one line so the user can pick an older
one. No handover directory: say so and stop.

### 2. Read it

### 3. Verify it against reality before believing any of it

A handover is a claim about a repo that has moved on since. Check:

```bash
git branch --show-current
git log --oneline <head-sha-from-handover>..HEAD
git status --short
git stash list
```

- Is the branch named in the handover still present, and is it checked out?
- Are the files listed as uncommitted still modified?
- Have commits landed since the handover was written?
- Does the `wip:` commit it mentions exist?

### 4. Report

Summarise the handover, then a **Drift** list of every way current reality
differs from what the document claims. An empty drift list is worth stating
explicitly - it means the document can be trusted as written.

### 5. Stop

State the next step from the handover and wait. Do not start working on it. The
user resumes when they are ready.
