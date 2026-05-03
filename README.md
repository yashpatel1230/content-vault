# content-vault

10 Claude Code skills + a Notion template. Same setup we use to run our content.

Free. MIT. Fork it.

```
linkedin-copywriter   x-copywriter   youtube-script   long-form
lead-magnet-creator   repurpose      researcher
graphics-designer     launch-video   video-use
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

## What's in the vault

**linkedin-copywriter.** Drafts LinkedIn posts in your voice. Hook frameworks, body shapes, CTA patterns, AI-slop blacklist.

**x-copywriter.** Drafts X tweets and threads. Different game than LinkedIn. The skill teaches you the platform as it drafts.

**youtube-script.** Spoken scripts for YouTube longs, shorts, talking-head clips. Timed beats with B-roll cues.

**long-form.** Newsletter, blog, Substack. Outline first, prose second.

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
