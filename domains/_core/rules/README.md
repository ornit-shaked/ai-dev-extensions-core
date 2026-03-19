# Core Rules

Behavioral constraints for AI agents executing workflows.

---

## 📋 Available Rules

### no-fabrication.md
Never fabricate information - always use actual data from code/config.

### minimal-changes.md
Make minimal, focused changes - avoid over-engineering.

---

## ✍️ Rule Format

Each rule file should follow this structure:

```markdown
# Rule Name

## Directive
Clear, actionable statement of what to do or not do.

## Rationale
Explain why this rule exists and what problems it prevents.

## Examples

### ✅ Good
Example of following the rule

### ❌ Bad
Example of violating the rule

## Testing
How to verify compliance (if applicable)
```

---

## 🔗 How Rules Work

1. **Loading**: Rules are loaded when domain is initialized
2. **Application**: AI agents apply rules during workflow execution
3. **Validation**: Can be checked during code review

---

## ➕ Adding New Rules

See [Core Domain README](../README.md) for instructions.

---

**Note**: Rules will be created in Phase 1 development. This is a placeholder structure.
