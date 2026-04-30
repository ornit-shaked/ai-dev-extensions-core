# SDLC Domain Design — Canonical Reference

> **Status:** Frozen design artifact — ontology-first, execution-agnostic.
> **Source of truth:** `sdlc_thinking_stage_1.docx` (canonical SDLC ontology).
> **Scope:** Conceptual model only. No implementation, no file structures, no workflow files.

## How to Read This Document

This document defines the SDLC ontology.
It is not a process, not a pipeline, and not an execution guide.
All implementation artifacts must conform to this model, not redefine it.

---

## A. Vision & Definitions

### A.1 Vision — SDLC as a Package (Not an Orchestrator)

The SDLC Package is an independent, self-contained, tool-agnostic package that defines the core concepts, structure, and building blocks required for an agent-compatible software development lifecycle.

It is **not** an orchestrator. It does not describe, assume, or depend on orchestration systems.

> *"Users think in goals. Systems think in steps. Flows translate between them."*

The package supplies a curated set of:

- **Steps** — atomic, runnable units of thinking or work 
- **Flows** — goal-oriented, user-facing compositions of Steps
- **Execution** — the executable layer (execution layer, not ontology) can be implemented in various ways (prompts, workflows, skills, scripts)

### A.2 Separation of Concerns

| Layer | Purpose | Stability |
|-------|---------|-----------|
| **Steps** | Atomic, reusable skills. Canonical building blocks designed for correctness, reuse, and long-term maintainability. | High — changes rarely. |
| **Flows** | Composite skills orchestrating Steps. User-facing skills that allow users (or agents) to work in terms of goals. | High — goals are stable. |
| **Execution** | How Skills are realized and deployed (Markdown + frontmatter, symlinked to IDE). | Low — evolves per tool. |

This separation allows the package to:

- Remain stable as internal logic evolves
- Offer a natural, guided experience to users
- Support both human-initiated and agent-initiated goals
- Be adopted incrementally, without enforcing pipelines or governance

### A.3 Design Principles

1. **Right-Sized Rigor** — Rigor is available, not mandatory. Not every problem requires the same level of analysis. The package allows partial execution, skipped Steps, or lightweight reasoning when the goal and risk level permit it.

2. **Contextual Completeness** — Completeness is contextual, not absolute. A Flow or Step is sufficiently complete when it provides enough information to safely progress — not when all possible information has been collected.

3. **Adaptive Guidance, Not Rigid Processes** — Flows guide thinking; they do not enforce execution. A Flow describes what may be relevant and which Steps are commonly useful, without implying mandatory execution of all Steps, a fixed order, or a checklist-style process.

### A.4 Canonical Definition of a Step

A Step is:

- A unit of thinking or work
- Runnable independently
- Defined by: **Input**, **Output**, **Status** (`complete` | `needs-human`)
- Not dependent on time
- Not dependent on a pipeline

A Step may contain: Prompts, Workflows, Skills, Local rules (execution logic).

A Step is **NOT**:

- A Gate
- An Approval
- Ownership
- Policy
- Risk acceptance
- "Allowed / forbidden" decisions

All of the above are cross-cutting constructs and intentionally excluded from the Step definition.

**Hard constraints:**

- Each Step has a single, invariant semantic responsibility — it does exactly one thing regardless of context.
- If a Step would behave differently across Flows, it must be split into separate Steps.
- A Step must not contain orchestration logic or flow awareness.
- Steps are named by their semantic responsibility, not by when they run.
- Model clarity and long-term stability take priority over brevity.

### A.5 Step Taxonomy (Tags)

Each Step is tagged with one (or more) of the following:

| Tag | Meaning |
|-----|---------|
| **Thinking** | Understanding, ideation, decision-making |
| **Contracting** | Defining boundaries and obligations |
| **Validation** | Checking alignment and correctness |
| **Learning** | Feedback, analysis, and improvement |

Tags are classification metadata, not time-based phases.

### A.6 Canonical Definition of a Flow

A Flow is a goal-oriented, user-facing composite skill that guides a user toward a concrete outcome by orchestrating multiple Step skills. A Flow is an executable skill that composes and runs other skills.

> *A Flow answers the question: "What needs to happen to achieve this goal?"*

A Flow is defined by:

| Element | Description |
|---------|-------------|
| **Flow Goal** | The outcome the user is trying to achieve. |
| **Expected Outcome** | The concrete result produced by completing the Flow. |
| **Recommended Steps** | A set of canonical Steps that are typically required to achieve the goal. |
| **Optional / Conditional Steps** | Steps that may be skipped, repeated, or included based on context. |
| **User Guidance** | High-level explanation of what the Flow is doing, why each Step matters, and what information is still missing. |

