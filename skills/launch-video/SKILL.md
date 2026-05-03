---
name: launch-video
description: Build a 30-60s motion-graphics launch video for a <YOUR_BRAND> product or feature. Remotion 4 React composition + ElevenLabs AI narration + sound effects + background music, beat-anchored timing, brand-aligned design system. Use when asked to "create a launch video", "make a product video", "video for X feature", "launch a new feature", or "/launch-video".
---

# Launch video creator

Builds a **30-60s motion-graphics launch video** for a <YOUR_BRAND>
product or feature, end-to-end:

- **Remotion 4** React composition rendered to MP4 (1920×1080 + 1080×1080)
- **ElevenLabs** AI narration (Bill voice by default), per-event sound
  effects, and a background music bed
- **Beat-anchored timing**: every visual phase reads its start frame from
  measured audio durations in `script.timings.json`. Edit copy → regen audio
  → all visuals auto-shift. No manual frame nudging.
- If your brand has a motion subsystem (glass/cursor/tool-pill components),
  inherit from there. The reference patterns described below are one valid
  system: a **glassmorphic motion subsystem** (chat shells, cursor, tool
  pills) layered over a **clean white tabular system** (results tables,
  dashboards, traces).

If your repo has a reference Remotion project, point this skill at it.
Otherwise the patterns described below stand alone. Reference
implementation path in the source repo: `<YOUR_REFERENCE_VIDEO_PATH>`.

---

## When to use

Trigger on:
- "Create a launch video for X"
- "Make a launch video / product video / feature reveal"
- "Render a video for the [feature]"
- User explicitly types `/launch-video`

Skip for:
- Static social graphics → `/graphics-designer`
- Slide decks / webinars → your decks pipeline
- Short ad clips < 8s → these can usually be a single Remotion still or a
  one-scene composition; this skill's full pipeline is overkill.
- **Raw recorded footage** (talking heads, webinar recordings, founder
  videos, customer interviews, screen-capture demos) → use `/video-use`
  instead. That skill cuts on word boundaries from a Scribe transcript,
  removes filler words, color grades, and burns subtitles. This skill is
  for **synthetic motion graphics** built from scratch in Remotion. The
  two compose: a `/video-use` edit can spawn Remotion overlay slots for
  branded animation inserts, but the cut comes from `/video-use`.

---

## Architecture in one diagram

```
motion/<video-name>/
├── package.json              # remotion 4 + react 19 + tsx + dotenv + mp3-duration
├── remotion.config.ts        # publicDir → ../../brand/motion (single asset source)
├── tsconfig.json
├── SCRIPT.md                 # human-readable narration script (per beat)
├── .env                      # ELEVENLABS_API_KEY (gitignored!)
├── .env.example
├── generate-audio.ts         # ElevenLabs narration runner, hash-cached per beat
├── generate-sfx.ts           # ElevenLabs sound-generation runner, hash-cached
├── generate-music.ts         # ElevenLabs music runner + leading-silence trim
├── script.timings.json       # narration durations (generated)
├── sfx.timings.json          # SFX durations (generated)
├── music.timings.json        # music duration (generated)
└── src/
    ├── Root.tsx              # registerRoot
    ├── Video.tsx             # composition registry + LaunchVideoComposition wrapper
    ├── theme.ts              # fps + duration + colors (mirrors <YOUR_BRAND_TOKENS_PATH>)
    ├── script.ts             # narration beats (id, phase, text)
    ├── timings.ts            # loader for script.timings.json + beatStartFrame()
    ├── sfx.ts                # SFX clip definitions (anchored to frames)
    ├── music.ts              # music prompt + volume
    ├── Narration.tsx         # narration-only Sequence track
    ├── SoundDesign.tsx       # narration + SFX + music combined
    └── scenes/
        ├── HeroBackground.tsx      # looped /video/hero-bg.mp4
        ├── OpeningScene.tsx        # the orchestration scene (anchors all phases)
        ├── GlassCursor.tsx         # multiplayer-style "you" cursor
        ├── CompanyTable.tsx        # populating data table with column reveals
        ├── AgentDashboard.tsx      # Google-Calendar week view
        ├── AgentRunDetail.tsx      # tool-call trace view
        ├── MemoryPanel.tsx         # stats + sparkline dashboard
        ├── Confetti.tsx            # particle burst
        └── ClosingCard.tsx         # closing chat callback (the "Inviting" pattern)
```

