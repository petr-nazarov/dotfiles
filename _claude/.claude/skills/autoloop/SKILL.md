---
name: autoloop
description: Use when the user types /autoloop (alone or with `commit`, `push`, `merge`, `deploy` or `full`), or wants a feature built unattended — overnight, while they are away from the computer — and carried all the way to a commit, push, merge, or deployment without further input from them.
argument-hint: "[commit|push|merge|deploy]"
---

# /autoloop — brainstorm now, build unattended

Two phases with a hard line between them:

1. **Interview (user present).** Every question you will ever need answered
   gets asked now.
2. **Loop (user absent).** From the moment they say "go" you never ask again.
   You run brainstorming → spec → plan → implementation → verification → the
   chosen git/deploy level, and you end with a working result plus a list of
   the decisions you made on their behalf.

The user's instruction to run unattended overrides every approval gate in
other skills (brainstorming's spec review, writing-plans' execution choice,
finishing-a-development-branch's options). The signed contract *is* those
approvals.

## Modes

Levels are cumulative — each includes everything above it.

| mode | ends with |
|------|-----------|
| `commit` | tests green locally, work committed |
| `push` | + branch pushed, CI green if the repo has CI |
| `merge` | + branch merged into the default branch, default branch pushed |
| `deploy` / `full` | + deployed and smoke-tested. Dev environment if the project has dev and prod; the only environment if it has one. **Never prod when a dev exists.** |

---

## Phase 1 — Interview

### 1. First question: the mode

If `$ARGUMENTS` names a mode, that is the answer. Otherwise the very first
thing you do — before exploring, before brainstorming — is ask it with
AskUserQuestion (`commit` / `push` / `merge` / `deploy`).

### 2. Explore and preflight (read-only)

Find out now what would otherwise stop you at 3 a.m.:

- `git status`, current branch, default branch (`origin/HEAD`), remote, upstream.
- Test, lint, typecheck and build commands. **Run the test suite now.** Any
  test already failing on the baseline goes into the contract by name; ask
  the user whether to fix it or leave it.
- `push`+: `gh auth status`, whether CI runs on branches/PRs, branch protection.
- `merge`+: whether main is protected (PR route needed) or a local merge is fine.
- `deploy`: how deployment happens (script, `just`/`make` target, CI on merge,
  platform CLI), which environments exist, whether credentials work *right
  now* (a read-only call such as `kubectl get ns`, `fly status`,
  `gcloud config list`), and whether the target environment is healthy now.
  Down → ask whether you may redeploy it or should stop at `merge`.
- Whether this session will block on permission prompts. If it is not in
  bypass-permissions mode, tell the user the loop will stall at the first
  prompt and have them fix it before starting.

### 3. Brainstorm, front-loaded

**REQUIRED SUB-SKILL:** superpowers:brainstorming — run its understanding,
classification, approaches and design steps now, while the user is here.
Differences:

- Use AskUserQuestion with up to 4 questions per call and a recommended
  option first; the user wants to leave, not chat one question at a time.
- Go past what brainstorming would ask: **predict the forks you will hit
  during implementation** (naming, library choice, UI details, data shape,
  edge-case behavior, what to do if X turns out impossible) and get those
  answered too.
- Ask what you may do without them: add dependencies? run migrations against
  dev? call paid APIs? create cloud resources?
- When the feature changes existing behavior, name the existing tests that
  will change and get a yes now.

### 4. The contract

Present one compact contract and ask for an explicit go:

```
Mode:        merge
Goal:        <outcome in 1-2 sentences>
Done means:  <checks that exercise the feature itself, not just liveness —
             e.g. "pytest green, GET /reports/1/export on dev returns text/csv">
Baseline:    <tests already failing before you start, and fix | leave>
Scope out:   <what you will not touch>
Design:      <chosen approach + key decisions from the interview>
Branch:      autoloop/<slug>  →  merged into main by <local merge | PR + auto-merge>
Deploy:      <command / pipeline, environment, smoke check>   (deploy mode only)
Allowed:     <deps, migrations, external calls the user approved>
Preflight:   tests <green|red: …>, gh auth ok, deploy creds ok, permissions ok
```

Do not start until the user says yes. Changes → revise and present again.

---

## Phase 2 — Loop

### Run log

Before anything else, write the contract to
`$(git rev-parse --git-common-dir)/autoloop/<start date YYYY-MM-DD>-<slug>.md` (inside
`.git`, so it is never committed). Append every decision and every gate result
to it as you go. After a context compaction, re-read it before doing anything.

### Pipeline

1. **Branch.** `push`/`merge`/`deploy`: create the contract's branch.
   `commit`: the branch the contract names.
2. **Spec.** Architectural path: write the spec as brainstorming describes,
   self-review it, commit it — no user review gate. Bounded path: the design
   goes in the run log; no spec file.
3. **Plan.** superpowers:writing-plans, then execute with
   superpowers:subagent-driven-development. Do not ask which execution method.
4. **Implement** with superpowers:test-driven-development; on a failure use
   superpowers:systematic-debugging.
5. **Review.** superpowers:requesting-code-review on the finished work; fix
   what it finds.
6. **Verify.** superpowers:verification-before-completion: full test suite,
   lint, typecheck, build, and actually run the thing (the `run` skill if
   present). Check every "Done means" item from the contract.
7. **Commit** using the project's conventions (the `cm` skill if present).
   If verify is red and you are stopping, still commit the work on the
   autoloop branch so nothing is lost, with a `wip:` subject, and never push it.
8. `push`+: push the branch; if CI exists, watch it (`gh run watch`) until
   it finishes. Red CI → back to step 4.
9. `merge`+: merge by the contract's method, push the default branch, then
   wait for CI on the default branch. If the default branch rejects the push
   (protected), switch to a PR with `gh pr merge --auto` and log the
   switch. A PR waiting on a human review is a stop at `push`.
10. `deploy`: deploy, watch it finish, run the smoke check against the
    deployed environment.

### Gates

Green means **no failures beyond the contract's baseline**. A test that
fails, then passes when you rerun it, counts as green only if it also flakes
on the baseline commit. Check that in a separate worktree and log it.

You never move to a level whose prerequisite is red. Failing tests do not get
pushed; red CI does not get merged; an unverified merge does not get
deployed. When you cannot make a gate green after three distinct fix
attempts (distinct hypotheses, not three retries of the same one), stop at
the highest green level you reached and report. Cap any single wait (CI,
deploy, review) at 60 minutes. A wait past that counts as a red gate.

### Questions that come up while the user is away

Do not use AskUserQuestion. Do not end your turn to wait. Instead:

1. Prefer what the contract or the interview already implies.
2. Otherwise pick the option that is **reversible and non-destructive** and
   **keeps existing behavior** where the contract did not ask for a change.
   When options are equally reversible, follow what the codebase and its
   users already do. Do not add config or flags just to hedge a choice.
3. Log it immediately: the decision, the alternatives, why, and how to
   reverse it.

### Never, even if it would get you to green

- Force-push, rewrite published history, `git branch -D`, `--no-verify`.
- Delete or skip tests, weaken assertions, or mark tests flaky to pass a gate.
  Changing a test is allowed only when the contract names that behavior
  change.
- Disable branch protection, admin-merge, or bypass required reviews or checks.
- Deploy to prod, touch prod data, drop or reset databases, rotate secrets.
- Do anything the contract's "Allowed" line did not cover that costs money or
  cannot be undone.

If the only way forward needs one of these, that is a blocker: stop at the
current level and report it.

### Keep going

Your turn ends only when the target level is reached and verified, or when a
blocker stops you. "Good progress, I'll summarize" with work remaining is not
an ending. Run long commands in the background and wait for them; do not stop
to ask whether to continue.

---

## Final report

Your last message, in this order:

1. **Result** — mode, level reached (none / committed / pushed / merged /
   deployed),
   branch, commit subjects, PR or deploy URL, and the evidence: the commands
   that ran and their outcome.
2. **Not done** — anything short of the contract, why, and the exact next
   command to finish it. Omit if empty.
3. **Run log** — its path.
4. **Decisions made while you were away** — last, so it is the first thing
   the user sees. One row per decision:

| # | Decision | Alternatives | Why | To change it |
|---|----------|--------------|-----|--------------|

Mark with ⚠ the ones the user is most likely to want to change.