**A Flow is descriptive, not prescriptive.**

A Flow is **NOT**:

- A pipeline
- A mandatory sequence
- An approval or governance mechanism
- A runtime or execution engine
- A definition of ownership or responsibility

A Flow does **NOT**:

- Enforce strict ordering
- Manage state or retries
- Encode execution logic
- Assume a specific tool or platform

### A.7 Conceptual Model vs. Execution Model

This distinction is critical to prevent incorrect tool-specific assumptions.

**Conceptual Constructs (Ontology):**

- **Step** — A semantic unit of thinking or work. Represents *what* needs to be reasoned about or produced, not *how* it is implemented.
- **Flow** — A goal-oriented composition of Steps. Defines conceptual relationships and guidance, not execution mechanics.

These constructs are stable, tool-agnostic, and intentionally abstract.

**Execution Constructs (Implementation Strategies):**

Conceptual constructs may be realized through different execution mechanisms:

- Skills
- Workflows
- Scripts
- Agent capabilities/Prompts file - but for now we wiill focus on what can be execute by windsurf.

These are implementation strategies, **not** conceptual entities. Skills and workflows are not part of the SDLC ontology. They are possible realizations of Steps or Flows in a specific tool, but will be part of the package.

**Interpretation Contract for AI Systems:**

When consumed by an AI system (e.g. an IDE agent or orchestrator):

- Do not infer execution semantics unless explicitly defined
- Do not assume a specific runtime, file structure, or orchestration model
- Treat Steps and Flows as logical guidance, not executable pipelines

> *The SDLC Package defines how to think, not how to run.*

---

## B. Conceptual Contracts

Three constructs form the SDLC ontology. Each is defined as a **conceptual contract** — no file format, no workflow mapping, no tool assumptions.

### B.1 Step (Conceptual Contract)

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Canonical name (from source §5). Immutable identifier. |
| `semantic_responsibility` | string | Single sentence, invariant across all Flows. |
| `input` | conceptual | What the Step needs to reason (not file paths — concepts, knowledge, context). |
| `output` | conceptual | What the Step produces (artifact, decision, assessment — not file format). |
| `status` | enum | `complete` \| `needs-human` |
| `tag` | enum | `Thinking` \| `Contracting` \| `Validation` \| `Learning` |

### B.2 Flow (Conceptual Contract)

| Field | Type | Description |
|-------|------|-------------|
| `goal` | string | The outcome the user is trying to achieve. |
| `expected_outcome` | string | The concrete result produced by completing the Flow. |
| `recommended_steps` | set of Step names | Canonical Steps typically needed. **Set, not sequence.** |
| `optional_steps` | set of Step names | Steps that may be skipped, repeated, or included based on context. |
| `user_guidance` | string | High-level explanation: what the Flow does, why each Step matters, what's missing. |

### B.3 Execution Intent (Conceptual — Not Implementation)

Captures **how a Step or Flow is intended to be realized**, without binding to any tool or mechanism.

| Intent Level | Meaning | Human Role | Agent Role |
|-------------|---------|------------|------------|
| `human-led` | Human performs the reasoning; agent provides structure and prompts only. | Primary executor | Scaffolding, templates, checklists |
| `agent-assisted` | Agent drafts output; human reviews, edits, and approves. | Reviewer, editor | Drafts, suggests, assembles |
| `agent-executed` | Agent performs end-to-end; human gates control progression. | Gate approver | Full execution within gate boundaries |

Execution Intent expresses desired autonomy.
Concrete realization (workflows, skills, rules) is defined in a separate Execution Mapping laye

**Constraints:**

- Execution Intent is a **classification label**, not an implementation contract.
- It does NOT define: which tool, which file, which workflow engine, or which prompt.
- Intent may vary per Step within a Flow (e.g., "Context Assembly" = agent-executed, "Option Evaluation & Decision" = agent-assisted).
- Intent may vary per project maturity (new project = more human-led; mature = more agent-executed).
- Gates in `agent-executed` are conceptual checkpoints, not governance mechanisms.

---

## C. Canonical Step Catalog

The following is the canonical list of Steps — intentionally independent of any feature, project, or technology.

### Thinking (7 Steps)

