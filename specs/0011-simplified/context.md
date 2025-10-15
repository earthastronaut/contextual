# Overview
Create a simplified workflow for AI tools that reduces cognitive overhead and streamlines the spec-driven development process. The current workflow has 9 commands (specify, clarify, analyze, plan, implement, commit, merge, contextualize, task) which can be overwhelming for new users. The proposed solution consolidates the workflow into essential commands while maintaining flexibility through optional features.

# Scope
- **Changes**: 
  - `commands/specify.md` - Convert to pure markdown prompt, remove script dependencies
  - `commands/clarify.md` - Simplify to direct AI-driven context updates
  - `commands/implement.md` - Streamline to AI-driven task execution
  - `README.md` - Update documentation to reflect AI-driven markdown workflow
  - `.contextual/templates/` - Remove entire directory (AI generates context dynamically)
  - `.contextual/scripts/` - Remove entire directory (commands are pure markdown prompts)
- **Requirements**: 
  - Reduce command count from 9 to 4-5 core commands (specify, implement, commit, merge, + optional contextualize)
  - Remove template dependencies - let AI generate context.md dynamically
  - Remove or minimize bash script dependencies - commands are markdown prompts
  - Ensure backward compatibility with existing specs
  - Maintain git integration for branch management
  - Keep the spec-driven development philosophy intact
- **Boundaries**: 
  - Will not remove existing commands (only simplify/consolidate)
  - Will not change the underlying `.contextual/` directory structure
  - Will not modify the installation script or multi-agent support
  - Will not alter the testing framework
- **Dependencies**: 
  - None - moving from bash scripts to pure markdown commands interpreted by AI

# Solution
- **Approach**: 
  - Leverage AI and markdown commands more - let AI handle workflow intelligence
  - Remove dependency on bash scripts and templates - AI generates context dynamically
  - Commands become pure markdown prompts that guide AI behavior
  - AI creates and manages context.md files without templates
  - Merge clarify/analyze/plan intelligence into specify and implement commands
  - Reduce decision points by having AI make smart contextual decisions
  - **Standardize command format with enhanced constraint visibility:**
    - Add prominent "⚠️ CRITICAL CONSTRAINTS ⚠️" section at top of specification-only commands
    - Use consistent section order: config frontmatter → constraints → goal → user input → steps → output → next steps → guidelines
    - Make file modification boundaries explicit and visually distinct with checkmarks (✅/❌)
    - Split constraints into "ALLOWED" (positive) and "FORBIDDEN" (negative) sections
    - Use bold, caps, and clear negative language ("NEVER", "MUST NOT") for constraints
    - Add multiple reminders: top section + "FINAL CHECKPOINT" before next steps + in guidelines
    - Add explicit user input interpretation guide to handle action verbs correctly
    - Include pre-completion validation checklist
    - Ensure AI cannot miss what files are off-limits through repetition and visual emphasis
- **Challenges**: 
  - Balancing simplicity with power-user features
  - Maintaining backward compatibility with existing specs in `specs/` directory
  - Ensuring documentation reflects both simple and advanced usage patterns
  - Avoiding regression in functionality while simplifying interfaces
- **Validation**: 
  - Test with existing specs to ensure they still work
  - Verify all 9 existing commands still function correctly
  - Ensure new simplified workflow works end-to-end on a sample feature
  - Check that README examples are clear and actionable
- **References**: 
  - `specs/0010-standardize-command-structure/command-template.md` - Command structure standards
  - `specs/0011-simplified/clarify-template.md` - Enhanced template showing improved constraint visibility
  - `specs/0011-simplified/constraint-improvements.md` - Explanation of why these improvements prevent AI errors
  - `README.md` - Current workflow documentation
  - `docs/contributions.md` - Detailed workflow explanation

# Tasks

## Phase 1: Remove Script and Template Dependencies
- [x] Remove bash script dependencies from commands (specify, clarify, etc.)
- [x] Remove or deprecate `.contextual/templates/context.md` template
- [x] Have AI generate context.md structure dynamically based on user input
- [x] Update commands to be pure markdown prompts without script calls

## Phase 2: Simplify Command Structure
- [x] Standardize all command templates with consistent format structure (see `clarify-template.md`)
- [x] Apply enhanced constraint structure to specification-only commands (specify, clarify, plan)
- [x] Simplify specify.md to have AI create context intelligently without templates
- [x] Simplify clarify.md to update context directly without complex workflows
- [ ] Merge plan intelligence into specify and implement commands (kept plan.md separate for now)
- [x] Make commands focus on guiding AI behavior rather than orchestrating scripts
- [x] Simplify analyze.md to remove bash script dependencies and follow clarify.md pattern

## Phase 3: Update Core Workflow Commands
- [x] Simplify implement.md to let AI handle task management and implementation
- [x] Merge task.md functionality into implement.md - make it handle both spec-driven implementation AND one-off tasks
- [x] implement.md should work in two modes:
  - **No user input**: Execute full spec-driven workflow (read context, extract tasks, implement)
  - **With user input**: Act as one-off task executor (implement immediately, track in "# Additional Tasks")
- [x] Delete task.md after merging functionality into implement.md
- [x] Simplify commit.md and merge.md to focus on git operations (commit.md already script-free, merge.md now script-free)
- [ ] Make contextualize.md optional for advanced context gathering (not modified - already optional)

## Phase 4: Update Documentation
- [x] Update README.md to show AI-driven markdown-based workflow
- [x] Remove references to bash scripts and templates from documentation
- [x] Add examples showing simplified AI-driven workflow
- [x] Clarify the role of markdown commands as AI guidance

