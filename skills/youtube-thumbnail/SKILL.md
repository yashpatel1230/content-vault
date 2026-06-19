---
name: youtube-thumbnail
description: Design an on-brand YouTube thumbnail for a two-person interview / podcast video. Cuts both faces out of their headshots (rembg), places them flush to the L/R edges in a Moonshots-style layout re-skinned to your brand (one saturated highlight box, your lockup), and renders 1280×720 PNGs (1× + @2×) in dark (default) or light skin. Encodes verified 2026 thumbnail research as a hard checklist. Use when asked to "make a YouTube thumbnail", "thumbnail for the podcast / interview", "thumbnail with two faces", "thumbnail for the episode with X", or "/youtube-thumbnail".
---

# youtube-thumbnail

The thumbnail factory for **two-person interview / podcast** videos.
HTML → PNG via headless Chrome, faces cut out with `rembg`. Produces the
high-CTR genre archetype (think *Moonshots* "AI Killed the Modern
Company") re-skinned to your brand: two head cutouts flush to the edges,
one bold 2–5 word headline with a single saturated highlight, bold name
labels, your wordmark lockup.

This is the **still thumbnail** skill. It feeds `/youtube-publisher`,
which sets the thumbnail on the uploaded video. For a text-only tutorial
style (single template, no faces), use `/graphics-designer` instead —
different genre.

---

## SETUP (run this once)

1. Fill the placeholders: `<YOUR_BRAND>`, `<YOUR_ACCENT>` (one saturated
   highlight color, e.g. an emerald `#10b981` or a max-interrupt red
   `#FF0000`), `<YOUR_LOGO>` (your wordmark + mark), `<YOUR_BRAND_DOC>`.
2. Install `rembg` once for the face cutouts (Python venv + the u2net
   model, ~176MB one-time download). It runs locally; no API key.
3. Point `<YOUR_GRAPHICS_DIR>` at wherever you keep render scripts +
   templates + the brand HTML. No template yet? The skill builds the
   1280×720 HTML from your brand tokens the first time.

---

## When to use

Trigger on:
- "Make a YouTube thumbnail for the interview / podcast / episode"
- "Thumbnail with me and <guest>"
- "Thumbnail for the video with <two people>"
- User types `/youtube-thumbnail`

Skip for:
- Tutorial / solo videos → `/graphics-designer` (text + slabs style)
- LinkedIn / X / banner graphics → `/graphics-designer`
- Setting the thumbnail on YouTube → `/youtube-publisher` (consumes this output)

## Design handoff from Figma

You can design a thumbnail in Figma and hand it over as the spec —
**export it as SVG** (1280×720 frame). SVG is text/XML, so the agent
reads your exact colors, geometry, and layout and rebuilds it in the
HTML template (version-controlled, brand-locked, automated). Figma is
the sketchpad; the HTML template is the source of truth that feeds the
publish pipeline. For maximum fidelity, untick **"Outline text"** in
Figma's SVG export so the literal words + font survive; either way the
SVG can be rasterized and matched visually. PNG export also works, but
SVG lets the agent read precise values.

## The research this skill encodes

Distilled from a verified, adversarially-checked research pass on 2026
thumbnail performance. The rules below are the **confirmed** ones; the
debunked myths are listed so you don't chase them.

**Load-bearing rules (verified):**
1. **The thumbnail is the #1 CTR lever** — over-invest in it.
2. **2–5 words, heavy weight.** A *label, not a sentence*. Headline =
   `HL` (1–2 words on the highlight box) + `REST` (1–2 short lines).
   Total ≤ 5 words is the ceiling; 3–4 is the target.
3. **One saturated accent.** A single highlight box carries the key
   phrase. `<YOUR_ACCENT>` is the default; a red `#FF0000` is the
   max-pattern-interrupt option (use white text on it). One accent,
   never two.
4. **Contrast ≥ 4.5:1 everywhere.** Ink-on-accent, white title on
   near-black (dark skin) or ink title on a near-white surface (light
   skin). Verified against WCAG.
5. **Bold name labels** under each face — the interview-format convention.
6. **Engineer for the phone.** It must read at ~246px wide. Squint-test
   every render (see step 4).
7. **A/B test to settle anything.** Real lifts are single-digit %. Render
   dark + light and test with YouTube's Test & Compare; don't argue taste.

**Debunked — do NOT design around these (all refuted under review):**
- "Faces add 35–50% CTR" / "multiple faces beat single" — faces are
  *table stakes* for this format, not a CTR guarantee. You earn the click
  with contrast + the highlighted word + a contrarian line, not by
  assuming the two faces carry it.
- "Emotional / surprised / sad faces win," any specific %-lift from tool
  blogs, "≥40% face height," "exactly 2–3 elements / 30–40% negative
  space." Ignore. Use clean, composed portraits (not candid screen-grabs).

## Inputs

Ask for whatever's missing **in one batch**:
- **The two people** — whose faces. Default left = host. Need a headshot
  for each (square-ish, even background cuts cleanest).
- **Both names** — exactly as they should appear (e.g. `FIRST LAST`).
  Rendered uppercase by default.
- **Headline** — the hook. Split into `HL` (the highlight-box phrase) +
  `REST`. Mirror the reference's contrarian energy (`AI Killed` /
  `Cold Outbound`). Keep it ≤ 5 words.
