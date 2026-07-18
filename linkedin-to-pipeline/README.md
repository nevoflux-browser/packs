# linkedin-to-pipeline

**English** · [中文](README.zh.md)

A NevoFlux pack that runs LinkedIn as **pipeline infrastructure**, not a brand-awareness feed.
It turns a proven content system — 70/20/10 funnel, hook patterns, five formats, a weekly
feedback loop — into a set of skills that plan, mine, write, review, and hand off posts, backed
by protected seed pages that hold your brand profile and content state.

The chain it operationalizes: **content → visibility → trust → conversations → opportunities.**
Content isn't the top of the funnel — it *is* the funnel.

## What it does / doesn't do

- **Does:** plan a content calendar, mine ideas from your own sources, write posts (hook-first,
  format-aware), QA them, and finalize paste-ready copy with a visual brief.
- **Doesn't:** auto-post to LinkedIn (it finalizes and hands off — you hit Post), render images
  or video (it writes a visual brief and points at a renderer), or read your LinkedIn data (you
  supply weekly numbers). External sources (reddit, GitHub, open tabs) are read-only inspiration.
- **Soft-integrates** the [`stop-slop`](https://nevoflux.app/packs/a4999593-96e1-47af-b392-3025db41eb15/)
  pack's `no-slop` skill to strip AI writing tells. If it's not installed, you'll get an install
  hint — nothing blocks.

## Quick start

1. Run `/linkedin-to-pipeline`.
2. Fill `linkedin-to-pipeline/brand-profile` (positioning, ICP, offer, voice, proof) and
   `linkedin-to-pipeline/idea-sources` (where your ideas come from).
3. Run `/linkedin-calendar-planning` to lay out the arc and open your 70/20/10 slots.
4. Then `/linkedin-idea-mining` → `/linkedin-post-write` → `/linkedin-post-review` →
   `/linkedin-post-publish`. Review weekly with `/linkedin-weekly-review`.

## Skills

| Skill | Command | What it does |
| --- | --- | --- |
| `linkedin-to-pipeline` | `/linkedin-to-pipeline` | Host/router. Checks your foundation pages and points you to the right step in the loop. |
| `linkedin-calendar-planning` | `/linkedin-calendar-planning` | Strategic entry point: lay out the one-time positioning→authority→conversion arc and open 70/20/10 slots over a rolling window. |
| `linkedin-idea-mining` | `/linkedin-idea-mining` | Fill the open slots with ideas from internal knowledge, your configured sources (incl. open tabs), and performance feedback. |
| `linkedin-post-write` | `/linkedin-post-write` | Write a post: pick a format (exploit/explore), offer 2–3 hook variants, write the body, de-slop, and brief any visual. |
| `linkedin-post-review` | `/linkedin-post-review` | The hard QA gate — voice, proof, hook, de-slop re-check. Can send a draft back to write. |
| `linkedin-post-publish` | `/linkedin-post-publish` | Finalize paste-ready copy + visual brief + a suggested slot, record status, hand off (no auto-posting). |
| `linkedin-post-repurpose` | `/linkedin-post-repurpose` | Turn a high performer into a new format (text → carousel → video). |
| `linkedin-weekly-review` | `/linkedin-weekly-review` | Analyze the week's numbers, keep "What's working" current, feed insights back to the calendar and ideas. |

## Seed pages

| Page | Holds |
| --- | --- |
| `linkedin-to-pipeline/brand-profile` | Positioning, ICP, offer, voice/banned words, cadence knobs, proof bank. |
| `linkedin-to-pipeline/idea-sources` | Social-listening + product signal sources and per-source mining rules. |
| `linkedin-to-pipeline/idea-backlog` | Ideas and their pipeline status (Idea → Draft → Review → Scheduled → Live). |
| `linkedin-to-pipeline/content-calendar` | The arc and the open 70/20/10 slots. |
| `linkedin-to-pipeline/weekly-review-log` | Weekly performance entries + the distilled "What's working". |

All seed pages are protected — uninstalling the pack keeps your data.

## Credits

Methodology distilled from Dan Rosenthal's *"How We Hit $2M ARR in 7 Months With One Channel:
LinkedIn."* MIT licensed.
