# Domains

Domain-specific workflows, templates, rules, and skills.

---

## Available Domains

### _core (Priority 0)
Shared rules and skills used by all domains. Always loaded first.
- `rules/` - Behavioral constraints for AI agents
- `skills/` - Reusable capabilities (future)

### architecture (Priority 1)
Architecture documentation workflows and templates.
- `workflows/` - architecture-intake-create, architecture-intake-resolve
- `templates/` - 8 section templates for microservice documentation
- **Example**: See `examples/architecture/user-service-example/`

---

## Domain Structure

Each domain follows this pattern:
```
domains/{domain-name}/
├── workflows/              # Workflow definitions
├── templates/              # Template files
├── .domain-metadata.yaml   # Domain configuration
└── README.md              # Domain documentation
```

---

## Adding a New Domain

**For detailed step-by-step instructions**, see `agent.md` or use AI assistance.

**Quick reference**:
- Create `domains/{name}/{workflows,templates}/`
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
