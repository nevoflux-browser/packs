---
name: unknowns-interviews
description: "Role-play interviews with simulated perspectives (user, skeptic, expert, competitor) to surface viewpoints you haven't considered. Sequential interviews with cross-role analysis. Use when you need to stress-test an idea from angles you can't access yourself."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, interviews, perspectives, role-play, unknowns]
enabled: true
triggers:
  - "/unknowns:interviews"
  - "interview me about this"
  - "what would a skeptic say"
  - "simulate different perspectives"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:interviews — hear from perspectives you can't access

Role-play interviews with simulated perspectives to surface viewpoints the user hasn't
considered. This targets **unknown unknowns** — blind spots that only emerge when you look
through someone else's eyes.

> Part of the Unknowns toolkit (Research stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Conversational

Multi-turn dialogue where the agent enters a role and interviews the user from that role's
viewpoint.

## Flow

### 1. Opening — set the topic and roles

Ask the user to describe the topic, idea, or plan to examine.

Propose 3-5 roles relevant to the topic. Roles should have distinct interests, knowledge, and
biases. Examples:

- For a product: "your target user," "a skeptical investor," "a competitor's product lead,"
  "a journalist covering your space," "a regulatory analyst"
- For a career decision: "your future self in 5 years," "a mentor who's been through this,"
  "someone who made the opposite choice," "your closest collaborator"
- For a strategy: "a board member," "a frontline employee," "a customer who just churned,"
  "an industry analyst"

Present the roles and ask the user to confirm, adjust, or add their own.

### 2. Core — sequential role-play interviews

For each confirmed role, in sequence:

**Enter the role.** Announce: "I'm now [role name]. I'll ask you questions from this
perspective." Adopt that role's:
- Priorities and concerns
- Knowledge level and domain expertise
- Communication style and biases
- Incentive structure

**Conduct the interview.** Ask 5-8 questions per role. Questions should:
- Reflect what that role would genuinely care about
- Challenge assumptions the user may hold
- Probe areas the role would consider critical
- Push back where the role would naturally push back

Let the user respond to each question before asking the next. This is a real conversation, not
a questionnaire.

**Exit the role.** After the interview, briefly summarize what this role's key concerns were.

**Sequential only.** Complete one role entirely before starting the next. Do not mix roles in
the same interview — each role gets a clean, focused session.

### 3. Output — cross-role analysis

After all interviews are complete, deliver:

```
## Interview Report: [topic]

### Roles interviewed: [list]

### Per-role summaries
#### [Role 1]
- Key concerns: [list]
- Strongest challenges: [list]
- Insights surfaced: [list]

#### [Role 2]
...

### Cross-role analysis
#### High-priority issues (raised by multiple roles)
- [issue]: raised by [role A, role B] — [synthesis]

#### Unique insights (from single roles)
- [insight]: from [role] — [why it matters]

#### Contradictions between roles
- [role A] says [X], but [role B] says [Y] — [implication]
```

If relevant, suggest: "Some issues could be explored with `unknowns:blind-spot-pass` (deeper
gap analysis) or `unknowns:references` (find how others handled similar concerns)."

### 4. Storage

Ask: "Save this interview report to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
