# Goal
Create a commit based on current changes.

## User Input

```text
$ARGUMENTS
```

You MUST consider the user input before proceeding (if not empty). This may include the commit message or the files to commit.

## Steps

### 1. Check Current Git Status
Check current status `git status --porcelain`

### 2. Analyze the Changes
Look at the file paths and determine the commit type. (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`)
- Guidelines
    - Use directory name if changes are focused there
    - Omit scope if changes span multiple areas
    - Keep scope short and descriptive

### 3. Create Description
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

### 5. Format Commit Message
Create commit message
```text
{feat}: {description}
- feat: ./filename.sh
- fix: {description}
- fix: ./bug.sh
- docs: {description}
- test: {description}
- chore: {description}
```

### 6. Stage Changes
Choose one of these methods:
- Add all changes `git add .`
- Add specific files `git add path/to/file1 path/to/file2`

### 7: Commit
Execute: `git commit -m "{COMMIT_MESSAGE}"`

## Output
- Very concise summary of the commit

## Next Steps
- Review the commit message
- Push the changes to the remote repository
- `/merge` to merge the changes to the main branch
