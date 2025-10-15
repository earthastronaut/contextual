---
config:
  SPECIFY_DIR: ./specs
---
# Goal

Create a feature specification document based on user input.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command creates **DOCUMENTATION**, DO NOT MODIFY SOURCE CODE!

**If user says:** "implement X" or "change Y" or "update Z"  
**They mean:** Create a specification for this requirement  
**NOT:** Make the actual code changes

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md` (primary target)
- ✅ Any files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

# User Input

```text
${ARGUMENTS}
```

**How to interpret user input:**
- Focus on **WHAT** needs to be specified, not **HOW** to implement
- "implement X" → create specification for X
- "change Y" → add Y to requirements
- "fix Z" → document Z as needing attention

# Steps

## 1. Check Current Branch

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Verify not on `main` - if on main, STOP and suggest new branch name
3. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
4. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`

## 2. Create Specification Directory

Run: `mkdir -p ${FEATURE_DIR}`

## 3. Generate Context File

Create `${FEATURE_CONTEXT}` with this structure:

```markdown
# Overview
What problem does this solve and what is the proposed solution? (2-3 sentences)

# Scope
- **Changes**: Specific files/components to modify
- **Requirements**: Concrete deliverables (be specific and measurable)
- **Boundaries**: What explicitly will not change
- **Dependencies**: New packages or integrations if any

# Solution
- **Approach**: Key architectural decisions or design patterns
- **Challenges**: Known constraints or technical considerations
- **Validation**: How to verify it works correctly
- **References**: Links to plans or external resources if needed

# Tasks

## Phase 1: Description
- [ ] task 1
- [ ] task 2
```

## 4. Populate with User Request

1. Analyze user request (${ARGUMENTS}) to understand **WHAT** needs to be done
2. Scan project for relevant context and patterns as needed
3. Do external research if needed to understand the request
4. Populate ${FEATURE_CONTEXT} with clear, actionable information
5. Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
6. Use `- [ ]` for incomplete tasks

## 5. Validate Changes

Before completing:
1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify ${FEATURE_CONTEXT} has clear, actionable information
3. Check no source code or command files were touched

# Output

Summary:
- Branch: `${CURRENT_BRANCH}`
- Created: `${FEATURE_CONTEXT}`
- Content overview with key sections

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Created ONLY files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- [ ] Did NOT touch command/source/config files
- [ ] Created specification, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

# Next Steps

After running this command:
1. Review `${FEATURE_CONTEXT}` for completeness
2. Use `/clarify [info]` to refine the specification
3. Use `/plan` to create detailed implementation plan
4. Use `/analyze [folder] [depth]` to analyze project structure
5. Use `/implement` to execute tasks
6. Use `/commit` then `/merge` when complete

# Guidelines

**Specification Best Practices:**
- Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
- Use `- [ ]` checkbox syntax for tasks
- Focus on **WHAT** needs to be specified, not **HOW**
- Keep sections distinct with no duplication
- Make requirements concrete and measurable
- Document acceptance criteria clearly

**File Modification Rules:**
- ✅ ONLY create files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, configs
- This command documents requirements, does NOT implement them
- When in doubt, you're probably trying to modify the wrong file

**User Input Interpretation:**
- "Implement X" means "create specification for X"
- "Change Y" means "specify requirement for Y"
- "Fix Z" means "document Z needs fixing in spec"
