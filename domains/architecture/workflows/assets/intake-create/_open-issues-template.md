# Open Issues: {{SERVICE_NAME}}

**Generated**: {{TIMESTAMP}}  
**Total Issues**: {{COUNT}}

---

## Overview

This file aggregates all items flagged with `needs-human: true` during the architecture intake process. These items require human review, validation, or additional documentation.

---

## High Priority Issues

### Identity & Boundaries

- [ ] **Non-goals definition** (Section: 1-identity.md)
  - **Issue**: Cannot auto-detect what the service explicitly does NOT do
  - **Action Required**: Business stakeholder to define non-goals
  - **Impact**: Helps prevent scope creep and clarifies boundaries
  - **Assigned To**: {{TEAM_LEAD|PRODUCT_OWNER}}

- [ ] **Ownership verification** (Section: 1-identity.md)
  - **Issue**: Team/contact information needs verification
  - **Action Required**: Confirm current owners and contacts
  - **Impact**: Ensures correct escalation paths
  - **Assigned To**: {{TEAM_LEAD}}

### Contracts & APIs

- [ ] **OpenAPI specification missing** (Section: 3-contracts.md)
  - **Issue**: No OpenAPI/Swagger spec found in repository
  - **Action Required**: Create OpenAPI spec or document manually
  - **Impact**: Critical for API consumers and integration testing
  - **Assigned To**: {{BACKEND_DEVELOPER}}
  - **Suggested Location**: `src/main/resources/openapi.yaml`

- [ ] **Event schema documentation** (Section: 3-contracts.md)
  - **Issue**: Async event schemas not fully documented
  - **Action Required**: Document all published/consumed event schemas
  - **Impact**: Required for event-driven integration
  - **Assigned To**: {{BACKEND_DEVELOPER}}

### Key Flows

- [ ] **Flow completeness validation** (Section: 5-flows.md)
  - **Issue**: Only {{COUNT}} flows auto-detected, may be incomplete
  - **Action Required**: Review and add missing critical flows
  - **Impact**: Incomplete flows may lead to incorrect agent behavior
  - **Assigned To**: {{TECH_LEAD}}

- [ ] **Business context for flows** (Section: 5-flows.md)
  - **Issue**: Technical flow steps documented, business context missing
  - **Action Required**: Add business rationale and decision criteria
  - **Impact**: Helps understand why flows exist and when to modify
  - **Assigned To**: {{PRODUCT_OWNER}}

---

## Medium Priority Issues

### Observability

- [ ] **Dashboard links missing** 
  - **Issue**: No Grafana/Kibana dashboard links found
  - **Action Required**: Add links to monitoring dashboards
  - **Impact**: Slows down troubleshooting and incident response
  - **Assigned To**: {{SRE|DEVOPS}}
  - **Example**: `https://grafana.company.com/d/tosca-engine-ms`

- [ ] **Alert configuration verification** 
  - **Issue**: Alert rules need verification
  - **Action Required**: Confirm alert thresholds and channels
  - **Impact**: May miss critical incidents or get false alarms
  - **Assigned To**: {{SRE|DEVOPS}}

- [ ] **Tracing configuration** 
  - **Issue**: Distributed tracing setup needs verification
  - **Action Required**: Confirm tracing backend and sampling rate
  - **Impact**: Affects debugging distributed transactions
  - **Assigned To**: {{SRE|DEVOPS}}

---

## Low Priority Issues

### Architecture

- [ ] **Component diagram** (Section: 2-architecture.md)
  - **Issue**: Text-based architecture, visual diagram would help
  - **Action Required**: Create C4 container diagram
  - **Impact**: Improves understanding for new team members
  - **Assigned To**: {{ARCHITECT}}
  - **Tool**: draw.io, PlantUML, or Mermaid

### ADRs

- [ ] **ADR directory missing** (Section: _metadata.yaml)
  - **Issue**: No architecture decision records found
  - **Action Required**: Create `docs/adr/` and document key decisions
  - **Impact**: Loss of architectural context over time
  - **Assigned To**: {{ARCHITECT|TECH_LEAD}}
  - **Template**: https://github.com/joelparkerhenderson/architecture-decision-record

### Documentation

- [ ] **Wiki links verification** (Section: 1-identity.md)
  - **Issue**: Some wiki links may be outdated
  - **Action Required**: Verify all documentation links are current
  - **Impact**: Developers may reference outdated information
  - **Assigned To**: {{TECH_WRITER|TEAM_LEAD}}

---

## Items for Future Enhancement

### Performance Baselines

- [ ] **Performance benchmarks** 
  - **Issue**: No documented performance baselines
  - **Action Required**: Run load tests and document expected performance
  - **Impact**: Helps detect performance regressions
  - **Assigned To**: {{QA|PERFORMANCE_ENGINEER}}

### Testing

- [ ] **Integration test documentation** 
  - **Issue**: Integration test setup could be more detailed
  - **Action Required**: Document integration test scenarios and data setup
  - **Impact**: Easier onboarding for new developers
  - **Assigned To**: {{QA|BACKEND_DEVELOPER}}

---

## Review Checklist

Before marking this intake as complete, ensure:

- [ ] All HIGH priority issues addressed or have owners assigned
- [ ] OpenAPI spec created or manual API documentation complete
- [ ] Non-goals section reviewed and approved by product owner
- [ ] Key flows validated by tech lead
- [ ] Dashboard links added to observability section
- [ ] Ownership information verified
- [ ] All sections reviewed by at least one team member

---

## Notes for AI Agents

**Agent Safety Guidelines**:
- Treat all items marked `needs-human: true` as uncertain
- Do not make assumptions about non-goals or business context
- Verify API contracts against actual code, not assumptions
- Flag any discrepancies found during code analysis
- When in doubt, ask for human review

**Using This File**:
- Check this file before making architectural changes
- Reference specific sections when uncertain about design decisions
- Update this file if you discover missing information
- Create new issues if you find undocumented areas

---

## Completion Tracking

**Status**: {{IN_PROGRESS|READY_FOR_REVIEW|COMPLETE}}

**Progress**:
- High Priority: {{X}}/{{TOTAL}} completed
- Medium Priority: {{X}}/{{TOTAL}} completed
- Low Priority: {{X}}/{{TOTAL}} completed

**Last Updated**: {{TIMESTAMP}}  
**Next Review Date**: {{SUGGESTED_DATE}}

---
*Auto-generated by /architecture-intake workflow*
