# Constraint Improvements for Command Templates

## Problem

AI tools were not respecting the file modification boundaries in specification-only commands like `/clarify`. Despite having constraints, the AI would still modify command files, source code, and other forbidden files when asked to "standardize command templates" or similar tasks.

## Root Cause

The original constraints were:
1. Not prominent enough (buried in the middle of the file)
2. Only stated negatively (what NOT to do)
3. Not repeated enough throughout the document
4. Lacked visual distinction
5. Missing explicit interpretation guidance for user input
6. No validation checkpoint before completion

## Solution: Enhanced Constraint Structure

See `clarify-template.md` for the complete improved template.

### Key Improvements

#### 1. **Prominent Placement**
- Move constraints to the **very top** after config frontmatter
- Use emoji (⚠️) for immediate visual attention
- Make it a major section, not a subsection

#### 2. **Dual Lists: Allowed vs Forbidden**
```markdown
**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md` - PRIMARY TARGET
- ✅ ANY files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

**FORBIDDEN MODIFICATIONS (NEVER TOUCH):**
- ❌ `commands/*.md` - Command definition files
- ❌ Source code files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory
```

**Why this works:**
- Positive examples show what IS allowed (reduces uncertainty)
- Negative examples show what is NOT allowed (sets boundaries)
- Visual markers (✅/❌) make it scannable
- Specific paths with explanations leave no ambiguity

#### 3. **Clear Purpose Statement**
```markdown
## THIS IS A SPECIFICATION-ONLY COMMAND

You are updating **DOCUMENTATION** about what needs to be done.
You are **NOT** implementing the changes described.
```

**Why this works:**
- Bold emphasis on key distinction
- Explicit statement that this is DOCUMENTATION
- Clear separation between planning and doing

#### 4. **User Input Interpretation Guide**
```markdown
**If user says:** "implement X" or "change Y" or "update Z"
**They mean:** Add this requirement to the specification
**NOT:** Make the actual code changes
```

**Why this works:**
- Addresses the exact failure case (responding to action verbs)
- Provides explicit mapping from user language to correct action
- Prevents misinterpretation of imperative requests

#### 5. **Multiple Reminders**
- **Top of file:** "⚠️ CRITICAL CONSTRAINTS ⚠️" section
- **After Output section:** "⚠️ FINAL CHECKPOINT ⚠️" with validation checklist
- **In Guidelines:** Repetition of core rules with examples

**Why this works:**
- Repetition reinforces the message
- Checkpoint before completion catches mistakes
- Multiple exposures at different points in the workflow

#### 6. **Validation Checklist**
```markdown
**Before you finish, verify:**
- [ ] Modified ONLY files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- [ ] Did NOT touch any command files (`commands/*.md`)
- [ ] Did NOT touch any source code files
- [ ] Did NOT touch any configuration files
- [ ] Updated specification, NOT implementation
```

**Why this works:**
- Forces explicit check before completion
- Checkbox format encourages actual verification
- Concrete, specific items to verify
- Catches errors before they're committed

#### 7. **Visual Hierarchy**
- Use of horizontal rules (`---`) to separate sections
- Multiple heading levels for organization
- Code blocks for examples
- Tables for option presentation
- Bold and CAPS for emphasis

**Why this works:**
- Makes the document easier to scan
- Critical information stands out visually
- Structure guides attention to important parts

## Application

These improvements should be applied to all specification-only commands:
- `/specify` - Creates specifications (should only modify `specs/` directory)
- `/clarify` - Updates specifications (should only modify `specs/` directory)
- `/plan` - Creates plans (should only modify `specs/` directory)
- `/analyze` - Creates analysis (should only modify `specs/` directory)

Commands that DO modify source code (`/implement`, `/commit`, `/merge`) don't need these constraints.

## Success Criteria

After applying this template:
1. AI should NEVER modify command files when running `/clarify`
2. AI should correctly interpret "implement X" as "add X to spec"
3. AI should self-check before completion
4. No source code modifications during specification commands
5. Clear user feedback about what was modified and where

## Testing

To test if constraints are working:
1. Run `/clarify still standardize the command templates with a format`
2. AI should UPDATE the specification, NOT the command files
3. AI should add tasks/requirements to the spec about standardization
4. AI should NOT directly modify `commands/*.md` files

