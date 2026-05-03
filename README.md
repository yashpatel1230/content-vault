# Content Vault

The content engine we use to run [Oxygen](https://oxygen-agent.com) marketing.
Free. MIT-licensed. No gated middle.

10 Claude Code skills + a Notion workspace template. Drop them into your
stack, point them at your own LinkedIn / X / Notion accounts, and you have
the same content system we run on.

```
linkedin-copywriter   ·   x-copywriter   ·   youtube-script   ·   long-form
lead-magnet-creator   ·   repurpose      ·   researcher
graphics-designer     ·   launch-video   ·   video-use
```

---

## Two ways to run it

Pick whichever fits your stack. The skills are identical either way.

### Path A · Oxygen (teams, hosted)

If you want the full content pipeline running for a team without
local setup, Oxygen ingests this whole vault as a one-click import.
You get the skills, the Content database, and the integrations
(LinkedIn, X, Notion, Drive) wired up out of the box.

→ [Try it on oxygen-agent.com](https://oxygen-agent.com)

### Path B · Claude Code (local, DIY)

If you live in your terminal, install the skills as a Claude Code plugin
and run them from your shell.

```bash
git clone https://github.com/timscheuerai/content-vault.git ~/.claude/skills/content-vault
```

Then in Claude Code, the skills surface automatically. Try:

```
/linkedin-copywriter   draft a post about my Q2 launch
/researcher            find 10 ideas for next week
/repurpose             turn the webinar from yesterday into LinkedIn + X
```

---

## Setup · the voice-personalization step

This is the part that makes the writer skills sound like **you**, not generic.

The writer skills (linkedin-copywriter, x-copywriter, long-form, youtube-script)
ship with empty `corpus.md.example` files. Until you populate them with your
own posts, the skills draft in a default operator voice. That's fine to start.
To make them sound like you, do this once:

### Step 1 · Connect LinkedIn

If you're on **Oxygen**: LinkedIn is wired up natively, skip ahead.

If you're on **Claude Code**: connect via [Unipile](https://unipile.com)
(or your platform of choice). Set the env vars in your shell or a `.env`:

```bash
export UNIPILE_DSN=<your-dsn>
export UNIPILE_API_KEY=<your-key>
export UNIPILE_ACCOUNT_ID=<your-account-id>
```

### Step 2 · Ask Claude to fill your corpus

Open Claude (in Oxygen or Claude Code) and prompt:

> Pull my last 20 LinkedIn posts via the Unipile API, sort by reactions
> descending, and write them into `skills/linkedin-copywriter/corpus.md`
> using the format in `corpus.md.example`.

The agent runs the API call, sorts, and writes the file. From the next
draft onward, `linkedin-copywriter` writes in your voice.

### Step 3 · Same for X

Connect via X API v2 (`X_BEARER_TOKEN` in your env), then:

> Pull my last 30 tweets, filter to originals (no replies, no RTs), sort
> by engagement, and write them into `skills/x-copywriter/corpus.md`.

### Step 4 · (Optional) Same for the long-form skills

`long-form` and `youtube-script` read from `linkedin-copywriter/corpus.md`
by default. If you want a separate corpus per format (e.g. you have a
newsletter archive), repeat step 2 with a different source.

That's it. The skills are now personalized.

---

## What's in the vault

| Skill | What it does |
|---|---|
| **`linkedin-copywriter`** | Drafts LinkedIn posts in your voice. Hook frameworks (H1-H13), body shapes (S1-S9), CTA patterns (A-G), AI-slop blacklist. |
| **`x-copywriter`** | Drafts X tweets and threads. Different culture from LinkedIn · this skill teaches you the platform as it drafts. |
| **`youtube-script`** | Spoken long-form. YouTube longs (8-12 min), shorts (60s vertical), talking-head clips. Beat-by-beat with timing cues and B-roll suggestions. |
| **`long-form`** | Written long-form. Newsletter, blog post, Substack issue. Outline-first workflow, 3 subject-line options for newsletters. |
| **`lead-magnet-creator`** | Builds free assets in 10 formats (Notion, Doc, PDF, Sheet, Skills repo, GitHub starter, GPT, web tool, video, vault bundle). The skill that built this vault. |
| **`repurpose`** | Hub-and-spoke. One master content piece (webinar, transcript, post) → N channel variants in your Notion DB. |
| **`researcher`** | Idea pipeline. Three modes: trend scan (what's hot in your space), performance scan (what's working for you), customer scan (what your interviews say). |
| **`graphics-designer`** | On-brand graphics. HTML → PNG via headless Chrome. LinkedIn portrait, square, banner, OG image, multi-slide carousels. |
| **`launch-video`** | 30-60s motion graphics. Remotion 4 + ElevenLabs narration + SFX + music, beat-anchored timing. |
| **`video-use`** | Edit any video by conversation. Cuts on word boundaries, color grades, burns subtitles. ([browser-use/video-use](https://github.com/browser-use/video-use)) |

---

## The Notion side

The skills produce content. The **Notion Content database** tracks it.

Schema: `Title · Status (Idea / Scripting / Scheduled / Published) · Pillar
(Building in Public / Educational / Personal / Memes / Promotional / Trend
Insights) · Format · Channel · Author · Publish Date · Drive Assets`.

Duplicate the template into your Notion workspace:

→ **[Content Vault · Notion landing page](https://www.notion.so/<TBD>)**
(includes the database template + the Resources page where we drop a new
free asset every week)

---

## Video walkthrough

Coming soon. We'll record a 10-min tour of the vault: install, corpus
setup, drafting your first post, repurposing a webinar.

---

## Built by Oxygen

We're [Oxygen](https://oxygen-agent.com), the AI Chief Revenue Officer
for B2B teams. We use this exact vault to run our own marketing. Open-
sourcing it because the patterns are more useful in the wild than locked
inside our repo.

Stuck? Drop us a line: hello@oxygen-agent.com

## License

MIT. Use it, fork it, rebrand it, ship it.
