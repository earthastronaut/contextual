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
/specify description of the feature you want to add
/implement
/commit
/merge
```

## 📦 What Gets Installed

```
{agent}/commands/      # AI commands linked from .contextual/commands/
.contextual/          # Configuration and utilities
|-- commands/         # AI commands (/specify, /implement, etc.)
|-- config.yaml       # Configuration file
|-- context/          # Global context storage
specs/{branch}/       # Feature specifications (auto-created when running /specify)
```

**Supported AI agents**: cursor, claude, gemini, copilot, windsurf, roo, auggie, q
(Default: cursor)

## 🛠️ Installation

```bash
# Basic install
contextual install /path/to/project

# With options
contextual install /path/to/project --agent cursor --contextual-root .dev-tools

# Update existing installation
contextual update /path/to/project
```

**Configuration**: Edit `.contextual/config.yaml` to customize. See the file for more details.

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
/specify add user authentication        # Create spec
/clarify add OAuth support              # Refine spec (optional)
/plan                                   # Create detailed implementation plan (optional)
/analyze backend/auth                   # Analyze folder (optional)
/task description of something to do    # One-off task (optional)
/implement                              # Build the feature
/commit                                 # Commit changes (optional)
/merge                                  # Squash merge to main (optional)
```

### Quick Tasks

These are for quick one-off tasks which can be added to the feature context file.

```bash
/implement fix typo in login form   # Decides if this is a one-off or spec-driven task
/task fix typo in login form        # More explicit one-off task
```

## 🎯 How It Works

- **AI-Driven**: Commands are markdown prompts interpreted by AI (no bash scripts)
- **Spec Commands**: `/specify`, `/clarify`, `/plan` → Update docs in `specs/` only
- **Implementation**: `/implement` → Makes actual code changes
- **Git Operations**: `/commit`, `/merge` → Save and integrate work

## 📚 More Info

- [Contributions Guide](docs/contributions.md) | [Tests](tests/README.md)
- [MIT License](LICENSE)
- Inspired by [spec-kit](https://github.com/spec-kit)

---

**Made with ❤️ for AI-assisted development**
