# Feature: merge-command

## Overview
Create a `.cursor/commands` called `merge.md` which will analyze the current feature branch and spec to generate a summary commit message for squashing. The command will then execute a `merge.sh` script that checks out the main branch, performs a `git merge --squash` operation, and commits with the generated message.

## Requirements
- Create `.cursor/commands/merge.md` file that analyzes current feature branch and spec
- Generate a concise, meaningful commit message based on feature analysis
- Execute `merge.sh` script that handles the git merge workflow
- Support configurable main branch name (default from config-utils.sh)
- Handle feature branch detection and validation (exit with error if not on feature branch)
- Provide clear error messages for invalid states
- Handle merge conflicts by aborting and showing detailed error messages

## Technical Specifications
- **Technology**: Bash scripting with Cursor command integration
- **Location**: `.cursor/commands/merge.md`
- **Dependencies**: 
  - `config-utils.sh` for MAIN_BRANCH configuration
  - `merge.sh` script for git operations
  - Git repository with feature branch structure
- **Configuration**: Uses MAIN_BRANCH from config-utils.sh (default: "main")
- **Git Operations**:
  - `git checkout $MAIN_BRANCH`
  - `git merge --squash $FEATURE_BRANCH`
  - `git commit -m "Merge feature/0003-merge-command: Brief description"`
- **Commit Message Format**: `Merge feature/{FEATURE_BRANCH}: {BRIEF_DESCRIPTION}` (git merge style)
- **Template Variable**: Overwrite template variable with generated message
- **Branch Cleanup**: Leave feature branch intact for manual cleanup (no automatic deletion)
- **Conflict Handling**: Abort merge and show error message with conflict details
- **Task Validation**: No validation of task completion status required before merge
- **Feature Branch Validation**: Show error and exit immediately if not on a feature branch

## Acceptance Criteria
- [x] `.cursor/command/merge.md` file exists and is executable
- [x] Command analyzes current feature branch name and spec content
- [x] Generates appropriate commit message based on feature analysis
- [x] Executes `merge.sh` script successfully
- [x] `merge.sh` checks out main branch correctly
- [x] `merge.sh` performs squash merge with generated message
- [x] Handles error cases (not on feature branch, no spec file, etc.)
- [x] Provides clear feedback during merge process
- [x] Uses MAIN_BRANCH configuration from config-utils.sh

## Implementation Notes
- The merge command should be a Cursor command that can be invoked with `/merge`
- Feature analysis should read the current branch name and corresponding spec file
- Commit message generation should extract key information from the spec
- `merge.sh` script should be created as a separate executable script
- Error handling should validate git repository state and branch structure
- Should integrate with existing contextual development workflow

## Tasks
- [x] Create `.cursor/command/merge.md` file
- [x] Implement feature branch and spec analysis logic
- [x] Create commit message generation algorithm
- [x] Create `merge.sh` script for git operations
- [x] Add error handling and validation
- [x] Test with existing feature branches
- [x] Integrate with config-utils.sh for MAIN_BRANCH
- [x] Add clear user feedback and progress messages

## Clarifications
### Session 2024-12-19
- Q: What format should the generated commit message follow? Should it include feature number, title, and key changes? → A: `Merge feature/0003-merge-command: Brief description` (git merge style) and overwrite template variable
- Q: Should the merge command clean up the feature branch after successful merge? → A: No, leave the feature branch intact for manual cleanup
- Q: How should the command handle conflicts during the squash merge? → A: Abort merge and show error message with conflict details
- Q: Should there be any validation that all tasks in the spec are completed before allowing merge? → A: No, allow merge regardless of task completion status
- Q: What should happen when the command is run outside of a feature branch? → A: Show error and exit immediately
