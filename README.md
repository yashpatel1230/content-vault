# content-vault

14 Claude Code skills + a Notion template. Same setup we use to run our content.

Free. MIT. Fork it.

```
researcher            repurpose             lead-magnet-creator
linkedin-copywriter   x-copywriter          long-form              newsletter-writer
youtube-script        youtube-description   youtube-thumbnail      youtube-publisher
graphics-designer     launch-video          video-use
```

## Two ways to run this

**Oxygen (hosted).** Team setup, one-click import, integrations already wired up.
oxygen-agent.com

**Claude Code (local).** Clone the repo into your skills folder.

```bash
git clone https://github.com/timscheuerai/content-vault.git ~/.claude/skills/content-vault
```

Then in Claude Code:

```
/linkedin-copywriter   draft a post about my Q2 launch
/researcher            find 10 ideas for next week
/repurpose             turn yesterday's webinar into LinkedIn + X
```

## The setup that actually matters

Without this step the writer skills sound like generic AI. Run it once and you're done.

### Connect LinkedIn

Oxygen: already done.

Claude Code: plug in Unipile or whatever you use.

```bash
export UNIPILE_DSN=...
export UNIPILE_API_KEY=...
export UNIPILE_ACCOUNT_ID=...
```

### Tell Claude to fill your corpus

> Pull my last 20 LinkedIn posts via Unipile, sort by reactions, write them into skills/linkedin-copywriter/corpus.md using the format in corpus.md.example.

Claude pulls, sorts, writes the file. From the next draft, linkedin-copywriter writes in your voice.

### Same for X

```bash
export X_BEARER_TOKEN=...
```

> Pull my last 30 tweets, originals only, sort by engagement, write them into skills/x-copywriter/corpus.md.

Done. Skills are personalized.

### Video + YouTube skills (optional)

Only if you use them. Each has a `## SETUP` block in its `SKILL.md`.

```bash
export ELEVENLABS_API_KEY=...   # youtube-description (transcripts), video-use
pip install rembg               # youtube-thumbnail (face cutouts)
```

`youtube-publisher` talks to your own channel, so it needs your Google
Cloud project + a YouTube Data API OAuth client (`client_secrets.json`).
Walkthrough is in the skill.

## What's in the vault

**linkedin-copywriter.** Drafts LinkedIn posts in your voice. Hook frameworks, body shapes, CTA patterns, AI-slop blacklist.

**x-copywriter.** Drafts X tweets and threads. Different game than LinkedIn. The skill teaches you the platform as it drafts.

**youtube-script.** Spoken scripts for YouTube longs, shorts, talking-head clips. Timed beats with B-roll cues.

**youtube-description.** Transcribes a finished cut (ElevenLabs Scribe), writes a 2-sentence description, your fixed CTA, and chapter timestamps.

**youtube-thumbnail.** Two-face interview/podcast thumbnails. rembg cutouts, one highlight word, 1280×720 dark + light. Encodes verified 2026 CTR research.

**youtube-publisher.** Uploads a video or a whole numbered series via the YouTube Data API. Titles, descriptions, thumbnails, ordered playlist. Resumable, idempotent.

**long-form.** Newsletter issue, blog, Substack. Outline first, prose second.

**newsletter-writer.** Lifecycle + onboarding emails and broadcasts. Same voice as your posts, rendered to your email template, optional push to Resend.

**lead-magnet-creator.** Builds free assets in 10 formats. Notion, PDF, Sheet, GitHub starter, GPT, web tool, video. The skill that built this vault.

**repurpose.** One master piece (webinar, transcript, post) into N channel variants. Hub-and-spoke.

**researcher.** 3 modes. What's hot in your space. What's working for you. What customers said in interviews.

**graphics-designer.** On-brand graphics. HTML to PNG via headless Chrome.

**launch-video.** 30-60s motion graphics. Remotion + ElevenLabs.

**video-use.** Edit any video by chat. Cuts on word boundaries, grades, burns subtitles. Vendored from [browser-use/video-use](https://github.com/browser-use/video-use).

## The Notion side

Skills produce content. The Notion DB tracks it.

Schema: Title, Status, Pillar, Format, Channel, Author, Publish Date, Drive Assets.

Walkthrough on the [Notion landing page](https://www.notion.so/3552c8bff8c181548699e4e806ccaccc).

## Need help?

Built by us at Oxygen. Stuck? hello@oxygen-agent.com

MIT. Use it however you want.
