---
name: youtube-publisher
description: Upload videos to YouTube (single video or a numbered series), set titles + descriptions + custom thumbnails, build a playlist, and order it. End-to-end pipeline using the YouTube Data API v3 with resumable uploads, OAuth token caching, and idempotent state. Use when asked to "upload to YouTube", "publish these videos", "make a YT series", "set up a YT playlist", "redo thumbnails", or "/youtube-publisher".
---

# youtube-publisher

The YouTube publishing pipeline. Takes raw video files on disk and ends
with a fully-published series: titles in the right scheme, descriptions
with the right CTA, custom on-brand thumbnails on every video, and a
properly-ordered playlist. Idempotent state files make every step
re-runnable so future series ship in minutes, not hours.

---

## SETUP (run this once)

YouTube publishing needs your own Google Cloud project + OAuth. There is
no shared key — this talks to *your* channel.

1. **Google Cloud project** → enable **YouTube Data API v3**.
2. **OAuth Desktop client** → download `client_secrets.json` (keep it
   out of git — see `.gitignore`).
3. **Verify the channel** at https://www.youtube.com/verify (phone +
   SMS). Required before custom thumbnails work, and before description
   links become clickable.
4. Fill the placeholders used in the schemes below: `<YOUR_BRAND>`,
   `<YOUR_DOMAIN>`.
5. The first real API call pops a browser for OAuth and caches the token
   locally (`token.json`, auto-refreshed, gitignored).

This skill documents the pipeline (upload → render thumbnails → finalize
→ playlist) using the YouTube Data API v3. The two scripts referenced
below (`upload.py`, `finalize.py`) are small, resumable, idempotent
wrappers — set them up once in `<YOUR_YT_SCRIPTS>/` (or have the agent
build them from this spec) and reuse them per series.

---

## When to use

Trigger on:
- "Upload these videos to YouTube"
- "Publish the [series name] videos"
- "Make a YT playlist for X"
- "Set custom thumbnails on these videos"
- "Update YT titles / descriptions"
- "Redo the thumbnails"
- User types `/youtube-publisher`

Skip for:
- Editing raw footage → `/video-use`
- Building motion-graphics launch videos → `/launch-video`
- Writing the YouTube script itself → `/youtube-script`
- Designing the thumbnail art → `/youtube-thumbnail` (interview) or
  `/graphics-designer` (tutorial / solo). This skill *sets* the
  thumbnail; those *make* it.

---

## Pipeline shape

```
<YOUR_YT_SCRIPTS>/
├── upload.py            # resumable uploads, OAuth flow, idempotent (uploaded.json)
├── finalize.py          # thumbnails + titles + descriptions + playlist (finalize-state.json)
├── metadata.json        # per-video title/description/tags for the UPLOAD step
├── client_secrets.json  # OAuth Desktop client (gitignored, one-time setup)
├── token.json           # cached OAuth token (gitignored, auto-refreshed)
├── uploaded.json        # idempotency: file → {video_id, video_url, ...}
└── finalize-state.json  # idempotency: {thumbnails, titles, descriptions, playlist_id, playlist_items}
```

Keep the **upload-time** metadata (per-video tags/description footers)
and the **finalize-time** meta (thumbnail design fields) separate. They
reference the same `video_id` after upload.

Source videos large enough to need Git LFS (`*.mp4`, `*.mov`) should be
tracked before committing — GitHub rejects files >100 MB without it.

---

## Definition of done · HARD GATE

A series is NOT done until **all six** are true:

1. Source video files in place (Git LFS if >100 MB)
2. Each video uploaded to YouTube, `video_id` captured in `uploaded.json`
3. Each video's **title** set per the scheme below
4. Each video's **description** set per the scheme below (CTA + playlist link for series videos)
5. Each video has a custom **thumbnail** pushed
6. The series **playlist** exists and contains all videos in the intended order

Do not declare "done" until you can paste the playlist URL and every
video's URL with the new title + thumbnail visible in Studio.

---

## Title scheme

**Topic first, series second.** Topic wins for click-through; series tag
is identification. Use the middot separator (no em dash, no hyphen, no
colon — brand rule).

```
Series video:
  CLI Install · <Series Name>
  MCP Server · <Series Name>
  Connections · <Series Name>
  ...

Standalone / non-series:
  <YOUR_BRAND> Demo · <one-line tagline>
```

For a standalone flagship video, the tagline can live in the title
instead of a series tag.

---

## Description scheme

**Terse. CTA first.** YouTube collapses descriptions after the first
~150 chars, so the link to `<YOUR_DOMAIN>` goes in the very first line.

Series videos:
```
Try <YOUR_BRAND> free → <YOUR_DOMAIN>

Full <Series> playlist → https://www.youtube.com/playlist?list=<playlist_id>
```

Standalone:
```
Try <YOUR_BRAND> free → <YOUR_DOMAIN>
```

That's it. Don't pad with chapter timestamps, social links, hashtag
walls. If the user wants more (timestamps from `/youtube-description`,
related links), add them explicitly — never default to bloat.

**Gotcha:** Links in descriptions render as plain text until Google
finishes a one-time **identity verification** on the channel (~24h).
After that they're clickable automatically. Nothing to script — just
warn the user once.

---

## Thumbnail

Set the thumbnail produced by `/youtube-thumbnail` (interview/podcast) or
`/graphics-designer` (tutorial/solo). One unified design per series —
geometry stays identical, only the per-video kicker + title swap. Render
at 1280×720, push via `youtube.thumbnails().set()` in the finalize step.

---

## Workflow

### 1. Stage the videos

Drop the cut files into your series folder, numbered for order
(`NN-topic.mov`). Track large files with Git LFS first if you version
them:

