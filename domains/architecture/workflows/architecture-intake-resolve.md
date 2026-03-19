---
description: Resolve open issues from an architecture intake interactively, updating documentation section by section
---

# Architecture Intake Resolve Workflow

## Overview

This workflow resolves open issues flagged during `/architecture-intake`. It reads `_open-issues.md` for the target service, presents each issue interactively, collects user input, updates the relevant section documentation, and marks issues as resolved.

Can run:
- **Standalone**: User runs `/architecture-intake-resolve`
- **Inline**: Called automatically at the end of `/architecture-intake` when user answers "yes"

---

## Execution

### Step 1: Identify Target Service

**If called standalone** (not inline from `/architecture-intake`):

Ask:
```
Which service would you like to resolve issues for?
(e.g., tosca-engine-ms)
```

Set variables:
- `SERVICE_NAME` = user input
- `OUTPUT_DIR` = `docs/architecture/`

**If called inline** from `/architecture-intake`: `SERVICE_NAME` and `OUTPUT_DIR` are already set — skip the question.

---

### Step 2: Load Open Issues

Read `{OUTPUT_DIR}/_open-issues.md`.

If the file does not exist:
```
❌ No open issues file found for: {SERVICE_NAME}
   Expected: {OUTPUT_DIR}/_open-issues.md

   Run /architecture-intake-create first to generate intake documentation.
```
Then stop.

Parse all unresolved issues (lines starting with `- [ ]`).

Count issues by priority:
- `HIGH_ISSUES` = list of high priority unresolved items
- `MEDIUM_ISSUES` = list of medium priority unresolved items
- `LOW_ISSUES` = list of low priority unresolved items
- `TOTAL_UNRESOLVED` = total count

If `TOTAL_UNRESOLVED == 0`:
```
✅ No open issues remaining for: {SERVICE_NAME}
   All items in _open-issues.md are already resolved.
```
Then stop.

---

### Step 3: Present Issue Menu

Output the following as a fenced code block:

```
🔧 Architecture Intake: Resolve Open Issues
   Service: {SERVICE_NAME}

Open Issues ({TOTAL_UNRESOLVED} remaining):

🔴 HIGH PRIORITY
  [1] {HIGH_ISSUE_1_TITLE}  (Section: {SECTION})
  [2] {HIGH_ISSUE_2_TITLE}  (Section: {SECTION})
  ...

🟡 MEDIUM PRIORITY
  [N] {MEDIUM_ISSUE_1_TITLE}  (Section: {SECTION})
  ...

🔵 LOW PRIORITY
  [N] {LOW_ISSUE_1_TITLE}  (Section: {SECTION})
  ...

Options:
  • Enter a number to resolve a specific issue
  • Enter 'high' to work through all high priority issues in order
  • Enter 'all' to work through all issues in order
  • Enter 'skip' at any issue to skip it and move to the next
  • Enter 'stop' to save progress and exit
```

Ask: **"Which issue would you like to resolve? (number / 'high' / 'all')"**

---

### Step 4: Resolve Issue Loop

For each selected issue (one at a time):

#### 4a: Present the Issue

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Issue [{NUMBER}] — {PRIORITY}
Section: {SECTION_FILE}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{FULL_ISSUE_DESCRIPTION_FROM_OPEN_ISSUES_FILE}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#### 4b: Ask for Input

Use the issue type to determine what to ask. Common patterns:

**For "Define non-goals"**:
```
Please describe what this service does NOT do.
Example: "Does not provision physical devices; does not store historical metrics"

Your answer (or 'skip' to come back later):
```

**For "No static OpenAPI spec committed"**:

First, attempt auto-fetch:
1. Check if `src/main/resources/openapi.json` or `openapi.yaml` already exists — if yes, mark resolved and skip asking.
2. If not found, ask:

```
⚠️  IMPORTANT: The server URL you provide must be running the LATEST version of the service.
    Using an outdated version will produce an inaccurate spec.

Please provide the base URL of a running dev/staging instance:
  Example: http://10.76.130.198:8043
  • Type 'skip' to come back later
  • Type 'not-applicable' if this service has no REST API

Server URL:
```

3. If URL provided: run `Invoke-WebRequest -Uri "{URL}/v3/api-docs" -OutFile "src/main/resources/openapi.json" -UseBasicParsing`
   - If successful: update `3-contracts.md` with spec location and note the source URL and date. Mark resolved.
   - If failed: display error, ask user to verify URL, offer 'skip'
4. Add note to `3-contracts.md`: *"Spec fetched from {URL} on {DATE}. Re-fetch when upgrading service version."*

