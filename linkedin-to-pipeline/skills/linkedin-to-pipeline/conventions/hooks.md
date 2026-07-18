# Hooks — the opening line does most of the work

Inside any format, the hook carries most of the load. Roughly **80% of the decision to read
is visual** (the image, the first line's shape on screen) and **20% is the opening line**
itself. So the hook and the visual are where the effort goes, not the body.

Keep the hook **short and specific — ideally under about 55 characters**. Vague or long hooks
lose the small first audience the algorithm tests the post against (see `algorithm.md`).

## Three hook patterns

Three patterns carry most posts. Use them as starting points, not a cage.

- **Social proof** — lead with a result you earned.
  *"We generated 40M impressions using this system"*
- **Numbers** — lead with a specific, concrete count or delta.
  *"3 changes that improved our reply rate 2x"*
- **Relevance** — name the reader's exact problem.
  *"If your LinkedIn posts aren't converting, this is why"*

## How `linkedin-post-write` uses this

`post-write` produces **2–3 hook variants** (usually one per pattern) and lets the user pick
before the body is written — the hook is the highest-leverage decision, so it gets its own
step. When `weekly-review-log`'s "What's working" section shows a pattern performing well for
this account, prefer it, but keep at least one variant exploring a different pattern.
