---
name: youtube-script
description: Draft spoken video scripts for YouTube longs (8-12 min), YouTube shorts (60s vertical), or talking-head clips. Spoken cadence (read aloud, ear-tested · not eye-read), beat-by-beat structure with timing cues and B-roll suggestions, hook-in-the-first-five-seconds discipline, retention pulls every 30s. Voice anchored to your LinkedIn corpus but rewritten for spoken delivery (shorter sentences, no em dashes anywhere, no list-stacking). Hands off to /video-use for editing the recording, or to /launch-video if synthetic motion graphics. Logs the row in the Notion Content DB. Use when asked to "write a youtube script", "draft a video script", "shorts script for X", "talking-head script", "scripted video about Y", or "/youtube-script". For written long-form (newsletter / blog), use /long-form instead.
---

# youtube-script

Spoken long-form. Talking-head video and shorts in your voice ·
written for the ear, not the eye. Different cadence than `/long-form`
even though the topic might be the same.

## When to use

Trigger on:
- "Write a YouTube script for X"
- "Draft a shorts script"
- "Talking-head script about Y"
- "Video script · 8 minutes"
- "Voiceover for the launch video" (talking copy, not narration beats)
- User explicitly types `/youtube-script`

Skip for:
- Written newsletter / blog → `/long-form`
- LinkedIn / X posts → `/linkedin-copywriter` · `/x-copywriter`
- Synthetic motion-graphic narration → `/launch-video` (Remotion has
  its own beat-anchored narration system)
- Editing existing recorded footage → `/video-use`

## Inputs

The brief should include:
- **Type**: `long` (8-12 min YouTube) · `short` (60s vertical · YT
  Shorts / IG Reels / TikTok) · `clip` (90s-3min talking-head clip)
- **Topic** + angle
- **Target duration** (default: 8 min long, 60s short, 2 min clip)
- **Audience**: cold YouTube viewer · email list opt-in · existing
  followers
- **Optional source**: Notion row URL if invoked from `/repurpose`
- **Optional CTA**: subscribe · grab a lead magnet · book a call ·
  reply on LinkedIn · default by type below

If anything is missing, ask in **one batch**, then draft.

## Voice anchor (spoken)

Same author voice as `/linkedin-copywriter`, but rewritten for the
ear. Read [`../linkedin-copywriter/corpus.md`](../linkedin-copywriter/corpus.md)
before drafting, then translate it for spoken delivery:

**Spoken differences:**
- Shorter sentences. Average ~12 words. The reader's eye can hold a
  long sentence; the listener's ear cannot.
- No em dashes anywhere. (Hard rule for everything <YOUR_BRAND>, but
  especially obvious here · em dashes don't have an audible
  equivalent. Just use a period.)
- Avoid stacked lists. "First, second, third" works on the page;
  three items spoken in a row sound like a robot. Break with
  beats.
- Contractions are mandatory. "It's", "you're", "we'll" · not "it
  is", "you are", "we will". Spoken voice contracts.
- Numbers are spoken. "Forty-seven" not "47" if you want it to land.
  "47" is fine on the teleprompter and reads aloud as "forty-seven".
  Just be aware.
- Read every line aloud before declaring it done. If your tongue
  trips, the camera will catch the trip.

## Structure by type

### YouTube long (8-12 min)

```
00:00-00:05   HOOK            One sentence. The friction. The promise.
00:05-00:25   COLD OPEN       Set the stakes. What you'll prove.
00:25-00:50   INTRO + IDENT   Brief who-you-are. Subscribe pulse 1.
00:50-...     BEAT 1          First insight. Concrete example.
              [retention pull every 90-120s · "but here's the weird part" / 
               "and that's where it gets interesting"]
              BEAT 2          Second insight. Counter-take or extension.
              BEAT 3          Third. Proof / data / customer example.
              [BEAT 4-5 if 12 min]
~12:00        PAYOFF          What changes if you act on this.
              CTA             Subscribe + lead magnet + (optional) book a call.
```

5-7 beats total. Each beat ~60-120 seconds spoken. Word count
target: ~150 words/min spoken pace · 8 min = ~1200 words · 12 min
= ~1800 words.

### YouTube short (60s · vertical)

```
00:00-00:02   HOOK            Two seconds. ONE sentence. Stakes-loaded.
00:02-00:08   PROBLEM         What's broken. (One sentence.)
00:08-00:35   PAYOFF          The insight / framework / number.
                              No more than 2 supporting points.
00:35-00:50   PROOF           One specific example or data point.
00:50-00:60   CTA             "Save this. / Follow for more. / Comment X."
```

~150 words total. Every word earns its place. No "subscribe" intros.
No "today we're talking about". Just the hook.

### Talking-head clip (90s-3min)

```
00:00-00:05   HOOK            One sentence.
00:05-...     ARG             One argument, fully developed.
              [no retention pulls · clip is short enough]
              CTA             Single line. Often "let me know what you think".
```

3-5 beats. Used for clipped LinkedIn / X video, weekly customer
shoutouts, etc.

## Workflow

### 1. Brief

Inputs above. If invoked from `/repurpose`, treat the master Notion
row's content as raw material to translate to spoken cadence.

### 2. Beat outline

Output the beats with timestamps and one-line descriptions before
drafting the script. Show to the user, wait for green light. As
with /long-form, **don't draft the full script until the outline
is approved**.

### 3. Draft the script

Format:

