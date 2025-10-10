# Feature: install-script

## Overview
Create a top-level `install.sh` script that adds or updates existing project folders with contextual development tools. The script supports different AI agents (currently Cursor) and manages project structure setup with proper file organization.

## Requirements
- Create `install.sh` script in project root
- Support command-line arguments: `--project-root`, `--agent`, `--contextual-root`
- Prompt user for project name if `--project-root` is empty
- Default to `cursor` agent with support for future agents
- Default contextual root to `.contextual` with override capability
- Check if project root exists, create if not
- Update existing folders based on agent structure (e.g., `.cursor/commands` for Cursor)
- Copy `.contextual` folder to project root
- Preserve existing `context/` files but overwrite `scripts/` and `templates/`

## Technical Specifications
- **Technology Stack**: Bash scripting for cross-platform compatibility
- **Architecture**: Command-line tool with modular agent support
- **Dependencies**: Git (for project detection), standard Unix utilities
- **File Structure**:
  - `install.sh` - Main installation script
  - Agent-specific folder structures (`.cursor/commands/`, etc.)
  - Contextual folder management (`.contextual/`)

## Acceptance Criteria
- Script accepts `--project-root`, `--agent`, and `--contextual-root` arguments
- Prompts user for project name when `--project-root` is empty
- Creates project directory if it doesn't exist
- Sets up agent-specific folder structure based on `--agent` parameter
- Copies contextual files while preserving existing context
- Overwrites scripts and templates as specified
- Provides clear feedback during installation process

## Implementation Notes
- **Agent Structure**: Currently supports Cursor with `.cursor/commands/` folder
- **File Management**: Use rsync or cp with appropriate flags for selective copying
- **Error Handling**: Validate arguments, check permissions, handle missing dependencies
- **User Experience**: Clear prompts, progress indicators, success/error messages
- **Extensibility**: Design for easy addition of new agents (Claude, etc.)

## Clarifications
- [NEEDS CLARIFICATION: What specific files should be copied from the contextual root?]
- [NEEDS CLARIFICATION: Should the script support updating existing installations or only fresh installs?]
- [NEEDS CLARIFICATION: What validation should be performed on the project root path?]
- [NEEDS CLARIFICATION: How should the script handle conflicts when overwriting files?]

## Tasks
- [x] Create main `install.sh` script structure
- [x] Implement argument parsing for `--project-root`, `--agent`, `--contextual-root`
- [x] Add user prompt functionality for project name
- [x] Implement project directory creation and validation
- [x] Create agent-specific folder structure logic
- [x] Implement contextual file copying with selective overwrite
- [x] Add error handling and user feedback
- [x] Create folder with test files for with different scenarios (new project, existing project, various agents).
- [x] write unit tests for the script. `tests/install.sh`

