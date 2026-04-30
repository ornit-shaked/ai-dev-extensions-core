# Flow Test: Create PRD

**Test Type:** Flow validation  
**Flow Under Test:** Create PRD  
**Test ID:** flow-create-prd-001

---

## Test Configuration

```yaml
flow_under_test: "Create PRD"
test_scenario:
  user_intent: "Create a PRD for adding OAuth 2.0 authentication to existing web application"
  user_context:
    - "Existing web application with username/password authentication"
    - "Current auth system is 5 years old, no modern security features"
    - "3000 active users, mostly enterprise customers"
    - "Security compliance requirements (SOC2, GDPR)"
    - "Development team has 4 engineers, 2 sprints available"
    - "Product manager wants social login (Google, Microsoft, GitHub)"
  expected_challenges:
    - "Migration from existing auth system"
    - "Backward compatibility with existing users"
    - "Session management changes"
    - "Security audit requirements"
```

---

## Test Execution Instructions

Follow the process defined in `../test-runner.md`:

1. **Load Flow Definition:** Read `domains/sdlc/skills/flow-create-prd.md`
2. **Evaluate Flow Quality:** Assess goal, guidance, prerequisites
3. **Load Step Definitions:** Read all Steps in `recommended_steps`
4. **Simulate User Journey:** Walk through Flow with test scenario
5. **Evaluate Step Quality:** Assess each Step's clarity, prompt, intent
6. **Generate Feedback:** Use `../feedback-template.md`

---

## Expected Outcomes

### Successful Test Indicators

- ✅ User can understand when to use Create PRD Flow
- ✅ All 7 recommended Steps are clear and actionable
- ✅ User journey completes from problem to specification
- ✅ Each Step produces expected conceptual output
- ✅ No critical friction points block progress

### Known Areas to Watch

- **Context Assembly:** Can it find existing auth system documentation?
- **Option Generation:** Are OAuth provider options clear?
- **Option Evaluation:** Trade-offs between providers
- **Specification:** Technical details for OAuth flow

---

## Test Results Location

Save results to: `../results/create-prd-results.md`
