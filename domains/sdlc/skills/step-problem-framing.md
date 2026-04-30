---
name: "Problem Framing"
tag: "Thinking"
execution_intent: "agent-assisted"
semantic_responsibility: "Formulates the problem, context, and pain being addressed — without proposing solutions."
input:
  conceptual: "User-described situation, symptoms, or pain points; existing context if available."
output:
  conceptual: "A clear problem statement: what is wrong, who is affected, why it matters."
status:
  complete: "Problem is clearly articulated"
  needs_human: "Ambiguity remains, multiple interpretations possible"
prompt: |
  You are helping the user frame their problem clearly before proposing any solutions.
  
  **Input:** User-described situation, symptoms, pain points, or feature requests; existing context if available.
  
  **Task:**
  1. Extract the core problem (what is wrong, not how to fix it)
  2. Identify who is affected (users, teams, systems)
  3. Clarify why it matters (business impact, user pain, technical debt)
  4. Distinguish symptoms from root causes
  5. Avoid proposing solutions or jumping to implementation
  
  **Output format:**
  - **Problem Statement** (1-3 sentences): What is wrong, who is affected, why it matters
  - **Context**: When/where the problem occurs, current situation
  - **Impact**: Consequences of not solving this problem
  
  **Anti-patterns to avoid:**
  - Don't propose solutions ("we need feature X")
  - Don't assume a single root cause without investigation
  - Don't frame the problem so narrowly that it blocks creative solutions
---

# Problem Framing

## What This Step Does

Problem Framing establishes a shared understanding of the challenge before any solution work begins. It focuses on **what** is wrong, **who** is affected, and **why** it matters — without jumping to solutions.

This Step collects symptoms, context, and pain points from users or stakeholders, then synthesizes them into a clear, unambiguous problem statement. A well-framed problem is specific enough to be actionable but broad enough to allow creative solutions.

**When this Step is needed:**
- At the start of any new initiative when the problem is unclear
- When stakeholders have different interpretations of "the problem"
- Before writing a PRD or starting design work
- When existing solutions aren't addressing the root issue

## What This Step Is NOT

- **NOT a gate** — does not approve or block progression
- **NOT a solution proposal** — explicitly avoids suggesting how to fix the problem
- **NOT dependent on execution order** — can run independently or be revisited
- **NOT a tool-specific operation** — focuses on reasoning, not execution
- **NOT orchestration logic** — does not manage other Steps or control flow

## Conceptual Guidance

### Typical Inputs
- User-described pain points or frustrations
- Symptoms observed in current systems or processes
- Stakeholder requests or feature ideas (to extract underlying problems)
- Existing context: previous attempts, related issues, constraints

### Typical Outputs
- **Problem statement**: A 1-3 sentence description of what is wrong
- **Context**: Who is affected, when/where the problem occurs, impact scope
- **Why it matters**: Business, user, or technical consequences of not solving it

### Relationship to Other Steps
- **Precedes:** Goal & Success Definition (problems lead to goals)
- **May trigger:** Constraints & Assumptions Identification (if problem reveals new constraints)
- **Informed by:** Context Assembly (if existing knowledge clarifies the problem)

### Common Patterns
- **Symptom vs. root cause**: Frame the underlying issue, not just surface symptoms
- **Multiple stakeholders**: Synthesize different perspectives into a shared problem statement
- **Solution disguised as problem**: Reframe "we need feature X" as "users can't accomplish Y"
