---
name: writing-blog-posts
description: "Use when drafting a new post for this Jekyll blog. Captures post format, voice, and verification workflow."
---

# Writing Blog Posts (brokenco.de)

Conventions for drafting posts in this Jekyll site. Follow these whenever
creating content under `_posts/`, whether from scratch or from source material
(see also the `fediverse-thread-to-draft` skill).

## Post Format

- Filename: `_posts/YYYY-MM-DD-slug-in-words.md` — date must match the post's
  publication date; the slug becomes the URL (`/YYYY/MM/DD/slug.html`).
- Frontmatter:

  ```yaml
  ---
  layout: post
  title: Title without surrounding quotes unless it contains a colon
  tags:
  - aws
  - opinion
  ---
  ```

- Title is plain text; quote it only when YAML requires it (e.g. a colon).
- Tags: lowercase, drawn from existing tags in the repo. Check with
  `grep -rh -A8 '^tags:' _posts/*.md | grep '^- ' | sort | uniq -c | sort -rn`.
  Reuse before inventing; most common: `opinion`, `rust`, `jenkins`,
  `software`, `opensource`, `deltalake`, `scribd`, `aws`.

## Voice and Structure

Match the established style of recent posts (read the 2-3 most recent dated
posts before drafting):

- First person, conversational but precise. Wry asides are welcome.
- Short paragraphs, usually 1-4 sentences each.
- `_italics_` for emphasis, `**bold**` sparingly for a strong claim.
- Blockquotes (`>`) for error messages, excerpts, and quoted material —
  attribute with a link when quoting external sources.
- Markdown links with descriptive text, never bare URLs in prose.
- Technical specifics over generalities: real numbers, service names, dates.
- Wrap prose at roughly 80 columns, matching existing posts.
- End with a takeaway, recommendation, or punchline — not a summary section.

## Workflow

1. Read the 2-3 most recent `_posts/` entries for tone calibration.
2. Draft the post with `write_file`. Title and slug should agree.
3. Verify the build: `bundle install` if needed, then
   `bundle exec jekyll build` and confirm
   `_site/YYYY/MM/DD/<slug>.html` exists.
4. Do NOT commit automatically — leave the file untracked or staged so the
   author reviews before committing.

## Pitfalls

- Never fabricate quotes, links, or error messages — pull them verbatim from
  source material or omit them.
- Do not commit tarballs, build output (`_site/`), or `.worktrees/`.
- Existing drafts may sit untracked in `_posts/`; do not assume an untracked
  post is yours to modify.
