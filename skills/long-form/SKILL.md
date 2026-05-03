---
name: long-form
description: Draft written long-form content (newsletter issue, blog post, Substack issue) in your voice. 800-2000 words, structured intro + body + CTA, paragraph-by-paragraph not list-by-list. Pulls voice from /linkedin-copywriter's corpus (same author, same register · longer arc). Runs the brand-doc skill checklist before output. Logs the row in the Notion Content DB and (for newsletters) drafts a separate punchy subject line. Use when asked to "write a newsletter", "draft a blog post", "long-form X", "Substack issue about Y", "weekly newsletter", or "/long-form". For spoken video scripts (YouTube longs / shorts) use /youtube-script instead · the cadence is fundamentally different.
---

# long-form

Written long-form content. One author voice (yours), three default
shapes (newsletter / blog / Substack issue). Same skill, different
register and length per shape.

This is **written long-form**. For **spoken long-form** (YouTube
longs, podcast monologues, talking-head video scripts), use
`/youtube-script` · spoken cadence is structurally different and
trying to merge them produces worse output for both.

## When to use

Trigger on:
- "Write a newsletter issue"
- "Draft a blog post about X"
- "Long-form / Substack issue on Y"
- "Weekly newsletter"
- "Article for the website"
- User explicitly types `/long-form`

Skip for:
- LinkedIn / X posts → `/linkedin-copywriter` · `/x-copywriter`
- YouTube / podcast / talking-head scripts → `/youtube-script`
- Lead magnet PDFs → `/lead-magnet-creator`
- Sales proposals → `/proposal-creator`

## Inputs

The brief should include:
- **Type**: `newsletter` (default) · `blog` · `substack-issue`
- **Topic** + angle (one sentence)
- **Target length**: default 1200-1500 words (newsletter), 800-1500 (blog)
- **Audience**: who's reading? (newsletter list, cold blog visitor, both)
- **Optional source**: Notion row URL if invoked from `/repurpose` ·
  this anchors the piece to a specific master and informs the body
- **Optional CTA**: what do you want the reader to do at the end? ·
  default: "reply to this email" (newsletter), "subscribe to the newsletter"
  (blog), "tweet me" (substack)

If anything is missing, ask in **one batch**, then draft.

## Voice anchor

The voice is yours, the same as `/linkedin-copywriter`. Read
the linkedin-copywriter corpus you've populated
([`../linkedin-copywriter/corpus.md`](../linkedin-copywriter/corpus.md))
**before drafting** if you've been off-task. Top 5 posts are the
strongest voice anchors.

Long-form differs from short-form in arc and density, not register:
- **Arc**: short-form is one beat (hook + payoff). Long-form is 3-5
  beats. You can develop a thought.
- **Density**: short-form is compressed (every line earns its place).
  Long-form has breathing room (paragraphs, not bullet-stacks).
- **Voice**: identical. Same opinions, same word choices, same
  no-em-dash / no-slop discipline.

If you find yourself padding to hit length, the topic isn't deep
enough. Tell the user, propose a shorter shape (LinkedIn post or
thread), don't force it.

## Workflow

### 1. Brief

Get the inputs above. If invoked from `/repurpose`, use the master
Notion row's title + body as the brief.

### 2. Outline

Output a 5-8 line outline before drafting. Each line is one beat:

```
1. Hook        Opening sentence. The friction point.
2. Setup       Why this matters now. One paragraph of context.
3. Body 1      First insight / argument. Concrete example.
4. Body 2      Second insight. Counter-take or extension.
5. Body 3      Third insight. (Optional · drop if outline feels thin)
6. Resolution  What changes if you do this. Stakes.
7. CTA         The action. Specific.
```

Show the outline to the user. Wait for green light or revisions
before writing the full draft. **Don't draft the body until the
outline is approved** · revisions are expensive once the prose is
flowing.

### 3. Draft

Once the outline lands, write the full piece.

Length targets:

| Type            | Words      | Beats | Notes                              |
| --------------- | ---------- | ----- | ---------------------------------- |
| Newsletter      | 1200-1500  | 5-7   | Conversational. Personal. Time-anchored ("This week..."). |
| Blog post       | 800-1500   | 4-6   | More evergreen. SEO-aware subheads. Links out. |
| Substack issue  | 1500-2500  | 6-8   | Longer arc. Can include footnotes / asides. |

Structure constraints:
- Lead with the hook in the first **two sentences**. Don't bury it.
- Paragraphs are short (2-4 sentences each). White space is structural.
- Subheads (H2) every ~300 words. Subheads are descriptive, not cute.
- One **specific concrete example** per body section. Numbers, names,
  real situations · not generic.
- The CTA is a single sentence. Don't tack on three.

