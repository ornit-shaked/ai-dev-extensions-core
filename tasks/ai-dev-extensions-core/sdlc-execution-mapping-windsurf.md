# SDLC Execution Mapping — Windsurf Phase 1

> **Source:** `sdlc-domain-design.md` (canonical SDLC Domain Design — ontology authority)
> **Target:** Windsurf IDE
> **Scope:** Phase 1 Flows only
> **Status:** Mapping document (not runnable code)

---

## A. Purpose & Scope

This document maps the canonical SDLC ontology to Windsurf-specific execution artifacts for Phase 1.

When to use this file?
1. Implementation of phase 1
2. When need to add new flow
3. When want to supportdifferent tool then Windsurf.

### A.1 What This Document Is

- **Execution mapping** — translates conceptual Steps and Flows into Windsurf content types
- **Phase 1 only** — covers 5 Flows and 11 Steps
- **Ontology-preserving** — no Step or Flow definitions are altered
- **Tool-specific** — realizes the ontology for Windsurf IDE

### A.2 What This Document Is NOT

- Not runnable code or final UX
- Not governance or approval logic
- Not a change to the ontology
- Not a comprehensive implementation plan

### A.3 Relationship to Domain Design

The SDLC Domain Design defines **what** Steps and Flows are conceptually.

This document defines **how** they are realized in Windsurf for Phase 1.

> All ontology questions defer to the Domain Design.
> All execution questions defer to this mapping.

---

### A.4 Implementation Decision (Updated 2026-04-19)

**Decision:** Unified Skills Architecture with Markdown Format

After design review, we refined the execution mapping to eliminate duplication while preserving existing content structure:

#### Original Plan:
- Steps → Separate directory (`steps/`) with `.md` files
- Flows → Separate directory (`flows/`) with `.md` files  
- Skills → Third directory wrapping Steps/Flows

**Problem:** Information duplication (same definitions in multiple places)

#### Revised Implementation:
**All Steps and Flows are realized as Windsurf Skills in a unified directory**

**Structure:**
```
domains/sdlc/
└── skills/
    ├── step-problem-framing.md
    ├── step-goal-definition.md
    ├── step-context-assembly.md
    ├── step-artifact-validation.md
    ├── ...
    ├── flow-create-prd.md
    ├── flow-technical-planning.md
    ├── flow-prepare-implementation.md
    └── flow-generate-tasks.md
```

**File Format:** Markdown with YAML frontmatter (`.md`) - same as existing Steps/Flows

**Naming Convention:**
- `step-{name}.md` — Atomic skills (Steps)
- `flow-{name}.md` — Composite skills (Flows)

**Rationale:**
1. **No duplication** — Single source of truth (prompt + metadata in one file)
2. **Preserves content** — Keep existing `.md` format with YAML frontmatter
3. **Windsurf-compatible** — Skills directory with markdown support
4. **Visual separation** — Prefix-based naming for clarity
5. **Simpler** — One directory, familiar format

**Skill Type Distinction:**
- Atomic skills (`step-*`) contain `prompt` field in frontmatter
- Composite skills (`flow-*`) contain `recommended_steps` array in frontmatter
- Type field in frontmatter: `type: "atomic"` or `type: "composite"`

**Ontology Preservation:**
The conceptual distinction between Steps (atomic units) and Flows (goal-oriented compositions) from the SDLC Domain Design remains unchanged. This is purely an execution layer simplification.

**Config Change:** `config/ide-mapping.yaml` updated to support `.md` files for skills.

---

## B. Phase 1 Flow Overview

| # | Flow | Goal | Entry Command |
|---|------|------|---------------|
| 1 | **Create PRD** | Produce a clear, pre-implementation Product Requirements Document | `/create-prd` |
| 2 | **Technical Planning** | Translate decisions into an implementation plan and task breakdown | `/technical-planning` |
| 3 | **Prepare for Implementation** | Ensure all prerequisites for implementation are in place | `/prepare-implementation` |
| 4 | **Generate Tasks** | Produce a structured, actionable task list from existing definitions | `/generate-tasks` |
| 5 | **PR Review** | Assess and improve a proposed change before merge | `/pr-review` |

