# Goal
Analyze the current feature branch and spec to generate a summary commit message, then execute a merge script that performs a squash merge to the main branch.

# User Input

```text
${ARGUMENTS}
```

You MUST consider the user input before proceeding (if not empty).

# Steps

## 1. Prerequisites
Execute: `.contextual/scripts/bash/merge-prerequisites.sh`
This will output:
- ${CURRENT_BRANCH}: The current branch name
- ${MERGE_TEMPLATE}: The template for the commit message

## 2. Analyze Feature
- Use current changes, the git log, and User Input to generate a summary commit message called ${DESCRIPTION}
- Use ${MERGE_TEMPLATE} and ${DESCRIPTION} to generate a concise commit message called ${COMMIT_MESSAGE}

## 3. Execute Merge
- Execute: `.contextual/scripts/bash/merge.sh --message "${COMMIT_MESSAGE}"`
- Errors are handled by the merge script and exit if any errors occur

# Output
- Successful merge to main branch
- Squashed commit with generated message
- Feature branch remains for manual cleanup

# Next Steps
After running this command:
1. Review the merge results
2. Verify the commit message is appropriate
3. Clean up feature branch if desired (manual cleanup)

# Guidelines
- **Feature Branch Required**: Command must be run from a feature branch
- **Spec File Required**: Feature specification file must exist
- **Error Handling**: Abort on conflicts and show detailed error messages
- **No Branch Cleanup**: Feature branch is left intact for manual cleanup
- **No Task Validation**: Merge proceeds regardless of task completion status
