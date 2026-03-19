# Examples

Complete workflow output examples demonstrating expected format and quality.

---

## Available Examples

### Architecture Domain

**user-service-example** - Complete architecture intake output for a Spring Boot microservice:
- All 8 sections (identity, architecture, contracts, data, flows, errors, config, observability)
- `_metadata.yaml` with completeness tracking
- `_open-issues.md` with prioritized items
- Demonstrates AUTO/SEMI source types and PARTIAL/COMPLETE sections

**Location**: `architecture/user-service-example/`

---

## How to Use Examples

**For Developers**:
- Study to understand expected output quality
- Compare your workflow results against examples
- Use as reference for documentation structure

**For AI Agents**:
- Read `_metadata.yaml` first for quick assessment
- Check `agent_ready` status and confidence levels
- Follow section metadata (source, completeness, needs_human)

---

## Adding New Examples

**For detailed instructions**, see `agent.md` or use AI assistance.

**Quick reference**:
- Copy structure from existing example
- Include all output files + metadata + open-issues
- Add explanatory README for the example
- Use realistic data (anonymized if needed)

**Naming**: `{domain}/{descriptive-name}-example/`

---

**Tip**: Examples should show realistic scenarios including PARTIAL sections and open issues, not just perfect outputs.