---

## C. Step Realization Matrix

The following table maps each Step used in Phase 1 to a Windsurf realization type.

**Important:** "Realization" indicates **how the Step is orchestrated** in Windsurf, not where the prompt lives.
- **Prompt text is always in the Step file** (`domains/sdlc/skills/step-*.md`) — tool-agnostic
- **Orchestration varies by realization type:**
  - **Prompt** = Single-turn execution (invoke Step directly)
  - **Workflow** = Multi-turn orchestration (human gates, iteration)
  - **Skill** = Reusable wrapper (invoked by multiple Flows)

| # | Step | Default Intent | Realization | Rationale |
|---|------|---------------|-------------|-----------|
| 1 | Problem Framing | agent-assisted | **Workflow** | Multi-turn interaction: agent drafts, human clarifies, agent refines. Requires iteration. |
| 2 | Goal & Success Definition | agent-assisted | **Prompt** | Single reasoning task with structured output. Agent proposes, human confirms. |
| 3 | Constraints & Assumptions Identification | agent-assisted | **Prompt** | Single analysis task. Agent surfaces candidates from context. |
| 4 | Context Assembly | agent-executed | **Skill** | Reusable, side-effect-free capability. Reads artifacts, codebase, architecture docs. Can be invoked by multiple Flows. |
| 5 | Option Generation | agent-assisted | **Prompt** | Single creative reasoning task. Agent generates alternatives. |
| 6 | Option Evaluation & Decision | human-led | **Workflow** | Multi-turn structured comparison. Agent provides trade-off matrix, human makes decision. Requires back-and-forth. |
| 7 | Plan & Decomposition | agent-assisted | **Prompt** | Single decomposition task with structured output (ordered work units). |
| 8 | Specification / Contract Definition | agent-assisted | **Workflow** | Multi-section drafting with human review per section. Iterative refinement of interfaces, boundaries, acceptance criteria. |
| 9 | Artifact Validation | agent-executed | **Skill** | Reusable validation capability. Checks compliance against specs. Invoked by multiple Flows. |
| 10 | Readiness Assessment | agent-assisted | **Prompt** | Single assessment task with gap analysis and recommendations. |
| 11 | Learning & Improvement | human-led | **Prompt** | Proposes improvements for human review. Single output, human decides adoption. |

### Realization Type Distribution

- **Prompts:** 6 Steps (Goals, Constraints, Options, Plan, Readiness, Learning)
- **Workflows:** 3 Steps (Problem Framing, Option Evaluation, Specification)
- **Skills:** 2 Steps (Context Assembly, Artifact Validation)

### Realization Type Decision Rules

**Prompt** — Preferred by default:
- Single-turn reasoning or drafting
- Structured output with clear inputs
- No multi-turn iteration required

**Workflow** — When iteration is essential:
- Multi-turn interaction with human feedback
- Guided composition of multiple prompts
- Stepwise refinement (e.g., section-by-section drafting)

**Skill** — For reusable capabilities:
- Side-effect-free operations (reading, validation, analysis)
- Invoked by multiple Flows
- No direct human interaction during execution

---

## D. Flow-by-Flow Execution Mapping

### D.1 Create PRD

**Entry Command:** `/create-prd`

**Goal:** Produce a clear, pre-implementation Product Requirements Document.

**Expected Outcome:** A PRD defining scope, goals, requirements, non-goals, and success criteria.

#### Steps Involved

