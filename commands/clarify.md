---
config:
  SPECIFY_DIR: specs
  CONTEXT_ROOT: README.md
---
# Goal

Update the feature specification based on user input or resolve clarification markers.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command updates **SPECIFICATION DOCUMENTS**, DO NOT MODIFY SOURCE CODE!

**User input interpretation:**
- "implement X" → Add X to the spec
- "change Y" → Update spec to include Y  
- You document requirements, you don't code them

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/` files only

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

# User Input

```text
${ARGUMENTS}
```

**How to interpret user input:**
- Focus on **WHAT** needs to be in the specification
- Ignore action verbs: "implement", "change", "update", "fix", "create"
- Extract the **intent**: what feature/requirement needs specifying
- Update specification with this information
- DO NOT make actual code changes

# Steps

## 1. Find Specification

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set `${FEATURE_CONTEXT}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md`
3. If doesn't exist → tell user to run `/specify` first

## 2. Read Current State

1. Read `${FEATURE_CONTEXT}` and related files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. If `${CONTEXT_ROOT}` exists, read only relevant parts to understand project context for this clarification.

## 3. Update Specification

**If user provided input:**
1. Determine what needs to be SPECIFIED (not implemented)
2. Update relevant sections in `${FEATURE_CONTEXT}`:
   - Overview, Scope, Solution, Tasks
3. Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
4. Keep organized and non-redundant

**If NO user input:**
1. Find `[NEEDS CLARIFICATION: question?]` markers
2. Present ONE question at a time with options:
   ```
   | Option | Answer |
   |--------|--------|
   | A      | [first option] |
   | B      | [second option] |
   | Short  | [custom answer] |
   ```
3. Wait for answer (A/B/Short), update spec, continue (max 7 per session)
4. If none found → report complete, suggest next steps

## 4. Validate Changes

Before completing:
1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify ${FEATURE_CONTEXT} has clear, actionable information
3. Check no source code or command files were touched

# Output

Summary:
- Sections modified
- New information added
- Remaining clarifications needed
- Updated file: `${FEATURE_CONTEXT}`

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Modified ONLY `${SPECIFY_DIR}/${CURRENT_BRANCH}/` files
- [ ] Did NOT touch command/source/config files
- [ ] Updated specification, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

# Next Steps

After running this command:
1. Review updated `${FEATURE_CONTEXT}`
2. Run `/clarify` again if more clarifications needed
3. Use `/plan` to create implementation plan
4. Use `/implement` to execute tasks

# Guidelines

**Global Context:**
- Read `${CONTEXT_ROOT}` if it exists and relevant to understand project conventions
- Use global context to inform clarifications and resolve ambiguities where relevant.

**Specification Updates:**
- Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
- Use `- [ ]` for incomplete tasks
- Focus on WHAT to specify, not HOW to implement
- Keep sections distinct, no duplication
- Make requirements concrete and measurable

**File Modification Rules:**
- ✅ ONLY edit files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, configs
- This command updates documentation, NOT implementation
- When in doubt, you're probably modifying the wrong file
