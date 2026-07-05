---
name: unknowns-quizzes
description: "Test your understanding of a topic through adaptive Q&A to expose knowledge gaps. Questions span multiple cognitive levels (Bloom's taxonomy). Difficulty adjusts based on your performance. Use when learning something new, preparing for a discussion, or wanting to verify you truly understand a subject."
version: "0.1.0"
author: "NevoFlux"
tags: [thinking, quizzes, testing, knowledge-gaps, learning, unknowns]
enabled: true
triggers:
  - "/unknowns:quizzes"
  - "test my understanding"
  - "quiz me on this"
  - "do I really understand this"
allowed_tools:
  - tool_search
  - tool_call_dynamic
---

# unknowns:quizzes — expose what you think you know but don't

Test understanding of a topic through Q&A to expose knowledge gaps. This targets **unknown
unknowns** — the dangerous kind where you think you understand something but actually don't.

> Part of the Unknowns toolkit (Communication stage). Inspired by Thariq's "A Field Guide to Fable."

## Interaction mode: Conversational

Multi-turn Q&A with adaptive difficulty. The agent asks, the user answers, the agent gives
feedback and adjusts.

## Flow

### 1. Opening — set the topic

Ask the user what they want to be tested on. Accept:
- A topic they're learning
- A project they're working on
- An article or document they just read
- A skill they think they have
- A decision they made (test the reasoning)

### 2. Core — adaptive Q&A

**Question generation.** Generate questions that span cognitive levels (Bloom's taxonomy):

| Level | What it tests | Example type |
|-------|--------------|-------------|
| **Recall** | Can you remember the facts? | "What is X?" |
| **Comprehension** | Can you explain it in your own words? | "Explain why X works this way" |
| **Application** | Can you use it in a new situation? | "How would you apply X to solve Y?" |
| **Analysis** | Can you break it down? | "What are the key differences between X and Y?" |
| **Synthesis** | Can you combine ideas? | "How would you design Z using concepts from X and Y?" |
| **Evaluation** | Can you judge and defend? | "Which approach is better for this situation and why?" |

**Question format.** Mix:
- Multiple-choice (3-4 options, one correct, distractors should be plausible)
- Open-ended (require explanation, not just answers)

Present one question at a time. Wait for the user's answer.

**Feedback.** After each answer:
- If correct: brief confirmation + note which cognitive level was demonstrated
- If incorrect: explain why, provide the correct answer, note the gap
- If partially correct: acknowledge what's right, clarify what's missing

**Adaptive difficulty.**
- User answers correctly → increase difficulty (higher cognitive level, more nuanced scenarios)
- User answers incorrectly → decrease difficulty or explore the same level from a different angle
- Target the boundary between "knows" and "doesn't know" — that's where the blind spots live

Run 8-12 questions, unless the user wants to continue.

### 3. Output — blind spot map

```
## Quiz Results: [topic]

### Score: [X/Y correct]

### Cognitive level performance
- Recall: [strong/adequate/weak]
- Comprehension: [strong/adequate/weak]
- Application: [strong/adequate/weak]
- Analysis: [strong/adequate/weak]
- Synthesis: [strong/adequate/weak]
- Evaluation: [strong/adequate/weak]

### Knowledge gaps identified
- [gap 1]: [evidence from wrong answers] — [what to study]
- [gap 2]: [evidence] — [what to study]

### Recommended next steps
- [specific action to address each gap]
```

If relevant, suggest: "Want to dig deeper into your weak areas? Try `unknowns:interviews`
(explore the topic from expert perspectives) or `unknowns:references` (find study material)."

### 4. Storage

Ask: "Save this quiz report to your knowledge base?"
If yes, use brain tools via `tool_call_dynamic`.