| Order | Step | Realization | Intent | Notes |
|-------|------|-------------|--------|-------|
| 1 | Problem Framing | Workflow | agent-assisted | Multi-turn: agent drafts problem statement, human clarifies context, agent refines. |
| 2 | Goal & Success Definition | Prompt | agent-assisted | Agent proposes success criteria based on problem framing. Human confirms alignment. |
| 3 | Constraints & Assumptions Identification | Prompt | agent-assisted | Agent surfaces constraints from context (technical, org, regulatory). Human validates. |
| 4 | Context Assembly | Skill | agent-executed | Agent reads existing artifacts (architecture docs, specs, codebase). Surfaces gaps. |
| 5 | Option Generation | Prompt | agent-assisted | Agent generates solution alternatives. Human adds domain-specific options. |
| 6 | Option Evaluation & Decision | Workflow | human-led | Multi-turn: agent provides trade-off matrix, human makes decision with rationale. |
| 7 | Specification / Contract Definition | Workflow | agent-assisted | Multi-section drafting: agent drafts PRD sections, human reviews and approves each. |

#### Human Gates

- **After Problem Framing:** Human validates problem definition before proceeding.
- **After Option Evaluation:** Human makes final decision on chosen approach.
- **During Specification:** Human reviews and approves each PRD section (scope, requirements, non-goals, etc.).

#### Execution Notes

- Context Assembly runs early to surface missing information.
- Option Evaluation may be skipped if the solution approach is already decided.
- Specification workflow produces PRD in sections: Problem, Goals, Requirements, Non-Goals, Success Criteria.

---

### D.2 Technical Planning

**Entry Command:** `/technical-planning`

**Goal:** Translate decisions into an implementation plan and task breakdown.

**Expected Outcome:** A plan with ordered work units, dependencies, and estimates.

#### Steps Involved

| Order | Step | Realization | Intent | Notes |
|-------|------|-------------|--------|-------|
| 1 | Context Assembly | Skill | agent-executed | Agent reads PRD, architecture decisions, existing specs. Identifies planning prerequisites. |
| 2 | Plan & Decomposition | Prompt | agent-assisted | Agent proposes work breakdown with dependencies. Human validates scope and granularity. |
| 3 | Specification / Contract Definition | Workflow | agent-assisted | Agent drafts task specifications with acceptance criteria. Human reviews. |
| *opt* | Constraints & Assumptions Identification | Prompt | agent-assisted | Optional: if new constraints emerge during planning. |
| *opt* | Readiness Assessment | Prompt | agent-assisted | Optional: verify planning prerequisites are sufficient. |

#### Human Gates

- **After Context Assembly:** Human confirms sufficient context to plan (or requests additional intake).
- **After Plan & Decomposition:** Human validates work breakdown and dependencies before task spec generation.

#### Execution Notes

- Requires existing decisions as input (PRD, architecture).
- Context Assembly surfaces gaps early (missing architecture, unclear requirements).
- Plan & Decomposition produces ordered work units; Specification defines acceptance criteria per unit.

---

### D.3 Prepare for Implementation

**Entry Command:** `/prepare-implementation`

**Goal:** Ensure all prerequisites for implementation are in place.

**Expected Outcome:** Confirmation that specs, designs, tasks, and context are sufficient to begin coding.

#### Steps Involved

| Order | Step | Realization | Intent | Notes |
|-------|------|-------------|--------|-------|
| 1 | Context Assembly | Skill | agent-executed | Agent reads all available artifacts (PRD, architecture, tasks, specs). |
| 2 | Readiness Assessment | Prompt | agent-assisted | Agent produces readiness report: ready/not-ready with gaps, risks, recommendations. Human makes go/no-go decision. |
| *opt* | Artifact Validation | Skill | agent-executed | Optional: validate existing artifacts against specs before starting. |

#### Human Gates

- **After Readiness Assessment:** Human makes go/no-go decision based on assessment report.

#### Execution Notes

- Lightweight Flow — runs right before coding starts.
- Surfaces gaps early rather than discovering them mid-implementation.
- If not ready: identifies missing artifacts or unclear specs; suggests intake or clarification.

---

### D.4 Generate Tasks

**Entry Command:** `/generate-tasks`

**Goal:** Produce a structured, actionable task list from existing definitions.

**Expected Outcome:** A set of implementable tasks with acceptance criteria, dependencies, and estimates.

#### Steps Involved

