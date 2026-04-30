# PRD Plan: SDLC Domain for ai-dev-extensions-core

Create a PRD for adding a first-class "sdlc" domain to the package, defining Steps/Flows mapping to content types, cross-domain architecture discovery, and configurable artifact storage.

---

## Key Design Decisions (need your confirmation)

### 1. Steps/Flows → Content Types Mapping

| Concept | Package Location | IDE Exposure | Purpose |
|---------|-----------------|--------------|---------|
| **Steps** | `skills/step-*.md` | Yes → `.windsurf/skills/` | Atomic, reusable smart prompts with input/output/status |
| **Flows** | `skills/flow-*.md` | Yes → `.windsurf/skills/` | Composite skills orchestrating Steps to achieve user goals |

**Implementation:** Steps and Flows are unified as skills in `domains/sdlc/skills/` using Markdown with YAML frontmatter. Flows reference Steps by name; the agent loads Step content from the skills directory. Steps are self-contained; Flows describe the user goal and which Steps are relevant, without prescribing mandatory execution order.

### 2. Step Ontology

**Hard constraints:**
- Each Step has a **single, invariant semantic responsibility** — it does exactly one thing regardless of context.
- If a Step would behave differently across Flows, it must be split into separate Steps.
- A Step must not contain orchestration logic or flow awareness.
- Steps are named by their semantic responsibility, not by when they run.
- Model clarity and long-term stability take priority over brevity.

#### Complete Steps Catalog

**Context Steps (Thinking — understanding):**

| # | Step | Invariant Semantic Responsibility | Type | Phase |
|---|------|----------------------------------|------|-------|
| 1 | `analyze-codebase` | Examine codebase structure, tech stack, patterns, and conventions. Output: codebase context summary. | **Thinking** | 1 |
| 2 | `load-architecture-context` | Read architecture metadata index (`_metadata.yaml`); load requested sections; report completeness status and gaps. Does not decide which sections are relevant — receives that as input. | **Thinking** | 1 |
| 3 | `load-prd` | Read an existing PRD for a feature. Output: requirements, scope, goals, non-goals. | **Thinking** | 1 |
| 4 | `load-technical-design` | Read an existing technical design for a feature. Output: approach, component impact, architecture decisions. | **Thinking** | 1 |
| 5 | `load-task` | Read a specific task's spec. Output: acceptance criteria, dependencies, constraints. | **Thinking** | 1 |

**Production Steps — Contracting (defining boundaries and obligations):**

| # | Step | Invariant Semantic Responsibility | Type | Phase |
|---|------|----------------------------------|------|-------|
| 6 | `create-prd` | Produce a PRD defining scope, goals, requirements, and non-goals. Input: user feature idea + loaded context. Output: PRD artifact. | **Contracting** | 1 |
| 7 | `create-technical-design` | Produce a technical design defining approach, architecture decisions, and component impact. Input: approved PRD + loaded context. Output: technical design artifact. | **Contracting** | 1 |
| 8 | `generate-tasks` | Produce an ordered set of implementable tasks with acceptance criteria. Input: approved design + loaded context. Output: task list artifact. | **Contracting** | 1 |

**Production Steps — Thinking (decision making):**

| # | Step | Invariant Semantic Responsibility | Type | Phase |
|---|------|----------------------------------|------|-------|
| 9 | `implement-task` | Apply a single task's requirements to the codebase. Input: task spec + architecture context. Output: code changes. | **Thinking** | 1 |

**Production Steps — Validation (checking alignment and correctness):**

| # | Step | Invariant Semantic Responsibility | Type | Phase |
|---|------|----------------------------------|------|-------|
| 10 | `validate-task-completion` | Verify implementation satisfies the task's acceptance criteria. Input: task spec + implementation. Output: pass/fail with gaps. | **Validation** | 1 |
| 11 | `validate-architecture-compliance` | Verify implementation conforms to architecture constraints and patterns. Input: architecture context + implementation. Output: compliance report with violations. | **Validation** | 1 |

**Phase 2 Steps (planned only — not built until Phase 1 cycle is solid):**

| # | Step | Invariant Semantic Responsibility | Type | Phase |
|---|------|----------------------------------|------|-------|
| 12 | `review-code` | Review code against standards, conventions, and best practices. | **Validation** | 2 |
| 13 | `estimate-effort` | Estimate complexity, effort, and risk for a set of tasks. | **Thinking** | 2 |
| 14 | `create-test-plan` | Define testing strategy, coverage requirements, and test cases. | **Contracting** | 2 |
| 15 | `deploy-checklist` | Verify deployment readiness: config, migrations, rollback, monitoring. | **Validation** | 2 |
| 16 | `retrospective` | Analyze delivery: what worked, what didn't, lessons learned. | **Learning** | 2 |
| 17 | `capture-decisions` | Record architectural/design decisions as ADRs. | **Learning** | 2 |

**Step type distribution (17 total):**
- **Thinking** (7): analyze-codebase, load-architecture-context, load-prd, load-technical-design, load-task, implement-task, estimate-effort
- **Contracting** (4): create-prd, create-technical-design, generate-tasks, create-test-plan
- **Validation** (4): validate-task-completion, validate-architecture-compliance, review-code, deploy-checklist
- **Learning** (2): retrospective, capture-decisions

