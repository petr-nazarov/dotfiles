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
| 2nd | a curious 12-year-old | one everyday comparison carries the idea ("like a library card that expires") |
| 3rd and after | a 5-year-old | only the single core idea in two or three sentences, plus what to do if anything |

Simpler means fewer ideas, not just easier words. On each level drop the
detail that matters least and keep what the user needs: what happened, what it
means for them, and what they have to do, if anything.

## Rules for every level

- **No acronyms or abbreviations.** Not even common ones (API, CI, DNS, PR,
  URL), and write units out ("six hours", not "6h"). Say what the thing does:
  "the automatic checks that run when code is uploaded", not "CI". Product
  names the user already uses (GitHub, Docker) may stay.
- **No jargon.** Replace it with what it does. If a term is unavoidable
  because the user will see it on screen, write it once and explain it in the
  same sentence.
- **Keep it correct.** Simpler, never wrong. A comparison that misleads is
  worse than none. Keep the original's certainty ("should work" stays
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

2nd: "It's like a visitor badge that's only good for one day. The program
showed yesterday's badge, the door stayed shut, and the job it was doing
stopped."

3rd: "The program's pass was too old, so it wasn't let in."
