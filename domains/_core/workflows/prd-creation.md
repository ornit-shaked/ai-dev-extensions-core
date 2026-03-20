---
description: Generate Product Requirements Document (PRD) for new features
version: 1.0.0
priority: ESSENTIAL
target_audience: junior_developer  # Ensures clarity for all skill levels
---

# PRD Creation Workflow

## Purpose

Guide agent through creating a **Product Requirements Document (PRD)** for a new feature. The PRD must be clear, actionable, and implementable by a junior developer.

**Key Principle**: Understand the "what" and "why", not the "how".

---

## Prerequisites

- [ ] User provided initial feature description
- [ ] Codebase is accessible for context analysis
- [ ] Output directory: `/tasks/[feature-name]/`

**Agent constraints:**
- NO fabrication of technical details
- NO implementation without approval
- Flag ambiguities with `needs-human: true`

---

## Step 1: Receive Initial Prompt

**Input**: User describes desired feature

**Action**: Acknowledge and proceed to assessment (do NOT write PRD yet)

---

## Step 2: Assess Current State

**Scan codebase for:**
- Related features/components
- Existing infrastructure (upload, storage, auth patterns)
- Architectural patterns and conventions

**Output format**:
```yaml
existing:
  - feature: "Related feature name"
    files: ["path/to/file"]
    
infrastructure:
  - type: "Service type"
    location: "path"
    capabilities: ["cap1", "cap2"]
    
constraints:
  - type: "Limitation type"
    description: "Details"
```

**Metadata**: `source: AUTO | completeness: PARTIAL`

---

## Step 3: Ask 3-5 Clarifying Questions

**Ask only if unclear from context. Priority order:**

1. **Problem/Goal** - What problem does this solve?
2. **Scope** - What's included/excluded?
3. **Success criteria** - How to measure success?
4. **Target users** - Who will use this?
5. **Timeline** - Urgency/priority?

**Format**: Multiple choice (A/B/C/D) for easy response

**Example**:
```
1. Primary goal?
   A. [Option inferred from context]
   B. [Alternative based on similar features]
   C. Other: ___

Select: ___
```

**needs-human: true** - Wait for response before continuing

---

## Step 4: Generate PRD

### Section 1: Introduction
- **What**: Feature description (2-3 sentences)
- **Why**: Problem solved
- **Goal**: Primary objective

**Metadata**: `source: SEMI | completeness: COMPLETE`

---

### Section 2: Goals
List 2-4 specific, measurable objectives

**Example**:
```markdown
## Goals
1. Enable [action] (measure: [metric])
2. Improve [outcome] (measure: +X%)
3. Reduce [problem] (measure: -Y%)
```

**Metadata**: `source: HUMAN | completeness: COMPLETE`

---

### Section 3: User Stories
2-5 stories in format: "As a [user], I want [action] so that [benefit]"

**Metadata**: `source: SEMI | completeness: COMPLETE`

---

### Section 4: Functional Requirements

**Numbered list using "The system must..." format**

**Example**:
```markdown
## Functional Requirements
1. The system must allow users to [action] ([constraints])
2. The system must validate [input] (rules: [validation])
3. The system must display [feedback] when [condition]
4. The system must save [data] to [location]
5. The system must handle errors by [behavior]
```

**Metadata**: `source: AUTO | completeness: PARTIAL | needs-human: true | risk: MEDIUM`

---

### Section 5: Non-Goals (Out of Scope)
Explicitly state what is NOT included

**Example**:
```markdown
## Non-Goals
- ❌ Advanced feature X
- ❌ Integration with Y
- ❌ Support for Z format
```

---

### Section 6: Architecture Impact

**NEW - For senior/architect review**

```markdown
## Architecture Impact
- **Affected layers**: [Frontend/Backend/DB/API]
- **Breaking changes**: Yes/No - [details if yes]
- **Migration required**: Yes/No
- **Backwards compatibility**: Yes/No
- **Performance impact**: [expected change in load/latency]
```

**Metadata**: `source: AUTO | needs-human: true | risk: HIGH`

---

### Section 7: Technical Considerations

**Reference existing infrastructure from Step 2**

