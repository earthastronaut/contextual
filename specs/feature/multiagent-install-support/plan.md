# Multiagent Install Support Implementation Plan

## Goal
Extend install script to support multiple agents: `--agent cursor,claude` or `--agent cursor --agent claude`

## Implementation Tasks

### Phase 1: Argument Parsing
- [x] Change `AGENT` variable to `AGENTS` array
- [x] Support comma-separated and multiple flag syntax
- [x] Update validation for all agents
- [x] Update usage documentation

### Phase 2: Core Logic
- [x] Modify `setup_agent_structure()` for agent array
- [x] Update `install_agent_commands()` to loop through agents
- [x] Update `install_commands_only()` for multiagent
- [x] Modify `validate_installation()` for all agents

### Phase 3: Installation Flow
- [x] Update `install_contextual()` to handle multiple agents
- [x] Loop through agents for structure setup and command installation
- [x] Update success reporting to show all agent directories

## Key Changes
- **Agent Array**: Use `AGENTS=()` instead of single `AGENT`
- **Syntax Support**: Both `--agent cursor,claude` and `--agent cursor --agent claude`
- **Backward Compatible**: Single agent usage unchanged
- **Error Handling**: Fail fast for invalid agents

## Success Criteria
- [x] Single agent usage works as before
- [x] Multiple agents via both syntax options
- [x] Command filtering applies to all agents
- [x] Proper directory structure and symlinks for all agents
