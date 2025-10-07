# Analyze Project Structure

## Goal
Update the feature context. Do a deep analysis of the current project structure and create a summary of the project structure, key files, and technologies used. Add this to the `specs/FEATURE_DIR/analyzed.md` file and reference directly in the `specs/FEATURE_DIR/context.md` file. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input
 $ARGUMENTS

## Steps

### 1. Check Prerequisites
- Run `.specify/scripts/bash/analyze.sh` to get project structure and technology stack
- Verify project structure and technology stack

### 2. Analyze Project Structure
- Scan the root directory and all subdirectories (excluding hidden files/directories starting with `.`)
- Identify key files, directories, and their purposes
- Map out the overall project organization

### 3. Examine Existing Code
- Read and analyze content of key files
- Identify programming languages, frameworks, and technologies used
- Understand the codebase architecture and patterns

### 4. Review Documentation
- Look for any FEATURE_CONTEXT files or related documentation
- Check for README files, specifications, or project documentation
- Identify any existing feature specifications or requirements

### 5. Create Analysis Output
- Generate `./specs/FEATURE_NAME/analyzed.md` with comprehensive findings
- Include project structure overview
- Document key files and their purposes
- Summarize existing code and technologies
- Note any patterns, conventions, or architectural decisions

## Output
- `./specs/FEATURE_NAME/analyzed.md` file with comprehensive project analysis
- Clear project structure diagram/overview
- Key files and directories with descriptions
- Technology stack identification
- Code organization patterns
- Any existing feature context or specifications
- Recommendations for further development

## Next Steps
After running this command:
1. Review the generated `analyzed.md` file for project understanding
2. Use `/clarify` to resolve any ambiguities in the feature specification
3. Use `/plan` to create detailed implementation plan
4. Use `/implement` to begin feature implementation

**Note**: Do not examine any files or directories starting with `.` (hidden files).
