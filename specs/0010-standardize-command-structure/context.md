# Overview
The command files in the `commands/` directory have inconsistent formatting, section hierarchy, and structure. This makes them difficult to maintain and understand. This specification standardizes all command files to follow a consistent structure with uniform section naming, heading levels, variable notation, and formatting conventions.

# Scope

- **Changes**: All command files in `/Users/dylan/projects/contextual/commands/` directory
  - analyze.md
  - clarify.md
  - commit.md
  - contextualize.md
  - implement.md
  - merge.md
  - plan.md
  - specify.md
  - task.md
  - tasks.md

- **Requirements**: 
  - Consistent heading hierarchy (# Goal, ## User Input, ## Steps, ## Output, ## Guidelines, ## Next Steps)
  - Uniform variable notation using `${VAR}` format
  - Consistent subsection numbering under Steps (### 1., ### 2., etc.)
  - Prerequisites section should always be "### 1. Prerequisites" under Steps
  - All commands must have Goal, User Input, Steps, Output, Next Steps, and Guidelines sections
  - Command files must remain functional with their corresponding bash scripts

- **Boundaries**: 
  - Bash scripts in `.contextual/scripts/bash/` are not modified (only documentation)
  - Command functionality and behavior remains unchanged
  - Only formatting and structure are standardized
  - No changes to command execution flow or script interfaces

- **Dependencies**: None - pure documentation refactoring

# Solution

- **Approach**: Apply a standardized template structure to all command files while preserving their unique content and functionality. Create a consistent format guide that defines the exact heading hierarchy, variable notation, and section ordering.

- **Challenges**: 
  - Each command has unique steps and requirements that must be preserved
  - Some commands call bash scripts (specify, implement, plan, clarify, analyze, merge) while others don't (commit, task, tasks, contextualize)
  - Variable notation varies between `$VAR`, `${VAR}`, and `{VAR}` across files
  - Nested section numbering varies in depth and format

- **Validation**: 
  - All command files pass markdown lint validation
  - All commands maintain the same section ordering
  - All variable references use consistent `${VAR}` notation
  - All heading levels follow the standardized hierarchy
  - Test commands continue to function with their bash scripts

- **References**: 
  - See `commands/` directory for current command files
  - See `command-template.md` for the standardized command structure specification

# Tasks

## Phase 1: Define Standard Command Template
- [x] Create a command template specification document defining the exact structure
- [x] Document variable naming conventions (`${VAR}` format)
- [x] Document heading hierarchy (# for Goal, ## for main sections, ### for numbered steps)
- [x] Document required sections order: Goal → User Input → Steps → Output → Guidelines → Next Steps

## Phase 2: Standardize Command Files
- [x] Standardize specify.md to match template
- [x] Standardize implement.md to match template
- [x] Standardize plan.md to match template
- [x] Standardize analyze.md to match template
- [x] Standardize clarify.md to match template
- [x] Standardize merge.md to match template
- [x] Standardize commit.md to match template
- [x] Standardize task.md to match template
- [x] Standardize tasks.md to match template
- [x] Standardize contextualize.md to match template

## Phase 3: Validation
- [x] Verify all commands follow the same structure
- [x] Verify all variable references use `${VAR}` notation
- [x] Test that commands still work with their bash scripts
- [x] Check for consistent formatting and readability
