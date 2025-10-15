# Overview

Users need a way to update only the command files without modifying their existing `.contextual` configuration, context files, or README. This adds an `--only-commands` flag to the install script that copies command files directly to the agent's commands folder (e.g., `.cursor/commands/`) without creating symlinks or touching `.contextual` directory contents.

# Scope

- **Changes**: Modify `scripts/install.sh` to add `--only-commands` flag functionality
- **Requirements**:
  - Add `--only-commands` flag to argument parsing
  - Skip `copy_contextual_files()` function when flag is set
  - Copy command files directly to agent's commands folder (e.g., `.cursor/commands/`) without creating symlinks
  - Do NOT copy to or interact with `.contextual/commands/` directory
  - Ensure `--include` option works with `--only-commands` for selective command installation
  - Update help text and usage documentation to include the new flag
  - Create agent folder structure if it doesn't exist
- **Boundaries**: 
  - No changes to command files themselves
  - No changes to config.yaml structure or parsing
  - Default installation behavior (without `--only-commands`) remains unchanged
  - Does not affect agent-specific folder structure setup
- **Dependencies**: None (pure bash script modification)

# Solution

- **Approach**: 
  - Add boolean `ONLY_COMMANDS` flag variable (default: false)
  - Parse `--only-commands` in argument handling section
  - Conditionally skip `copy_contextual_files()` call in main installation flow
  - Copy command files directly from `commands/` source to agent folder (e.g., `.cursor/commands/`)
  - Skip config variable replacement since we're not using `.contextual/config.yaml`
  - No symlink creation - direct file copies only
- **Challenges**: 
  - Commands copied directly won't have config variables replaced (acceptable tradeoff for simplicity)
  - Must ensure agent folder exists before copying
  - Need to handle `--include` filtering when copying directly
- **Validation**: 
  - Test: `install.sh /path/to/project --only-commands` copies commands directly to agent folder
  - Test: `install.sh /path/to/project --only-commands --include specify.md,implement.md` installs only those commands
  - Test: Existing `.contextual` directory is not modified (no files added/changed)
  - Verify command files are copied (not symlinked) to agent folder
  - Verify commands work correctly without config variable replacement

# Tasks

## Phase 1: Add Flag Support
- [x] Add `ONLY_COMMANDS` variable to default values section
- [x] Add `--only-commands` case to argument parsing (flag_args loop)
- [x] Update `show_usage()` function to document the new flag with examples

## Phase 2: Create Direct Copy Function
- [x] Create new function `install_commands_only()` that copies commands directly to agent folder
- [x] Function should get agent folder from `get_agent_folder()` 
- [x] Function should respect `--include` filter using `is_command_included()`
- [x] Function should copy from `$COMMANDS_SOURCE` directly to agent folder (no .contextual interaction)
- [x] Function should create agent folder if it doesn't exist

## Phase 3: Modify Installation Flow
- [x] Add conditional in `install_contextual()` to check `ONLY_COMMANDS` flag
- [x] When true: skip `copy_contextual_files()` and `install_agent_commands()`
- [x] When true: call `install_commands_only()` instead
- [x] Add info message indicating direct copy mode (no config variables replaced)

## Phase 4: Validation and Testing

Put the tests into the `./tests/integration` folder and run with `.contextual test`
- [x] Skip `validate_installation()` when `ONLY_COMMANDS=true` (or modify to only check agent folder)
- [x] Test basic: `install.sh [path] --only-commands`
- [x] Test combined: `install.sh [path] --only-commands --include specify.md,implement.md`
- [x] Test on existing installation (commands updated, .contextual untouched)
- [x] Verify commands are files, not symlinks

# Additional Tasks

- [x] Update documentation in README.md for the --only-commands flag
