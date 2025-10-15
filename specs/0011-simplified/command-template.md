# Standard Command Template

Standardized structure for creating commands in `/commands`. See existing commands for reference examples.

## Core Template

```markdown
---
config:
  VARIABLE_NAME: default_value
---
# Goal
[1-3 sentences describing what this command does]

# User Input
```text
${ARGUMENTS}
```

# Steps
## 1. [Step Name]
1. [Sub-step 1]
2. `command example` → `${OUTPUT_VARIABLE}`

# Output
[What the command produces]
- [Files created/modified]

# Next Steps
1. [Recommended next action]

# Guidelines
- **[Category]**: [Best practice or constraint]
```

### For Spec-Only Commands (Documentation/Research Only)

Add these constraint sections to the core template:

```markdown
# Goal
[Goal description]

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command creates **DOCUMENTATION/RESEARCH**, DO NOT MODIFY SOURCE CODE!

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/[files]`

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

[... rest of template ...]

## [Final Step]. Validate
1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify no source code or command files touched

# ⚠️ FINAL CHECKPOINT ⚠️
- [ ] Modified ONLY `${SPECIFY_DIR}/${CURRENT_BRANCH}/` files
- [ ] Did NOT touch command/source/config files
```

---

## Command Types Comparison

| Type | Purpose | Examples | Key Features |
|------|---------|----------|-------------|
| **Spec-Only** | Create/modify documentation only | `specify`, `clarify`, `plan`, `analyze` | Triple constraint enforcement, validation steps, no source code changes |
| **Implementation** | Modify source code | `implement`, `commit`, `merge` | Git integration, task tracking, can change any files |
| **Context Mgmt** | Manage contextual info | `contextualize` | Modifies `.contextual/context/` only |

---

## Standard Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `${ARGUMENTS}` | User input to command | `feature-name --flag` |
| `${CURRENT_BRANCH}` | Current git branch | `0011-simplified` |
| `${SPECIFY_DIR}` | Specs root directory | `./specs` |
| `${FEATURE_DIR}` | Feature directory | `./specs/0011-simplified` |
| `${FEATURE_CONTEXT}` | Main context file | `./specs/0011-simplified/context.md` |
| `${MAIN_BRANCH}` | Main branch name | `main` |
| `${CONTEXTUAL_ROOT}` | Context data root | `.contextual/context` |

**Conventions:**
- Use UPPERCASE for all config variables
- Format: `${VARIABLE_NAME}` in command text
- Define in YAML frontmatter with defaults
- Can be overridden by `.contextual/config.yaml`

---

## Formatting Quick Reference

| Element | Syntax | Usage |
|---------|--------|-------|
| **Headers** | `#`, `##`, `###` | Major sections, steps, sub-steps |
| **Bold** | `**text**` | Constraints, important notes |
| **Code** | `` `text` `` | Variables, paths, commands |
| **Code Block** | ` ```language ``` ` | Multi-line code/examples |
| **Lists** | `-`, `1.`, `- [ ]` | Bullets, sequences, tasks |
| **Markers** | ✅ ❌ ⚠️ | Allowed, forbidden, warnings |

---

## Best Practices

**Clarity:**
- Use concrete, actionable language with examples
- Define variables before using them
- Be explicit about what IS and ISN'T allowed

**Constraints (Spec-Only Commands):**
- **Triple reinforcement**: Top (Goal) → During (Validation Step) → End (Final Checkpoint)
- Use visual markers (✅/❌) and strong negative language ("NEVER", "FORBIDDEN")
- Include concrete examples and pre-completion checklist

**User Input:**
- Show `${ARGUMENTS}` placeholder and interpretation guide
- Define parameter format and defaults
- For spec-only: explain action verb interpretation (e.g., "implement X" → document X in spec)

**Dual-Mode Commands:**
- Clearly define when each mode applies with examples
- Document mode selection logic explicitly

---

## Creating a New Command

1. **Choose type** (spec-only, implementation, context management)
2. **Copy reference command** as starting point (see examples below)
3. **Update frontmatter** with config variables
4. **Write sections** following core template structure
5. **Add constraints** if spec-only (use template above)
6. **Test** with various inputs and update docs

**Essential Validation Checklist:**
- [ ] YAML frontmatter with required variables
- [ ] Goal clearly states command purpose
- [ ] Steps are numbered and actionable
- [ ] Output describes what gets produced
- [ ] For spec-only: Critical constraints at top, validation step, final checkpoint
- [ ] Variables use `${UPPERCASE_WITH_UNDERSCORES}` format
- [ ] Visual markers (✅/❌/⚠️) used appropriately
- [ ] Language is clear and concrete

---

## Reference Examples

| Example | Lines | Type | Features |
|---------|-------|------|----------|
| `task.md` | 55 | Implementation | Minimal structure, basic task execution |
| `clarify.md` | 86 | Spec-Only | Full constraint structure with validation |
| `implement.md` | 101 | Implementation | Dual-mode with intelligent selection |
| `analyze.md` | 475 | Spec-Only | Multi-path with conditional steps |

---

**Notes:**
- All commands are pure markdown prompts (no bash scripts)
- AI interprets commands and generates structure dynamically
- Commands in `/commands` symlinked to `.contextual/commands/` by install script
