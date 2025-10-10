# Feature: install-script-project-root-arg

## Overview
Update the `contextual install` command to accept an optional positional argument for the project root, providing a more convenient interface for users who want to specify the project directory without using the `--project-root` flag.

## Requirements
- Add support for optional positional argument as project root
- Maintain backward compatibility with existing `--project-root` flag
- Positional argument should take precedence over `--project-root` flag when both are provided
- When no project root is provided (neither positional argument nor `--project-root` flag), prompt user to enter project name (preserve current behavior)
- Only the first positional argument is treated as project root; show error and exit if additional positional arguments are provided
- When positional argument is provided but is not a valid directory path, show error and exit immediately with clear error message
- Update help text and usage examples to document the new positional argument
- Ensure the positional argument follows the same validation and processing as the existing flag

## Technical Specifications
- **Technology Stack**: Bash scripting (no changes to existing stack)
- **Architecture**: Modify argument parsing in `contextual` CLI and `install.sh` script
- **Dependencies**: No new dependencies required
- **File Changes**:
  - `contextual` - Update argument parsing to handle positional argument
  - `scripts/install.sh` - Modify argument parsing to accept positional argument
  - Help text and usage examples in both files

## Acceptance Criteria
- `contextual install /path/to/project` works as expected
- `contextual install /path/to/project --agent cursor` works with positional argument
- `contextual install --project-root /path/to/project` continues to work (backward compatibility)
- When both positional argument and `--project-root` are provided, positional argument takes precedence
- Help text shows both usage patterns clearly
- Error handling works correctly for invalid positional arguments
- All existing functionality remains unchanged

## Implementation Notes
- **Argument Parsing**: Modify the argument parsing logic to check for positional arguments before processing flags
- **Precedence**: Positional argument should override `--project-root` flag if both are provided
- **Validation**: Apply the same validation logic to positional arguments as existing flag
- **Help Text**: Update usage examples to show `contextual install [PROJECT_ROOT] [OPTIONS]` format with brackets indicating optional nature
- **Error Messages**: Show "Error: Invalid project root path: [path]. Please provide a valid directory path." for invalid directory paths
- **Multiple Arguments**: Show error and exit if additional positional arguments are provided beyond the first one

## Clarifications
### Session 2024-12-19
- Q: When no project root is provided (neither positional argument nor --project-root flag), what should the default behavior be? → A: Prompt user to enter project name (current behavior)
- Q: Should the script support multiple positional arguments or just the first one as project root? → A: Only the first positional argument is treated as project root, show error and exit for additional ones
- Q: How should the script handle cases where positional argument is provided but is not a valid directory path? → A: Show error and exit immediately with clear error message
- Q: What specific error message should be shown when an invalid directory path is provided as a positional argument? → A: "Error: Invalid project root path: [path]. Please provide a valid directory path."
- Q: How should the help text display the new positional argument option? → A: `contextual install [PROJECT_ROOT] [OPTIONS]` (brackets indicate optional)

## Tasks
- [x] Update `contextual` script to parse positional arguments before flags
- [x] Modify `scripts/install.sh` to accept and process positional argument
- [x] Update help text in both `contextual` and `install.sh` scripts
- [x] Add validation for positional argument format and existence
- [x] Implement precedence logic (positional argument overrides `--project-root`)
- [x] Update usage examples and documentation
- [x] Test backward compatibility with existing `--project-root` flag
- [x] Test new positional argument functionality
- [x] Test precedence behavior when both are provided

## Additional Tasks
- [x] `contextual update /path/to/project` which just calls the same `install.sh` script
- [x] add the positional argument tracking to the install.sh script.
- [x] run tests and update tests as needed