```bash
git lfs track "media/<series-slug>/*.mp4" "media/<series-slug>/*.mov"
git add .gitattributes
```

Files >100 MB **will** be rejected by GitHub without LFS, so set this up
first.

### 2. Configure upload metadata

Edit `metadata.json`. A `_defaults` block (category, privacy, tags,
descriptionFooter) applies to every video; the `videos[]` array carries
per-video title/description/tags + the `file` path.

**Default privacy: `unlisted`.** Always. Public-flip happens after the
user reviews the live videos in Studio.

### 3. Upload

```bash
python3 <YOUR_YT_SCRIPTS>/upload.py --dry-run --all   # preview
python3 <YOUR_YT_SCRIPTS>/upload.py --only 0          # one as a smoke test
python3 <YOUR_YT_SCRIPTS>/upload.py --all             # the rest
```

First real call pops a browser for OAuth on the channel-owner Google
account. Token caches in `token.json`. Resumable uploads, 8 MB chunks,
500/502/503/504 auto-retry with a short sleep.

**Quota:** 1,600 units/upload × default 10k/day = 6 uploads/day. For 7+
videos either spread across a day boundary or request a quota increase
via the YouTube API quota form (~1-3 weeks).

### 4. Render thumbnails

Produce them with `/youtube-thumbnail` or `/graphics-designer`. Required
per video at finalize time: `slug`, `video_id` (from `uploaded.json`),
`kicker`, `title`, `yt_title`. Sanity-check every PNG before pushing —
the visual review here is the only thing between you and a bad thumbnail
going live. Specifically check:
- Long single-word titles fit the column
- Kicker reads cleanly
- Logo + wordmark visible, NOT cropped
- The graphic is centered, not bleeding off

### 5. Finalize

```bash
python3 <YOUR_YT_SCRIPTS>/finalize.py --dry-run    # preview
python3 <YOUR_YT_SCRIPTS>/finalize.py              # ship
```

Does, in order:
1. **Thumbnails** — `youtube.thumbnails().set()` per video
2. **Titles** — `youtube.videos().update()` snippet
3. **Descriptions** — `youtube.videos().update()` snippet
4. **Playlist** — creates if missing, adds each video at `position: idx`

Flags:
- `--only-thumbnails` / `--only-titles` / `--only-descriptions` / `--only-playlist`
- `--force` — re-run actions already recorded in `finalize-state.json`
- `--delay-between N` — seconds between thumbnail uploads (avoids rate limit)
- `--dry-run`

### 6. Public flip

Last step the user controls. Either:
- Studio → each video → Visibility → Public (manual review)
- Or extend `finalize.py` with a `--make-public` flag that calls
  `videos.update` with `status.privacyStatus: "public"` per video

Default to the manual review — the user wants to confirm the actual live
thumbnail and metadata before publishing.

---

## Known gotchas (each one bites at least once)

**Custom thumbnails require channel verification.** First attempt returns
`403 The authenticated user doesn't have permissions to upload and set
custom video thumbnails.` Fix: user goes to
https://www.youtube.com/verify, enters phone + SMS code. ~2 min. After
that, thumbnails work.

**Thumbnail upload rate limit.** YouTube caps `thumbnails.set` per
channel in a rolling window. A burst of 4-5 back-to-back returns `429 The
user has uploaded too many thumbnails recently`. The state file preserves
what succeeded; pass `--delay-between 120` (2 min between uploads) when
re-running. Window is opaque but often clears in ~1-2h, sometimes resets
at midnight PT. **Fallback when blocked:** open Finder + the Studio edit
tabs and drag-drop manually — Studio's upload path isn't subject to the
same limit.

```bash
open -R output/<series>-00-<slug>.png
for vid in <id1> <id2> ...; do open "https://studio.youtube.com/video/$vid/edit"; done
```

**Identity verification for clickable links.** First time you put URLs in
any description, Google triggers a one-time channel identity verification
(~24h). Until done, links render as plain text. Nothing to script.

**Daily upload quota.** 10k units/day default → 6 uploads/day. 7+ videos
crosses a day boundary. Have the script catch quota errors and break the
loop with a clear message — resume tomorrow.

**Position-0 truthy check.** `if state["playlist_items"].get(vid):`
treats a position-0 entry as not-in-playlist because `0` is falsy. Use
`if vid in state["playlist_items"]:` instead.

---

## Don'ts

- **Don't restart from scratch when state exists.** `uploaded.json` and
  `finalize-state.json` make the whole pipeline idempotent. Re-running
  any step is a no-op for what's already done. Use `--force` only when
  re-pushing because the artifact actually changed.
- **Don't push thumbnails in a tight loop.** The rate limit will bite.
  Use `--delay-between 120` for batches; fall back to Studio drag-drop if
  the API is already cooling off.
- **Don't write rich descriptions.** Terse CTA + playlist link is the
  whole brief. Timestamps, social links, hashtag walls without the user
  asking is the kind of bloat that reads as AI slop.
- **Don't auto-flip to public.** Default is `unlisted` until the user
  manually reviews each video in Studio. Public flip is an explicit ask.
- **Don't change the thumbnail design without showing renders first.**
  Iterate visually, get a thumbs-up, then ship.
- **Don't add an em dash anywhere.** Brand rule. Title separator is the
  middot (`·`).
- **Don't bypass the channel verification step.** Tell the user to verify
  at youtube.com/verify *before* the first thumbnail upload, not after
  the first 403.
- **Don't commit `client_secrets.json` or `token.json`.** They're in
  `.gitignore` already; double-check before any `git add -A`.

---

## See also

- Thumbnail art: `/youtube-thumbnail` (interview) · `/graphics-designer` (tutorial/solo)
- Description + chapters: `/youtube-description`
- Script before filming: `/youtube-script`
- Raw footage edit: `/video-use`
