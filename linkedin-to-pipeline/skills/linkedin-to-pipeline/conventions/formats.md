# Formats — five that work, chosen by what the idea needs

Five core formats cover almost everything. Pick by what the idea needs, not by habit.

| Format | Fits |
|---|---|
| **Text** | Ideas, opinions, and short narratives |
| **Carousel** | Breaking a concept into steps |
| **Infographic** | Showing a system or comparison in a single view |
| **GIF / demo** | Visualizing a process, especially product |
| **Video** | Explaining and demonstrating a complex idea |

## Selection principle: exploit, then explore

> Put most of your output into formats that already perform for you, and use a smaller
> portion to test new variations.

- **Exploit (the big share):** default to a format that has performed well for this account.
  "Already performs" is not a guess — it comes from the **"What's working"** section of
  `linkedin-to-pipeline/weekly-review-log`, which `linkedin-weekly-review` keeps current.
- **Explore (the small share):** deliberately test a new format or variation on a minority of
  posts, so the proven set can keep growing.

On a cold start there is no history yet, so fall back to choosing purely by what the idea
needs.

Whatever the format, **the hook does most of the work** (see `hooks.md`).

## Visual boundary — brief, don't render

This pack writes **copy plus a visual brief** (structure, per-panel or per-scene text, art
direction). It does **not** render images or video. The brief names the downstream tool:

- **Video / GIF** → the built-in `video` skill.
- **Carousel / infographic** → create-artifact (render the carousel as an HTML slide deck,
  the infographic as an HTML/SVG page).

If the named tool isn't available, hand off a plain-text brief — never block on it.