| Order | Step | Realization | Intent | Notes |
|-------|------|-------------|--------|-------|
| 1 | Context Assembly | Skill | agent-executed | Agent reads existing specs, plans, PRD. |
| 2 | Plan & Decomposition | Prompt | agent-assisted | Agent proposes task breakdown. Human validates granularity. |
| 3 | Specification / Contract Definition | Workflow | agent-assisted | Agent drafts task specs with acceptance criteria. Human reviews. |
| *opt* | Readiness Assessment | Prompt | agent-assisted | Optional: verify task completeness before submission. |

#### Human Gates

- **After Plan & Decomposition:** Human validates task breakdown before specs are generated.
- **After Specification:** Human reviews task acceptance criteria.

#### Execution Notes

- Similar to Technical Planning but more focused on task-level detail.
- Requires existing specs or plans as input.
- Output: actionable tasks ready for backlog or sprint.

---

### D.5 PR Review

**Entry Command:** `/pr-review`

**Goal:** Assess and improve a proposed change before merge.

**Expected Outcome:** Review assessment: approval, requested changes, or identified issues.

#### Steps Involved

| Order | Step | Realization | Intent | Notes |
|-------|------|-------------|--------|-------|
| 1 | Context Assembly | Skill | agent-executed | Agent reads PR diff, related specs, architecture context, existing tests. |
| 2 | Artifact Validation | Skill | agent-executed | Agent validates code against specs, architecture contracts, coding standards. |
| 3 | Readiness Assessment | Prompt | agent-assisted | Agent produces review report: approval/changes/issues. Human makes final approval decision. |
| *opt* | Learning & Improvement | Prompt | human-led | Optional: if review reveals process improvements or knowledge gaps. |

#### Human Gates

- **After Readiness Assessment:** Human makes final approval/rejection decision.
- **If Learning triggered:** Human decides which improvements to adopt.

#### Execution Notes

- Context Assembly reads specs and architecture to validate alignment.
- Artifact Validation checks: spec compliance, architecture conformance, test coverage, code quality.
- Readiness Assessment summarizes findings and recommends approval/changes.
- Learning & Improvement triggered if review reveals systemic issues (not just PR-specific).

---

## E. Non-Goals

This mapping does **NOT**:

- Define runnable code or final UX
- Specify file paths, directory structures, or schemas
- Define orchestration or execution engines
- Assume specific prompt templates or skill implementations
- Enforce governance or approval workflows
- Replace human judgment or decision-making

---

## F. Open Questions for Phase 2

The following questions are deferred to Phase 2 or later:

1. **Artifact storage:** Where do PRDs, plans, and specs produced by these Flows live in the host project?
2. **Step file structure:** What is the concrete format for Step definitions (YAML frontmatter, markdown, etc.)?
3. **Skill implementation:** How are Context Assembly and Artifact Validation implemented as reusable skills?
4. **Workflow templates:** What are the concrete prompt sequences for multi-turn Workflows?
5. **Human gate UX:** How are human gates surfaced in the IDE (notifications, approvals, etc.)?
6. **Cross-domain artifact paths:** How are configurable artifact paths resolved at runtime?

---

## G. Validation Checklist

Before accepting this mapping:

- [ ] All Phase 1 Flows present (Create PRD, Technical Planning, Prepare for Implementation, Generate Tasks, PR Review)
- [ ] All Steps trace back to Domain Design Step Catalog (C.1–C.13)
- [ ] No Step or Flow definitions altered
- [ ] Realization types follow decision rules (Prompt by default, Workflow for iteration, Skill for reuse)
- [ ] Execution Intent alignment respected (human-led, agent-assisted, agent-executed)
- [ ] Human gates identified and described conceptually
- [ ] No file paths, schemas, or implementation details

---

## Closing Statement

> **This document maps SDLC ontology to Windsurf execution for Phase 1 only.**
>
> **Changes to ontology must be made in the SDLC Domain Design.**
>
> This mapping is a design artifact, not a specification for implementation. Concrete prompt templates, skill implementations, and workflow sequences will be defined in subsequent work.
