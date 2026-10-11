---
name: dumbdown
description: Use when the user types /dumbdown, or says they did not understand an explanation — "explain it simpler", "dumb it down", "in plain words", "too technical", "what does that even mean", "I don't get it".
argument-hint: "[the part you didn't get]"
---

# /dumbdown — say it again, simpler

Re-explain your previous message so someone outside the field understands
it. Each time the user calls this again in a row, go one level simpler.

## What to re-explain

- First call: your last message before the command.
- Called again right after a `/dumbdown` answer: the **same original
  message**, one level lower. The previous attempt shows what still did not
  land.
- If `$ARGUMENTS` names a part ("the cache bit", "step 3"), explain only that
  part.

## Levels

| call | reader | how it sounds |
|------|--------|---------------|
| 1st | a smart adult from another field | plain words, every term replaced or explained, short sentences |
| 2nd | someone with no technical background | the real sequence of events, one step per sentence, each thing named by what it does here |
| 3rd and after | someone who only needs the gist | the single core fact in two or three sentences, plus what to do if anything |

Simpler means fewer ideas, not just easier words. On each level drop the
detail that matters least and keep what the user needs: what happened, what it
means for them, and what they have to do, if anything.

## Rules for every level

- **No analogies, metaphors or comparisons** unless the user explicitly asks
  for one. Explain the actual situation in its own terms: the real things
  involved (this container, this file, your login) and what actually happens
  to them. "Like a library card" or "think of it as a shelf" is not simpler,
  it is a different story the user then has to translate back.

- **No acronyms or abbreviations.** Not even common ones (API, CI, DNS, PR,
  URL), and write units out ("six hours", not "6h"). Say what the thing does:
  "the automatic checks that run when code is uploaded", not "CI". Product
  names the user already uses (GitHub, Docker) may stay.
- **No jargon.** Replace it with what it does. If a term is unavoidable
  because the user will see it on screen, write it once and explain it in the
  same sentence.
- **Keep it correct.** Simpler, never wrong. Keep the original's certainty ("should work" stays
  "should"). If you notice the original message was wrong, say so plainly.
- **Short sentences, everyday words, plain prose.** No tables, no code, no
  file paths. Use a short list only for steps the user has to do.
- Start with the explanation itself. No "Sure!", no "Great question", no
  "In simple terms". Don't apologize for the earlier message.
- Never talk down to the user. Simple words are fine at level 3; a baby
  voice or "imagine you're a little kid" is not.

## Example

Original: "The OAuth token expired, so the API returned 401 and the CI job
failed."

1st: "The login pass the program uses to talk to the other service had
expired. The service refused the request, so the automatic checks that run
on every change stopped with an error."

2nd: "The program logs in to another service before it can use it. That
login only lasts a limited time, and it had run out. So the service said no,
and the automatic check that was running stopped."

3rd: "The program's login had run out, so the check failed."
