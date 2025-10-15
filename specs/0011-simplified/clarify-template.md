---
config:
  SPECIFY_DIR: ./specs
---
# Goal

Update the feature specification based on user input. 

You're working with a spec-driven workflow where each git branch has a corresponding specification in `${FEATURE_CONTEXT}`. This command helps refine that specification by:
- Incorporating new information and requirements
- Resolving ambiguities and clarifications  
- Improving clarity and actionability
- Adding implementation details to the plan/spec

**CRITICAL CONSTRAINT: YOU MUST ONLY MODIFY FILES WITHIN THE SPECIFICATION DIRECTORY**

THIS IS A SPECIFICATION-ONLY COMMAND

You are updating **DOCUMENTATION** about what needs to be done.
You are **NOT** implementing the changes described.

**If user says:** "implement X" or "change Y" or "update Z"
**They mean:** Add this requirement to the specification
**NOT:** Make the actual code changes

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md` - PRIMARY TARGET
- ✅ ANY files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

**FORBIDDEN MODIFICATIONS (NEVER TOUCH):**
- ❌ `*/commands/*.md` - Command definition files
- ❌ `README.md` - Project documentation
- ❌ Source code files (*.js, *.sh, *.py, *.ts, etc.)
- ❌ Configuration files (package.json, .gitignore, etc.)
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

# User Input

```text
${ARGUMENTS}
```

**How to interpret user input:**
- Focus on **WHAT** needs to be in the specification
- Ignore action verbs: "implement", "change", "update", "fix", "create", "add", "modify"
- Extract the **intent**: what feature/requirement needs to be specified
- Update the specification document with this information
- DO NOT make the actual code changes described

# Steps

## 1. Find Specification

1. Run: `git branch --show-current` to get `${CURRENT_BRANCH}`
2. Set `${FEATURE_CONTEXT}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md`
3. If file doesn't exist → STOP and tell user to run `/specify` first

## 2. Understand Current State

1. Read current specification from `${FEATURE_CONTEXT}`
2. Check for related files:
   - `${SPECIFY_DIR}/${CURRENT_BRANCH}/plan.md` (implementation plan)
   - `${SPECIFY_DIR}/${CURRENT_BRANCH}/analyzed/` (analysis files)
3. Understand the existing requirements and scope

## 3. Update Specification

### If user provided input:

1. Analyze the user request to understand **WHAT needs to be SPECIFIED** (not implemented)
2. Determine which section(s) of `${FEATURE_CONTEXT}` need updates:
   - **Overview** - What problem and solution
   - **Scope** - Changes, requirements, boundaries, dependencies
   - **Solution** - Approach, challenges, validation, references
   - **Tasks** - Phases and task list
3. Update **ONLY** `${FEATURE_CONTEXT}` (and related files in same directory if needed)
4. Add `[NEEDS CLARIFICATION: question?]` for any ambiguous areas
5. Keep information organized and non-redundant

**REMEMBER:** You are describing what needs to be built, not building it.

### If NO user input provided:

1. Scan specification for `[NEEDS CLARIFICATION: question?]` markers
2. If clarifications found:
   - Present **ONE** question at a time in table format:
   
   ```
   | Option | Answer |
   |--------|--------|
   | A      | [first option] |
   | B      | [second option] |
   | Short  | [custom answer] |
   ```
   
   - Wait for user answer (A, B, or Short)
   - Replace marker with answer in specification
   - Save `${FEATURE_CONTEXT}`
   - Continue to next clarification (max 5 per session)
3. If no clarifications found:
   - Report specification is complete
   - Suggest next steps (plan, analyze, implement)

## 4. Validate Changes

Before completing:
1. Confirm you ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify `${FEATURE_CONTEXT}` has clear, actionable information
3. Check that no source code or command files were touched

# Output

Brief summary of what was updated in the specification:
- Which sections were modified
- What new information was added
- Any clarifications still needed
- Path to updated file: `${FEATURE_CONTEXT}`

---

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Modified ONLY files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- [ ] Did NOT touch any command files (`commands/*.md`)
- [ ] Did NOT touch any source code files
- [ ] Did NOT touch any configuration files
- [ ] Updated specification, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

---

# Next Steps

1. Review the updated specification in `${FEATURE_CONTEXT}`
2. (Optional) Use `/plan` to create an implementation plan
3. (Optional) Use `/analyze [folder]` to analyze project structure  
4. Use `/implement` to implement the planned tasks
5. Use `/commit` to commit changes
6. Use `/merge` to merge the feature into main

# Guidelines

**Specification Best Practices:**
- Add `[NEEDS CLARIFICATION: question?]` for ambiguous areas
- Use `- [ ]` checkbox syntax for incomplete tasks
- Focus on **WHAT** needs to be specified, not **HOW** to implement
- Keep sections distinct with no duplicate information
- Make requirements concrete and measurable
- Document acceptance criteria clearly

**File Modification Rules:**
- ✅ ONLY edit files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, configs, or other files
- This command documents requirements, it does NOT implement them
- When in doubt, you're probably trying to modify the wrong file

**User Input Interpretation:**
- User describes requirements, not implementations
- "Implement X" means "add X to the specification"
- "Change Y" means "update the specification to include Y"
- "Fix Z" means "document that Z needs fixing in the spec"

