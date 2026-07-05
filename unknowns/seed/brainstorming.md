---
slug: unknowns/brainstorming
title: "Brainstorming"
tags: [unknowns, discovery, conversational]
---

# Brainstorming

**Stage:** Discovery | **Mode:** Conversational | **Targets:** Unknown knowns

## What it does

Generates options (and optionally visual prototypes) to activate preferences you have but can't
articulate until you see them.

## When to use it

- When you don't know what you want but will recognize it when you see it
- When choosing between approaches and can't decide from descriptions alone
- When exploring a design or creative direction
- Early in any project before committing to a path

## How it works

1. You describe the problem or direction to explore
2. The agent generates 5-8 genuinely different options per round
3. For visual/design topics: generates HTML prototype artifacts you can see and interact with
4. You react to each option (like / dislike / interesting)
5. The agent probes your reactions — especially dislikes — to reveal latent preferences
6. Repeat with progressively refined options until you converge on 2-3 favorites

## Key mechanism

**Reactions reveal preferences.** You often can't state what you want in advance. But when you
see an option and feel "no, not that," the reason you give for the rejection reveals a preference
you didn't know you had. The process is a preference excavation tool disguised as option
generation.

**Prototyping mode.** For visual or experiential topics, text descriptions aren't enough. The
agent generates tangible artifacts (HTML mockups, layout variations) so you can react to real
things, not abstract descriptions.

## Output

Top 3 converged options + a map of preferences revealed during the process (what you like, what
you reject, and the patterns behind both).

## Connects to

- After this → `plans` to structure the chosen direction into steps
- After this → `blind-spot-pass` to scan the chosen direction for risks
- After this → `references` to find examples similar to what you converged on

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"
