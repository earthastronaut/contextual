---
config:
  SPECIFY_DIR: ./specs
  ANALYZE_EXCLUDE_PATTERNS:
    - cache
    - __pycache__
    - node_modules
    - vendor
    - dist
    - build
    - .pytest_cache
    - .tox
    - venv
    - .venv
    - .env
    - .next
    - .nuxt
    - .bundle
    - "*.egg-info"
    - target
    - .gradle
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
- `shallow`: Directory structure and file listing only
- `standard`: Structure + key files + technologies + dependencies
- `deep`: Standard + detailed architecture + component relationships + data flow

# Steps

## 1. Determine Paths

1. Get current branch: `git branch --show-current` → `${CURRENT_BRANCH}`
2. Set `${FEATURE_DIR}` = `${SPECIFY_DIR}/${CURRENT_BRANCH}`
3. Set `${FEATURE_CONTEXT}` = `${FEATURE_DIR}/context.md`
4. Set `${ANALYSIS_OUTPUT_DIR}` = `${FEATURE_DIR}/analyzed`
5. Set `${ANALYSIS_OUTPUT_ROOT}` = `${ANALYSIS_OUTPUT_DIR}/summary.md`
6. If ${FEATURE_CONTEXT} doesn't exist → STOP, tell user to run `/specify` first

## 2. Parse Analysis Request

From user input, determine:
- `${ANALYSIS_INPUT_DIRECTORY}` - directory to analyze (default: `.`)
- `${ANALYSIS_DEPTH}` - analysis depth level (default: `standard`)

## 3. Apply Exclude Patterns

When analyzing directories and files:
1. Set `${EXCLUDE_PATTERNS}` from config `ANALYZE_EXCLUDE_PATTERNS`
2. Set `${INCLUDE_PATTERNS}` from config `ANALYZE_INCLUDE_PATTERNS`
3. Exclude any directory/file matching `${EXCLUDE_PATTERNS}` (case-insensitive)
4. Always include items matching `${INCLUDE_PATTERNS}` (overrides exclude)
5. Apply when scanning directories, counting files, and analyzing structure

## 4. Perform Analysis

Create `${ANALYSIS_OUTPUT_DIR}` directory if needed.

### For ALL depth levels (shallow/standard/deep):

**Create `${ANALYSIS_OUTPUT_DIR}/structure.md`:**
```markdown
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
[1-2 sentences: How is the codebase organized?]

## Technology Stack
**Runtime**: [Language & version] on [Runtime]
**Framework**: [Framework & version]
**Package Manager**: [npm, pip, cargo, etc.]
**Database**: [If applicable]

**Key Libraries** (top 5-8 only):
- **[Category]**: [lib1], [lib2]

## Directory Structure
[Tree showing key directories with descriptions]

## Organization Patterns
**Approach**: [Feature-based / Type-based / Layered]
**Naming**: Files: [convention], Dirs: [convention]

## Key Directories
[List 3-5 most important directories with purpose and key files]

## Configuration
**Build**: [package.json, Makefile, etc.]
**Development**: [tsconfig, .env, etc.]

## Entry Points
**Application**: [main entry file]
**Development**: [dev command]
**Tests**: [test command]

**Largest Files** (potential refactor candidates):
- `[path]` ([#] lines) - [Why large]
```

### For STANDARD and DEEP only:

**Create `${ANALYSIS_OUTPUT_DIR}/components.md`:**
```markdown
---
# Machine-readable metadata
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
[2-3 sentences about component organization]

## Component Relationships
[Textual or simple diagram showing how components relate - can use mermaid or ASCII]

## Recommendations
[Suggestions for improvements]
```

