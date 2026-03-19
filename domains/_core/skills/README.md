# Core Skills

Reusable capabilities that can be composed into workflows.

---

## 🛠️ Available Skills

### parse-yaml.skill.yaml
Parse and validate YAML files.

### analyze-code.skill.yaml
Analyze code structure and patterns.

---

## 📐 Skill Schema

Skills are defined in YAML format:

```yaml
skill:
  id: "skill-name"
  name: "Human Readable Name"
  description: "What this skill does"
  version: "1.0.0"
  
  capabilities:
    - "Capability 1"
    - "Capability 2"
  
  inputs:
    - name: "input_name"
      type: "string|number|boolean|object"
      required: true
      description: "Input description"
  
  outputs:
    - name: "output_name"
      type: "string|object|array"
      description: "Output description"
  
  examples:
    - input: {...}
      output: {...}
  
  tags:
    - "parsing"
    - "validation"
```

---

## 🔗 How Skills Work

**Phase 2 Feature** - Skills will provide:

1. **Composition**: Combine skills into workflows
2. **Reusability**: Use across multiple domains
3. **Testing**: Validate skill behavior
4. **Documentation**: Clear capability definitions

---

## ➕ Adding New Skills

See [Core Domain README](../README.md) for instructions.

---

**Status**: Phase 2 - Skills framework is planned but not yet implemented.

**Current**: Placeholder structure for future development.