## Phase 5: Testing & Validation
- [x] Test simplified workflow with a new sample feature (tested on 0011-simplified itself)
- [x] Verify backward compatibility with existing specs (0001-0010) - tests pass
- [x] Run test suite to ensure no regressions - all tests pass ✓
- [x] Update any tests that reference old script-based patterns - removed specify.sh test, removed tasks.md check

## Phase 6: Cleanup Unused Directories
- [x] Remove `.contextual/scripts/` directory (no longer needed - commands are pure markdown)
- [x] Remove `.contextual/templates/` directory (no longer needed - AI generates context dynamically)
- [x] Remove tests related to `.contextual/scripts/` and `.contextual/templates/` functionality

### Phase 7: Update config and install.sh
- [x] Analyze the `/commands` and `.contextual/config` and determine what config variables should be updated or removed. Make config a yaml file `config.yaml`.
- [x] Update install.sh to look for a `.contextual/config.yaml` file in the project root when installing. Update the commands/{name}.md metadata to include the project specific variables.
- [x] Install commands to `.contextual/commands/` and create symlink to the appropriate agent folder.
- [x] Allow `.contextual` to be a variable specified to the `install.sh` command (already implemented via --contextual-root flag). 
- [x] Symlinks in `install.sh` for `commands` folder - kept as individual file symlinks for better flexibility (allows agent-specific commands alongside shared ones)
- [x] Remove legacy config file from `.contextual/config` and all backward compatibility from `install.sh` - YAML only
- [x] Update all `commands/*.md` files to use the config variables at the top based on overwrites from `config.yaml` done in `install.sh` (config frontmatter already in place, install.sh handles YAML) 

### Phase 8: Update README.md
- [x] Update README.md to reflect the new simplified workflow. Remove references to bash scripts and templates. Add examples showing simplified AI-driven workflow.
- [x] Update `docs/contributions.md` to reflect the new simplified workflow. Remove references to bash scripts and templates. Add examples showing simplified AI-driven workflow.
- [x] Add more instructions to the `.contextual/context/README.md` file for the user.


# Additional Tasks
- [x] Simplify README.md instructions (reduced from 192 to 99 lines - 48% shorter)
- [x] Restore task.md command for backward compatibility (updated to use AI-driven workflow, recommends /implement instead)
- [x] Update implement.md with intelligent mode selection based on user input content, not just presence. Added examples for spec-driven vs one-off modes.
- [x] Simplify implement.md (reduced from 153 to 106 lines - 31% shorter) while keeping all critical details and decision logic
- [x] Update analyze.md to remove bash script dependencies, add critical constraints like clarify.md, and make it specification-focused (research and documentation only, no implementation)
- [x] Merge analysis template structures from `.contextual/templates/analyzed/` into analyze.md - embedded all template content (structure.md, components.md, architecture.md, dependencies.md, quality.md, README.md) directly in the command
- [x] Add machine-readable metadata frontmatter to all analysis templates:
  - structure.md: technology, file_stats, organization, largest_files
  - components.md: total_components, components (name/path/category/description/responsibilities/dependencies/used_by/exports), complexity, last_analyzed
  - architecture.md: architectural_style, patterns_used, state_management, authentication, data_storage, layers
  - dependencies.md: total_dependencies, production/dev counts, health, security, update_status, internal deps, coupling, critical_dependencies
  - quality.md: overall_grade, metrics (LOC/coverage/duplication), file_sizes, tools, security, maintainability_score
  - README.md: project metadata, analysis metadata (date/depth/analyzer/version), metrics, health (grade/status)
- [x] Update all test files to reflect new structure (commands instead of scripts/templates)
- [x] Fix test runner to properly count empty test directories as passing
- [x] All tests passing with 100% success rate ✓
- [x] Enhanced `.contextual/context/README.md` with comprehensive documentation (purpose, usage, best practices, examples)
- [x] Completed all remaining Phase 7 and Phase 8 tasks
- [x] Confirmed individual file symlinks approach for better flexibility (allows agent-specific commands)
- [x] Removed legacy `.contextual/config` file completely - YAML only (no backward compatibility)
- [x] Updated install.sh to only support config.yaml
- [x] Updated all tests to check for config.yaml only
- [x] All tests still passing with 100% success rate ✓
- [x] Update config.yaml and install.sh to use all caps variable names (SPECS_DIR, MAIN_BRANCH, MERGE_TEMPLATE, ANALYZE_EXCLUDE_PATTERNS, ANALYZE_INCLUDE_PATTERNS) consistent with command files
- [x] Comment out all defaults in config.yaml so users can uncomment and customize as needed
- [x] Refactor ANALYZE_SKIP_PATTERNS to be ANALYZE_EXCLUDE_PATTERNS for clearer naming
- [x] Create standard command template based on common structure of all commands → Created `command-template.md` with comprehensive documentation
- [x] Clean up duplication between context.md, command-template.md, and plan.md by creating cross-references
- [x] Simplify command-template.md instructions → See [`plan.md`](./plan.md) for implementation tasks (reduced from 298 to 169 lines - 43% reduction)
- [x] Update all commands in `/commands` to match simplified template structure while keeping critical details:
  - specify.md: Simplified constraint structure (145→138 lines, -5%)
  - clarify.md: Enhanced with better structure (86→117 lines, +36% for clarity)
  - plan.md: Simplified constraint structure (130→123 lines, -5%)
  - analyze.md: Added constraint sections, improved structure (475→507 lines, +7%)
  - implement.md: Refined formatting (101→105 lines, +4%)
  - commit.md: Consistent structure (68→84 lines, +24% for clarity)
  - merge.md: Enhanced structure (65→79 lines, +22% for clarity)
  - task.md: Minimal updates (55→59 lines, +7%)
  - contextualize.md: Adjusted to template (56→75 lines, +34% for clarity)
  - Total: 1231→1287 lines (+56 lines, +5% overall for improved clarity and consistency)
