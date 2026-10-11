---
name: tell-client
description: Use when the user types /tell-client, or needs to tell a non-technical client, customer or stakeholder what was changed, fixed or built — an update message, a "what we did" note, a reply explaining a change — written to send under the user's own name.
argument-hint: "[client name] [language] [what to focus on]"
---

# /tell-client — a message the user sends as their own

Write a short update the user can paste to a non-technical client. The client
should understand what changed for them, and the message should read as if
the user typed it themselves.

## 1. Work out what happened

Use this conversation first. If it doesn't cover the work, read the repo:

```bash
git log --oneline -15
git diff --stat HEAD~5..HEAD   # widen or narrow to the session's commits
```

`$ARGUMENTS` may give the client's name, a language, or a focus ("only the
login fix"). Ask one question only if you truly can't tell which work the
message is about.

## 2. Translate to what the client sees

The client cares about outcomes, not how they were reached. For each change,
answer: what is different for them or their users, and do they need to do
anything?

| we did | client hears |
|--------|--------------|
| fixed race condition in checkout webhook | some orders weren't showing up after payment, that's fixed |
| migrated to new hosting, added CDN | moved the site to a better server, pages should load faster now |
| added rate limiting after bot traffic | put a limit in place so a bot can't flood the bookings like last week |

Leave out internal work the client can't notice (upgrades, tests, cleanup),
unless it explains a delay or a cost, or the client asked about it. Group small changes into one sentence. Never invent a benefit you
didn't verify.

## 3. Write it in the user's voice

The message is:

- **Short.** 3–8 sentences for a typical update. A greeting line, what
  changed, anything they need to do (if nothing, say so in a few words or
  leave it out, never invent a task), a sign-off with the user's first name
  (`git config user.name`).
- **First person, casual and plain.** "I" by default, "we" if the user works
  with a team. Written like a quick message to someone they work with.
- **Plain text.** Paragraphs or a very short dash list. No headings, no bold,
  no emoji.
- **No technical words.** No acronyms, no tool names, no file names, no
  version numbers unless the client uses them themselves. Times, dates and
  money in the client's everyday format.
- **In the language the user asks for.** Otherwise match the language the
  user writes to you in.

So it doesn't read like AI wrote it, it avoids:

- em dashes (—) and semicolons. Use commas, periods, "and", "so".
- "I hope this finds you well", "I'm excited to share", "Great news!",
  "Please don't hesitate to reach out", "Let me know if you have any
  questions!"
- seamless, robust, leverage, enhance, ensure, streamline, comprehensive,
  delve, optimize, "under the hood"
- three-part lists of adjectives, and a closing line that sums up the message
- perfectly matching sentence lengths. Mix short and long.

**Small imperfections are allowed, not required.** At most one or two in a
message, picked from slips a busy person really makes: a missing comma, a
lowercase start after a greeting, "dont" or "its" without the apostrophe, a
casual "btw" or "anyway". Never put them in names, numbers, dates, prices or
anything where a slip changes the meaning. Skip them altogether when the
message is formal (an apology for an outage, anything about money or
contracts).

If the user has sent you a message they wrote to this client before, match
its greeting, sign-off, length and tone. Their own style beats every rule
above.

## 4. Output

Only the message, inside a plain fenced block so it copies cleanly. After it,
one line at most naming what you left out on purpose ("left out the
upgrade and the tests, the client won't notice them"). No other commentary.

## Example

```
Hi Anna,

quick update on the shop. The problem where some orders didn't show up in
your dashboard after payment is fixed, I tested it with a few orders today
and they all came through.

I also moved the site to a better server so pages should open a bit faster,
especially on phones.

Nothing you need to do on your side. If you notice anything odd just let me
know

Petr
```
