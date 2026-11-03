---
name: media-to-text
description: Use when the user types /media-to-text, or points at audio or video files (voice messages, Telegram/WhatsApp .ogg/.opus, calls, meetings, podcasts, lectures, .mp3/.m4a/.mp4/.mkv/.webm) and wants them transcribed, deciphered, summarized, or turned into text — including "decipher these voice notes", "what did they say", "transcript of this call", or "one of the messages says what to do: do it".
argument-hint: "[dir-or-files] [-l LANG]"
---

# Media to Text (+ summary)

Local transcription with whisper.cpp, then a speaker-labeled transcript, a summary, and any requests found in the recording.

Input: $ARGUMENTS (default: media files in the current directory).

## 1. Transcribe

Run in the background (about 1 minute of compute per 10 minutes of audio on this CPU):

```bash
bash ~/.claude/skills/media-to-text/transcribe.sh <scratchpad>/media <dir-or-files...> [-l ru]
```

- Writes `<out>/all.txt`: one `=== name (m:ss)` header per file, in name order. Telegram file IDs sort chronologically. For other names, check that name order is the real order (dates in the names, mtime).
- Re-running skips files that are already transcribed, so after a failure just run it again.
- Model: `$WHISPER_MODEL`, default `~/.local/share/voxtype/models/ggml-large-v3-turbo.bin`. Pass `-l <lang>` when the language is known. Auto-detection can switch language on short clips.
- Never pipe `ls` into xargs: `ls` here is eza with long output, which breaks file names. The script uses `find`.

## 2. Build `transcript.md` next to the source files

- **Speakers:** the audio has no speaker labels, so infer who is talking from the content: who reports, who asks, "I told them…", who owns which product. The user is Петя (Petya). Use the other person's name if it comes up, otherwise "Партнёр" or "Speaker B". Note which attributions are uncertain.
- **Cleanup:** fix only obvious mishears of names and terms, such as product names or "сексосфи" → success fee. Keep the original wording; don't paraphrase.
- **Header:** source, date, and a note that it was transcribed automatically and the speakers are inferred. Then one block per message: `**Speaker** _(m:ss, id)_`, followed by the text.
- **Transcript language:** keep the original. The summary is written in the language the user is writing in.

Generate the file with a small script (speaker map + replacement list) instead of retyping long transcripts by hand.

## 3. Find and act on instructions

Scan the transcript for requests addressed to the user ("can you send…", "prepare…", "next steps"). If the user said "do what it says":
- Do the tasks that fall within this session (send/prepare the transcript, write a draft, a list of questions).
- Report anything outward-facing (sending messages, signing, paying) and leave it undone.
- Point out what the recording can't supply, such as text messages sent between the voice notes.

## 4. Reply

1. **Instruction found / done:** what was asked, by whom, what you did, and the transcript's absolute path.
2. **Summary:** topic and context, key numbers and decisions, disagreements and how they were resolved, next steps with owners.
3. **Caveats:** uncertain speakers, failed files, low-confidence passages.

## Common mistakes

| Mistake | Fix |
|---|---|
| Summary only, no transcript file | Always write `transcript.md`. The user often forwards it or puts it in a CRM. |
| Treating messages as one speaker | Infer and label the speakers. Conversations alternate. |
| Running whisper in the foreground on long media | Use `run_in_background` and wait for the notification. |
| Video ignored | The script extracts the audio track (`-vn`) from mp4/mkv/mov/webm. |
| Missing model | `curl -L -o <path> https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin` |