Assets live in `brand/motion/`:
- `video/hero-bg.mp4` + poster (your brand's hero background loop · e.g.
  an ambient video at `brand/motion/video/hero-bg.mp4`)
- `logos/{models,tools,companies,sequencers}/` — third-party brand marks
- `audio/{launch-narration,sfx,music}/` — generated mp3s (committed for
  reproducible renders)
- `components/HeroChatMockup.tsx` — framework-agnostic chat shell

---

## Workflow for a new launch video

### 1. Brief

Get from the user:
- **Audience**: who is this for (GTM teams? Engineers? Investors?)
- **Runtime**: target seconds (default 30-45s; 60s+ feels long for hype)
- **Key messages**: 4-8 things to communicate, in narrative order
- **Output formats**: landscape (web/LinkedIn), square (IG/feed), or both

### 2. Outline beats

Each beat = one narration sentence that lands during one visual phase.
Typically **6-8 beats**. Sum of beat audio lengths = total runtime.
Beat lengths target **3-7s** each.

For each beat capture: `id`, `phase` (one-line visual description), `text`
(spoken line, 10-20 words).

### 3. Write SCRIPT.md

Save the script as a sibling of `package.json` for human review.
Format:

```md
## Beat N — Phase name
**Frames** ~start–end (seconds) · **target ~Nwords**

> "Spoken line here."

**Visual sync:** what happens on screen.
```

### 4. Build `src/script.ts`

Mirrors SCRIPT.md as data. The narration generator and the composition
both import `SCRIPT`. **No Remotion imports here** so generators can run
in plain Node:

```ts
export interface Beat { id: string; phase: string; text: string; }
export const SCRIPT: Beat[] = [...];
export const AUDIO_SUBDIR = "audio/launch-narration";
export function audioPath(id: string) { return `${AUDIO_SUBDIR}/${id}.mp3`; }
```

### 5. Generate narration

```bash
cd motion/<video-name>
cp .env.example .env  # paste ELEVENLABS_API_KEY
npm install
npm run generate-audio
```

This creates `brand/motion/audio/launch-narration/{beat-id}.mp3` and
writes durations to `script.timings.json`. Hashes by beat text so
unchanged beats are skipped on subsequent runs (cheap iteration).

### 6. Build the visual scene

In `OpeningScene.tsx`:

1. Compute beat starts at module load:
   ```ts
   const HERO_BEAT     = beatStart("hero", 0);        // → 0
   const DATABASE_BEAT = beatStart("database", 0);    // → 171 (after hero finishes)
   // ... etc
   ```
2. Express every animation frame as `BEAT_X + offset`:
   ```ts
   const BADGE_IN     = HERO_BEAT + 6;
   const TYPE_START   = HERO_BEAT + 38;
   const TOOLS_START  = HERO_BEAT + 115;  // synced to "GTM stack" lyric
   const CURSOR_PRESS = HERO_BEAT + 165;
   ```
3. Cross-fade between phase scenes using opacity gates per beat.

### 7. Generate SFX (optional but high-impact)

Define click/transition moments in `src/sfx.ts`. Anchor each clip to a
specific `fromFrame` using the same `beatStartFrame()` helper. Example
clips that earn their place:
- typing texture under prompt animation
- crisp click on cursor presses
- celebratory pop on "enroll" / completion moments
- subtle swell on closing card reveal

```bash
npm run generate-sfx
```

### 8. Generate music

Define one prompt + duration in `src/music.ts`. `generate-music.ts`
trims leading silence automatically (ElevenLabs music often opens with
a quiet bar that reads as "no music" against narration).

```bash
npm run generate-music
```

### 9. Iterate with renders

```bash
npm run render:landscape
```

