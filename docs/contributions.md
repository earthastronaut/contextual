# Contributing to Contextual Development Tools

This guide explains how to install, set up, and contribute to the Contextual Development Tools project.

## 📦 Installation & Setup

### Quick Start

```bash
# Clone the repository
git clone https://github.com/contextual/contextual.git
cd contextual

# Make the CLI executable
chmod +x contextual

# Install into your project
./contextual install --project-root /path/to/your/project
```

### Manual Installation

```bash
# Download the contextual CLI
curl -O https://raw.githubusercontent.com/contextual/contextual/main/contextual
chmod +x contextual

# Install into your project
./contextual install --project-root /path/to/your/project
```

### Development Setup

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/contextual.git
   cd contextual
   ```

3. **Install contextual tools**:
   ```bash
   ./contextual install --project-root .
   ```

4. **Run tests** to ensure everything works:
   ```bash
   ./contextual run-tests
   ```

## 🏗️ Project Structure

```
contextual/
├── contextual                 # Main CLI entrypoint
├── commands/                  # AI-driven command definitions (markdown)
│   ├── specify.md            # Create feature specifications
│   ├── implement.md          # Implement features
│   ├── commit.md             # Commit changes
│   ├── merge.md              # Merge branches
│   └── ...                   # Other workflow commands
├── scripts/                   # Core functionality scripts
│   ├── install.sh            # Project installation script
│   └── run-tests.sh          # Test runner
├── specs/                     # Feature specifications
│   ├── 0001-install-script/
│   ├── 0002-contextual-cli-entrypoint/
│   └── 0003-merge-command/
├── tests/                     # Test suite
│   ├── README.md             # Test documentation
│   ├── integration/          # Integration tests
│   └── utils/                # Test utilities
├── docs/                      # Additional documentation
├── .contextual/              # Contextual development tools
│   ├── commands/             # Installed command files (symlinked to agent folders)
│   ├── config.yaml           # Configuration file
│   └── context/              # Global context storage
├── .cursor/                  # Cursor AI agent integration
│   └── commands/             # Symlinks to .contextual/commands
└── LICENSE                   # MIT License
```

## 🔄 Development Workflow

Contextual Development Tools follows a spec-driven development approach:

### 1. Specify a Feature
Use `/specify feature description` to create new feature specifications which creates a context.md file and a feature branch.

### 2. Clarify Requirements
Use `/clarify` command to clarify the requirements of the feature. This will prompt you for any missing information and update the feature's context.md file.

### 3. Analyze Project Structure
Use `/analyze` command to analyze the project structure and add it to the feature's context.md file.

### 4. Plan Implementation
Use `/plan` command to create a plan and add it to the feature's context.md file.

### 5. Implement the Feature
Use `/implement` command to implement any tasks from the context.md file.

### 6. Commit Changes
Use `/commit` command to commit the changes. This will commit the changes to the feature branch with a generated commit message.

### 7. Merge the Changes
Use `/merge` command to squash merge the changes into the main branch (configurable by $CONTEXTUAL_MAIN_BRANCH). This will merge the changes into the main branch with a generated commit message.

## 🧪 Testing

The project includes a comprehensive test suite:

### Running Tests

```bash
# Run all tests
./contextual run-tests

# Run specific test
./contextual run-tests install-test

# List available tests
./contextual run-tests --list

# Run tests with verbose output
./contextual run-tests --verbose

# Clean up test artifacts
./contextual run-tests --cleanup
```

### Test Coverage

- **Install Script Tests**: Installation functionality, error handling, project setup
- **CLI Tests**: Command-line interface validation and argument parsing
- **Integration Tests**: End-to-end workflow validation
- **Error Handling**: Edge cases and failure scenarios

For detailed test documentation, see [tests/README.md](tests/README.md).

## 🤝 Contribution Guidelines

### Code Standards

- **Follow the spec-driven workflow** for new features
- **Write tests** for new functionality
- **Update documentation** as needed
- **Use conventional commit messages**
- **Ensure all tests pass** before submitting PRs

### Development Workflow

This project uses an AI-driven, spec-driven development workflow:

1. Create a new feature specification using `/specify`
2. (Optional) Clarify requirements using `/clarify`
3. (Optional) Analyze project structure using `/analyze`
4. (Optional) Plan implementation using `/plan`
5. Implement the feature using `/implement`
6. Test your changes with `./contextual run-tests`
7. Commit changes using `/commit`
8. Merge changes using `/merge`
9. Submit a pull request

**Note**: All commands are AI-driven markdown prompts. The AI interprets them and performs the necessary actions without requiring bash scripts.

### Best Practices

- **Keep context.md files small and focused** on the specific feature
- **Use clear, descriptive commit messages**
- **Test thoroughly** before submitting changes
- **Update documentation** when adding new features
- **Follow existing code style** and patterns

## 🐛 Troubleshooting

### Common Issues

**Permission Denied Errors**
```bash
# Make scripts executable
chmod +x contextual
chmod +x scripts/*.sh
chmod +x tests/*.sh
```

**Script Not Found**
```bash
# Ensure you're in the project root
cd /path/to/contextual
./contextual help
```

**Installation Failures**
```bash
# Check project root exists and is writable
ls -la /path/to/your/project
./contextual install --project-root /path/to/your/project --verbose
```

**Test Failures**
```bash
# Run tests with verbose output for debugging
./contextual run-tests --verbose

# Clean up test artifacts
./contextual run-tests --cleanup
```

### Getting Help

- **Check the logs**: Most commands provide detailed error messages
- **Run with verbose flag**: Add `--verbose` to commands for more output
- **Review test documentation**: See [tests/README.md](tests/README.md) for detailed test information
- **Open an issue**: Report bugs or request features on GitHub

## 📚 Additional Resources

- [Main README](../README.md) - Project overview and usage
- [Test Documentation](../tests/README.md) - Comprehensive testing guide
- [Command Definitions](../commands/) - AI-driven command markdown files
- [Configuration](../.contextual/config.yaml) - Project configuration
