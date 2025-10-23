---
config:
  SPECIFY_DIR: specs
  CONTEXT_ROOT: README.md
  ANALYZE_EXCLUDE_PATTERNS:
    - .*
    - **/.*
    - **/node_modules
    - **/vendor
    - **/__pycache__
    - **/dist
    - **/build
    - **/*cache*
    - **/test
    - **/mock
  ANALYZE_INCLUDE_PATTERNS: []
---
# Goal

Perform comprehensive project analysis and create research documentation in the feature specification.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${SPECIFY_DIR}/${CURRENT_BRANCH}/`**

This command performs **RESEARCH AND DOCUMENTATION**, DO NOT MODIFY SOURCE CODE!

**What this command does:**
- Analyze project structure, architecture, dependencies, and key files
- Create detailed analysis documentation in `analyzed/` subdirectory
- Update specification with links to analysis findings
- You research and document, you don't implement changes

**ALLOWED MODIFICATIONS:**
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/analyzed/` (analysis files)
- ✅ `${SPECIFY_DIR}/${CURRENT_BRANCH}/context.md` (add analysis links)
- ✅ Any files within `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md`, `README.md`, source code, config files
- ❌ ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

# User Input

```text
${ARGUMENTS}
```

**How to interpret user input:**
- Parse for: `[directory_to_analyze] [--depth shallow|standard|deep]`
- Default directory: project root (`.`)
- Default depth: `standard`

**Depth levels:**
- `shallow`: Basic structure and file overview (quick scan)
- `standard`: Structure + key components + dependencies (recommended)
- `deep`: Full analysis including architecture and quality metrics (comprehensive)

**Examples:**
- `analyze` - Standard analysis of current directory
- `analyze src --depth shallow` - Quick structure scan of src folder
- `analyze . --depth deep` - Comprehensive analysis of entire project

# Steps

## 1. Setup Analysis Environment

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set paths:
   - `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
   - `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`
   - `${ANALYSIS_OUTPUT_DIR}` = `${FEATURE_DIR}/analyzed`
3. Verify context exists, otherwise STOP and tell user to run `/specify` first

## 2. Parse User Request

Extract from user input:
- `${ANALYSIS_INPUT_DIRECTORY}` - directory to analyze (default: `.`)
- `${ANALYSIS_DEPTH}` - analysis depth (default: `standard`)

## 3. Gather Project Context

1. Read `${CONTEXT_ROOT}` for project overview
2. Use this information in analysis summary

## 4. Configure File Filtering

Apply filtering rules:
1. Load `${EXCLUDE_PATTERNS}` from config
2. Load `${INCLUDE_PATTERNS}` from config  
3. Exclude files matching exclude patterns (case-insensitive)
4. Always include files matching include patterns (overrides exclude)

## 5. Perform Analysis

Create `${ANALYSIS_OUTPUT_DIR}` directory if needed.

### Phase 1: Basic Structure (All Depths)

**Create `${ANALYSIS_OUTPUT_DIR}/structure.md`:**
```markdown
---
technology:
  language: ""
  framework: ""
  package_manager: ""
file_stats:
  total_files: 0
  source_files: 0
  test_files: 0
organization:
  pattern: ""
  largest_files: []
---

# Project Structure

## Overview
[How is the codebase organized?]

## Technology Stack
**Language**: [Language & version]
**Framework**: [Framework & version]
**Package Manager**: [npm, pip, cargo, etc.]

## Directory Structure
[Key directories with descriptions]

## Key Files
[Most important files and their purpose]
```

### Phase 2: Components (Standard & Deep)

**Create `${ANALYSIS_OUTPUT_DIR}/components.md`:**
```markdown
---
total_components: 0
components: {
    component_1: {
        name: COMPONENT_NAME,
        path: COMPONENT_PATH,
        category: COMPONENT_CATEGORY,  # entry_points, core, features, utilities, ui
        description: |
            COMPONENT_DESCRIPTION
        responsibilities: [
            RESPONSIBILITY_1,
            RESPONSIBILITY_2
        ],
        dependencies: [DEPENDENCY_1, DEPENDENCY_2],
        used_by: [USED_BY_1, USED_BY_2],
        exports: [EXPORT_1, EXPORT_2]
    }
    ...
}
complexity: {simple: 0, moderate: 0, complex: 0}
last_analyzed: ""
---

# Components & Modules

## Overview
[Component organization and key modules]

## Relationships
[How components interact]
```

**Create `${ANALYSIS_OUTPUT_DIR}/architecture.md`:**
```markdown
---
architectural_style: ""
patterns_used: []
state_management: ""
data_storage:
  type: ""
  technology: ""