**Create `${ANALYSIS_OUTPUT_DIR}/architecture.md`:**
```markdown
---
# Machine-readable architecture metadata
architectural_style: ""  # monolith, microservices, layered, hexagonal, etc.
patterns_used: []  # [repository, factory, observer, etc.]
state_management: ""  # redux, context, signals, etc.
authentication:
  method: ""  # oauth, jwt, session
  provider: ""  # auth0, firebase, custom
data_storage:
  type: ""  # sql, nosql, file-system
  technology: ""  # postgresql, mongodb, sqlite
  access_pattern: ""  # orm, query-builder, raw-sql
layers: []  # [{name, location, purpose}]
---

# Architecture & Design

## Architectural Style
**Type**: [Monolith / Microservices / Layered / etc.]
**Description**: [2-3 sentences]
**Rationale**: [Why this was chosen]

## System Architecture
[Layers and component diagram]

## Key Design Patterns
[List patterns used, where, purpose, implementation]

## Data Flow
[Describe key flows: request/response, state changes, etc.]

## State Management
**Pattern**: [Redux / Context / etc.]
**Scope**: [Global / Feature / Component]

## Data Storage
**Type**: [Database type]
**Technology**: [Specific DB]
**Access**: [ORM / Query Builder / etc.]

## Authentication & Authorization
**Auth Method**: [OAuth / JWT / Session]
**Provider**: [Auth0 / Firebase / Custom]

## Error Handling
[Client and server approaches]

## Performance
**Optimizations**: [Key strategies]
**Bottlenecks**: [Areas of concern]

## Testing Strategy
**Unit / Integration / E2E**: [How tested]

## Deployment
**Infrastructure / CI/CD / Environments**
```

### For DEEP only:

**Create `${ANALYSIS_OUTPUT_DIR}/dependencies.md`:**
```markdown
---
# Machine-readable dependency metadata
total_dependencies: 0
production_dependencies: 0
dev_dependencies: 0
health: ""  # excellent, good, needs-attention, poor
security:
  vulnerabilities: 0
  high: 0
  medium: 0
  low: 0
update_status:
  up_to_date: 0
  minor_updates: 0
  major_updates: 0
  outdated: 0
internal:
  circular_dependencies: 0
  coupling: ""  # loose, tight, mixed
critical_dependencies: []  # [{name, version, purpose}]
---

# Dependencies Analysis

## Overview
**Total External Dependencies**: [#]
**Direct**: [#] | **Dev**: [#]
**Overall Health**: [Excellent / Good / Needs Attention]

## Dependency Summary
[Nested list for Production and Development dependencies by category]

## Critical Dependencies
[Top 5-8 dependencies with version, purpose, status, usage]

## External Dependencies by Category
[Nested list for all dependencies by category]

## Internal Dependencies
**Module Dependency Graph**: [Map of internal imports in mermaid format]
**Most Depended-Upon**: [Core modules others depend on]
**Circular Dependencies**: [✅ None / ⚠️ Found]
**Coupling**: [Loose / Tight / Mixed]

## Health Status
**Update Status**: [Up-to-date / Minor / Major updates needed]
**Security**: [Vulnerabilities summary]
**Bundle Size**: [If applicable]

## Risks
**High-Risk**: [Dependency concerns]
**Single Points of Failure**: [Critical deps]
**Maintenance Concerns**: [Unmaintained packages]

## Recommendations
[Immediate / Short-term / Long-term improvements]
```

**Create `${ANALYSIS_OUTPUT_DIR}/quality.md`:**
```markdown
---
# Machine-readable quality metadata
overall_grade: ""  # A, B, C, D, F
metrics:
  lines_of_code: 0
  test_coverage: 0
  doc_coverage: 0
  duplication_level: ""  # low, medium, high
file_sizes:
  small: 0  # < 100 LOC
  medium: 0  # 100-500 LOC
  large: 0  # 500-1000 LOC
  very_large: 0  # > 1000 LOC
tools:
  formatter: ""  # prettier, black, etc.
  linter: ""  # eslint, pylint, etc.
  test_framework: ""  # jest, pytest, etc.
security:
  vulnerabilities: 0
  high_severity: 0
  medium_severity: 0
  low_severity: 0
maintainability_score: 0  # 1-10
---

# Code Quality Analysis

## Overall Score
**Grade**: [A-F]
**Summary**: [One paragraph assessment]

## Testing Coverage
**Framework**: [Jest / pytest / etc.]
**Coverage**: [% by module]
**Critical Untested Areas**: [What needs tests]

## Code Consistency
**Formatter / Linter / Style Guide**: [Status]
**Naming / Patterns**: [Consistency assessment]

## Error Handling
**Quality / Consistency / Logging**: [Assessment]

## Security
**Strengths / Concerns / Checklist**: [Security analysis]

## Maintainability
[Scores for clarity, coverage, docs, modularity, consistency]

## Technical Debt
**High-Impact**: [Major debt items]
**Quick Wins**: [Easy improvements]

## Recommendations
[Immediate / Short-term / Long-term actions]
```

