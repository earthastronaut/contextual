# Goal
Implement a single task and add it to the ${FEATURE_CONTEXT} file.

# User Input

```text
${ARGUMENTS}
```

You MUST consider the user input before proceeding (if not empty).

# Steps

## 1. Implement Task
Break down the user input into tasks and execute them.

## 2. Track Task
Execute: `.contextual/scripts/bash/implement.sh` to get ${FEATURE_CONTEXT} and add the task prompt to the file.
- Create section "# Additional Tasks" in ${FEATURE_CONTEXT} if it doesn't exist.
- Add `- [x] "${ARGUMENTS}"` to the section in ${FEATURE_CONTEXT}.

# Output
- Completed task implementation
- Updated ${FEATURE_CONTEXT} with completed task marker

# Next Steps
After running this command:
1. Review the implementation results
2. Use `/commit` to commit the changes
3. Continue with next tasks

# Guidelines
- **Single task focus**: Implement only one task at a time
- **Task tracking**: Mark task as complete in ${FEATURE_CONTEXT}
- **Additional tasks**: Use "# Additional Tasks" section for ad-hoc tasks
