---
config:
  SPECIFY_DIR: specs
---
# Goal

Implement a single task, which doesn't need full spec-driven workflow, and track it in the feature context.

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Find Specification

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
3. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`
4. If context doesn't exist → create minimal context or warn user

## 2. Implement Task

1. **Analyze the task**: Understand what needs to be done based on ${ARGUMENTS}
2. **Break down into subtasks**: Identify specific steps required to complete the task
3. **Execute each subtask**: Implement changes systematically, one step at a time
4. **Validate implementation**: Ensure the task is fully completed and working
5. **Handle any errors**: Address issues that arise during implementation

## 3. Track

1. Read ${FEATURE_CONTEXT}
2. Create "# Additional Tasks" section if it doesn't exist
3. Add `- [x] ${ARGUMENTS}` to the section
4. Save ${FEATURE_CONTEXT}

# Output

Brief summary of changes implemented..

# Next Steps

1. Review changes in ${FEATURE_CONTEXT}
2. Use `/commit` to commit the changes

# Guidelines

**Task Execution:**
- Single focus: Implement only one task at a time
- Task tracking: Mark tasks as complete in ${FEATURE_CONTEXT}
- Additional tasks: Use "# Additional Tasks" section for ad-hoc tasks