---

# Architecture & Design

## Architectural Style
[Monolith / Microservices / Layered / etc.]

## Key Patterns
[Design patterns used]

## Data Flow
[Key system flows]

## State Management
[How state is managed]

## Data Storage
[Database and storage approach]
```

### Phase 3: Dependencies (Deep Only)

**Create `${ANALYSIS_OUTPUT_DIR}/dependencies.md`:**
```markdown
---
total_dependencies: 0
production_dependencies: 0
dev_dependencies: 0
health: ""  # excellent, good, needs-attention, poor
security:
  vulnerabilities: 0
critical_dependencies: []
---

# Dependencies Analysis

## Overview
**Total Dependencies**: [#]
**Health**: [Excellent / Good / Needs Attention]

## Key Dependencies
[Most important dependencies]

## Health Status
[Update status and security]

## Recommendations
[Improvement suggestions]
```

**Create `${ANALYSIS_OUTPUT_DIR}/quality.md`:**
```markdown
---
overall_grade: ""
metrics:
  lines_of_code: 0
  test_coverage: 0
tools:
  formatter: ""
  linter: ""
  test_framework: ""
---

# Code Quality Analysis

## Overall Score
**Grade**: [A-F]
**Summary**: [Assessment]

## Testing
**Framework**: [Test framework]
**Coverage**: [Coverage percentage]

## Code Quality
**Tools**: [Formatter, linter status]
**Consistency**: [Code consistency]

## Technical Debt
[Major issues and quick wins]

## Recommendations
[Improvement suggestions]
```

## 6. Create Analysis Summary

Create `${ANALYSIS_OUTPUT_DIR}/summary.md`:
```markdown
---
project:
  name: ""
  type: ""
  language: ""
  framework: ""
analysis:
  date: ""
  depth: ""  # shallow, standard, deep
metrics:
  lines_of_code: 0
  total_files: 0
health:
  grade: ""
  status: ""
---

# [Project Name] Analysis

## Executive Summary
[What it does, who it's for, why it exists]

**Project Type**: [Web app, CLI tool, library, etc.]
**Language**: [Language]
**Framework**: [Framework]
**Grade**: [A-F]
**Analysis Depth**: [shallow/standard/deep]

## Key Findings

**Strengths** ✅
[Top strengths]

**Areas for Improvement** ⚠️
[Key gaps]

## Analysis Files

- [structure.md](./structure.md): Project structure and technology
- [components.md](./components.md): Key components (if created)
- [architecture.md](./architecture.md): System design (if created)
- [dependencies.md](./dependencies.md): Dependencies (if created)
- [quality.md](./quality.md): Code quality (if created)
```

## 7. Update Context

1. Read `${FEATURE_CONTEXT}`
2. Add "Project Analysis" section with link to `${ANALYSIS_OUTPUT_ROOT}`
3. Include analysis depth and scope

## 8. Validate Changes

1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify analysis files created
3. Check context file updated

# Output

Summary:
- Analysis depth level used
- Files created in `${ANALYSIS_OUTPUT_DIR}/`
- Key findings (2-3 sentences)
- Link to `${ANALYSIS_OUTPUT_ROOT}`
- Updated file: `${FEATURE_CONTEXT}`

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Modified ONLY `${SPECIFY_DIR}/${CURRENT_BRANCH}/` files
- [ ] Did NOT touch command/source/config files
- [ ] Created research documentation, NOT implementation

**If you modified ANY files outside `${SPECIFY_DIR}/${CURRENT_BRANCH}/`, you did it WRONG.**

# Next Steps

After running this command:
1. Review generated analysis files for project understanding
2. Use `/clarify` to resolve ambiguities in feature specification
3. Use `/plan` to create detailed implementation plan
4. Use `/implement` to execute the planned changes

# Guidelines

**Analysis Approach:**
- Research and document, never modify source code
- Organize findings into clear, scannable sections
- Use appropriate depth level for analysis scope

**File Rules:**
- ✅ ONLY edit files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, or configs
- Create analysis documentation in `${ANALYSIS_OUTPUT_DIR}/`

**Performance:**
- Complete analysis efficiently (less than 5 minutes for deep mode)
- Apply exclude patterns to skip build artifacts
- Use include patterns to override exclusions when needed

**Practical Examples:**
- **Quick overview**: `analyze src --depth shallow` - Fast structure scan
- **Standard analysis**: `analyze` - Recommended for most projects
- **Comprehensive**: `analyze . --depth deep` - Full architecture analysis
- **Specific folder**: `analyze components --depth standard` - Focus on specific area
