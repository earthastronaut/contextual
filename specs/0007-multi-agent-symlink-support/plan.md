# Implementation Plan: Multi-Agent Symlink Support

## Overview
Enable support for multiple AI agents (Cursor, Claude, Gemini, Copilot) by creating a top-level `./commands` folder with symlinks for local development, and enhancing `install.sh` to copy commands to agent-specific folders based on the `--agent` flag.

## Current State Analysis
- **Existing Structure**: Commands currently live in `.cursor/commands/` (10 command files)
- **Current install.sh**: Only supports Cursor agent with hardcoded `copy_cursor_commands()` function
- **Agent Support**: Limited to Cursor only

## Implementation Phases

### Phase 1: Create Top-Level Commands Structure
**Goal**: Establish the new commands folder as the single source of truth

- [x] Create `./commands/` folder in project root
- [x] Move all command files from `.cursor/commands/` to `./commands/`
- [x] Create symlink from `.cursor/commands/` → `./commands/` for local Cursor development
- [x] Test that existing Cursor commands work via symlink

### Phase 2: Enhance install.sh for Multi-Agent Support
**Goal**: Modify install.sh to support multiple agents via --agent flag

- [x] Add agent configuration mapping (cursor → .cursor/commands, claude → .claude/commands, etc.)
- [x] Create generic `setup_agent_structure()` function that handles all agent types
- [x] Create generic `copy_agent_commands()` function to copy from `./commands/` to agent folders
- [x] Update `validate_installation()` to check agent-specific command folders
- [x] Update usage documentation in `show_usage()` to list supported agents

### Phase 3: Testing & Validation
**Goal**: Ensure all agents work correctly and backward compatibility is maintained

- [x] Test installation with each agent: cursor, claude, gemini, copilot
- [x] Verify local development symlink workflow for Cursor
- [x] Test that existing projects using Cursor still work (backward compatibility)

## Technical Decisions

### Agent Configuration
```bash
# Agent → Folder mapping
cursor  → .cursor/commands
claude  → .claude/commands
gemini  → .gemini/commands
copilot → .copilot/commands
```

### Command Distribution Strategy
- **Local Development**: `./commands/` → `.cursor/commands/` (symlink)
- **Installation**: `./commands/` → `PROJECT_ROOT/{agent}/commands/` (copy files)
- **Universal**: All commands available to all agents

### File Operations
- **Source**: `./commands/*.md`
- **Destination**: `$PROJECT_ROOT/.$AGENT/commands/*.md`
- **Method**: Copy (cp -r) during installation

## Implementation Details

### Modified Functions in install.sh

#### 1. `setup_agent_structure()` Enhancement
```bash
# Current: Only handles cursor
# New: Handle cursor, claude, gemini, copilot with case statement
```

#### 2. `copy_agent_commands()` - New Generic Function
```bash
# Replaces: copy_cursor_commands()
# Purpose: Copy from ./commands/ to agent-specific folder
# Parameters: project_dir, agent
```

#### 3. `validate_installation()` Enhancement
```bash
# Current: Only validates .cursor/commands
# New: Validate based on $agent parameter
```

## Key Changes Summary

| Component | Current | New |
|-----------|---------|-----|
| Command Location | `.cursor/commands/` | `./commands/` (source) |
| Local Dev | Direct files | Symlink to `./commands/` |
| Agents Supported | cursor | cursor, claude, gemini, copilot |
| install.sh Logic | Hardcoded cursor | Dynamic agent handling |
| Command Distribution | Copy from contextual | Copy from `./commands/` |

## Success Criteria
- [x] `./commands/` folder created with all command files
- [x] `.cursor/commands/` is symlink to `./commands/` for local development
- [x] `install.sh --agent cursor` creates `.cursor/commands/` in PROJECT_ROOT
- [x] `install.sh --agent claude` creates `.claude/commands/` in PROJECT_ROOT
- [x] `install.sh --agent gemini` creates `.gemini/commands/` in PROJECT_ROOT
- [x] `install.sh --agent copilot` creates `.copilot/commands/` in PROJECT_ROOT
- [x] All commands copied correctly to agent folders
- [x] Existing Cursor workflows unaffected
- [x] Documentation updated with new agent options

## Risk Mitigation
- **Breaking Change**: Moving files from `.cursor/commands/` → Test thoroughly before merge
- **Symlink Compatibility**: Ensure symlinks work on all platforms (Unix/Linux/macOS)
- **Backward Compatibility**: Maintain default cursor behavior when no agent specified

## Next Steps After Implementation
1. Update project documentation with new structure
2. Update contribution guide with commands folder location
3. Consider adding agent auto-detection for smart defaults

