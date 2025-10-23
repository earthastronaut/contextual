# Goal

Update the install.sh script to support multiple agents.

# Examples for Agents
- `./contextual install /path/to/project --agent cursor,claude`
- `./contextual install /path/to/project --agent cursor --agent claude`

# Examples for commands
- `./contextual install /path/to/project -include specify.md,implement.md,commit.md`
- `./contextual install /path/to/project --include specify.md --include implement.md --include commit.md`

# Implementation Plan

A detailed implementation plan has been created in [plan.md](./plan.md) that outlines:

- **Phase 1**: Argument parsing enhancement to support multiple agents
- **Phase 2**: Core logic updates for multiagent processing  
- **Phase 3**: Installation flow updates for multiple agents
- **Phase 4**: Testing and validation

The plan maintains backward compatibility while adding support for both comma-separated (`--agent cursor,claude`) and multiple flag (`--agent cursor --agent claude`) syntax.

**Key Technical Decisions:**
- Use bash array `AGENTS=()` instead of single `AGENT` variable
- Support both syntax options for maximum flexibility
- Maintain existing error handling and validation patterns
- Preserve all current functionality for single agent usage

# Additional Tasks
- [x] create tests for this in @integration/
