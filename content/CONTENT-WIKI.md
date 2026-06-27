# Content Wiki · operating manual

This vault is a content **knowledge graph**, not just a post calendar. It mirrors the LLM-wiki pattern (raw sources → synthesized, cross-linked notes) onto your content so your ideas compound instead of getting rewritten from scratch every post.

> This folder ships with one example of each note type (`example-*`). Delete them once your own notes land, or duplicate them as starting templates.

## The layers

| Layer | Folder | Role |
| --- | --- | --- |
| Artifacts | `posts/` | Published / drafted pieces. One `.md` per piece. The raw record. |
| Concepts | `concepts/` | Atomic durable ideas. One claim per note. **The compounding asset.** |
| Entities | `entities/` | Recurring people, customers, competitors, partners. |
| MOCs | `mocs/` | Maps of Content. Narrative arcs that thread posts into a story. |
| Catalog | `index.md` | What exists, grouped. |
| History | `log.md` | Append-only event log. |

`posts/` is the raw layer. `concepts/` + `entities/` + `mocs/` are the synthesis layer that makes those posts compound.

## Why this compounds

Tags and pillars are *filters*. They slice the list; they don't connect ideas. The graph comes from **links + atomic concept notes + the discipline of linking every new post back into them.**

Each concept note carries an `## Appears in` list of `[[post-slug]]` links. Because Obsidian renders backlinks automatically, every post shows its concepts in its backlinks pane **without editing the post**. So the edges live in the concept / entity / MOC notes and stay bidirectional for free. Open the Obsidian graph view to watch it thicken.

The payoff loop: you stop writing from a blank page. The next post is built by pulling an existing concept note (its canonical lines, its proof, its prior framings) and extending it, then depositing whatever is new back into the layer. You remix your own canon. After a few weeks the graph is the asset, not any single post.

## The discipline (every new post)

1. **Before writing** — find the concept(s) the post expresses. Read those notes. Reuse their canonical lines and proof instead of reinventing them.
2. **After writing** — for each of the post's 1-3 core ideas:
   - If a concept note exists: add the post to its `## Appears in` (and any fresh canonical line to `## Canonical lines`), bump `appears_in` / `updated`.
   - If no note exists: create one from the template below.
   - Same for any recurring person / customer / competitor → `entities/`.
   - If the post extends a narrative arc → append the beat in the matching `mocs/` note.
3. Append a line to `log.md`.

The content skills do steps 1-2 for you (see "Skill hooks"). Doing it by hand is the fallback.

## Note templates

Concept:

```markdown
---
type: concept
status: living
owner: you
created: YYYY-MM-DD
updated: YYYY-MM-DD
appears_in: <count>
tags: [content-concept]
---

# <Concept Title>

**Claim.** <1-3 sentences: the durable argument this thread keeps making.>

## Canonical lines
- "<verbatim quotable line>" · [[post-slug]]

## Appears in
- [[post-slug]] · <3-6 word angle>

## Related
[[other-concept]] · [[other-concept]]

## Source notes
Synthesized from the posts above (`posts/`). First seen <date>.
```

Entity: same shape, `type: entity`, `tags: [content-entity, person|competitor|partner|customer]`, a `## Facts` section instead of `## Canonical lines`.

MOC: `type: moc`, `tags: [content-moc]`, a `## The thread (chronological)` numbered list of `[[post]] · beat`, and a `## Concepts in this arc` line.

## Your taxonomy emerges (don't pre-build it)

Start with zero concepts. As you publish, the writers create a note the first time an idea recurs, and add to it every time after. Within a few weeks you'll have 15-25 concept notes that *are* your content thesis: the things you say over and over. Keep `index.md` and the list there current as notes appear.

Add a concept only when an idea is genuinely new and durable, not a rephrase of an existing one. Prefer extending an existing note.

## Skill hooks

The writer skills participate in the loop automatically:

- `/researcher` reads `concepts/` + `mocs/` to propose ideas that extend existing threads (and flags under-covered concepts), alongside its trend / performance / customer scans.
- `/linkedin-copywriter`, `/x-copywriter`, `/long-form`, `/newsletter-writer` pull the relevant concept note(s) as grounding before drafting, and after writing deposit new ideas back into `concepts/` + update `## Appears in`.

That's what makes the graph self-maintaining: you write posts as usual, and the canon grows underneath you.