```markdown
## Technical Considerations

**Existing Infrastructure**:
- Service: `path/to/service` (capabilities: [list])
- Storage: [type] at [location]
- Model: `path/to/model` (add fields: [list])

**Dependencies**:
- [Dependency 1] (status: already in use / new)
- [Dependency 2]

**Security**:
- [Security concern 1]: [mitigation]
- [Security concern 2]: [mitigation]

**Performance**:
- [Performance consideration]
```

**Metadata**: `source: AUTO | needs-human: true | risk: HIGH`

---

### Section 8: Risk Assessment

**NEW - Critical risks with mitigation**

```markdown
## Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [Risk type] | High/Med/Low | High/Med/Low | [Strategy] |
| [Risk type] | High/Med/Low | High/Med/Low | [Strategy] |
```

**Metadata**: `source: SEMI | needs-human: true`

---

### Section 9: Dependencies & Integration

**NEW - External touchpoints**

```markdown
## Dependencies & Integration

**External Dependencies**:
- [Service/API name]: [purpose]
- [Third-party service]: [integration point]

**Internal Services**:
- [Service name]: [API/integration details]

**Breaking Changes to APIs**: Yes/No
- [Details if yes]
```

---

### Section 10: Testing Strategy

**NEW - Testing requirements**

```markdown
## Testing Requirements
- **Unit tests**: [Critical functions to test]
- **Integration tests**: [End-to-end flows]
- **Security tests**: [Vulnerability checks]
- **Performance tests**: [Load/stress scenarios]
```

---

### Section 11: Success Metrics

**Tie back to Goals (Section 2). Must be measurable.**

```markdown
## Success Metrics
| Metric | Baseline | Target | Timeline |
|--------|----------|---------|----------|
| [Metric] | [Current] | [Goal] | [Timeframe] |
```

---

### Section 12: Open Questions

**Unresolved items requiring human/developer input**

**Example**:
```markdown
## Open Questions
1. Should we support [option A] or [option B]?
2. What happens to [edge case]?
3. Do we need [additional feature]?
```

**Metadata**: `needs-human: true`

---

## Step 5: Present & Iterate

**Present draft PRD with:**
- Overall metadata header
- All sections complete
- Flagged items marked `needs-human: true`

**Iterate based on feedback until user approves**

**needs-human: true** - Wait for approval

---

## Step 6: Save PRD

**Only after user approval**

### Create structure:
```bash
/tasks/[feature-name]/
  └── prd-[feature-name].md
```

### PRD Header (machine-readable frontmatter):
```yaml
---
prd_version: 1.0
feature: [feature-name]
status: APPROVED
created: [date]
approved: [date]
target_reader: junior_developer

# Tracking metadata for automation
open_questions: [count]
high_risk_items: [count]
needs_architect_review: [Yes/No]

# Next steps for task generation
next_steps:
  - Review open questions
  - Create technical design (if needed)
  - Break into tasks
  - Assign developer

# Risk summary
risks:
  high: [count]
  medium: [count]
  low: [count]
---
```

**Note**: Frontmatter is YAML format for easy parsing by other workflows (e.g., task generation)

### Confirm:
```
✅ PRD saved: /tasks/[feature-name]/prd-[feature-name].md

Next steps: [list from frontmatter]
⚠ Risk summary: [high]/[medium]/[low]
```

---

## Rules

**DO NOT:**
- Fabricate data not in codebase
- Implement (only document requirements)
- Skip `needs-human: true` review points
- Assume user intent without clarification

**DO:**
- Reference existing code/patterns from Step 2
- Use metadata blocks (source, completeness, risk)
- Provide multiple-choice questions
- Keep requirements testable and clear
- Iterate until approved

---

## Success Criteria

PRD is ready when:
- ✅ All 12 sections complete
- ✅ Requirements are testable
- ✅ Non-goals explicitly stated
- ✅ Architecture impact assessed
- ✅ Risks identified with mitigation
- ✅ Technical considerations reference existing code
- ✅ Success metrics are measurable
- ✅ Open questions documented
- ✅ User approved
- ✅ Suitable for junior developer

---

## Example Output

See: `/tasks/profile-picture-upload/prd-profile-picture-upload.md`