- **Theme** — `dark` (default, recommended) or `light` (on-brand).
- **Accent** — highlight color (`<YOUR_ACCENT>` default, `#FF0000` red
  option) + accent-text color (dark ink on a light accent, white on red).
- **Proof stack** (optional) — an iOS-style notification stack in the
  centre (great social-proof motif for "calls booked / replies /
  signups"). Your mark becomes the app icon; the centre wordmark
  auto-hides since the stack owns that space.
- **Name case** — upper (default) or title (sentence case).

## Definition of done · HARD GATE

Not shipped until **all** are true:
1. Both face cutouts exist and were eyeballed for clean alpha (no halo on
   hair/glasses).
2. PNGs rendered (1× **and** @2×) at 1280×720.
3. Passed the **squint test** (step 4) at thumbnail scale.
4. Logged where your content lives (your Drive folder, Notion Content
   row, or content vault file), with the asset link captured.

Iterating on the visual is fine; declaring done without logging it is not.

---

## Workflow

### 1. Cut out both faces

Each face must be a transparent PNG. Reuse an existing cutout if you have
one. Otherwise run `rembg` on the headshot:

```bash
# one-time: python3 -m pip install rembg  (downloads u2net model on first run)
rembg i public/speakers/<person>.png public/cutouts/<person>-cut.png
```

**Open the result and check the alpha edges** — stray pixels on
hair/glasses are most visible on the dark skin.

### 2. Render

Build the thumbnail from an HTML template (your brand tokens, a 1280×720
frame) and rasterize with headless Chrome. The template exposes the
per-thumbnail fields; a thin render script substitutes them:

```bash
# render pattern: substitute fields, then screenshot at 1280x720
python3 render_interview_thumbnail.py \
  --hl "AI Killed" --rest "Cold Outbound" \
  --name-l "HOST NAME" --name-r "GUEST NAME" \
  --face-l public/cutouts/host-cut.png \
  --face-r public/cutouts/guest-cut.png \
  --theme dark \
  --out yt-interview-<topic>
```

Outputs `yt-interview-<topic>.png` (+ `@2x`). Use `\n` in `--rest` to
force a line break. Default skin is **dark**; pass `--theme light` for
the on-brand light skin. Render **both** if you intend to A/B test.

**Proof-stack variant** (red accent + notification stack, sentence-case names):

```bash
python3 render_interview_thumbnail.py \
  --hl "Outbound Signals" --rest "that book calls" \
  --name-l "Host Name" --name-r "Guest Name" --name-case title \
  --face-l public/cutouts/host-cut.png --face-r public/cutouts/guest-cut.png \
  --theme dark --font-size 76 \
  --accent "#FF0000" --accent-text "#ffffff" \
  --proof "New call booked" --proof-time "now" \
  --out yt-interview-<topic>
```

Longer headlines need `--font-size` below the 96 default (76 fits a 2–3
word line; drop further for more words).

### 3. Fit the faces (only if a new headshot frames badly)

Defaults are tuned for ~800×800 portrait cutouts. For a new headshot,
nudge per-side knobs until eyes sit on the upper third and the body
bleeds off the outer edge (so the headline clears it): a head-height
scale, an outer-edge bleed (x), and a vertical offset (y), per side.
Re-render and re-check. Trust the render, not your expectation.

### 4. Squint test · HARD GATE

Downscale to thumbnail size and look. If the headline isn't instantly
legible or the faces blur together, it fails — fix and re-render.

```bash
python3 -c "from PIL import Image; im=Image.open('output/yt-interview-<topic>.png'); im.resize((246,138)).save('/tmp/squint.png')"
```

Open `/tmp/squint.png`. Checklist:
- Headline readable at 246px? (if not: fewer words / heavier / more contrast)
- The accent box is the only saturated color?
- Both faces clearly separate, eyes visible?
- Names legible? `<YOUR_LOGO>` lockup present?
- Zero em-dashes, zero banned words (per `<YOUR_BRAND_DOC>`).

### 5. Log it

Save the PNGs (1× + @2×) where your content lives — your Drive graphics
folder, a Notion Content row (Format = Video, Channel = YouTube), or your
content vault file. Capture the asset link. Note which skin(s) shipped if
you rendered both for an A/B test.

### 6. Report back

One line: PNG paths, asset link(s), where logged. Note if both skins
shipped for an A/B test. Suggest the handoff: `/youtube-publisher` sets
this as the video thumbnail; `/linkedin-copywriter` for the launch post.

## Don'ts

- **Don't write a sentence.** ≤ 5 words, one highlight. If the hook needs
  explaining, it's the wrong hook.
- **Don't add a second accent color.** One accent only.
- **Don't trust the faces to carry it** — that myth was debunked. The
  headline does the work.
- **Don't ship a light thumbnail by default.** It blends into YouTube's
  UI; dark pattern-interrupts. Light is the on-brand option, not the
  strong one.
- **Don't skip the squint test or the cutout-edge check.**
- **Don't bake in a duration** unless the thumbnail is for off-YouTube use
  (YouTube overlays the real duration itself).

## See also

- Render template + script: `<YOUR_GRAPHICS_DIR>` (1280×720 HTML +
  substitute-and-screenshot script)
- Brand: `<YOUR_BRAND_DOC>` · voice rules + checklist
- Consumes this: `/youtube-publisher` (sets thumbnail on the video)
- Sibling style: `/graphics-designer` (tutorial / solo, text + slabs)
