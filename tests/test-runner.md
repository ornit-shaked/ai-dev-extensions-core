# Test Runner Instructions

This document provides instructions for an LLM agent to execute SDLC Flow tests.

## Purpose

Run automated validation tests on SDLC Flows to assess:
- Flow guidance clarity and completeness
- Step definitions and prompts
- User journey feasibility
- Friction points and gaps

## Input

A test definition file from `tests/flows/test-*.md` with:
- `flow_under_test`: Name of the Flow to test
- `test_scenario`: User context for simulation

## Process

### Phase 1: Load Flow Definition

1. **Locate Flow file:**
   - Path: `domains/sdlc/skills/flow-{flow_name}.md`
   - Example: `domains/sdlc/skills/flow-create-prd.md`

2. **Extract Flow metadata (from YAML frontmatter):**
   - `flow`: Canonical name
   - `goal`: What user is trying to achieve
   - `expected_outcome`: What Flow produces
   - `entry_command`: Tool-specific command (if any)
   - `recommended_steps`: List of Step names
   - `optional_steps`: List of optional Step names

3. **Read Flow guidance (from Markdown body):**
   - "User Guidance" section
   - "When to use"
   - "What this Flow produces"
   - "Prerequisites"
   - "Recommended Steps" explanations
   - "What This Flow Does NOT Do"

### Phase 2: Evaluate Flow-Level Quality

For each Flow section, assess:

#### Goal & Expected Outcome
- ✅ **Clear:** Is it obvious what the user is trying to achieve?
- ⚠️ **Ambiguous:** Could be interpreted multiple ways
- ❌ **Unclear:** Confusing or missing

#### User Guidance
- ✅ **Helpful:** Clearly explains when to use this Flow
- ⚠️ **Incomplete:** Missing key scenarios
- ❌ **Confusing:** Contradictory or unclear

#### Prerequisites
- ✅ **Explicit:** Clear what's needed before starting
- ⚠️ **Vague:** Somewhat unclear
- ❌ **Missing:** No prerequisites listed

#### "What This Flow Does NOT Do"
- ✅ **Present:** Prevents common misconceptions
- ⚠️ **Incomplete:** Missing important clarifications
- ❌ **Absent:** Section missing

### Phase 3: Load Step Definitions

For each Step in `recommended_steps` and `optional_steps`:

1. **Locate Step file:**
   - Path: `domains/sdlc/skills/step-{step_name}.md`
   - Example: `domains/sdlc/skills/step-problem-framing.md`

2. **Extract Step metadata (from YAML frontmatter):**
   - `name`: Canonical name
   - `tag`: Thinking/Contracting/Validation/Learning
   - `execution_intent`: human-led/agent-assisted/agent-executed
   - `semantic_responsibility`: What Step does
   - `input.conceptual`: What Step needs
   - `output.conceptual`: What Step produces
   - `status.complete`: When done
   - `status.needs_human`: When human needed
   - `prompt`: LLM instructions

3. **Read Step guidance (from Markdown body):**
   - "What This Step Does"
   - "What This Step Is NOT"
   - "Conceptual Guidance"

### Phase 4: Simulate User Journey

Using the `test_scenario` from test definition:

1. **Simulate user starting the Flow:**
   - User intent: [from test_scenario.user_intent]
   - User context: [from test_scenario.context]

2. **Walk through Flow guidance:**
   - Does guidance help user understand when to use this Flow?
   - Are prerequisites clear and available?
   - Does user know what to expect as output?

3. **Execute Steps conceptually:**
   - For each Step in `recommended_steps`:
     - Read Step's prompt
     - Simulate LLM executing prompt with test scenario
     - Verify output matches `output.conceptual`
     - Note any friction or confusion

4. **Evaluate optional Steps:**
   - Are optional Steps truly optional for this scenario?
   - Should any optional Steps be recommended?
   - Are there missing Steps?

### Phase 5: Evaluate Step Quality

For each Step, assess:

#### Clarity
- ✅ **Name is self-explanatory:** Obvious what Step does
- ✅ **Semantic responsibility is clear:** Purpose is unambiguous
- ✅ **"When to use" is obvious:** From guidance or context
- ✅ **"What This Step Is NOT" prevents confusion:** Anti-patterns listed

#### Prompt Quality
- ✅ **Actionable:** LLM can execute instructions
- ✅ **Structured:** Clear Input/Task/Output format
- ✅ **Examples provided:** Help understanding
- ✅ **Tool-agnostic:** No tool-specific instructions

#### Intent Alignment
- ✅ **execution_intent matches nature:** human-led/agent-assisted/agent-executed is correct
- ✅ **Single responsibility:** Step doesn't try to do too much
- ✅ **No overlap:** Step doesn't duplicate other Steps

#### Friction Points
- **Ambiguity:** Where is guidance unclear?
- **Missing info:** What information is missing?
- **Ordering confusion:** Does "no fixed order" cause uncertainty?
- **Overlap:** Do Steps seem redundant?

### Phase 6: Generate Feedback

Using `tests/feedback-template.md`, generate structured feedback:

1. **Executive Summary:**
   - Overall assessment (PASSED/NEEDS WORK/FAILED)
   - Key findings (3-5 bullet points)
   - Recommendation (proceed/refine/redesign)

2. **Flow Evaluation:**
   - Goal clarity
   - Guidance quality
   - Prerequisites
   - Common patterns
   - What Flow does NOT do

3. **Step-by-Step Evaluation:**
   - For each Step:
     - Clarity assessment
     - Prompt quality
     - Intent alignment
     - Friction points
     - Suggestions

4. **Recommendations:**
   - **Priority 1:** Critical issues (must fix)
   - **Priority 2:** Important improvements (should fix)
   - **Priority 3:** Nice-to-have enhancements (optional)

## Output

Save feedback to: `tests/results/{flow_name}-results.md`

## Success Criteria

A test PASSES if:
- ✅ Flow guidance is clear and helpful
- ✅ All recommended Steps exist and have prompts
- ✅ User journey can be completed conceptually
- ✅ No critical friction points identified
- ✅ Only minor improvements suggested

A test NEEDS WORK if:
- ⚠️ Flow guidance has gaps
- ⚠️ Some Steps lack clarity
- ⚠️ User journey has friction points
- ⚠️ Important improvements identified

A test FAILS if:
- ❌ Flow guidance is confusing or missing
- ❌ Steps are missing or have no prompts
- ❌ User journey cannot be completed
- ❌ Critical issues prevent Flow execution

## Notes

- **Be objective:** Base assessments on evidence, not assumptions
- **Be specific:** Point to exact locations of issues
- **Be constructive:** Suggest improvements, not just criticisms
- **Be consistent:** Use same criteria for all Flows
