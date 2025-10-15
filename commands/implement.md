---
config:
  SPECIFY_DIR: specs
---
# Goal

Implement tasks from spec (spec-driven) OR execute a one-off task (ad-hoc).

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Find Specification

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Verify not on `main` - if on main, STOP
3. Set `${FEATURE_CONTEXT}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md`
4. If context doesn't exist → tell user to run `/specify` first

## 2. Determine Mode (Use Judgment)

Read ${FEATURE_CONTEXT} first, then decide:

**When user input specifies existing phase, task, or section:**
- → Spec-Driven Mode (3B)
- Filter and implement only matching tasks
- Examples: "phase 1", "task 2", "authentication tasks"

**When user input is a new instruction:**
- → One-Off Mode (3A)
- Implement as ad-hoc task and track it
- Examples: "update README", "add error handling", "fix typo"

**Otherwise if uncertain or user input is empty:**
- → Spec-Driven Mode (3B)
- Implement next phase of uncompleted tasks

## 3A. One-Off Task Mode

1. Implement the task (${ARGUMENTS})
2. Track in ${FEATURE_CONTEXT}:
   - Create "# Additional Tasks" section if needed
   - Add `- [x] ${ARGUMENTS}`
3. Skip to Output (step 4)

## 3B. Spec-Driven Mode

1. **Find linked files**: Scan ${FEATURE_CONTEXT} for links, follow recursively (depth: 3)
   - Patterns: `[text](path)`, `@file`, `./path`, `[[link]]`, `$VAR`
   - Types: .md, .txt, .json, .yaml, .js, .ts, .py, .sh
   - Skip: External URLs, binaries

2. **Extract tasks** from all files:
   - Uncompleted: `- [ ]`, `* [ ]`, `+ [ ]`
   - Ignore completed: `- [x]`, `* [x]`, `+ [x]`
   - Markers: `[HIGH]`, `[MEDIUM]`, `[LOW]`, `[CRITICAL]`, `TODO:`, `FIXME:`

3. **Filter tasks** (if user input provided):
   - Phase/section name → tasks in that section
   - Task number → specific task
   - Keywords → matching descriptions
   - None → next phase of uncompleted tasks

4. **Execute**:
   - Organize by priority and dependencies
   - Implement tasks, mark `[x]` in relevant files after each
   - Continue on errors (halt only for critical failures)

## 4. Output

**One-Off Mode:**
- Task complete: `- [x] ${ARGUMENTS}` in "# Additional Tasks" section of ${FEATURE_CONTEXT}

**Spec-Driven Mode:**
- Concise summary of progress
- All files updated with `[x]` markers
- Suggested commit message: `"feat: implement ${FEATURE}"`

# Next Steps

After running this command:
1. Review implementation results
2. Use `/commit` to save changes
3. Use `/clarify` if ambiguities arise

# Guidelines

**Mode Selection:**
1. Read ${FEATURE_CONTEXT} to see what tasks exist
2. If input references spec (phase/task/keyword) → Spec-driven
3. If input is new instruction → One-off
4. If no input → Spec-driven (all tasks)

**Task Tracking:**
- Spec-driven: Mark `[x]` in ALL files containing the task
- One-off: Add to "# Additional Tasks" section

**Error Handling:**
- Continue on non-critical failures
- Document issues
- Only halt for critical errors
