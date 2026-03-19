# Core Domain

Shared rules, skills, and utilities used across all domains.

---

## 🎯 Purpose

The `_core` domain provides foundational resources that are used by all other domains:

- **Rules**: Behavioral constraints for AI agents
- **Skills**: Reusable capabilities that can be composed into workflows
- **Utilities**: Common functions and helpers

This domain is always enabled and loaded first.

---

## 📋 Rules

Rules define how AI agents should behave when executing workflows.

### Available Rules

#### no-fabrication.md
**Never fabricate information**

- Always use actual data from code/config
- Mark uncertain items with `needs-human: true`
- Don't assume or invent missing information
- Document what exists, not what should exist

**Why:** Ensures documentation accuracy and trustworthiness

---

#### minimal-changes.md
**Make minimal, focused changes**

- Avoid over-engineering
- Keep changes scoped to requirements
- Don't add unnecessary features
- Follow existing patterns and style

**Why:** Reduces risk and maintains codebase consistency

---

## 🛠️ Skills

Skills are reusable capabilities that can be composed into workflows.

### Available Skills

#### parse-yaml.skill.yaml
**Parse and validate YAML files**

Capabilities:
- Parse YAML syntax
- Validate schema
- Extract values
- Handle errors gracefully

**Used by:** Configuration analysis, metadata parsing

---

#### analyze-code.skill.yaml
**Analyze code structure and patterns**

Capabilities:
- Detect frameworks and libraries
- Extract class/method signatures
- Identify design patterns
- Map dependencies

**Used by:** Architecture extraction, code review

---

## 📦 Structure

```
domains/_core/
├── rules/
│   ├── no-fabrication.md
│   └── minimal-changes.md
├── skills/
│   ├── parse-yaml.skill.yaml
│   └── analyze-code.skill.yaml
├── .domain-metadata.yaml
└── README.md (this file)
```

---

## 🔗 Usage

Core resources are automatically available to all domains.

**In domain metadata:**
```yaml
dependencies:
  - _core  # Explicitly declare core dependency
```

**In workflows:**
Rules are automatically applied. Skills can be invoked as needed.

---

## ➕ Adding New Rules

1. Create `rules/my-rule.md` following the format:
   ```markdown
   # Rule Name
   
   ## Directive
   Clear statement of what to do/not do
   
   ## Rationale
   Why this matters
   
   ## Examples
   Good and bad patterns
   ```

2. Update `.domain-metadata.yaml`:
   ```yaml
   rules:
     - id: "my-rule"
       file: "rules/my-rule.md"
       description: "Brief description"
   ```

3. Document in this README

---

## ➕ Adding New Skills

1. Create `skills/my-skill.skill.yaml` following the schema
2. Update `.domain-metadata.yaml`
3. Document in this README
4. Add tests/examples

---

## 📊 Status

**Current Status:** Phase 1 - Foundation

- ✅ Rules framework defined
- ⏳ Skills framework (Phase 2)
- ⏳ Skill composition (Phase 2)
- ⏳ Skill testing (Phase 2)

---

## 🔐 Maintenance

Core domain changes should be:
- Carefully reviewed (affects all domains)
- Backward compatible
- Well documented
- Tested across all domains

---

**Version**: 1.0.0  
**Last Updated**: March 2026  
**Owner**: Platform Engineering