Rendering takes ~30-90s. **Always re-encode the output to `yuv420p` TV
range** for QuickTime compatibility — the bg video is `yuvj420p` (JPEG
range) and the propagation breaks playback in some players:

```bash
ffmpeg -y -i out/launch-landscape.mp4 \
  -c:v libx264 -profile:v high -level:v 4.0 \
  -pix_fmt yuv420p -color_range tv -crf 18 -c:a copy \
  out/launch-landscape-fixed.mp4
mv out/launch-landscape-fixed.mp4 out/launch-landscape.mp4
```

Use `ffmpeg -ss N -i ... -frames:v 1 /tmp/check.jpg` to spot-check
specific timestamps without watching the whole render.

---

## Design rules

### Voice (visual + spoken)
- **Never** use em dashes. Periods, commas, colons, parens, middot only.
- Banned words anywhere: `leverage`, `synergy`, `robust`, `world-class`,
  `seamless`, `intuitive`, `powerful`, `innovative`.
- Numerals beat adjectives ("8 tools" not "many tools").
- Terse, concrete. No hedging.
- Closing: **brand-led, not "Congrats."** The strongest closing pattern
  found here: *"Inviting" kicker → chat input with a new prompt typed in
  → URL signature*. The chat callback to the opening beats celebration
  every time.

### Color (example tokens · adjust to your brand)
Light, neutral. One accent only, used once per scene where it earns
meaning (live dot, highlight, success state).

| Token | Hex | Use |
|---|---|---|
| `--bg` | `#fafafa` | page bg |
| `--surface` | `#ffffff` | cards, dashboards |
| `--ink` | `#0a0a0a` | primary text + numerals |
| `--muted` | `#71717a` | secondary text |
| `--line` | `#e4e4e7` | borders |
| `--accent` | `#10b981` | the one accent |

### Typography
- Stack: `'Helvetica Neue', Helvetica, Arial, sans-serif`
- Mono (kickers, code, labels): `ui-monospace, 'SFMono-Regular', Menlo`
- Hero typography: weight 450 with tight tracking (`-0.05em`)
- Mono kicker style: 11-14px, uppercase, letter-spacing `0.16-0.18em`,
  color `#71717a` or `#a1a1aa`
- Bold/medium parts in muted-grey body text mirror the brand pattern:
  `<span style={{ color: "#0a0a0a", fontWeight: 500 }}>bold</span>` vs
  surrounding `#71717a` text.

### Two visual modes
Pick one per scene; don't mix:
1. **Glassmorphic / in-product** — chat shell, cursor, tool pills,
   over the hero bg video. White glass with `backdrop-filter: blur(28px)`,
   `rgba(255,255,255,0.45)`.
2. **Clean white / tabular** — tables, dashboards, traces, memory panel.
   `bg #ffffff`, `1px solid #e4e4e7`, subtle drop shadow.

The bg-fade transition between modes is one of the most cinematic moments;
budget ~20-30 frames for it and use `Easing.bezier(0.4, 0, 0.2, 1)`
(material standard) for smoothness.

---

## Animation rules

1. **Damping 22-28 on springs.** Below 20 you get bounce that reads as
   amateur. Use 14-18 only when you intentionally want a "pop".
2. **Tighter staggers > slower.** First instinct is always to slow down;
   the second pass usually involves cutting staggers in half. Default
   stagger between cascading items: 3-6 frames.
3. **Sync visuals to lyrics where it matters.** If the narration says
   "GTM stack", the tool pills should fly in *on that word* — not 3s
   before. Use `with_timestamps` from ElevenLabs for word-level sync,
   or estimate from beat duration / word count if approximate is fine.
4. **Reserve row heights.** When tables/cards animate text in,
   `minHeight` on the row prevents layout from jumping as content fills.
   Looks janky if rows grow during the cascade.
5. **Conditional render rather than 0-opacity if it would create a tall
   empty rectangle.** Cards that haven't started revealing yet should
   not occupy space.
6. **Crossfade between scene modes**, don't hard-cut. Each major scene
   gets an `opacity` gate animated via `interpolate` + ease curves.