### 3. Flows as User Goals

**Hard constraints:**
- Flows are **conceptual and descriptive** — they represent user goals, not executable pipelines.
- Step listings within Flows are **recommended compositions**, not mandatory execution sequences.
- Steps may be used in any order that satisfies their input requirements.
- Flows do not own or control Steps; they reference them.

#### Phase 1 Flows

| Flow | Type | Recommended Steps | User Goal | Phase |
|------|------|-------------------|-----------|-------|
| `sdlc-design-plan` | workflow | `analyze-codebase`, `load-architecture-context`, `create-prd`, `create-technical-design` | Feature idea → approved PRD + technical design | 1 |
| `sdlc-plan-implementation` | workflow | `load-prd`, `load-technical-design`, `load-architecture-context`, `generate-tasks` | Approved design → ordered task list with acceptance criteria | 1 |
| `sdlc-implement` | workflow | `load-task`, `load-architecture-context`, `implement-task`, `validate-task-completion`, `validate-architecture-compliance` | Task → implementation → validated result | 1 |
| `sdlc-architecture-awareness` | rule | *(always-on, no steps)* | Agent checks architecture docs before modifying code | 1 |

#### Phase 2 Flows (planned only)

| Flow | Type | Recommended Steps | User Goal | Phase |
|------|------|-------------------|-----------|-------|
| `sdlc-review` | workflow | `load-task`, `load-architecture-context`, `review-code` | Formal code review against standards and architecture | 2 |
| `sdlc-test-plan` | workflow | `load-prd`, `load-technical-design`, `load-architecture-context`, `create-test-plan` | Define testing strategy for a feature | 2 |
| `sdlc-deploy` | workflow | `load-prd`, `load-technical-design`, `deploy-checklist` | Verify deployment readiness | 2 |
| `sdlc-retrospective` | workflow | `load-prd`, `retrospective`, `capture-decisions` | Post-delivery analysis and knowledge capture | 2 |

### 4. Phase 1 Scope

Phase 1 delivers a **complete working cycle** — 3 workflow flows, 1 rule, 11 steps, and the full configuration/cross-domain mechanism. No new flows/steps until the entire cycle works end-to-end.

- **Phase 1 Steps (11):** `analyze-codebase`, `load-architecture-context`, `load-prd`, `load-technical-design`, `load-task`, `create-prd`, `create-technical-design`, `generate-tasks`, `implement-task`, `validate-task-completion`, `validate-architecture-compliance`
- **Phase 1 Flows (3 + 1 rule):** `sdlc-design-plan`, `sdlc-plan-implementation`, `sdlc-implement`, `sdlc-architecture-awareness`

### 5. Unified Configuration (`.dev-extensions.config.yaml`)

A single config file in the host project for **all domains**, with a base path and per-domain overrides:

```yaml
# .dev-extensions.config.yaml (in host project root)
artifacts:
  base_path: "artifacts/"                  # project-level base for all domain outputs

  domains:
    architecture:
      path: "docs/architecture/"           # absolute from project root (overrides base_path)
      metadata_file: "_metadata.yaml"      # index file for cross-domain reads
      open_issues_file: "_open-issues.md"

    sdlc:
      path: "sdlc/"                        # relative to base_path → artifacts/sdlc/
      structure: "{flow-type}/{identifier}" # sub-structure pattern
```

**Design principles:**
- Per-domain `path` can be absolute (from project root) or relative (to `base_path`)
- Architecture keeps its existing `docs/architecture/` location
- Cross-domain reads use this same config to discover each other's artifacts
- New domains inherit `base_path` by default
- If no config exists: flows prompt user for paths on first run

### 6. Cross-Domain Architecture Discovery

**Mechanism — 3-tier approach (all part of Phase 1):**
1. **Config-based path:** SDLC flows read architecture location from `.dev-extensions.config.yaml` (`artifacts.domains.architecture.path`), default `docs/architecture/`
2. **Metadata-as-index:** Read `_metadata.yaml` first to see section completeness and agent readiness, then read only the specific section(s) needed for the current task (e.g., `3-contracts.md` for API work)
3. **Graceful degradation:**
   - `_metadata.yaml` exists → targeted section reads
   - Arch dir exists but no metadata → suggest `/architecture-intake-create`
   - No arch dir → ask user for key info inline or suggest running intake
   - Always proceed with available info, explicitly surface gaps

### 7. Domain Structure

**Note:** This PRD contains planning documentation. For current implementation structure, see:
- [domains/sdlc/README.md](../../domains/sdlc/README.md) - Current SDLC domain documentation
- [DEVELOPMENT.md - Package Structure](../../DEVELOPMENT.md#package-structure) - Overall package structure

---

## Plan of Action (after confirmation)

1. Generate `tasks/prd-sdlc-domain.md` — full PRD following the create-prd workflow structure
2. PRD will include all design decisions above, functional requirements, user stories, and open questions
3. **No implementation** — PRD only
