# Implement Feature

## Goal
Implement the feature based on the context and all linked files.

## User Input
 $ARGUMENTS

## Steps

### 1. Setup & Discovery
1. **Get feature context**: Run `.specify/scripts/bash/implement.sh` to get FEATURE, FEATURE_CONTEXT, and FEATURE_BRANCH
2. **Find all linked files**: Scan FEATURE_CONTEXT for links and follow recursively (depth limit: 5)
   - **Link patterns**: `[text](path)`, `@filename`, `./path`, `[[internal]]`, `{{var}}`, `$VAR`
   - **File types**: .md, .txt, .json, .yaml, .js, .ts, .py, .sh
   - **Handle**: Markdown links, reference links, directory links (→ README.md)
   - **Skip**: External URLs, images, binary files
3. **Read all files**: Extract content and parse for additional links

### 2. Extract & Organize Tasks
1. **Scan all files** for task patterns:
   - **Checkbox tasks**: `- [ ]`, `- [x]`, `* [ ]`, `* [x]`, `+ [ ]`, `+ [x]`
   - **Priority markers**: `[HIGH]`, `[MEDIUM]`, `[LOW]`, `[CRITICAL]`
   - **Status indicators**: `TODO:`, `FIXME:`, `NOTE:`, `REQUIREMENT:`

2. **Extract task context**: Capture description, source file, dependencies, priority, completion status
3. **Categorize by priority**: Group by High/Medium/Low priority and dependencies
4. **Create master task list**: Consolidate all tasks into implementation phases

### 3. Execute Implementation
1. **Implement systematically**: Complete tasks in logical dependency order
2. **Update progress**: Mark completed tasks as `[x]` in ALL relevant files
3. **Handle errors gracefully**: Continue with independent tasks if some fail (halt only on critical failures)
4. **Validate**: Check against acceptance criteria from all sources

### 4. Error Handling
- **Missing context/files**: Note missing dependencies and continue with available tasks
- **Broken links**: Document issues and work with available information
- **Circular references**: Detect and break infinite loops in link chains
- **Task failures**: Update all relevant files with error notes and progress

## Output
- Progress updates during execution
- Final summary with suggested commit: `"feat: implement $FEATURE"`
- Updated FEATURE_CONTEXT and all linked files with completed task markers