---

## ElevenLabs gotchas

- **Default voice + model**: `generate-audio.ts` defaults to **Bill**
  (`pqHfZKP75CvOlQylNhV4`) on `eleven_multilingual_v2`. Bill is the
  `advertisement` use-case voice in ElevenLabs' library: wise, mature,
  crisp. Reads as a real ad voiceover, not "AI guy on social media".
  `multilingual_v2` is the most stable + lifelike model for production
  narration. **Do not use `eleven_turbo_v2_5` for launch videos** —
  it's the fast/cheap model and the difference is audible against a
  hero bg video. Turbo is fine for previews / SFX timing checks, not
  the final render.
- **Voice settings** baked into the script: `stability 0.40`,
  `similarity_boost 0.75`, `style 0.30`, `use_speaker_boost true`.
  Per ElevenLabs best-practices: stability under 0.30 is unstable,
  over 0.60 is monotone; similarity 0.75 is the docs sweet spot;
  style 0.20–0.40 adds expressiveness without drift. Don't push style
  above 0.4 unless you want noticeable inflection swings.
- **Voice cache key includes voice + model + settings.** Swapping any
  of those (or editing beat text) invalidates the cached MP3 and
  re-renders the beat. Just edit `.env` (`VOICE_ID=...` `MODEL_ID=...`)
  or `generate-audio.ts` and re-run `npm run generate-audio`.
- **Other narration-grade voices** if Bill doesn't fit:
  - **Eric** `cjVigY5qzO86Huf0OWal` — smooth, trustworthy, modern SaaS feel
  - **Chuck Miller** `HIGUfNOdjuWQwwapnTRW` — pro clone, deep raspy, cinematic
  - **George** `JBFqnCBsd6RMkjVDRZzb` — British storyteller, narrative_story
  - **Logan** `jD4PjnscE4XmlzgsuqY0` — pro clone, young storyteller
  - **Brian** `nPczCjzI2devNBz1zQrb` — the legacy default; labeled `social_media`, reads more "AI" than Bill
  - A/B sample these in your reference Remotion project before committing
- **Voices listing requires `voices_read` permission**. Some keys
  don't have it; if you can't `GET /v1/voices`, fall back to known IDs.
