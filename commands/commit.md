# Goal
Create a commit based on current changes.

# User Input

```text
${ARGUMENTS}
```

You MUST consider the user input before proceeding (if not empty). This may include the commit message or the files to commit.

# Steps

## 1. Check Current Git Status
Check current status `git status --porcelain`

## 2. Analyze the Changes
Look at the file paths and determine the commit type. (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`)
- Guidelines
    - Use directory name if changes are focused there
    - Omit scope if changes span multiple areas
    - Keep scope short and descriptive

## 3. Create Description
Based on the main files changed:
- Keep it concise and descriptive
- Examples:
  - "add merge command with prerequisites check"
  - "update configuration utilities"
  - "add new test cases"
- Guidelines
    - Start with lowercase letter
    - Use present tense ("add" not "added")
    - Be specific but concise
    - Focus on the main change

## 4. Format Commit Message
Create commit message following conventional commits format:
```text
${TYPE}: ${DESCRIPTION}
```

Examples:
- `feat: add merge command with prerequisites check`
- `fix: correct function name in validate_feature_setup`
- `docs: update README with installation instructions`
- `test: add unit tests for config utilities`
- `chore: update dependencies`

## 5. Stage Changes
Add all changes `git add .` or add specific files `git add path/to/file1 path/to/file2`

## 6. Commit
Execute: `git commit -m "${COMMIT_MESSAGE}"`

# Output
- Very concise summary of the commit

# Next Steps
After running this command:
1. Review the commit message
2. Push the changes to the remote repository
3. Use `/merge` to merge the changes to the main branch