**For "Dashboard links missing"**:
```
Please provide links to operational dashboards for this service:
  • Grafana: 
  • Kibana:
  • Other:
  (leave blank if not applicable, type 'skip' to come back later)
```

**For "Verify / validate" items**:
```
Please provide the verified information:
  • The correct value, OR
  • 'confirmed' if the auto-detected value is correct, OR
  • 'skip' to come back later

Your answer:
```

**For "Flow completeness validation" (Section: 5-flows.md)**:

> Agent: Read `5-flows.md` to get existing flow names (count them). Read the issue text in `_open-issues.md` to extract the potentially missing flows from the "Additional flows may exist (e.g., ...)" part. Number the missing flows as continuation of the existing list (if 5 flows exist, missing start at [6]). Output the following as a fenced code block:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Flow Completeness — {SERVICE_NAME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Documented flows (already covered):
  [1] {FLOW_1_NAME}
  [2] {FLOW_2_NAME}
  ...

Potentially missing flows (need your input):
  [6] {MISSING_FLOW_1}
  [7] {MISSING_FLOW_2}
  ...

Options:
  • Enter a number to review a specific flow
  • Enter 'all' to go through all potentially missing flows in order
  • Enter 'skip' at any flow to skip it and move to the next
  • Enter 'stop' to save progress and exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> Agent: For each selected number, output the following as a fenced code block:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[{N}] {FLOW_NAME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Does this flow exist in {SERVICE_NAME}?

  yes  — it exists. Describe briefly:
         Trigger: (what starts it? e.g. API call, event, scheduled job)
         Steps:   (2-4 key steps in plain language)

  no   — doesn't exist, or already covered by a documented flow above

  skip — come back to this later
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> Agent: If the user selects a number from the "Documented flows" list (1..N), respond: `"[{N}] {FLOW_NAME} is already documented. Choose a number from the 'Potentially missing flows' list."`
> - `yes` → append a minimal stub to `5-flows.md` (see Document Update Rules)
> - `no` → dismiss silently
> - After last selected flow: ask `"Are all the documented flows above complete and accurate? (yes / no)"`
> - **Mark resolved** only when ALL potentially missing flows answered `yes`/`no` AND user confirms documented flows are complete
> - **If partial**: keep `- [ ]`, add sub-bullet `  - **Progress**: {N}/{TOTAL} flows reviewed`

---

**For "Business context for flows" (Section: 5-flows.md)**:

> Agent: Read `5-flows.md`. Extract flow names and trigger endpoints/events. Output the following as a fenced code block:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Business Context — {SERVICE_NAME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Flows needing business context:
  [1] {FLOW_1_NAME}  — {TRIGGER_1}
  [2] {FLOW_2_NAME}  — {TRIGGER_2}
  ...

Options:
  • Enter a number to provide business context for a specific flow
  • Enter 'all' to go through all flows in order
  • Enter 'skip' at any flow to skip it and move to the next
  • Enter 'stop' to save progress and exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> Agent: For each selected number, identify ONE missing business context gap and output the following as a fenced code block:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Flow: {FLOW_NAME}  ({N} of {SELECTED_COUNT})
   Trigger: {TRIGGER_ENDPOINT_OR_EVENT}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{ONE_TARGETED_QUESTION_DERIVED_FROM_THE_GAP}

Your answer (or 'skip' to move to next flow):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

> Agent: Question selection rules (pick the most relevant for that specific flow):
> - No "why" → `"Why does this flow exist? What business problem does it solve?"`
> - Unexplained decision point → `"What determines [decision point] from a business perspective?"`
> - Unexplained external call → `"What happens if [external service] is unavailable during this flow?"`

> Agent: Write each answer as `> **Business context**: {answer}` directly below the flow's `### Trigger` heading — verbatim, nothing else.
> - **Mark resolved** only when ALL flows have been answered (no `skip` remaining)
> - **If partial**: keep `- [ ]`, add sub-bullet `  - **Progress**: {N}/{TOTAL} flows answered`

---

**For "Review / validate completeness" items** (generic fallback for other sections):
```
Please review the auto-generated content in {SECTION_FILE} and provide:
  • Any corrections or additions needed, OR
  • 'ok' if the content looks correct as-is, OR
  • 'skip' to come back later

Your answer:
```

#### 4c: Handle User Response

**If user enters 'skip'**:
- Leave issue as `- [ ]` in `_open-issues.md`
- Display: `⏭ Skipped. Moving to next issue...`
- Continue loop

**If user enters 'stop'**:
- Save all progress made so far
- Jump to Step 5 (Final Summary)

**If user provides actual input**:
- Update the relevant section file with the new information
- Mark issue as resolved in `_open-issues.md`: change `- [ ]` to `- [x]`
- Update `_metadata.yaml` if section completeness changed
- Display:
  ```
  ✅ Issue resolved. {SECTION_FILE} updated.
  ```

#### 4d: Ask to Continue

After resolving or skipping an issue, if there are more issues remaining:

```
({REMAINING_COUNT} issues remaining)
Continue to the next issue? (yes / stop)
```

- If **yes**: continue loop with next issue
- If **stop**: jump to Step 5

---

### Step 5: Update Metadata

After all selected issues are processed:

1. Re-count unresolved issues in `_open-issues.md`
2. Update `_metadata.yaml`:
   - Update `issues_count` and priority counts
   - Update `completeness` for any sections that changed
   - Update `needs_human_review` count
   - Update `timestamp` to current date
3. For each section where `needs-human: true` items were all resolved:
   - Update the section's metadata block from `needs-human: true` to `needs-human: false`
   - Update `completeness: PARTIAL` to `completeness: COMPLETE` if appropriate

---

### Step 6: Final Summary

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Resolve Session Complete: {SERVICE_NAME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Resolved this session:  {RESOLVED_THIS_SESSION} issues
Remaining open:         {REMAINING_COUNT} issues
Total resolved:         {TOTAL_RESOLVED} / {GRAND_TOTAL}

Updated files:
  {LIST_OF_UPDATED_FILES}

If `REMAINING_COUNT > 0`:
📋 {REMAINING_COUNT} issues still open.
   Run /architecture-intake-resolve again to continue.

If `REMAINING_COUNT == 0`:
🎉 All issues resolved! Intake is complete.
🤖 Agent Ready: COMPLETE — safe for full agent consumption.

---

## Document Update Rules

When updating section files based on user input:

### Non-goals (1-identity.md)
Replace the placeholder block:
```
> ⚠️ **Requires Human Review**: ...
- TBD — requires input from ...
```
With the actual non-goals list provided by the user.

### Missing URLs / Links
Add the URL/path to the relevant section under the appropriate heading.

### Verified constants / values
Replace the `> ⚠️ **Needs Review**: ...` block with the verified value.

### Flow completeness validation (5-flows.md)
- For each `yes` answer: append a minimal stub at the end of `5-flows.md`:
  ```markdown
  ## Flow N: {FLOW_NAME}
  > source: MANUAL

  ### Trigger
  {FROM_USER_ANSWER}

  ### Actors
  {FROM_USER_ANSWER}

  ### Flow Steps
  {FROM_USER_ANSWER}
  ```
- **If ALL candidates answered (`yes`/`no`) AND existing flows confirmed complete**:
  - Change `- [ ]` to `- [x]` in `_open-issues.md`
  - Set `completeness: COMPLETE`, `needs-human: false` in `5-flows.md` metadata
- **If some candidates still `skip`**:
  - Keep `- [ ]` in `_open-issues.md`
  - Append a progress note as a new sub-bullet under the issue: `  - **Progress**: {N}/{TOTAL} candidates handled`
  - Keep `needs-human: true` in `5-flows.md` metadata
  - On the next run: read the existing `**Progress**` note to know which candidates are already done

### Business context for flows (5-flows.md)
- Write each answer as `> **Business context**: {answer}` immediately after the flow's `### Trigger` heading — verbatim, no new subsection.
- **If ALL flows answered**:
  - Change `- [ ]` to `- [x]` in `_open-issues.md`
  - Set `needs-human: false`, `completeness: COMPLETE` in `5-flows.md` metadata
- **If some flows still `skip`**:
  - Keep `- [ ]` in `_open-issues.md`
  - Append a progress note as a new sub-bullet under the issue: `  - **Progress**: {N}/{TOTAL} flows answered`
  - Keep `needs-human: true` in `5-flows.md` metadata
  - On the next run: read the existing `**Progress**` note and skip already-answered flows in the selection menu

### Generic flow validation (other cases)
If user says "ok": change metadata from `needs-human: true` to `needs-human: false`.
If user provides corrections: apply them inline to the flow steps.

### Dashboard links (8-observability.md)
Add links under the `## Dashboards` section.

---

## Constraints

- **Never fabricate** — only write what the user explicitly provides
- **Preserve existing content** — only update the specific area related to the issue
- **One issue at a time** — do not bulk-update multiple sections from a single answer
- **Always update `_open-issues.md`** — mark `- [x]` immediately when resolved
- **Always update `_metadata.yaml`** — keep counts accurate after each session

---

*Workflow Version: 1.0.0*
