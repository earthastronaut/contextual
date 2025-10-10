# Spec-Driven Development Flow

This directory contains the simplified spec-driven development workflow.

## Directory Structure

```
.contextual/
├── context/          # Global context storage (renamed from memory/)
├── scripts/          # Bash scripts for automation
│   └── bash/         # Bash utility scripts
│       ├── common.sh         # Common utilities
│       ├── branch-utils.sh   # Branch management
│       ├── file-utils.sh     # File discovery
│       ├── specify.sh        # Specify command
│       ├── implement.sh      # Implement command
│       └── specify-dev.sh    # Main entry point
└── README.md         # This file

.cursor/
└── commands/
    ├── specify.md    # Command to create new features
    └── implement.md  # Command to implement features
```

## Workflow

### 1. Specify a Feature
Use `.cursor/commands/specify.md` to:
- Create a new feature folder: `specs/{FEATURE_NAME}/`
- Create a new git branch: `feature/{FEATURE_NAME}`
- Generate a `context.md` template file

### 2. Implement the Feature
Use `.cursor/commands/implement.md` to:
- Read the current feature context
- Update tasks if present
- Run implementation in the LLM

## Usage Examples

### Using Cursor Commands
1. Run `specify.md` command
2. Fill out the generated `context.md` file
3. Run `implement.md` command
4. Review and iterate as needed

### Using Bash Scripts
```bash
# Load the main tool
source .contextual/scripts/bash/specify-dev.sh

# Create a new feature
specify-dev specify "User Authentication"

# Implement current feature
specify-dev implement

# Check status
specify-dev status
```

# Use specific functions
specify_feature "Feature Name"
implement_feature
show_status
```