## 5. Create Analysis Summary

Create `${ANALYSIS_OUTPUT_DIR}/summary.md`:
```markdown
---
# Machine-readable analysis metadata
project:
  name: ""
  type: ""  # web-app, cli-tool, library, mobile-app, etc.
  language: ""
  framework: ""
analysis:
  date: ""
  depth: ""  # shallow, standard, deep
  analyzer: ""
  version: ""
metrics:
  lines_of_code: 0
  total_files: 0
  test_coverage: 0
  dependencies: 0
health:
  grade: ""  # A, B, C, D, F
  status: ""  # excellent, good, needs-attention, poor
---

# [Project Name] Analysis

## Executive Summary
[2-3 paragraph overview: what it does, who it's for, why it exists]

**Project Type**: [Web app, CLI tool, library, etc.]
**Primary Language**: [Language]
**Framework**: [Framework & version]
**Grade**: [A-F with brief justification]
**Last Analyzed**: [Date]
**Analysis Depth**: [shallow/standard/deep]

## What This Project Does
[2-3 sentences explaining the business purpose]

**Primary Use Cases**:
- [Use case 1]
- [Use case 2]
- [Use case 3]

**Target Users**: [Who uses this and why]

## Health Summary

**Strengths** ✅
[Top 3 strengths as bullet points]

**Critical Gaps** ⚠️
[Top 3 gaps as bullet points]

## Detailed Analysis

- [structure.md](./structure.md): Project organization, technology stack, and directory structure
- [components.md](./components.md): Key modules and component relationships (if created)
- [architecture.md](./architecture.md): System design, patterns, and data flow (if created)
- [dependencies.md](./dependencies.md): External and internal dependency analysis (if created)
- [quality.md](./quality.md): Code quality, testing, and technical debt assessment (if created)
```

## 6. Update Context

1. Read `${FEATURE_CONTEXT}`
2. Add or update "Project Analysis" section with:
   - Link to `${ANALYSIS_OUTPUT_ROOT}`
   - Brief note on analysis scope and depth
3. DO NOT duplicate information from analysis files

## 7. Validate Changes

Before completing:
1. Confirm ONLY modified files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
2. Verify all analysis files in `${ANALYSIS_OUTPUT_DIR}/`
3. Check ${FEATURE_CONTEXT} has link to analysis
4. Ensure no source code or command files were touched

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

**Research Approach:**
- Analyze and document, never implement changes to source code
- Keep context file focused on requirements, reference detailed analysis
- Include all aspects based on depth level
- Organize findings into clear sections for easy navigation
- Use clear, scannable format with headers and lists

**File Modification Rules:**
- ✅ ONLY edit files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`
- ❌ NEVER touch source code, commands, configs
- Read any project files needed to understand context
- But only modify files in `${ANALYSIS_OUTPUT_DIR}/`
- This command creates research documentation, NOT implementation

**Performance:**
- Complete analysis in reasonable time (< 5 minutes for deep mode on large projects)
- Apply `${EXCLUDE_PATTERNS}` to avoid analyzing build artifacts and cache
- Honor `${INCLUDE_PATTERNS}` to override exclude patterns when needed

**YAML/Metadata Formatting:**
- Minimize quoted strings in frontmatter and YAML
- Only quote when necessary (special chars, multiline with `|`, empty strings, ambiguous values)
- Simple strings, numbers, booleans, and lists should be unquoted