#### C.1 Problem Framing

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Formulates the problem, context, and pain being addressed — without proposing solutions. |
| **Input** | User-described situation, symptoms, or pain points; existing context if available. |
| **Output** | A clear problem statement: what is wrong, who is affected, why it matters. |
| **Status** | `complete` — problem is clearly articulated. `needs-human` — ambiguity remains, multiple interpretations possible. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-assisted` — agent drafts framing, human validates problem definition. |

#### C.2 Goal & Success Definition

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Defines what success means and how it is measured. |
| **Input** | Problem statement (from Problem Framing); stakeholder expectations. |
| **Output** | Success criteria, measurable outcomes, definition of done. |
| **Status** | `complete` — success criteria are clear and measurable. `needs-human` — criteria require stakeholder alignment. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-assisted` — agent proposes criteria, human confirms alignment. |

#### C.3 Constraints & Assumptions Identification

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Identifies constraints, assumptions, and operational boundaries. |
| **Input** | Problem statement, goals, existing context (technical, organizational, regulatory). |
| **Output** | Explicit list of constraints (hard limits) and assumptions (beliefs to validate). |
| **Status** | `complete` — constraints and assumptions are documented. `needs-human` — assumptions need validation or constraints are unclear. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-assisted` — agent surfaces candidates, human validates. |

#### C.4 Context Assembly

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Collects and consolidates all relevant existing knowledge. |
| **Input** | Problem scope, goals, constraints; pointers to existing artifacts (architecture docs, specs, codebase). |
| **Output** | Consolidated context summary: what is known, what is missing, what is uncertain. |
| **Status** | `complete` — sufficient context assembled to proceed. `needs-human` — critical knowledge gaps identified. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-executed` — agent reads and assembles; human gates if gaps are critical. |

