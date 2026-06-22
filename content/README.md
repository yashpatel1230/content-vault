# content/ — your content vault

This replaces the old Notion DB. **Skills produce content here; Obsidian tracks it.** No external
tool, no sync — every piece is a markdown file you own, tracked by frontmatter and visualized by a
native Obsidian Base.

## How it works

- The writer skills (`/linkedin-copywriter`, `/long-form`, `/youtube-script`, …) write a markdown
  file into `posts/` with YAML frontmatter.
- **`Content.base`** is a native Obsidian [Base](https://help.obsidian.md/bases) (no plugin needed)
  that turns those files into a **Kanban board** grouped by `status` (Idea → Drafting → Review →
  Published → Backlog), plus table and card views. This is the direct replacement for the Notion
  board.
- `assets/` holds pasted images/attachments.

## Frontmatter schema (was the Notion DB schema)

```yaml
---
title: Your post title
status: Idea          # Idea | Drafting | Review | Published | Backlog
pillar: [Educational] # your content pillars
format: Text          # Text | Carousel | Video | Thread | Newsletter | ...
channel: [LinkedIn]   # LinkedIn | X | YouTube | Newsletter | Blog
author: you
publish: 2026-01-01   # planned/actual publish date
drive: []             # links to any Drive assets
---
```

Open `Content.base` in Obsidian for the board. Search everything (incl. your back catalogue) with
[qmd](../scripts/qmd-setup.sh): `qmd query "..."`.
