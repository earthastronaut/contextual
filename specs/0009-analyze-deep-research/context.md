# Overview
The current analyze command provides basic project structure analysis with one-line file/folder summaries. This enhancement enables deeper research capabilities including code pattern analysis, dependency mapping, architectural insights, and comprehensive documentation extraction. The solution extends the existing analyze workflow to support multi-level analysis depth, code parsing, relationship discovery, and intelligent summarization.

# Scope
What changes, what doesn't, and what's required?

- **Changes**: 
  - `commands/analyze.md` - Enhanced workflow with depth levels and advanced analysis steps
  - `.contextual/scripts/bash/folder-analyzer.sh` - Keep the same.
  - Add section to the `commands/analyze.md` file explore imports, includes, and other relationships. Map out the dependency map.
  - Analysis output format in `$FEATURE_DIR/analyzed/` - Files for `architecture`, `patterns`, `dependencies`, `relationships`, and link to `$FEATURE_DIR/context.md` file.

- **Requirements**: 
  - Support 3 analysis depth levels: `shallow` (current behavior), `standard` (enhanced summaries), `deep` (full analysis)
  - Extract and analyze file dependencies, imports/exports, and cross-file relationships
  - Identify architectural patterns (MVC, microservices, monolith, etc.)
  - Detect code patterns and common practices in the codebase
  - Generate comprehensive documentation including API surfaces, data models, and key workflows
  - Maintain backward compatibility with existing analyze command (default to `standard` depth)
  - Analysis should complete in reasonable time (< 5 minutes for large projects on deep mode)
- Compare current `$FEATURE_CONTEXT` with the new analysis output and update the context file with the new information and update the `$FEATURE_CONTEXT` with links.


- **Boundaries**: 
  - Only analyze text-based files (no binary analysis)
  - No execution or running of code (static analysis only)
  - No modification of source code, only specs directory files
  - No external API calls or network requests during analysis
  - Analysis depth is user-configurable, not automatic

- **Dependencies**: 
  - None (pure bash implementation with standard Unix tools: `grep`, `sed`, `awk`, `find`, `wc`)

# Solution
How will this be built and verified?

- **Approach**: 
  1. Add depth parameter to analyze command: `/analyze [folder] [--depth shallow|standard|deep]`
  2. Folder-analyzer.sh does **shallow** analysis.
  3. Section in `commands/analyze.md` to do standard analysis including dependencies, patterns, architecture, and relationships
  4. Section in `commands/analyze.md` to do full analysis including dependencies, patterns, architecture, and relationships
  5. Build dependency graph by analyzing import/export relationships
  6. Use the template `.contextual/templates/analyzed.md` to generate the analysis output.

- **Challenges**: 
  - Parsing multiple language syntaxes (JS, Python, Go, etc.) in bash
  - Performance on large codebases (need efficient `find` and `grep` patterns)
  - Accurate dependency detection without full AST parsing
  - Distinguishing framework patterns from application patterns
  - Memory usage when building dependency graphs for large projects
  - Handling various module systems (CommonJS, ES6, Python imports, Go packages)

- **Validation**: 
  - Test on contextual project itself with all 3 depth levels
  - Verify shallow mode matches current behavior (backward compatibility)
  - Test on JavaScript, Python, and Go projects to validate multi-language support
  - Measure performance: deep analysis should complete < 5 minutes on 10K+ file projects
  - Verify generated analysis helps AI understand project architecture
  - Check that dependency relationships are accurate (manual spot-checking)

- **References**: 
  - Current analyze.sh: `.contextual/scripts/bash/analyze.sh`
  - Current folder-analyzer.sh: `.contextual/scripts/bash/folder-analyzer.sh`
  - Current analyze command: `commands/analyze.md`


# Plan
See [plan.md](./plan.md) for detailed implementation plan with tasks organized into 5 phases covering foundation, shallow analysis, standard analysis, deep analysis, and integration.

**Status**: ✅ All phases complete - analyze command now supports shallow/standard/deep depth levels with multi-file output structure.

# Clarifications

## Session 2025-10-11
- Should the analyze command automatically detect optimal depth based on project size, or always require explicit user input? -> Default to "standard" depth, allow explicit user control
- For deep analysis, should we include security vulnerability hints (e.g., eval usage, SQL injection patterns) or focus purely on architecture? -> Focus purely on architecture
- Should the dependency graph output be in mermaid format? -> Yes, use Mermaid diagram syntax

# Additional Tasks
- [x] Infer what is needed from the analyzed/* files. Do not specify within the analyze.md script - Updated analyze.md to reference templates instead of specifying all details inline, allowing AI to infer requirements from template structure
- [x] Add user input for which types of analysis to do. Default to all - Added `--include` and `--exclude` flags to allow selective analysis type generation (e.g., `--include architecture,components` or `--exclude quality`)
- [x] Test analyze command on external project - Successfully analyzed Dance Scene project (Next.js full-stack app) generating comprehensive documentation
- [x] folder-analyzer.sh should also obey .gitignore if found. Ignore any files that .gitignore specifies.
- [x] analyze.sh complexity - 203 lines in single file, could benefit from refactoring - Refactored by extracting analysis utilities into separate module (analysis-utils.sh), reducing main file to 156 lines (23% reduction)
- [x] Limited test coverage - only 4 test files, no unit tests for bash functions. Update test coverage. Especially for .contextual/scripts/bash - Created comprehensive unit testing framework with 7 new test files (11 total, 175% increase). Added unit tests for all bash utility modules (print-utils, branch-utils, analysis-utils, env-utils, config-utils) with mock support and 58 individual test cases. All tests passing (100% success rate).
- [x] Add CI/CD pipeline to run tests before merging to main branch - Created GitHub Actions workflow (.github/workflows/ci.yml) that runs comprehensive test suite on pull requests and pushes to main. Executes all unit and integration tests with automatic cleanup. Provides clear pass/fail status for merge decisions.
- [x] dry Shared code duplication - plan.sh, clarify.sh, implement.sh have significant overlap - Created shared feature-utils.sh utility module with common functions (check_feature_prerequisites, get_all_feature_variables, output_*_variables, check_context_file_readiness). Refactored all three scripts to use shared utilities, reducing code duplication by ~40 lines per file (~120 lines total). All scripts now source feature-utils.sh for common functionality.

# Project Analysis

For detailed project analysis, see [analyzed/README.md](./analyzed/README.md).

The analysis provides comprehensive documentation of the Contextual Development Tools project including:
- **Structure**: Technology stack, directory organization, and file statistics
- **Components**: Key scripts, commands, utilities with dependency maps
- **Architecture**: System design, patterns, data flows, and workflow diagrams

**Quick Summary**: Contextual is a bash-based CLI toolkit (6,700+ LOC) for spec-driven development with AI agents. It provides structured workflows for feature specification, project analysis, planning, implementation, and git merge operations. Grade: B+ (solid architecture, needs more tests).
