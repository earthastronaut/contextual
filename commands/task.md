---
config:
  SPECIFY_DIR: ./specs
---
# Goal

Implement a single task and track it in the feature context.

**Quick one-off task command** - for small tasks that don't need full spec workflow.

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Find Specification

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
3. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`
4. If context file doesn't exist → create minimal context or warn user

## 2. Implement Task

Break down the user input (${ARGUMENTS}) into subtasks and execute them.

## 3. Track Task

1. Read ${FEATURE_CONTEXT}
2. Create "# Additional Tasks" section if it doesn't exist
3. Add `- [x] ${ARGUMENTS}` to the section
4. Save ${FEATURE_CONTEXT}

# Output

Summary:
- Completed task implementation
- Updated ${FEATURE_CONTEXT} with completed task marker

# Next Steps

After running this command:
1. Review the implementation results
2. Use `/commit` to commit the changes
3. Continue with next tasks

# Guidelines

**Task Execution:**
- Single task focus: Implement only one task at a time
- Task tracking: Mark task as complete in ${FEATURE_CONTEXT}
- Additional tasks: Use "# Additional Tasks" section for ad-hoc tasks

**Prefer /implement:**
- Use `/implement [task]` instead - same functionality, more flexible
- This command exists for backward compatibility
