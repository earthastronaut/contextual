---
config:
  MAIN_BRANCH: main
  MERGE_TEMPLATE: |
    Merge {FEATURE_BRANCH}: {DESCRIPTION}
    - {commit_hash}: one line per commit included.
    ...
    spec: {FEATURE_CONTEXT}
---
# Goal

Analyze the current feature branch and spec to generate a summary commit message, then perform a squash merge to main branch.

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Check Prerequisites

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set `${MAIN_BRANCH}` = `main` (from config)
3. Verify NOT on ${MAIN_BRANCH} - if on main, STOP with error
4. Check for uncommitted changes: `git diff-index --quiet HEAD --`
   - If uncommitted changes exist → STOP, tell user to commit first
5. Check for untracked files: `git ls-files --others --exclude-standard`
   - If untracked files exist → WARN user but continue

## 2. Analyze Feature & Generate Commit Message

1. Get changed files: `git diff --name-only ${MAIN_BRANCH}...${CURRENT_BRANCH}`
2. Look for any `context.md` files in the changes
3. If `context.md` files found → read them as ${FEATURE_CONTEXT}
4. Review git log: `git log ${MAIN_BRANCH}..${CURRENT_BRANCH} --oneline`
5. Consider user input and ${FEATURE_CONTEXT} to generate:
   - `${DESCRIPTION}` (2-3 sentences describing the feature)
6. Set `${COMMIT_MESSAGE}` using ${MERGE_TEMPLATE}:
   - Replace `{FEATURE_BRANCH}` with ${CURRENT_BRANCH}
   - Replace `{DESCRIPTION}` with ${DESCRIPTION}
   - Replace `{FEATURE_CONTEXT}` with path to context.md file(s)

## 3. Execute Merge

1. Checkout main: `git checkout ${MAIN_BRANCH}`
   - If fails → STOP with error
2. Squash merge: `git merge --squash ${CURRENT_BRANCH}`
   - If conflicts → STOP, tell user to resolve manually
3. Commit: `git commit -m "${COMMIT_MESSAGE}"`
   - If fails → STOP with error
4. Report success

# Output

Summary:
- Successful merge to ${MAIN_BRANCH} branch
- Squashed commit with generated message
- Feature branch remains for manual cleanup

# Next Steps

After running this command:
1. Review the merge results
2. Verify the commit message is appropriate
3. Clean up feature branch if desired (manual cleanup)

# Guidelines

**Prerequisites:**
- Must be run from feature branch (not ${MAIN_BRANCH})
- Feature specification file must exist
- No uncommitted changes allowed

**Merge Behavior:**
- Squash merge combines all commits into one
- Feature branch left intact for manual cleanup
- No automatic task validation (merges regardless of completion status)

**Error Handling:**
- Abort on conflicts and show detailed error messages
- Stop on any git operation failures
