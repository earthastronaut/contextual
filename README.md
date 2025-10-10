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

# Install into your project
./contextual install --project-root /path/to/your/project
```

## 🛠️ Usage

### Basic Commands

```bash
# Show help
contextual help

# Show version
contextual version

# Install contextual tools into a project
contextual install --project-root /path/to/project

# Update your project with new features
contextual update --project-root /path/to/your/project
```

### Installation Options

```bash
# Install with custom agent (default: cursor)
contextual install --project-root /path/to/project --agent cursor

# Install with custom contextual root directory
contextual install --project-root /path/to/project --contextual-root .dev-tools
```

## 🔄 Development Workflow

Contextual Development Tools follows a spec-driven development approach:

### 1. Specify a Feature
Use `/specify feature description` to create new feature specifications which creates a context.md file and a feature branch.

### 2. Implement the Feature
Use `/implement` command to implement any tasks from the context.md file.

### 3. Commit Changes
Use `/commit` command to commit the changes. This will commit the changes to the feature branch with a generated commit message.

### 4. Merge the Changes
Use `/merge` command to squash merge the changes into the main branch (configurable by $CONTEXTUAL_MAIN_BRANCH). This will merge the changes into the main branch with a generated commit message.

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
