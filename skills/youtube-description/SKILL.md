---
name: youtube-description
description: Transcribe a finished YouTube video and generate its description block — a very short 2-sentence description, your fixed CTA, and YouTube chapter timestamps — then write it into your content record. Uses ElevenLabs Scribe for word-level timestamps. Use when asked to "write the YouTube description", "generate timestamps / chapters for this video", "describe this YT video", "make the description for <video>", or "/youtube-description".
---

# youtube-description

Turns a finished video cut into a copy-paste-ready YouTube description.
Three parts, always in this order:

1. **Description** — very short, 2 sentences, in your voice.
2. **Fixed CTA block** — your product + social links, verbatim, never edited.
3. **Timestamps** — YouTube chapters derived from the transcript.

The transcription engine is ElevenLabs Scribe (word-level timestamps),
the same one `/video-use` uses. The output is a block you paste into
YouTube yourself (this skill does not touch the live video).

---

## SETUP (run this once)

1. Lock your **fixed CTA block** by filling the placeholders in step 4:
   `<YOUR_BRAND>`, `<YOUR_DOMAIN>`, `<YOUR_LINKEDIN_URL>`. After that the
   CTA is reproduced verbatim on every video, never reworded.
2. Set `ELEVENLABS_API_KEY` in your env (or `.env`). Scribe needs it.
   `/video-use` in this vault already uses the same key.
3. (Optional) Point `<YOUR_BRAND_DOC>` at your voice rules so the
   description passes the same slop checks as your other copy.

---

## When to use

Trigger on:
- "Write the YouTube description for <video>"
- "Generate chapters / timestamps for this video"
- "Describe this YT video"
- User types `/youtube-description`

Sibling skills (don't confuse):
- Upload + thumbnails + playlist → `/youtube-publisher`
- Edit raw footage into a cut → `/video-use`
- Write the script before filming → `/youtube-script`

---

## Inputs

A finished video. Accept any of:
- An absolute path to an `.mp4` / `.mov`.
- An existing ElevenLabs Scribe JSON (a `/video-use` transcript on disk) —
  reuse it to skip the API call and the wait. `/video-use` edits store
  these under `<videos_dir>/edit/transcripts/<stem>.json`.

---

## Workflow

### 1. Get a timestamped transcript

Reuse a `/video-use` Scribe JSON if one exists (no API call, no wait —
Scribe on a 25-min video costs minutes and credits). Otherwise call
Scribe once and cache the result.

Either way, build a `[M:SS] text` transcript — one line per ~20s — and
note the **total duration** (no chapter may land at or past it). The
ElevenLabs Scribe endpoint returns word-level `start`/`end` times; group
words into ~20s buckets and prefix each line with its start timestamp.

Read the whole transcript. It is your only source for both the
description and the chapters.

### 2. Write the description (very short · 2 sentences)

House format for a tutorial:

> Learn how to set up a cold email system with Claude Code that can handle
> 100k+ emails / month. We'll be using Claude Code, <YOUR_BRAND>, and a set
> of other tools.

Pattern:
- **Sentence 1:** `Learn how to <outcome> with <concrete spec>.` The
  outcome and the number are the hook. Lead with what the viewer can do.
- **Sentence 2:** `We'll be using <tool stack>.` Lowercase the tool names,
  end with "and other tools" / "and a set of custom skills" if the list
  runs long.

Rules: two sentences, no more. No em dashes (use `.` `,` `:` `(` `·`).
No banned words (`leverage`, `seamless`, `powerful`, … full list in
`<YOUR_BRAND_DOC>`). Concrete numerals over adjectives. It must read like
you typed it, not like a SaaS template.

### 3. Build the chapters

From the transcript, pick chapter boundaries at real topic shifts and
title each. Hard YouTube rules:
- **First chapter is `0:00`.** Always. Without it YouTube shows no chapters.
- At least **3** chapters; each at least **10s** after the previous.
- Use the timestamp format the transcript prints (`M:SS`, or `H:MM:SS`
  past an hour).
- Titles: terse, descriptive, no numbering, no em dashes. Lead with the
  thing the viewer learns ("Connecting your CRM"), not "Part 3".
- 8–15 chapters for a 20–30 min tutorial is the right density. Don't make
  one per transcript line.

### 4. Assemble the block

Exactly this structure. The **fixed CTA block sits between the
description and the timestamps** and is reproduced **verbatim** — never
reword, never drop a line, never change the handle:

```
<description · sentence 1>
<description · sentence 2>

Try <YOUR_BRAND> for free:
<YOUR_DOMAIN>

Connect with me on LinkedIn:
<YOUR_LINKEDIN_URL>

Timestamps:
0:00 <first chapter title>
<m:ss> <title>
<m:ss> <title>
...
```

### 5. Write it into your content record

Put the assembled block where your content lives so it's tracked and
copy-pasteable:
- **Markdown content vault**: add or replace a `## YouTube description`
  section in the video's `.md` file. Wrap the block in a fenced
  ` ```text ` code block so line breaks survive the paste into YouTube.
  The section is **idempotent** — replace the existing one, don't append
  a second.
- **Notion Content DB**: paste the block into the video row's body /
  a "YouTube description" property.

Report back where you wrote it and the chapter count. Show the assembled
block in chat too.

---

## Definition of done

1. A timestamped transcript exists for the video.
2. A 2-sentence description in your voice (no em dashes, no banned words).
3. The fixed CTA block, verbatim, between description and timestamps.
4. Chapters starting at `0:00`, none past the printed duration.
5. The whole block written into your content record as an idempotent
   section, inside a copy-paste-ready code block, and the location reported.

---

## Don'ts

- **Don't pad the description.** Two sentences. (This is the opposite of
  the terse-CTA-only rule in `/youtube-publisher`; here you explicitly
  want the short description + timestamps. But "short" still means two
  sentences.)
- **Don't edit the CTA block.** Verbatim, including the LinkedIn URL (use
  your canonical profile — no tracking params).
- **Don't invent chapter times.** Every timestamp comes from the transcript.
- **Don't push to the live YouTube video.** The content record only,
  unless asked. To set descriptions live, `/youtube-publisher`'s
  finalize step (`--only-descriptions`) is the path.
- **Don't burn Scribe on an existing transcript.** Check for a
  `/video-use` JSON first and reuse it.
