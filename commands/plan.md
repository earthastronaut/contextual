---
config:
  SPECIFY_DIR: ./specs
---
# Goal

Create a detailed implementation plan from the feature specification and organize tasks into `plan.md`.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command creates **PLANNING DOCUMENTATION**, DO NOT MODIFY SOURCE CODE!

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md`
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/plan.md` (primary target)
- ✅ Any files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Find Specification

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Verify not on `main` - if on main, STOP and tell user to switch
3. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
4. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`
5. If context doesn't exist → tell user to run `/specify` first

## 2. Analyze Context

- Extract requirements, specs, and acceptance criteria from ${FEATURE_CONTEXT}
- Identify key components and features to implement

## 3. Examine Existing Code

- If `${FEATURE_DIR}/analyzed.md` exists, review that analysis first
- Otherwise, scan project for existing code and configurations
- Don't examine ${SPECIFY_DIR} directories
- Identify what's implemented vs. missing

## 4. Generate Plan

- Create focused task breakdown (max 10 tasks, fewer is better)
- Organize into logical phases (e.g., "Phase 1: Foundation")
- Use `- [ ]` syntax for all tasks
- Prioritize by dependency and importance
- Include only essential technical decisions

## 5. Create Plan File

Generate `${FEATURE_DIR}/plan.md` with:
- Concise, actionable implementation steps
- Critical decisions and next steps
- Phase-organized tasks

## 6. Update Context

- Add plan summary to ${FEATURE_CONTEXT}
- Link to plan.md
- Preserve existing content and structure

## 7. Validate Changes

Before completing:
1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify plan.md has clear, actionable tasks
3. Check no source code or command files were touched

# Output

Summary:
- Created: `${FEATURE_DIR}/plan.md`
- Updated: `${FEATURE_CONTEXT}` with plan link
- Task count and phase organization
- Key technical decisions

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Modified ONLY `${SPECIFY_DIR}/${CURRENT_BRANCH}/` files
- [ ] Did NOT touch command/source/config files
- [ ] Created plan documentation, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

# Next Steps

After running this command:
1. Review `${FEATURE_DIR}/plan.md` for completeness
2. Use `/clarify` to resolve any remaining ambiguities
3. Use `/implement` to begin executing the plan
4. Update plan as needed during implementation

# Guidelines

**Plan Best Practices:**
- Use `- [ ]` checkbox syntax for all tasks
- Organize into logical phases
- Keep focused (max 10 tasks, fewer is better)
- Prioritize by dependency and importance
- Include only essential technical decisions
- Maintain brief, scannable format

**File Modification Rules:**
- ✅ ONLY modify files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, configs
- This command creates plan documentation, NOT implementation
- When in doubt, you're probably modifying the wrong file

**Scope Boundaries:**
- Scan existing code to understand what's implemented
- Follow links and files for domain context
- But ONLY modify files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- Create specifications only, don't implement the feature
