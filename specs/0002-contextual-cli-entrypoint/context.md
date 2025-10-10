# Feature: contextual-cli-entrypoint

## Overview
Create a `contextual` bash script entrypoint that serves as the main command-line interface for the contextual development tools. This script will provide subcommands that reference existing scripts in a `/scripts` folder, allowing users to run commands like `contextual install --args` and `contextual run-tests`.

## Requirements
- Create a `contextual` bash script at the project root
- Reference scripts in a `/scripts` folder containing `install.sh` and `run-tests.sh`
- Support subcommands: `install`, `run-tests` (or `test`), `help`, and `version`
- Pass through command-line arguments to the underlying scripts
- Provide help/usage information for the main command and subcommands
- Maintain compatibility with existing script functionality

## Technical Specifications
- **Technology**: Bash scripting
- **Location**: Project root (`/contextual`)
- **Scripts Directory**: `/scripts/` containing:
  - `install.sh` - Contextual development tools installer
  - `run-tests.sh` - Test runner for contextual development tools
- **Subcommands**:
  - `contextual install [--args]` → `scripts/install.sh [--args]`
  - `contextual run-tests [--args]` → `scripts/run-tests.sh [--args]`
  - `contextual test [--args]` → `scripts/run-tests.sh [--args]` (alias)
  - `contextual help` → Show contextual CLI usage and brief description of each subcommand
  - `contextual version` → Show contextual CLI version information (hardcoded in script)
- **Error Handling**: Add contextual wrapper error messages before passing through underlying script errors and exit codes
- **Help System**: Built-in help for main command and subcommands

## Acceptance Criteria
- [x] `contextual` script exists at project root and is executable
- [x] `contextual install --help` shows install script help
- [x] `contextual run-tests --help` shows test script help
- [x] `contextual test` works as alias for `contextual run-tests`
- [x] `contextual help` shows contextual CLI usage and brief description of each subcommand
- [x] `contextual version` shows contextual CLI version information
- [x] All arguments are properly passed through to underlying scripts
- [x] Script handles unknown subcommands with appropriate error message
- [x] Script provides usage information when run without arguments
- [x] Error messages include contextual wrapper information before underlying script errors
- [x] Exit codes are properly propagated from underlying scripts

## Implementation Notes
- The main `contextual` script should be a dispatcher that calls the appropriate script in `/scripts/`
- Use `case` statement to handle subcommands
- Preserve all command-line arguments using `"$@"`
- Ensure scripts directory structure is created if it doesn't exist
- Include hardcoded version string at the top of the contextual script
- Add contextual wrapper error messages before passing through underlying script errors

## Tasks
- [x] Create `/scripts/` directory structure
- [x] Move `install.sh` to `/scripts/install.sh`
- [x] Move `run-tests.sh` to `/scripts/run-tests.sh`
- [x] Create main `contextual` script at project root
- [x] Implement subcommand dispatching logic
- [x] Add help/usage functionality
- [x] Implement `help` subcommand with CLI usage and brief subcommand descriptions
- [x] Implement `version` subcommand with version information
- [x] Test argument passthrough functionality
- [x] Update any references to moved scripts
- [x] Make `contextual` script executable
- [x] Test all subcommands work correctly

## Clarifications
### Session 2024-12-19
- Q: Should the scripts be moved to `/scripts/` directory or should the contextual script reference them in their current location? → A: Move scripts to `/scripts/` directory (restructure project)
- Q: Should we add any additional subcommands beyond install and run-tests? → A: Add both help and version subcommands
- Q: How should the contextual script handle errors when the underlying scripts fail? → A: Add contextual wrapper error messages before passing through
- Q: Where should the version information come from for the `contextual version` command? → A: Hardcoded version string in the contextual script
- Q: What should the `contextual help` command display? → A: Contextual CLI usage + brief description of each subcommand
