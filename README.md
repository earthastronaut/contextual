# Contextual Development Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A spec-driven development workflow toolkit for AI-assisted coding with Cursor and other AI agents.

## 🚀 Features

- **Spec-Driven Development**: Create, clarify, and implement features using structured specifications
- **AI Agent Integration**: Seamless integration with Cursor and other AI development tools
- **Automated Workflow**: Streamlined commands for specification, implementation, and merging
- **Project Setup**: Easy installation and configuration for new projects
- **Comprehensive Testing**: Built-in test suite with automated validation
- **Git Integration**: Automated branch management and merge workflows

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/contextual/contextual.git
cd contextual

# Install .contextual and commands into your project
./contextual install /path/to/your/project

# Start a new feature
# /specify add contextualize
# /implement
# /commit
# /merge
```

## 📦 Structure

Within your project, this will add or update the following files:

```
.contextual/
├── context/                 # Your project's context files (not modified on update)
├── scripts/                 # Workflow scripts for commands to use.
├── templates/               # Templates for commands and scripts to use.
└── config                   # Configuration of your project for contextual.
.{agent}/                   # Agent-specific folder (varies by AI agent)
└── commands/               # AI agent commands (e.g., /specify, /implement, etc.)
```

**Supported AI agents**: cursor, claude, gemini, copilot, windsurf, roo, auggie, q, and more.
Default agent is `cursor` (creates `.cursor/commands/`)

## 🛠️ Usage

### Basic Commands

```bash
# Show help
contextual help

# Show version
contextual version

# Install contextual tools into a project
contextual install /path/to/project

# Update your project with new features
contextual update /path/to/your/project
```

### Installation Options

```bash
# Install with custom agent (default: cursor)
contextual install /path/to/project --agent cursor

# Install with custom contextual root directory
contextual install /path/to/project --contextual-root .dev-tools
```

### Configuration

After installation, you can customize the behavior by editing `.contextual/config` and uncommenting/modifying the variables:

```bash
# Edit the config file
vim .contextual/config
```

Available configuration options:
- `GIT_REPO_ROOT` - Git repository root path
- `CONTEXTUAL_ROOT` - Contextual root directory (default: `.contextual`)
- `CONTEXT_DIR` - Context files directory (default: `.contextual/context`)
- `CONTEXT_ROOT` - Main context file (default: `.contextual/context/README.md`)
- `SPECS_DIR` - Specifications directory (default: `./specs`)
- `MAIN_BRANCH` - Main branch name for merges (default: `main`)
- `MERGE_TEMPLATE` - Merge commit message template (default: `Merge {FEATURE_BRANCH}: {DESCRIPTION}`)

You can also set these as environment variables with the `CONTEXTUAL_` prefix (e.g., `CONTEXTUAL_MAIN_BRANCH=develop`).

## 🔄 Development Workflow

Contextual Development Tools follows a spec-driven development approach:

### 1. Specify a Feature
Use `/specify feature description` to create new feature specifications which creates a context.md file and a feature branch.

### 2. Implement the Feature
Use `/implement` command to implement any tasks from the context.md file.

### 3. Commit Changes
Use `/commit` command to commit the changes. This will commit the changes to the feature branch with a generated commit message.

### 4. Merge the Changes
Use `/merge` command to squash merge the changes into the main branch (configurable by `MAIN_BRANCH` in `.contextual/config`). This will merge the changes into the main branch with a generated commit message.

## Optional Commands

The main file for changes is the context.md file. This is the file that will be used to track the changes and the progress of the feature. These optional commands modify that context.md file. Note that it's best to keep the context.md file small and focused on the feature.

### Clarify Requirements
Use `/clarify` command to clarify the requirements of the feature. This will prompt you for any missing information and update the feature's context.md file.

### Analyze Project Structure
Use `/analyze` command to analyze the project structure and add it to the feature's context.md file.

### Plan Implementation
Use `/plan` command to create a plan and add it to the feature's context.md file.

## 📚 Additional Documentation

- [Contributions](docs/contributions.md) - How to contribute to the project
- [Test Documentation](tests/README.md) - Comprehensive testing guide

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for the AI-assisted development community
- Designed to work seamlessly with Cursor and other AI coding assistants
- Inspired by [spec-kit](https://github.com/spec-kit) and spec-driven development practices

---

**Made with ❤️ for developers who love AI-assisted coding**
