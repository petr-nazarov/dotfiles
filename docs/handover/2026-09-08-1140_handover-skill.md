# Handover: handover-skill

2026-09-08 11:40 · dotfiles · branch `main` · HEAD `56d965d`

## Goal

Give Claude Code sessions a way to hand work off — between sessions, machines,
days, or agents — instead of losing context at the boundary. A skill writes a
one-page, fixed-template summary into `docs/handover/` of whatever repo is being
worked on, commits it, and pushes it, so the next session (anywhere) can pick it
up cold.

## Current state

Done and verified:

- `clip-edit`: SUPER+CTRL+SHIFT+V opens the cliphist picker, edits the chosen
  entry in nvim inside ghostty, and copies the result back on save. Verified
  end-to-end with stubbed tofi/ghostty/wl-copy (edited content reaches wl-copy
  intact, unchanged content copies nothing, dismissed picker is a no-op, no temp
  files left behind); `hyprctl binds` confirms modmask 69 on V. Committed as
  `56d965d`.
- `handover` skill written and stowed; the symlink at
  `~/.claude/skills/handover/SKILL.md` resolves into this repo, and the skill
  now appears in the session's available-skills list, so registration works.

Done but untested:

- The `handover` skill's own behaviour end to end. This document is the first
  run of write mode. Resume mode has never been executed.

## Changed files

Uncommitted:
- `_claude/.claude/skills/handover/SKILL.md` - the new skill: write mode
  (gather git state → derive theme → fixed template → dirty-tree question →
  commit/push) and resume mode (read newest handover → verify against current
  git state → report drift → stop).

Committed this session:
- `56d965d` clip edit — `_headless/.local/bin/clip-edit` plus the
  SUPER+CTRL+SHIFT+V bind at `_linux_gui/.config/hypr/hyprland.lua:181`.

## Next step

Run `/handover resume` in this repo to exercise resume mode against this
document, and confirm it reports an empty drift list.

## Blockers & open decisions

None. Design decisions settled this session: in-repo + committed + pushed;
two modes (write/resume); ask at runtime on a dirty tree; fixed ~1-page
template; `YYYY-MM-DD-HHMM_<slug>.md` with resume taking the newest; manual
invocation plus a proactive offer, never an unprompted write.

## How to verify

```bash
ls -l ~/.claude/skills/handover/SKILL.md   # symlink into dotfiles/_claude/...
ls docs/handover/                          # this file
```

A good result: the symlink resolves, the file is listed, and `/handover resume`
summarises this document with no drift.
