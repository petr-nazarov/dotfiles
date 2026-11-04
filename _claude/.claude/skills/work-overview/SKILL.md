---
name: work-overview
description: Use when the user types /work-overview, or wants a short overview for a client of what was done over a period — today, yesterday, this or last week, last month, since a date, since the last overview — across all of that client's projects, not just the current repo.
argument-hint: "[today | yesterday | last week | last month | since YYYY-MM-DD | since last] [language]"
allowed-tools: [Bash, Read, Write, AskUserQuestion]
---

# /work-overview — what the client got this period

A very short, non-technical note telling the client what changed for them over a period, built
from every repo of that client and from the user's Claude sessions there.

## 1. Pick the window

From `$ARGUMENTS`, in local time. `until` is not included.

| argument | since | until |
|---|---|---|
| `today` | today | tomorrow |
| `yesterday` | yesterday | today |
| `last week`, `past week` | 6 days ago | tomorrow |
| `this week` | this Monday | tomorrow |
| `last month`, `past month` | same date a month ago | tomorrow |
| `this month` | the 1st of this month | tomorrow |
| `since 2026-10-01` | that date | tomorrow |
| `2026-10-01..2026-10-15` | first date | day after the second |
| `since last`, or nothing | the last day the newest `tmp/work-overview-*.md` covered (its end date minus one) | tomorrow |

Nothing given and no earlier overview: the past week. Get today with `date +%F` and do the date
math yourself; `date -d` and `date -v` differ between Linux and macOS.

## 2. Find the client root

- **In a devcontainer** (`/.dockerenv` exists or the current folder is under `/workspaces`): the
  workspace folder, `/workspaces/<name>`. Every repo in it belongs to this client.
- **On the host**: walk up from the current folder to the folder directly inside a `clients`
  folder (`~/Projects/FrrCode/clients/cardbook`).
- Neither fits: ask with `AskUserQuestion`, offering the git top-level and its parent.

## 3. Collect

```bash
bash ~/.claude/skills/work-overview/scripts/collect.sh <since> <until> <client root>
```

It prints the user's commits on every branch, their PRs and issues on GitHub, uncommitted work,
and the user's prompts from Claude sessions under that root, including those inside the
client's devcontainers. The header comment in the script describes the format. A `note:` line
about gh means PR data is missing for those repos. Fill the gap from `origin/main` (merged
work), and say in one line after the note that PRs weren't checked.

Read a commit or PR only when its subject is too vague to tell what it did for the client.
Prompts can still hold secrets the script didn't catch; nothing from them is copied into the note
except plain facts.

Sort every item into one of these, from the data alone:

| the data shows | it goes in the note as |
|---|---|
| merged or on main, and a later prompt deployed it (deploys ship everything on main before them) | done, live now |
| merged or on main in a repo with no deploy step (used straight from git, pulled by a hook) | done, live now |
| merged or on main, no deploy seen; or a mobile app change with no store release seen | done, "goes out with the next update" |
| a branch, an open PR, uncommitted work, or a request with no commit yet | in progress |
| a prompt with an outcome and no code: an investigation, an answer, a provider set up, data pulled | done, as that outcome |
| a request that was later undone or rolled back | left out |

## 4. Write the note

Read section 2 of `~/.claude/skills/tell-client/SKILL.md` and translate the same way: what is
different for the client or their users, never how. Group by product or area the client knows by name, merge small items, leave out
internal work they can't notice (refactors, tooling, tests, hooks, the user's own setup).

Shape, every time:

```markdown
# <Client> — work overview, <period, e.g. "22–29 October 2026" or "29 October 2026">

- <one sentence: what changed for them>
- ...

**In progress:** <one sentence, only if something is unfinished and visible to them>
**Needed from you:** <one sentence, only if they must do something>
```

3–7 bullets in total. Each bullet is one plain sentence, no technical words, tool names, PR
numbers or file names. Never claim a result the data doesn't show. Nothing client-facing in the
window: one bullet saying so.

- **Client name:** the client root's folder name, spelled the way the client's products spell it
  (`cardbook` → CardBook). Never the GitHub org name.
- **Needed from you:** only an action the client must take: something the user asked them for in a
  prompt, or an access, decision or content the work is waiting on. A question the user is still
  working out themselves is not one.
- **Language:** a language word in `$ARGUMENTS` wins. Otherwise the language the user has the
  client's messages written in (prompts like "tell client in russian"), else English.

## 5. Save and show

Write it to `tmp/work-overview-<since>_<until>.md` in the current folder (create `tmp/`; keep
the dates in the name, step 1 reads them back). If the current folder is a git repo and
`git check-ignore -q tmp` fails, mention that `tmp/` isn't ignored. Then print the same note in
the reply, followed by the file path and, at most, one line on what you left out on purpose.
