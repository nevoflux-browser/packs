# Pipeline — five stages, three roles, one non-negotiable

Every post moves through five stages. Track the stage on each item in
`linkedin-to-pipeline/idea-backlog`.

```
Idea  →  Draft  →  Review  →  Scheduled  →  Live
```

- **Idea** — captured, tagged with a target funnel stage and slot.
- **Draft** — written by `linkedin-post-write` (hook chosen, body written, de-slopped).
- **Review** — QA'd by `linkedin-post-review`. This is a **hard gate**: it can send a draft
  back to Draft. Nothing advances without it.
- **Scheduled** — finalized by `linkedin-post-publish` into paste-ready copy + a slot.
- **Live** — published by the user (this pack never auto-posts).

## The three roles

Scaling content is easier when the work is split across clear roles:

- **Writer** — owns the idea and the draft.
- **Designer** — owns the visual (this pack produces the brief; rendering is handed off).
- **QA / editor** — owns the final pass so nothing ships with a mistake in it.

A single person or agent may wear several hats, but the **passes stay distinct** — writing is
not reviewing.

## The non-negotiable

> 100% AI output isn't acceptable.

A human owns the final result. Two things enforce this in practice:

- `post-write` runs the body through the `no-slop` skill to strip AI tells, and pauses for the
  user to pick the hook.
- `post-review` re-runs `no-slop` as a gate check and requires a human pass before anything is
  marked cleared.

If the `no-slop` skill isn't installed, prompt to install the `stop-slop` pack rather than
silently shipping AI-flavored copy.
