---
slug: unknowns/interviews
title: "Interviews"
tags: [unknowns, research, conversational]
---

# Interviews

**Stage:** Research | **Mode:** Conversational | **Targets:** Unknown unknowns

## What it does

Simulates interviews with different roles (users, skeptics, experts, competitors) to surface
viewpoints and concerns you haven't considered.

## When to use it

- When you need perspectives you can't easily access in real life
- When stress-testing an idea before presenting it to real stakeholders
- When you suspect you're in an echo chamber
- When preparing for tough questions

## How it works

1. You describe the topic
2. The agent proposes 3-5 relevant roles with distinct interests and biases
3. You confirm or customize the roles
4. The agent enters each role sequentially and interviews you (5-8 questions per role)
5. After all interviews, cross-role analysis reveals patterns

## Key mechanism

**Sequential, not mixed.** Each role gets a clean interview. Mixing roles in one conversation
dilutes the perspectives. Sequential interviews let each voice be fully heard before synthesis.

**Role embodiment, not generic questions.** The agent adopts each role's priorities, knowledge
level, communication style, and biases. A "skeptical investor" doesn't ask the same questions
as a "first-time user" — they have fundamentally different incentive structures.

**Cross-role analysis is where the gold is.** Issues raised by multiple roles are high-priority.
Contradictions between roles reveal genuine tensions. Unique insights from single roles point to
overlooked angles.

## Output

Per-role interview summaries + cross-role synthesis (high-priority issues, unique insights,
contradictions between roles).

## Connects to

- After this → `blind-spot-pass` for deeper analysis of concerns raised
- After this → `references` to find how others handled similar concerns
- Before this ← `brainstorming` (stress-test a chosen direction from multiple angles)

> Inspired by Thariq's "A Field Guide to Fable: Finding Your Unknowns"
