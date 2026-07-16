# VoxCPM Text Preparation

For the authoritative CLI flag table, see `voxcpm/cli-reference`. For mode selection and
generation tuning, see `voxcpm/synthesis`. This page is about the text and control input you
feed into either of those — how to write it so the output sounds right.

## Write the text first, then add control

Write a clean version of the target-language text on its own before layering on any voice
description or style instruction. Getting the words right first, separately from the voice
instruction, makes it obvious which part of a bad result to fix — the wording, or the
control/style instruction.

## Dialects: use authentic wording, not a Mandarin literal translation

If the target text is meant to be spoken in a dialect, write it the way a native speaker of
that dialect would actually phrase it — not a word-for-word translation of the Mandarin
phrasing into that dialect's characters. A literal translation reads as obviously foreign to
a native speaker even if every character is technically valid.

Example, Cantonese:

- Authentic: 伙計，唔該一個A餐
- Not this (Mandarin phrasing transliterated): 服务员，来个A餐

## Non-verbal markers

Non-verbal cues go in lowercase English square brackets: `[laughing]`, `[sigh]`.

Use them **sparingly**. Piling on multiple non-verbal markers in one line makes generation
less stable — the model has more conflicting cues to reconcile and results get less
predictable the more of these you stack.

## Numbers and dates

Add `--normalize` when your text contains numbers or dates. Without it, how a number gets
read out is not predictable — a bare "2024" in the text could come out as "二零二四" or as
"两千零二十四" depending on how the model resolves it. `--normalize` is what tells VoxCPM to
apply consistent text normalization to these instead of leaving the reading up in the air.

## Voice design instructions (`design` / `--control`)

Fold identity, voice quality, and emotion into a single descriptive sentence rather than
listing them as separate fragments. Example:

> 热情洋溢的中年男性播音员，声音较为低沉

That one sentence carries who's speaking (a middle-aged male announcer), the quality of the
voice (fairly deep), and the emotional tone (enthusiastic) — hand it to `--control` as-is.

## Style instructions when cloning

When cloning from a reference (`clone`, see `voxcpm/synthesis`), you can layer a style
instruction on top of the cloned voice to steer delivery, e.g.:

> speaking very fast, bright and full

This doesn't change *whose* voice comes out (that's still driven by the reference audio) —
it steers *how* that voice delivers the line.
