---
# Machine-readable structure metadata
technology:
  language: ""
  version: ""
  runtime: ""
  framework: ""
  framework_version: ""
  package_manager: ""
  database: ""
file_stats:
  total_files: 0
  source_files: 0
  test_files: 0
  config_files: 0
organization:
  pattern: ""  # feature-based, type-based, layered
  private_folders_prefix: ""  # _, __, .hidden, etc.
largest_files: []  # [{path, lines, reason}]
---

# Project Structure

## Overview
<!-- 1-2 sentences: How is the codebase organized? -->

## Technology Stack

**Runtime**: [Language & version] on [Runtime]  
**Framework**: [Framework & version]  
**Package Manager**: [npm, pip, cargo, etc.]  
**Database**: [If applicable]

**Key Libraries** (top 5-8 only):
- **[Category]**: [lib1], [lib2]
- **[Category]**: [lib1], [lib2]

> Full dependency list in [dependencies.md](./dependencies.md)

## Directory Structure

```
project-root/
├── src/              # [Description]
│   ├── [feature1]/   # [Description]
│   ├── [feature2]/   # [Description]
│   └── [shared]/     # [Description]
├── tests/            # [Description]
├── config/           # [Description]
└── [other]/          # [Description]
```

## Organization Patterns

**Approach**: [Feature-based / Type-based / Layered]  
**Naming**: Files: [convention], Dirs: [convention]  
**Private folders**: [How non-public code is marked]

## Key Directories

### [Directory Name] - `[path]`
**Purpose**: [What lives here]  
**Key files**: [3-5 most important files]

### [Directory Name] - `[path]`
**Purpose**: [What lives here]  
**Key files**: [3-5 most important files]

## Configuration

**Build**: [package.json, Makefile, etc.]  
**Development**: [tsconfig, .env, etc.]  
**Deployment**: [Dockerfile, k8s, etc.]  
**Code Quality**: [eslint, prettier, etc.]

## Entry Points

**Application**: `[main entry file]` - [What it does]  
**Development**: `[dev command]` - [How to start]  
**Tests**: `[test command]` - [How to run]  
**Build**: `[build command]` - [What it produces]

## File Statistics

| Category | Count |
|----------|-------|
| Total Files | [#] |
| Source Files | [#] ([languages]) |
| Test Files | [#] |
| Config Files | [#] |

**Largest Files** (potential refactor candidates):
- `[path]` ([#] lines) - [Why large]
- `[path]` ([#] lines) - [Why large]