- **Music API rejects brand names** in prompts. "Apple keynote",
  "Linear launch trailer" etc. trigger a TOS violation. Describe the
  vibe without naming brands ("cinematic instrumental for a modern
  technology launch trailer", "pulsing electronic beat with arpeggiated
  synthesizer melody").
- **Music starts with leading silence** (~1-2s) by default. The
  generator's `silenceremove` ffmpeg pass strips it so playback hits at
  frame 0. Keep that filter in place.
- **Sound-effects minimum duration is 0.5s.** Anything below that the
  API errors. Round up.
- **Music volume**: `0.10` reads as silent under narration; `0.15-0.18`
  is the sweet spot — clearly there but doesn't fight the voice.

---

## Pitfalls to avoid

1. **Adding `<Audio>` without `<Sequence>`**: it'll play continuously
   from frame 0. Use `<Series.Sequence>` or `<Sequence from={...}>` to
   place audio at specific positions.
2. **Computing absolute frame constants** that drift when audio changes.
   Always express as `BEAT_X + offset`. Re-derives automatically when
   you regen audio.
3. **JSON imports in Node generators**: `script.ts` should not import
   from `remotion`. Import `staticFile` lazily where needed.
4. **Mixing too many accents.** One accent per scene. If a scene has
   both a play button and a check icon and a highlight, you've lost
   the focal point.
5. **Studio scrub showing "blacked-out first 10s"**: that's a thumbnail
   cache issue in Remotion Studio — the rendered MP4 has the visuals.
   Re-extract a frame with `ffmpeg -ss N` to verify.
6. **API keys in chat/logs**: rotate any key the user pastes into a
   conversation. Always store in `.env` (gitignored).
7. **Hard-coded prompt text in scenes**: the same prompt may appear in
   the visual chat input, the SCRIPT.md, and the audio narration. Keep
   the audio version in `script.ts` as the single source of truth and
   reference it from visuals where appropriate.
8. **Closing on "Congrats."**: the audience remembers the brand, not
   the celebration. Close with the chat callback + brand stamp.

---

## Reusable scenes (copy & adapt)

The scene library is written to be reusable. For a new launch video,
copy what fits and edit data + copy:

| Component | Use for |
|---|---|
| `HeroBackground` | The looped hero background video |
| `GlassCursor` | Multiplayer-style "you" cursor with label pill |
| `CompanyTable` | Any populating tabular content with cascading columns |
| `AgentDashboard` | Google-Calendar week-view with event cards |
| `AgentRunDetail` | Step-by-step tool-call trace with reasoning headers |
| `MemoryPanel` | Stats + dashboard preview pattern |
| `Confetti` | Celebration burst (use sparingly, once per video max) |
| `ClosingCard` | The "Inviting" chat callback closing pattern |
| `HeroChatMockup` (in brand/motion) | Standalone chat shell for stills/static use |

For new components, follow the same pattern:
- Props for frame anchors (`cardInFrame`, `firstRowFrame`, `rowStagger`)
- Inline styles in TSX (no separate CSS file — assets resolve via `staticFile`)
- All animation values via `spring`, `interpolate`, or `interpolate` with
  `Easing.bezier` for smooth curves

---

## Starting a new launch video — concrete steps

```bash
# 1. Scaffold the project (or copy a reference Remotion project)
cp -R motion/launch-video motion/<new-video-name>
cd motion/<new-video-name>

# 2. Reset state
rm -rf node_modules out
rm script.timings.json sfx.timings.json music.timings.json
echo "{}" > script.timings.json
echo "{}" > sfx.timings.json
echo "{}" > music.timings.json
rm -rf ../../brand/motion/audio/launch-narration/* \
       ../../brand/motion/audio/sfx/* \
       ../../brand/motion/audio/music/*

# 3. Install + add API key
npm install
cp .env.example .env  # paste ELEVENLABS_API_KEY

# 4. Edit script.ts with the new beats
# 5. Edit OpeningScene.tsx to wire the new beats to scenes
# 6. Edit sfx.ts + music.ts prompts
# 7. Generate audio
npm run generate-all

# 8. Render + spot-check
npm run render:landscape
# repeat: tweak → render → check frames with ffmpeg
```

---

## What this skill does NOT do

- Doesn't pick the brief / strategy. The user supplies the messages.
- Doesn't produce voice-over scripts from scratch — the human writes
  the beats. The skill structures + animates them.
- Doesn't produce music compositions — relies on ElevenLabs Music API.
- Doesn't render in 4K (1080p is the ceiling here; bumping to 4K means
  re-encoding hero-bg.mp4 and tuning render performance).
- Doesn't auto-publish to social channels. The MP4 lands in `out/`;
  publishing to YouTube / LinkedIn / etc. is on the user.

---

## After the render: upload + log

Once the MP4 renders cleanly:

1. **Upload to Drive** via `mcp__claude_ai_Google_Drive__create_file`
   into your videos folder (`<YOUR_DRIVE_VIDEOS_FOLDER>`). Title pattern
   `<feature> · launch · YYYY-MM-DD.mp4`.
2. **Log in Notion** Content DB (data source
   `<YOUR_NOTION_CONTENT_DB_ID>`). Create the row with Title,
   Format=Video, Channel (LinkedIn / YouTube / X per where it's going),
   Pillar=Promotional, Status=Scripting (if awaiting review) or
   Scheduled, and paste the Drive `viewUrl` into `Drive Assets`.

---

## See also

- Reference implementation (in source repo): `<YOUR_REFERENCE_VIDEO_PATH>`
- Brand design system: `<YOUR_BRAND_DOC>`
- Brand tokens (motion subsystem): `<YOUR_BRAND_TOKENS_PATH>`
- ElevenLabs docs: https://elevenlabs.io/docs (text-to-speech, sound-generation, music)
- Remotion docs: https://www.remotion.dev/docs/
