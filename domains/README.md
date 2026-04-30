# Domains

Domain-specific workflows, templates, rules, and skills.

---


## Domain Structure


---

## Adding a New Domain

**For detailed step-by-step instructions**, see `agent.md` or use AI assistance.

**Quick reference**:
- Create `domains/{name}/{workflows,skills}/`
- Add `.domain-metadata.yaml` (see architecture domain as example)
- Update root `manifest.yaml`
- Create domain README

**Key metadata fields**:
- `priority`: Loading order (0=first, higher=later)
- `dependencies`: Always include `_core`
- `enabled_by_default`: true/false

---

## Best Practices

1. **One concern per domain** - Keep domains focused
2. **No cross-domain references** - Workflows should work independently  
3. **Test in isolation** - Verify domain works alone
4. **Clear naming** - Use kebab-case (e.g., `code-review`)

---

See [MICROSERVICE_INTEGRATION.md](../MICROSERVICE_INTEGRATION.md) for integration details.
