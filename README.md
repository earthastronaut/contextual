# Contextual Development Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A spec-driven development workflow toolkit for AI-assisted coding with Cursor and other AI agents.

## 🚀 Features

- **Spec-Driven Development**: Create, clarify, and implement features using structured specifications
- **AI-Driven Workflow**: Pure markdown commands interpreted by AI - no bash scripts required
- **AI Agent Integration**: Seamless integration with Cursor and other AI development tools
- **Intelligent Automation**: AI handles workflow logic, context management, and task execution
- **Project Setup**: Easy installation and configuration for new projects
- **Comprehensive Testing**: Built-in test suite with automated validation
- **Git Integration**: Automated branch management and merge workflows

## 🚀 Quick Start

```bash
# Install into your project
./contextual install /path/to/your/project

# Create a feature branch
git checkout -b feature/add-user-authentication

# Run these commands
/plan description of the feature you want to add
/implement
/commit
/merge
```

## 📦 What Gets Installed

```
{agent}/commands/      # AI commands linked from .contextual/commands/
.contextual/          # Configuration and utilities
|-- commands/         # AI commands (/plan, /implement, etc.)
|-- config.yaml       # Configuration file
|-- context/          # Global context storage
specs/{branch}/       # Feature specifications (auto-created when running /plan)
```

**Supported AI agents**: cursor, claude, gemini, copilot, windsurf, roo, auggie, q
(Default: cursor)

## 🛠️ Installation

### Standard Installation

```bash
# Basic install (creates .contextual directory with config and context)
contextual install /path/to/project

# With options
contextual install /path/to/project --agent cursor --contextual-root .dev-tools

# Update existing installation
contextual update /path/to/project
```

**Configuration**: Edit `.contextual/config.yaml` to customize. See the file for more details.

### Commands-Only Installation

For updating just the command files without a `.contextual` directory or configuration help.

```bash
# Install/update into `.cursor/commands/` directory
contextual install /path/to/project --only-commands

# Install specific commands only
contextual install /path/to/project --only-commands --include plan.md,implement.md,commit.md

# Install/update into `.claude/commands/` directory
contextual install /path/to/project --only-commands --agent claude
```

**When to use `--only-commands`:**
- When you want to simplify installation and avoid any `.contextual` directory.
- When you only have one agent you're using and not sharing commands with other agents.
- Commands are copied directly (no config variable replacement)

## 🔄 Workflow


### Create a feature branch

The workflow starts by you creating a feature branch with the name you want.

```bash
git checkout -b feature/add-user-authentication
```

### Core Commands

These are the core commands you can use to build the feature.

```bash
/contextualize                          # Clarify global context information (optional)
/plan description of feature            # Create/refine spec and implementation plan
/analyze backend/auth                   # Analyze folder (optional)
/implement                              # Build the feature (can include quick tasks)
/commit                                 # Commit changes (optional)
/merge                                  # Squash merge to main (optional)
```

### Quick Tasks

For quick one-off tasks, use `/implement` with a description:

```bash
/implement fix typo in login form   # Handles both spec-driven and one-off tasks
```

## 🎯 How It Works

- **AI-Driven**: Commands are markdown prompts interpreted by AI (no bash scripts)
- **Spec Commands**: `/plan` → Create/refine specs and implementation plans (updates docs in `specs/` only)
- **Implementation**: `/implement` → Makes actual code changes (handles both spec-driven and quick tasks)
- **Git Operations**: `/commit`, `/merge` → Save and integrate work

## 📚 More Info

- [Contributions Guide](docs/contributions.md) | [Tests](tests/README.md)
- [MIT License](LICENSE)
- Inspired by [spec-kit](https://github.com/spec-kit)

---

**Made with ❤️ for AI-assisted development**
