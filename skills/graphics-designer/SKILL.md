---
name: graphics-designer
description: Design and ship on-brand <YOUR_BRAND> graphics. Single image (LinkedIn portrait, square, banner, OG image) or multi-slide LinkedIn carousel. Branches an existing template in <YOUR_GRAPHICS_TEMPLATES_PATH> or starts fresh from the brand tokens, fills in copy + cards, renders 1× and @2× PNGs via headless Chrome, uploads to Drive's "60 Graphics" folder, creates a row in the Notion Content database, and validates against the <YOUR_BRAND_DOC> skill checklist before declaring done. Use when asked to "design a graphic", "make a LinkedIn graphic / banner / carousel", "create an image post", "design a hero image", "I need a graphic for X", or "/graphics-designer".
---

# graphics-designer

The on-brand graphics factory. HTML → PNG via headless Chrome, with
mandatory adherence to your brand spec. Produces single graphics or
multi-slide carousels. Logs every output in the Notion Content DB and
mirrors the file to Drive's `03 Marketing/60 Graphics/`.

**Read `<YOUR_BRAND_DOC>` if you have one** — voice rules + skill
checklist + format-specifications table dictate dimensions, validators,
and the visual discipline that separates on-brand from AI-generated.

## When to use

Trigger on:
- "Design a graphic for X"
- "Make a LinkedIn portrait / square / banner"
- "Create a carousel about Y" (multi-slide)
- "I need a hero image / OG image / share image"
- "Render the X graphic"
- User explicitly types `/graphics-designer`

Skip for:
- Animated graphics → `/launch-video` (synthetic) or `/video-use` (footage edit)
- Slide decks → your decks pipeline (existing `presentations/` build)
- PDF lead magnets → `/lead-magnet-creator`

## Inputs

The brief should include:
- **Format** + **Channel** (e.g. LinkedIn portrait post, X header, carousel)
- **Headline** (use the two-line hero pattern · `Outbound stack. / Live in 3 weeks.`)
- **Kicker** (mono micro-label · "WEBINAR · 12 May" or "/research")
- **Body** (cards, bullets, table rows, speaker tiles · whatever the
  template has)
- **Accent target** (where the one accent dot / cell / pill lands)
- **Optional template hint** (which existing template to branch from)
- **Optional source** (Notion row URL · for cluster traceability)

If anything is missing, ask in **one batch** before drafting.

## Workflow

### 1. Pick the right template

If you have existing templates in `<YOUR_GRAPHICS_TEMPLATES_PATH>`,
branch from the closest match. Otherwise start from a clean HTML
scaffold and apply your brand tokens (`<YOUR_BRAND_TOKENS_PATH>`).

Common template archetypes worth keeping in your library:
- Webinar event announcement (host + speakers)
- Webinar event with partner branding
- Tool / stack diagrams with logos
- Anatomy of a thing (annotated diagram)
- Accelerator / partner announcement
- Personal LinkedIn banner (1584×396)
- Company LinkedIn banner (1128×191)

If the brief doesn't fit any of the above, branch from the most modular
template you have, or from your live styleguide HTML page. Don't
reinvent · compose.

### 2. Branch the template

```bash
cp <YOUR_GRAPHICS_TEMPLATES_PATH>/<closest-match>.html \
   <YOUR_GRAPHICS_TEMPLATES_PATH>/<new-name>.html
```

Naming: `<channel>-<topic>-<dateOrId>.html`. Examples:
- `linkedin-outbound-stack-2026-05.html`
- `linkedin-carousel-icp-tactics-01.html`  (carousel slide 1)
- `linkedin-carousel-icp-tactics-02.html`  (carousel slide 2)
- `x-header-2026-05.html`

For carousels: one HTML file per slide. Same dimensions
(1080×1350 each). Numbered suffix.

### 3. Edit copy + cards

Each existing template marks per-graphic edits in CONFIG blocks at
the top of the file. Stay inside those blocks. Don't touch the design
system styles · they're inherited from your tokens (mirrored inline).

Things you usually edit:
- `<title>` (browser tab + future PNG metadata)
- Header brand chip (`Live · Webinar` or `/research` slug)
- Kicker line (mono · short)
- Hero h1 (two lines · second in `<em>` for muted half)
- Speaker / card tiles (duplicate or remove rows as needed)
- Footer (URL, slug, page indicator)

Things you almost never touch:
- Token values (color, type, radius, spacing)
- Component classes (`.brand`, `.kicker`, `.tick`, `.chip`, `.matrix`)
- Layout helpers (`.two-col`, `.three-col`, etc.)
- The brand mark SVG · always present in `.brand` (path:
  `<YOUR_LOGO_PATH>`)

### 4. Render

```bash
cd graphics
./render.sh <new-name> <width> <height>
```

Defaults: `1080 1350` (LinkedIn portrait). For other formats, see the
**Format specifications** table in `<YOUR_BRAND_DOC>`.

The render script is a thin wrapper around headless Chrome:

```bash
# render.sh pattern
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-sandbox \
  --window-size=$WIDTH,$HEIGHT \
  --screenshot=output/$NAME.png \
  --default-background-color=00000000 \
  "file://$PWD/templates/$NAME.html"
# then a second pass at 2× device-scale-factor for the @2x output
```

For carousels: render each slide with the same command:

```bash
./render.sh linkedin-carousel-icp-tactics-01 1080 1350
./render.sh linkedin-carousel-icp-tactics-02 1080 1350
# ... etc
```

Outputs land in `graphics/output/`:
- `<name>.png` (1×, the deliverable)
- `<name>@2x.png` (retina · for high-density displays)

### 5. Visual review

Open the rendered PNG. Walk the **skill checklist**:

**Copy checks:**
1. Em-dash scan · zero `—` in any visible copy
2. Banned-words scan · zero hits on the slop list
3. Negation-pivot scan · no "not just X, but Y" patterns
4. Numerals where adjectives would weaken

**Visual checks:**
5. Accent count · the one accent appears at most once
6. Font discipline · body in Helvetica Neue 400, mono only on labels
7. Wordmark slot · `<YOUR_BRAND>` wordmark + logo mark visible (header or footer)
8. Hero-headline pattern · two lines, second in muted via `.hero em`
9. Footer URL · `<YOUR_DOMAIN>` (or campaign URL)
10. Corner ticks · all four `.tick` squares present, 35px clear
11. Dimensions match the format spec exactly

If any check fails: fix the HTML, re-render, recheck. Don't ship a
graphic that fails any of the 11.

### 6. Upload to Drive

```bash
# parent: 03 Marketing/60 Graphics
# folder id: <YOUR_DRIVE_GRAPHICS_FOLDER>
```

Use `mcp__claude_ai_Google_Drive__create_file` per output PNG. Title
pattern: `<channel>-<topic>-<YYYY-MM-DD>.png` (or `@2x` variant).

For carousels, upload all slides as separate files into a subfolder
named after the carousel topic, so they stay grouped:

```
60 Graphics/
└── 2026-05 ICP tactics carousel/
    ├── slide-01.png
    ├── slide-02.png
    └── ...
```

Capture each `viewUrl` from the Drive create response.

### 7. Log in Notion

Create a row in the Content DB (`<YOUR_NOTION_CONTENT_DB_ID>`) via
`mcp__claude_ai_Notion__notion-create-pages`:

- **Title**: `<topic> · LinkedIn` (e.g. `Outbound stack · LinkedIn`)
- **Status**: `Scripting` (awaiting human review) or `Scheduled` if
  the user confirms it's ready
- **Pillar**: pick the multi-select that matches the brief
- **Format**: `Image` for single graphic · `Carousel / PDF` for carousel
- **Channel**: `LinkedIn` (or whatever the brief specified)
- **Drive Assets**: paste the Drive `viewUrl`(s). For carousels, paste
  all slide URLs.

Page body: include the brief, the headline, the kicker, the source
URL if invoked from `/repurpose`, and any notes for the human reviewer.

If invoked from `/repurpose`, the orchestrator may handle the row
creation · check the source context first to avoid duplication.

### 8. Report back

One-line summary plus links:
- Rendered PNG path(s)
- Drive `viewUrl`(s)
- Notion row URL
- Confirmation that all 11 skill-checklist items passed

Suggest next: post on LinkedIn (manual · <YOUR_NAME> handles publishing),
or chain into `/linkedin-copywriter` for the post copy that will
accompany the graphic.

## Carousel mode

LinkedIn carousels are the highest-engagement format. Build them
deliberately.

### Structure (default 7 slides)

| Slide | Role           | Content                                    |
| ----- | -------------- | ------------------------------------------ |
| 1     | Cover          | Hero headline + kicker + accent. The hook. |
| 2     | The problem    | One sentence + one supporting fact         |
| 3     | The framework  | Numbered list (3-5 items)                  |
| 4-6   | Each step      | One slide per step · headline + 2-3 lines  |
| 7     | CTA            | "Save · share · follow <YOUR_NAME>"        |

Adjust slide count for the topic. 5-12 slides is the sweet spot. Less
than 5 is just a graphic; more than 12 loses people.

### Visual continuity across slides

- Same headline color treatment on every slide.
- Slide number in the footer (`02 / 07`) as mono.
- Accent rotates · don't anchor it to the same position every slide.
- Kicker stays the same across slides (it's the carousel's identity).

### Render carousel

```bash
for i in 01 02 03 04 05 06 07; do
  ./render.sh <carousel-name>-$i 1080 1350
done
```

## Don'ts

- **Don't reinvent the design system.** Compose existing component
  classes. If you need a new component, lift it from another template
  or from your live styleguide HTML. Adding new tokens or components
  belongs in `<YOUR_BRAND_TOKENS_PATH>`, not in a one-off graphic.
- **Don't mix print and motion subsystems.** A graphic is print-style
  (corner ticks, dot grid, accent). Motion-system surfaces (glass,
  hero video, drift orbs) are for `/launch-video` and web.
- **Don't ship without re-rendering.** If you edited the HTML, re-run
  `./render.sh` and re-check the PNG. Trust the render, not your
  expectation.
- **Don't skip the @2× output.** The render script produces both;
  upload both. LinkedIn auto-picks the right density.
- **Don't use stock photos.** Speaker / customer photos go in
  `graphics/public/speakers/` and `graphics/public/webinar/`. If you
  don't have a real photo, use a `<div class="photo placeholder">`
  with initials, not a generic image.
- **Don't bypass the skill checklist.** All 11 items, every time.
- **Don't write the post copy here.** Once the graphic is shipped,
  hand off to `/linkedin-copywriter` for the accompanying text.

## See also

- Brand reference: `<YOUR_BRAND_DOC>` · format spec table, voice rules,
  skill checklist
- Existing templates: `<YOUR_GRAPHICS_TEMPLATES_PATH>`
- Render script: `graphics/render.sh`
- Tokens: `<YOUR_BRAND_TOKENS_PATH>`
- Notion Content DB: `<YOUR_NOTION_CONTENT_DB_ID>`
- Drive folder `60 Graphics`: `<YOUR_DRIVE_GRAPHICS_FOLDER>`
- Downstream skills: `/linkedin-copywriter` (post copy after graphic
  ships), `/repurpose` (when graphic is a derivative of a master)