#### C.5 Option Generation

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Produces possible solution alternatives. |
| **Input** | Problem statement, goals, constraints, assembled context. |
| **Output** | A set of distinct solution alternatives with brief descriptions. |
| **Status** | `complete` — meaningful alternatives generated. `needs-human` — domain expertise needed for viable options. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-assisted` — agent generates options, human adds domain-specific alternatives. |

#### C.6 Option Evaluation & Decision

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Compares alternatives and arrives at a reasoned decision. |
| **Input** | Solution alternatives, evaluation criteria (from goals/constraints). |
| **Output** | Reasoned decision with trade-off analysis and rationale. |
| **Status** | `complete` — decision made with documented rationale. `needs-human` — trade-offs require human judgment. |
| **Tag** | Thinking |
| **Default Execution Intent** | `human-led` — human makes the decision; agent provides structured comparison. |

#### C.7 Plan & Decomposition

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Breaks decisions into logical, actionable units of work. |
| **Input** | Chosen solution, constraints, available context. |
| **Output** | Ordered set of work units (tasks, milestones, or deliverables) with dependencies. |
| **Status** | `complete` — plan is actionable and decomposed. `needs-human` — decomposition granularity or dependencies unclear. |
| **Tag** | Thinking |
| **Default Execution Intent** | `agent-assisted` — agent proposes decomposition, human validates scope and order. |

### Contracting (1 Step)

#### C.8 Specification / Contract Definition

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Defines contracts, interfaces, boundaries, and required behaviors. |
| **Input** | Decisions, plan, constraints, relevant domain context. |
| **Output** | Formal or semi-formal specification: interfaces, boundaries, acceptance criteria, behavioral expectations. |
| **Status** | `complete` — specification is reviewable and testable. `needs-human` — ambiguities in scope or interface. |
| **Tag** | Contracting |
| **Default Execution Intent** | `agent-assisted` — agent drafts specification, human reviews and approves. |

### Validation (2 Steps)

#### C.9 Artifact Validation

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Verifies that produced artifacts comply with specifications and decisions. |
| **Input** | Artifact(s) to validate, applicable specifications/contracts/decisions. |
| **Output** | Validation report: compliant / non-compliant, with specific findings. |
| **Status** | `complete` — validation performed, results clear. `needs-human` — findings require human interpretation. |
| **Tag** | Validation |
| **Default Execution Intent** | `agent-executed` — agent validates against spec; human gates on non-compliant findings. |

#### C.10 Readiness Assessment

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Assesses whether the current state is ready to progress, highlighting gaps and risks. |
| **Input** | Current state of artifacts, specifications, and context; criteria for progression. |
| **Output** | Readiness report: ready / not-ready, with gaps, risks, and recommendations. |
| **Status** | `complete` — assessment performed. `needs-human` — readiness decision requires human judgment. |
| **Tag** | Validation |
| **Default Execution Intent** | `agent-assisted` — agent assembles readiness evidence, human makes go/no-go decision. |

### Learning (3 Steps)

#### C.11 Observation & Monitoring

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Collects real-world behavior and operational data. |
| **Input** | System or process under observation; metrics or signals to collect. |
| **Output** | Collected observations, measurements, or behavioral data. |
| **Status** | `complete` — observations collected. `needs-human` — anomalies detected requiring interpretation. |
| **Tag** | Learning |
| **Default Execution Intent** | `agent-executed` — agent collects data; human gates on anomalies. |

#### C.12 Incident / Deviation Analysis

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Analyzes failures, deviations, or mismatches between expectation and reality. |
| **Input** | Observed deviation or incident; expected behavior; relevant context. |
| **Output** | Root cause analysis, contributing factors, impact assessment. |
| **Status** | `complete` — analysis performed with findings. `needs-human` — root cause ambiguous or requires domain expertise. |
| **Tag** | Learning |
| **Default Execution Intent** | `agent-assisted` — agent assembles evidence and proposes root cause, human validates. |

#### C.13 Learning & Improvement

| Field | Value |
|-------|-------|
| **Semantic Responsibility** | Distills insights and updates knowledge, assumptions, contracts, or future Steps. |
| **Input** | Analysis results, observations, historical patterns. |
| **Output** | Actionable improvements: updated assumptions, revised contracts, process changes, knowledge base updates. |
| **Status** | `complete` — improvements documented. `needs-human` — proposed changes require review before adoption. |
| **Tag** | Learning |
| **Default Execution Intent** | `human-led` — human decides which improvements to adopt; agent proposes candidates. |

---

## D. Canonical Flow Catalog

All 13 Flows are listed below. Each Flow is **descriptive, not prescriptive** — recommended Steps are a set, not a mandatory sequence.

### Discovery & Definition Flows

#### D.1 Problem Definition

| Field | Value |
|-------|-------|
| **Goal** | Clarify and frame a problem worth solving. |
| **Expected Outcome** | A clear, shared problem statement with context and impact. |
| **Recommended Steps** | Problem Framing, Goal & Success Definition, Constraints & Assumptions Identification, Context Assembly |
| **Optional Steps** | Option Generation (if exploring whether the problem is solvable) |
| **User Guidance** | Start here when the problem is unclear or not yet articulated. Focus on understanding before solving. |

#### D.2 Create PRD

| Field | Value |
|-------|-------|
| **Goal** | Produce a clear, pre-implementation Product Requirements Document. |
| **Expected Outcome** | A PRD defining scope, goals, requirements, non-goals, and success criteria. |
| **Recommended Steps** | Problem Framing, Goal & Success Definition, Constraints & Assumptions Identification, Context Assembly, Option Generation, Option Evaluation & Decision, Specification / Contract Definition |
| **Optional Steps** | — (all recommended Steps are typically relevant for a full PRD) |
| **User Guidance** | Use before architecture or implementation begins. This Flow produces the "what" — not the "how." |

#### D.3 Define Epic

| Field | Value |
|-------|-------|
| **Goal** | Create a shared, actionable definition for a large feature or initiative. |
| **Expected Outcome** | An epic definition: scope, goals, boundaries, decomposed into workable chunks. |
| **Recommended Steps** | Problem Framing, Goal & Success Definition, Constraints & Assumptions Identification, Context Assembly, Plan & Decomposition, Specification / Contract Definition |
| **Optional Steps** | Option Generation, Option Evaluation & Decision (if multiple approaches are viable) |
| **User Guidance** | Use for cross-team planning and roadmap alignment. Focus on boundaries and decomposition. |

### Design & Planning Flows

#### D.4 Architecture & Design Definition

| Field | Value |
|-------|-------|
| **Goal** | Define system architecture, boundaries, and design decisions. |
| **Expected Outcome** | Architecture documentation: component boundaries, contracts, design decisions with rationale. |
| **Recommended Steps** | Context Assembly, Constraints & Assumptions Identification, Option Generation, Option Evaluation & Decision, Specification / Contract Definition |
| **Optional Steps** | Problem Framing (if the architectural challenge is not yet well-defined) |
| **User Guidance** | Use before implementation of complex or cross-cutting features. Consumes existing architecture artifacts if available. |

#### D.5 Technical Planning

| Field | Value |
|-------|-------|
| **Goal** | Translate decisions into an implementation plan and task breakdown. |
| **Expected Outcome** | A plan with ordered work units, dependencies, and estimates. |
| **Recommended Steps** | Context Assembly, Plan & Decomposition, Specification / Contract Definition |
| **Optional Steps** | Constraints & Assumptions Identification (if new constraints emerge), Readiness Assessment (to verify planning prerequisites) |
| **User Guidance** | Use for sprint planning or development kickoff. Requires existing decisions (PRD, architecture) as input. |

### Implementation Flows

#### D.6 Prepare for Implementation

| Field | Value |
|-------|-------|
| **Goal** | Ensure all prerequisites for implementation are in place. |
| **Expected Outcome** | Confirmation that specs, designs, tasks, and context are sufficient to begin coding. |
| **Recommended Steps** | Context Assembly, Readiness Assessment |
| **Optional Steps** | Artifact Validation (if existing artifacts need compliance check before starting) |
| **User Guidance** | Use right before coding starts. Surfaces gaps early rather than discovering them mid-implementation. |

#### D.7 Generate Tasks

| Field | Value |
|-------|-------|
| **Goal** | Produce a structured, actionable task list from existing definitions. |
| **Expected Outcome** | A set of implementable tasks with acceptance criteria, dependencies, and estimates. |
| **Recommended Steps** | Context Assembly, Plan & Decomposition, Specification / Contract Definition |
| **Optional Steps** | Readiness Assessment (to verify task completeness) |
| **User Guidance** | Use for story creation and backlog refinement. Requires existing specs or plans as input. |

### Review & Validation Flows

#### D.8 PR Review

| Field | Value |
|-------|-------|
| **Goal** | Assess and improve a proposed change before merge. |
| **Expected Outcome** | Review assessment: approval, requested changes, or identified issues. |
| **Recommended Steps** | Context Assembly, Artifact Validation, Readiness Assessment |
| **Optional Steps** | Learning & Improvement (if review reveals process improvements) |
| **User Guidance** | Use for code review, design review, or documentation review. Consumes specs and architecture context. |

#### D.9 Readiness Review

| Field | Value |
|-------|-------|
| **Goal** | Evaluate whether a feature or change is ready to progress. |
| **Expected Outcome** | Readiness report: go / no-go with gaps, risks, and recommendations. |
| **Recommended Steps** | Context Assembly, Artifact Validation, Readiness Assessment |
| **Optional Steps** | Constraints & Assumptions Identification (if new constraints surfaced) |
| **User Guidance** | Use for pre-merge, pre-release, or milestone checkpoints. Broader than PR Review — evaluates overall readiness. |

### Release & Operations Flows

#### D.10 Release Preparation

| Field | Value |
|-------|-------|
| **Goal** | Prepare documentation and artifacts for release. |
| **Expected Outcome** | Release-ready documentation, changelogs, deployment notes. |
| **Recommended Steps** | Context Assembly, Artifact Validation, Specification / Contract Definition |
| **Optional Steps** | Readiness Assessment (final go/no-go before release) |
| **User Guidance** | Use before deployment or customer delivery. Ensures all artifacts are complete and consistent. |

#### D.11 Incident Analysis

| Field | Value |
|-------|-------|
| **Goal** | Understand and analyze a failure or unexpected behavior. |
| **Expected Outcome** | Root cause analysis with contributing factors and recommended actions. |
| **Recommended Steps** | Context Assembly, Observation & Monitoring, Incident / Deviation Analysis |
| **Optional Steps** | Learning & Improvement (to feed insights back into the process) |
| **User Guidance** | Use post-incident or for production issues. Focus on understanding, not blame. |

### Learning & Improvement Flows

#### D.12 Post-Implementation Review

| Field | Value |
|-------|-------|
| **Goal** | Capture lessons learned and improvement opportunities. |
| **Expected Outcome** | Retrospective document: what worked, what didn't, actionable improvements. |
| **Recommended Steps** | Context Assembly, Observation & Monitoring, Learning & Improvement |
| **Optional Steps** | Incident / Deviation Analysis (if specific deviations occurred) |
| **User Guidance** | Use after delivery or major milestones. Focus on process and outcome quality, not individual performance. |

#### D.13 Continuous Improvement

| Field | Value |
|-------|-------|
| **Goal** | Iteratively improve processes, prompts, and definitions based on feedback. |
| **Expected Outcome** | Proposed improvements to Steps, Flows, prompts, or rules — requiring human review. |
| **Recommended Steps** | Observation & Monitoring, Learning & Improvement |
| **Optional Steps** | Incident / Deviation Analysis (if triggered by specific failures) |
| **User Guidance** | This Flow evolves the SDLC package itself, not the product being built. Feedback is collected from real usage. This Flow does not auto-modify anything; it produces proposed improvements that require human review. |

---

## E. Execution Intent Map

Default execution intent per Step. These are **starting positions** — projects may override based on maturity, risk, and team preference.

| # | Step | Default Intent | Rationale |
|---|------|---------------|-----------|
| 1 | Problem Framing | `agent-assisted` | Agent drafts framing; human validates problem definition |
| 2 | Goal & Success Definition | `agent-assisted` | Agent proposes criteria; human confirms alignment |
| 3 | Constraints & Assumptions Identification | `agent-assisted` | Agent surfaces candidates; human validates |
| 4 | Context Assembly | `agent-executed` | Agent reads and assembles; human gates if gaps are critical |
| 5 | Option Generation | `agent-assisted` | Agent generates options; human adds domain-specific alternatives |
| 6 | Option Evaluation & Decision | `human-led` | Human decides; agent provides structured comparison |
| 7 | Plan & Decomposition | `agent-assisted` | Agent proposes decomposition; human validates scope |
| 8 | Specification / Contract Definition | `agent-assisted` | Agent drafts specification; human reviews and approves |
| 9 | Artifact Validation | `agent-executed` | Agent validates against spec; human gates on non-compliant |
| 10 | Readiness Assessment | `agent-assisted` | Agent assembles evidence; human makes go/no-go |
| 11 | Observation & Monitoring | `agent-executed` | Agent collects data; human gates on anomalies |
| 12 | Incident / Deviation Analysis | `agent-assisted` | Agent proposes root cause; human validates |
| 13 | Learning & Improvement | `human-led` | Human decides which improvements to adopt |

**Distribution:** 2 human-led, 8 agent-assisted, 3 agent-executed.

---

## F. Cross-Domain Artifact Contract

### F.1 Domains as Independent Knowledge Providers

The SDLC Package coexists with other conceptual domains (e.g. Architecture, Security, Operations). Each domain produces artifacts, captures structured knowledge, and may evolve independently. The SDLC domain does not own these artifacts, but may consume them.

### F.2 Artifacts as First-Class Inputs

Artifacts produced by other domains (e.g. architecture documentation, contracts, diagrams) are treated as first-class inputs to SDLC Steps. Steps may:

- Read existing artifacts
- Reference their content
- Detect gaps or inconsistencies

Artifacts may exist before, during, or after SDLC Flows are executed. Their presence is **optional, not mandatory**.

### F.3 Missing Information Is a Valid State

The absence of artifacts or data is **not** an error. When required information is missing, a Step may:

- Ask the user for input
- Infer information from code or context
- Explicitly surface gaps or uncertainties

> *Completeness is contextual, not absolute.*

No execution order between domains is assumed or enforced.

### F.4 Architecture Domain Integration

The Architecture domain (already present in this package) produces structured documentation with:

- `_metadata.yaml` — index of section completeness and agent readiness
- `_open-issues.md` — items requiring human review
- Section files (e.g., `3-contracts.md`, `5-data-model.md`)

**Conceptual contract for SDLC ↔ Architecture:**

- SDLC Steps that need architecture context (e.g., Context Assembly) may consume architecture artifacts.
- The metadata index should be read first to assess availability and completeness.
- Missing architecture artifacts should be surfaced as gaps, not treated as errors.
- No fixed path is assumed — artifact locations are configurable (see section G).

---

## G. Artifact Materialization & Configurability

> **Status: OPEN DECISION** — this section documents the design intent and candidate options, not a final decision.

### G.1 Design Intent

The SDLC Package produces and reasons over artifacts. However:

- The exact directory structure for SDLC artifacts in the host project is **not yet finalized**.
- No single canonical path is assumed at this stage.

This is by design, to allow:

- Different project conventions
- Different maturity levels
- Incremental adoption

### G.2 Configurability as a Design Requirement

The SDLC Package explicitly requires:

- Configurable artifact storage locations in the host project
- Support for different project layouts and preferences
- No hardcoded paths in Steps or Flows
- Default behavior that is overridable by the host project

### G.3 Candidate Option: Unified Configuration File

*Harvested from PRD draft — presented as a candidate option, not a requirement.*

A single config file in the host project for all domains:

```yaml
# .dev-extensions.config.yaml (candidate pattern)
artifacts:
  base_path: "artifacts/"
  domains:
    architecture:
      path: "docs/architecture/"
      metadata_file: "_metadata.yaml"
    sdlc:
      path: "sdlc/"
      structure: "{flow-type}/{identifier}"