```
# <Title>

**Type**: long / short / clip
**Target duration**: <m:ss>
**Hook**: <one sentence · the cold open>

---

[00:00-00:05] HOOK
<spoken line>

[00:05-00:25] COLD OPEN
<spoken paragraph · 50-70 words>
[B-ROLL: <visual cue if applicable>]

[00:25-00:50] INTRO
<spoken paragraph>
[B-ROLL: <cue>]

[00:50-02:00] BEAT 1 — <one-line description>
<spoken paragraph · 100-150 words>
[B-ROLL: <cue>]

... etc

[12:00] CTA
<spoken line · single sentence>
```

Conventions:
- **B-roll cues** in `[B-ROLL: ...]` brackets after the line they
  reference. Cues describe what should be on screen during that
  voiceover (screen recording / cut-in / chart / quote card / etc.).
  Don't B-roll every paragraph · only when the visual genuinely adds.
- **Retention pulls** are sentences like "but here's where it gets
  weird", "the thing nobody tells you is", "and this is where most
  people get it wrong". Use one every 90-120s in longs. Drop them
  for shorts and clips.
- **Subscribe pulses** in longs only. Once at 0:25-0:50 ("if you're
  new here, hit subscribe · I drop one of these every Friday"), once
  in the CTA. No mid-video subscribe interruptions.
- **No filler intros**. "Today we're going to talk about..." is dead
  on arrival. Hit the hook, set the stakes, move.

### 4. Read aloud check

For every script before declaring done:
1. Read it aloud (or have the user do it). Mark any line that trips
   your tongue.
2. Time it. If the read is more than ~10% over target duration, cut
   not extend.
3. Check the hook works in the first **two seconds** for shorts and
   first **five seconds** for longs. If you can't say it in that
   window, the hook is wrong.

### 5. Slop scrub (mandatory · brand checklist)

Same 4 copy checks as every text-producing skill:
1. Em-dash scan · zero `—` (especially important here · spoken cadence
   doesn't tolerate them)
2. Banned-words scan · the full brand-doc list
3. Negation-pivot scan · "not just X, but Y" patterns
4. Numerals · use real numbers where possible

### 6. Save the script

Long-form scripts live in the Notion Content DB page body. Don't
write to a file in the repo (text drafts stay in Notion · the repo
is for assets).

Create a row via `mcp__claude_ai_Notion__notion-create-pages` with
data source `<YOUR_NOTION_CONTENT_DB_ID>`:

- **Title**: video title (e.g. "Why GTM dashboards are dead · YouTube")
- **Status**: `Scripting`
- **Pillar**: pick the multi-select that matches the angle
- **Format**: `Video`
- **Channel**: `YouTube` (default) · or `LinkedIn` if it's a clip
  going there

Page body:

```
Type: long / short / clip
Target duration: <m:ss>
Source: <master URL if from /repurpose>

— Beat outline —
1. HOOK
2. COLD OPEN
...

— Script —
[full timed script with B-roll cues]

— Production notes —
- Camera setup: <if specific>
- Lower-thirds: <if any>
- End-card link: <where the CTA points>
```

If invoked from `/repurpose`, the orchestrator may handle row
creation · check the source context to avoid duplication.

### 7. Hand off to production

After the script lands in Notion, suggest the next step:

- **For a recorded video**: record → run `/video-use` to
  cut + grade + subtitle.
- **For a synthetic / motion-graphics version**: run `/launch-video`
  (different beat structure, but the script's beats can map to its
  Remotion scenes).
- **For a clip going on LinkedIn**: chain into `/linkedin-copywriter`
  for the post copy that wraps the video.

## Don'ts

- **Don't pad to hit duration.** If 8 min feels thin, propose a 60s
  short or a clip and stop. Long videos that feel padded retain
  worse than tight 60s shorts.
- **Don't draft before the beat outline is approved.** Spoken-script
  rewrites at the line level cost 5-10x outline rewrites.
- **Don't write essays.** This is spoken. Sentences are short. If a
  sentence reads like an essay sentence, it'll sound like one. Trim.
- **Don't stack lists.** "First X. Second Y. Third Z." is the
  fastest way to make a viewer click off. Break each item into its
  own beat with a B-roll change.
- **Don't borrow YouTube guru tropes.** "Buckle up" / "Stay tuned" /
  "Drop a like and subscribe" / "What's up everybody" all read like
  AI slop in your voice. Pretend those don't exist.
- **Don't bolt the CTA onto the end of the last beat.** Give it its
  own beat. You say the line, look at camera, ask. Pause matters.
- **Don't write the video title here.** Title generation is its own
  art (and YouTube SEO matters). Put a working title at the top of
  the script and flag for separate optimization.
- **Don't fabricate quotes / metrics / customer names.** Same rule
  as every other content skill.

## See also

- Brand reference: `<YOUR_BRAND_DOC>` · voice rules + skill checklist
  (if you have a brand doc with voice rules, link it here)
- Voice corpus (shared with /linkedin-copywriter and /long-form):
  [`../linkedin-copywriter/corpus.md`](../linkedin-copywriter/corpus.md)
- Sibling skill (written long-form): `/long-form`
- Production hand-off: `/video-use` (edit recorded footage) ·
  `/launch-video` (synthetic motion graphics)
- Notion Content DB data source: `<YOUR_NOTION_CONTENT_DB_ID>`
- Upstream skill: `/researcher` (sources ideas), `/repurpose`
  (orchestrates a master into spoken-script variants)
