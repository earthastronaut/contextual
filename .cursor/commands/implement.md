# Implement Feature

## Goal
Implement the feature based on the context and all linked files.

## User Input
 $ARGUMENTS

## Steps

### 1. Prerequisites
Execute: `.contextual/scripts/bash/implement.sh`
This will output:
- $FEATURE_CONTEXT: The context file path

### 2. Analyze Context
1. **Find all linked files**: Scan $FEATURE_CONTEXT for links and follow recursively (depth limit: 3)
   - **Link patterns**: `[text](path)`, `@filename`, `./path`, `[[internal]]`, `{{var}}`, `$VAR`
   - **File types**: .md, .txt, .json, .yaml, .js, .ts, .py, .sh, .png
   - **Handle**: Markdown links, reference links, directory links (→ README.md)
   - **Skip**: External URLs, binary files
2. **Read all files**: Extract content and parse for additional links

### 2. Extract Tasks Loop
Sequential loop
1. **Scan files** for task patterns:
   - **Checkbox tasks**: `- [ ]`, `* [ ]`, `+ [ ]`
   - **Ignore Complete Checkbox tasks**: `- [x]`, `* [x]`, `+ [x]`
   - **Priority markers**: `[HIGH]`, `[MEDIUM]`, `[LOW]`, `[CRITICAL]`
   - **Status indicators**: `TODO:`, `FIXME:`, `NOTE:`, `REQUIREMENT:`
2. **Extract task context**: Capture description, source file, dependencies, priority, completion status

### 3. Organize Tasks into Phases
For all tasks
1. **Categorize by priority**: Group by High/Medium/Low priority and dependencies
2. **Create master task list**: Consolidate all tasks into implementation phases based on logically dependencies

### 3. Execute Implementation
1. **Update progress**: Mark completed tasks as `[x]` in ALL relevant files
2. **Handle errors gracefully**: Continue with independent tasks if some fail (halt only on critical failures)
3. **Validate**: Check against acceptance criteria from all sources

### 4. Error Handling
- **Missing context/files**: Note missing dependencies and continue with available tasks
- **Broken links**: Document issues and work with available information
- **Circular references**: Detect and break infinite loops in link chains
- **Task failures**: Update all relevant files with error notes and progress

## Output
- Progress updates during execution
- Final summary with suggested commit: `"feat: implement $FEATURE"`
- Updated $FEATURE_CONTEXT and all linked files with completed task markers

## Next Steps
After running this command:
1. Review the implementation results and validate against acceptance criteria
2. Update any remaining incomplete tasks
3. Commit changes with the suggested commit message
4. Use `/clarify` if any ambiguities arise during implementation
5. Use `/plan` to create additional implementation phases if needed

## Guidelines
- **Task tracking**: Mark completed tasks as `[x]` in ALL relevant files
- **Error handling**: Continue with independent tasks if some fail (halt only on critical failures)
- **Validation**: Check against acceptance criteria from all sources
- **Progress updates**: Update all relevant files with error notes and progress
- **Scope boundaries**: Only modify files within the project scope, not specification files