Newsletter-specific:
- Open with a date or time anchor ("Tuesday morning · 6 AM" · "Last
  week we shipped X").
- Sign-off in your voice. No "Cheers," / "Best,". Just the next
  thought or a single line.
- Subject line: separate output. See § "Subject lines" below.

Blog-specific:
- Title is SEO-friendly but not slop. "Why GTM teams should stop
  building dashboards" beats "5 reasons your dashboard sucks".
- Include 2-3 internal links (to other <YOUR_BRAND> blog posts or lead
  magnets) where they earn placement · never forced.

Substack-specific:
- Allow more digressions and asides. Substack readers tolerate (and
  enjoy) tangential beats that wouldn't fit a blog.
- Closing footnote with `[1]`-style reference if you cite anything.

### 4. Subject lines (newsletter only)

For newsletters, generate **3 subject-line options** alongside the
draft. Output them at the top of the deliverable. Patterns that
work:
- Specific number: "47 webinar signups, 0 demos"
- Friction-first: "I almost killed our outbound stack last week"
- Curiosity gap: "The one thing GTM Engineers get wrong"
- One-word punch: "Outbound."
- Question that reads like a thought: "What if your SDR didn't exist?"

Patterns to avoid:
- Numbered listicles ("5 ways to...") · stale
- Hyphenated compounds ("game-changing...") · slop
- All caps · spam folder
- Em dashes · slop
- "Newsletter #042" · nobody opens that

### 5. Slop scrub (mandatory)

Run the brand-doc skill checklist on the final draft. The copy
checks especially:
1. Em-dash scan · zero `—` characters
2. Banned-words scan · zero hits on `leverage`, `synergy`, `robust`,
   `world-class`, `seamless`, `intuitive`, `powerful`, `innovative`,
   `delve`, `unleash`, `revolutionary`, `game-changing`
3. Negation-pivot scan · no "not just X, but Y" patterns
4. Numerals · adjectives describing scale → real numbers where
   possible

If any check fails, fix and re-run. Don't ship.

### 6. Save the draft

Long-form drafts live in the Notion Content DB page body. Don't
write the draft to a file in the repo (the repo is for assets, not
text drafts).

Create a row via `mcp__claude_ai_Notion__notion-create-pages` with
data source `<YOUR_NOTION_CONTENT_DB_ID>`:

- **Title**: the piece's title (e.g. "Newsletter Issue 03 · The pipeline post")
- **Status**: `Scripting` (until human reviews)
- **Pillar**: pick the multi-select that matches the angle
- **Format**: `Long-form Article`
- **Channel**: `Newsletter` · `Website` (blog) · or as appropriate

Page body:

```
Type: <newsletter / blog / substack>
Length: <word count>
Source: <master URL if from /repurpose>

— Subject lines (newsletter only) —
1. <option 1>
2. <option 2>
3. <option 3>

— Outline —
1. <beat>
2. <beat>
...

— Draft —
<the full piece, with subheads>
```

If invoked from `/repurpose`, the orchestrator may handle row
creation · check the source context to avoid duplication.

### 7. Report back

Hand off to the user:
- Notion row URL
- Word count
- Subject lines (newsletter)
- Confirmation all 4 copy checks passed

Suggest next: open the Notion row to review, then flip Status to
`Scheduled` when ready, then post manually (you handle publishing).

## Don'ts

- **Don't pad to hit length.** If 1500 words feels thin, propose a
  shorter shape (LinkedIn post or thread) and stop. Padding produces
  the slop pattern you want to avoid.
- **Don't draft before the outline is approved.** Rewrites in prose
  cost 5x more than rewrites in outline.
- **Don't impose newsletter time-anchors on blog posts.** Blog
  evergreen voice means no "this week" openers.
- **Don't write listicles.** "5 ways to..." structures are short-form
  posts, not long-form. If the topic naturally lists, write a thread
  or a LinkedIn post instead.
- **Don't forget the subject lines for newsletters.** Three options.
  Always.
- **Don't include AI-flavoured intros** ("In this piece, I'll explore
  how..."). Cut the ritual sentences and start with the hook.
- **Don't mix print and motion brand systems** (this skill is
  text-only · brand-doc print rules apply if any visual treatment
  is added).
- **Don't fabricate quotes / metrics / customer names.** If you're
  drawing from `/repurpose` source or a customer-interview transcript,
  use exact quotes only when the source is non-NDA · paraphrase
  otherwise.

## See also

- Brand reference: `<YOUR_BRAND_DOC>` · voice rules + skill checklist
  (if you have a brand doc with voice rules, link it here)
- Voice corpus (shared with /linkedin-copywriter):
  [`../linkedin-copywriter/corpus.md`](../linkedin-copywriter/corpus.md)
- Sibling skill (spoken long-form): `/youtube-script`
- Notion Content DB data source: `<YOUR_NOTION_CONTENT_DB_ID>`
- Upstream skill: `/researcher` (sources ideas), `/repurpose`
  (orchestrates from a master into long-form variants)
