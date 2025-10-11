# Goal
Implment a single task and add it to the {FEATURE_CONTEXT} file.

# Steps

## 1. Implement Tasks
Break down the user input into tasks and execute them.
```text
$ARGUMENTS
```

## 2. Track
Execute: `.contextual/scripts/bash/implement.sh` to get {FEATURE_CONTEXT} and add the task prompt to the file.
- Create section "# Additional Tasks" in {FEATURE_CONTEXT} if it doesn't exist.
- Add `- [x] "$ARGUMENTS"` to the section in {FEATURE_CONTEXT}.
