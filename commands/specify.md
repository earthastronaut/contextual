---
config:
  SPECIFY_DIR: specs
  CONTEXT_ROOT: README.md
---
# Goal

Create a feature specification document based on user input.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command creates **DOCUMENTATION**, DO NOT MODIFY SOURCE CODE!

**File Modification Rules:**
- ✅ ONLY create files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md` (primary target)
- ✅ Any files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory
- ❌ NEVER touch source code, commands, configs
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- This command documents requirements, does NOT implement them
- When in doubt, you're probably trying to modify the wrong file

# User Input

```text
${ARGUMENTS}
```

**User Input Interpretation:**
- Focus on **WHAT** needs to be specified, not **HOW** to implement
- "Implement X" means "create specification for X"
- "Change Y" means "specify requirement for Y"
- "Fix Z" means "document Z needs fixing in spec"

# Steps

## 1. Check Current Branch

1. Check if we're in a git repository
2. If git available: get current branch → `${CURRENT_BRANCH}`
3. If no git or on `main`: suggest new branch name or use `feature/${TIMESTAMP}`
4. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
5. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`

## 2. Generate Context File

- Create directory `${FEATURE_DIR}/` if it does not exist
- Create `${FEATURE_CONTEXT}` file with this structure:

```markdown
# Overview
[What problem does this solve and what is the proposed solution? (2-3 sentences)]

# Scope
[List requirements, boundaries, and dependencies. Be specific and measurable. Do not include implementation details.]

# Solution
[Describe the solution. List the approach, challenges, validation, and references.]

# Tasks
[Plan and list the implementation tasks by phase. Be specific and measurable. Do not repeat yourself. Reference the solution and scope sections.]

## Phase 1: [Phase Name]
- [ ] task1
- [ ] task2
```

**Specification Best Practices:**
- Use `- [ ]` checkbox syntax for tasks
- Keep sections distinct with no duplication. Don't repeat yourself.
- Make requirements concrete and measurable
- Document acceptance criteria clearly

## 4. Update Context File

1. Analyze user input (previous section) to understand **WHAT** needs to be done
2. Use available tools to gather relevant context:
   - Read `${CONTEXT_ROOT}` if it exists to understand project context and patterns
   - Look for existing specifications to maintain consistency
   - Optionally Search codebase for related patterns
   - Optionally read existing specifications for consistency
   - Optionally research external resources if needed
3. Populate ${FEATURE_CONTEXT} with clear, concise, actionable information
4. Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
5. Use `- [ ]` for incomplete tasks

## 6. Validate Changes

**Before you finish, verify:**
- Created ONLY files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- Verify ${FEATURE_CONTEXT} has clear, concise, actionable information
- Did NOT touch command/source/config files
- Created specification, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

# Output

Summary:
- Branch: `${CURRENT_BRANCH}`
- Created: `${FEATURE_CONTEXT}`

# Next Steps

After running this command:
1. Review `${FEATURE_CONTEXT}` for completeness
2. Use `/clarify [info]` to refine the specification
3. Use `/plan` to create detailed implementation plan
4. Use `/analyze [folder] [depth]` to analyze project structure
5. Use `/implement` to execute tasks
6. Use `/commit` then `/merge` when complete