```

This pattern supports per-domain path overrides, cross-domain discovery via the same config, and default inheritance for new domains.

### G.4 Candidate Option: Tentative Directory Structure

*From source document — illustrative only, must not be assumed as final.*

```
artifacts/
  └── {domain-name}/
      └── {identifier}/
          └── outputs-of-flows-and-steps
```

### G.5 Interpretation Rules for AI Systems

- Do not assume a fixed artifact directory for the SDLC domain.
- Treat artifact storage as a design decision to be surfaced, not inferred.
- If artifact location is required and not defined: ask the user, propose options, or proceed with a temporary grouping without persistence.
- The absence of a defined target directory is not an error.

---

## H. Non-Goals / Boundaries

The SDLC Package does **NOT**:

- Define orchestration logic
- Enforce governance or approval processes
- Assume execution order between domains
- Replace existing tools (e.g., GitHub, CI/CD, issue trackers)

Its role is to **augment reasoning and structure**, not to centralize control.

> *The success of the SDLC Package is measured by improved clarity, safer decision-making, and reduced cognitive load — not by the number of executed steps or produced artifacts.*

---

## I. Open Decisions

| # | Decision | Status | Candidate Options | Notes |
|---|----------|--------|-------------------|-------|
| 1 | **Artifact storage location/structure** | `needs-human` | PRD's `artifacts/{domain}/{id}/` pattern; flat per-domain; per-flow grouping | See §G for candidate options |
| 2 | **Execution mapping (Steps/Flows → prompts/workflows/skills)** | `needs-human` | One prompt per Step; workflow per Flow; skill wrappers; mixed | Source §4.8: execution mapping is not ontology |
| 3 | **Step file/schema structure** | `needs-human` | YAML frontmatter + markdown; pure markdown; structured YAML | Source §6: "does not yet define the concrete file/schema structure" |
| 4 | **IDE deployment strategy** | `needs-human` | Current flatten mode; domain-specific overrides; new content types | Depends on decision #2 |
| 5 | **Phase 1 Flow selection** | `needs-human` | Proposed: Create PRD, Technical Planning, Prepare for Implementation, Generate Tasks, PR Review | See §D for full catalog |
| 6 | **Unified config file format** | `needs-human` | PRD's `.dev-extensions.config.yaml`; per-domain config; environment-based | See §G.3 for candidate |
| 7 | **Cross-domain discovery mechanism** | `needs-human` | Config-based path lookup; convention-based; metadata index scan | Conceptual contract in §F is stable; mechanism is open |

---

## J. Human Gate Checklist

Before accepting this document as frozen, verify:

- [ ] **Step Catalog completeness** — All 13 canonical Steps present with no additions or removals
- [ ] **Step identity** — No Step has been renamed, merged, or split beyond the source definition
- [ ] **Step semantics** — Each Step's semantic responsibility matches the source document exactly
- [ ] **Flow conceptual purity** — All Flows use recommended Steps (sets, not sequences); no pipeline notation
- [ ] **Flow completeness** — All 13 canonical Flows present
- [ ] **No execution mapping in ontology** — Steps/Flows are not mapped to file paths, workflows, or skills in this document
- [ ] **Cross-domain contract** — Architecture integration rules are consistent with existing `_metadata.yaml` pattern
- [ ] **Open decisions explicit** — All deferred decisions are listed in §I; none are silently assumed
- [ ] **Execution Intent** — Default intent map is reasonable; no binding to specific tools

---

## Appendix I: Open Decisions (Expanded)

### OD-1: Artifact Storage Location/Structure

**Context:** The SDLC domain will produce artifacts (specs, plans, analyses, reviews). Where do these live in the host project?

**Candidate options:**
1. **PRD pattern:** `artifacts/{domain}/{identifier}/` with configurable base path
2. **Flat per-domain:** `sdlc/` directory at project root
3. **Per-flow grouping:** `sdlc/{flow-name}/{identifier}/`
4. **Colocated with source:** artifacts live alongside the code they relate to

**Decision criteria:** Must support different project conventions, incremental adoption, and cross-domain discovery.

### OD-2: Execution Mapping Strategy

**Context:** How are conceptual Steps and Flows realized as executable content in the IDE?

**Candidate options:**
1. **One prompt per Step:** Each Step maps to a single prompt/asset file
2. **Workflow per Flow:** Each Flow maps to a workflow file that references Step prompts
3. **Skill wrappers:** Steps exposed as skills for agent discoverability
4. **Mixed:** Different content types for different purposes

**Decision criteria:** Must preserve conceptual/execution separation. Must work with existing `ide-mapping.yaml` and `domain-mapping.yaml` systems.

### OD-3: Step File/Schema Structure

**Context:** What is the concrete file format for a Step definition?

**Candidate options:**
1. **YAML frontmatter + markdown body:** Structured metadata + free-form prompt/guidance
2. **Pure markdown:** Lightweight, human-readable, IDE-friendly
3. **Structured YAML:** Machine-readable, suitable for tooling

**Decision criteria:** Must express all contract fields (name, responsibility, input, output, status, tag). Must be usable by both humans and AI systems.

### OD-4: IDE Deployment Strategy

**Context:** How does the SDLC domain content get deployed to IDEs (Windsurf, Cursor)?

**Depends on:** OD-2 (execution mapping).

**Current system:** Flatten mode copies individual files, symlinks `assets/` directories as `.assets-{domain}/` with per-workflow subdirectories for clear ownership.

### OD-5: Phase 1 Flow Selection

**Context:** Which Flows are implemented first to deliver a complete working cycle?

**Proposed Phase 1 (5 Flows):**

| Flow | Why |
|------|-----|
| Create PRD | Core starting point — defines what to build |
| Technical Planning | Translates PRD into plan and task breakdown |
| Prepare for Implementation | Ensures prerequisites before coding |
| Generate Tasks | Produces actionable task list |
| PR Review | Validates implementation quality |

**Alternative:** Swap PR Review for Readiness Review for broader validation.

### OD-6: Unified Config File Format

**Context:** How does the host project configure artifact paths and domain settings?

**Candidate:** `.dev-extensions.config.yaml` (see §G.3 for proposed structure).

### OD-7: Cross-Domain Discovery Mechanism

**Context:** How does the SDLC domain locate and read artifacts from other domains?

**Conceptual contract is stable** (§F). Mechanism options:
1. **Config-based:** Read path from config file
2. **Convention-based:** Use known directory patterns
3. **Metadata scan:** Search for `_metadata.yaml` files

---

## Appendix II: Harvest Report

### Sources

| Input | Role |
|-------|------|
| `sdlc_thinking_stage_1.docx` | Canonical ontology (authority) |
| `prd-ai-dev-extensions-core-sdlc.md` | Candidate material (harvest only) |

### Accepted As-Is

| PRD Section | Lines | Content |
|------------|-------|---------|
| §2 Step hard constraints | 22–29 | Single invariant responsibility, split if differs, no orchestration logic |
| §3 Flow hard constraints | 81–87 | Flows are conceptual and descriptive, not pipelines; recommended, not mandatory |

### Adapted

| PRD Section | Lines | Original | Adapted To | Why |
|------------|-------|----------|------------|-----|
| §4 Phase 1 Scope | 107–112 | "3 workflow flows + 11 execution steps" | Phase 1 = 5 canonical Flows (see OD-5) | Re-scoped to canonical Flow names; removed execution-level step counts |
| §5 Unified Configuration | 114–139 | `.dev-extensions.config.yaml` as requirement | Candidate option in §G.3 | Concept aligns with source §9.4; must not be presented as the only option |
| §6 Cross-Domain Discovery | 141–150 | 3-tier mechanism as requirement | Conceptual contract in §F + mechanism as OD-7 | Contract is sound; specific mechanism is implementation detail |

### Rejected

| PRD Section | Lines | Content | Reason | Risk If Kept |
|------------|-------|---------|--------|--------------|
| §1 Content-Type Mapping | 9–20 | Steps→`assets/steps/*.md`, Flows→`workflows/*.md` | Source §4.8: "Skills and workflows are not part of the SDLC ontology." Premature execution mapping. | Conflates conceptual and execution layers; makes ontology tool-dependent |
| §2 Steps Catalog | 31–79 | 17 execution-level steps (`analyze-codebase`, `load-prd`, `implement-task`…) | Replaces canonical 13 Steps with execution actions. Not the same ontology. | Identity drift; steps become I/O operations, not thinking units |
| §3 Phase 1 Flows | 89–96 | `sdlc-design-plan`, `sdlc-implement` with fixed sequences | Non-canonical flow names; fixed step sequences of execution-level steps | Flows become executable pipelines; violates §4.2 constraints |
| §3 Phase 2 Flows | 98–105 | `sdlc-review`, `sdlc-deploy`, etc. | Same issues as Phase 1 flows | Same risks |
| §7 _core Relationship | 152–154 | "SDLC `create-prd` Step evolves `_core` PRD workflow" | References non-canonical step name; conflates execution | Creates false dependency between ontology and execution |
| §8 Domain Structure | 156–188 | File layout: steps/, templates/, schemas/ | Source §6: "does not yet define the concrete file/schema structure" | Premature implementation; locks execution structure before design is stable |

### Remaining Questions (needs-human)

1. **Phase 1 Flow selection** — Proposed 5 Flows; awaiting confirmation.
2. **`source_of_truth.md` acceptance rules** — SharePoint link not accessible locally; harvest_analysis rules used instead. If additional rules exist, they should be incorporated.

---

## Freeze Statement

> **This document is the single source of truth for the SDLC domain design.**
>
> PRD drafts are inputs; they do not override this design.
>
> Any changes to the canonical Step or Flow definitions must be traced back to the source document (`sdlc_thinking_stage_1.docx`) and explicitly justified.
