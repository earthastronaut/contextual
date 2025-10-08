# Analyze Project Structure

## Goal
Update the feature context. Do a deep analysis of the current project structure and create a summary of the project structure, key files, and technologies used. Add this to the `$FEATURE_DIR/analyzed.md` file and reference directly in the `$FEATURE_CONTEXT` file. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input
 $ARGUMENTS

## Steps

### 1. Prerequisites
Execute: `.specify/scripts/bash/analyze.sh`
This will output:
- $SPECIFY_DIR: The specify directory path
- $FEATURE_CONTEXT: The context file path

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
- Generate `$FEATURE_DIR/analyzed.md` with comprehensive findings
- Include project structure overview
- Document key files and their purposes
- Summarize existing code and technologies
- Note any patterns, conventions, or architectural decisions

### 6. Merge Back to Context
- Add analysis summary to $FEATURE_CONTEXT file
- Preserve existing content and structure

## Output
- `$FEATURE_DIR/analyzed.md` file with comprehensive project analysis
- Updated $FEATURE_CONTEXT with link to the analysis
- Clear project structure diagram/overview
- Key files and directories with descriptions
- Technology stack identification
- Code organization patterns
- Any existing feature context or specifications
- Recommendations for further development

## Next Steps
After running this command:
1. Review the generated `$FEATURE_DIR/analyzed.md` file for project understanding
2. Use `/clarify` to resolve any ambiguities in the feature specification
3. Use `/plan` to create detailed implementation plan
4. Use `/implement` to begin feature implementation

## Concise Output Format
The `$FEATURE_DIR/analyzed.md` file should be **comprehensive and well-organized**

**Key Principles:**
- **Separation of concerns**: Keep context file focused on requirements, reference detailed analysis rather than duplicating it
- **Comprehensive coverage**: Include all aspects of project structure, technologies, and patterns
- **Logical organization**: Organize findings into clear sections for easy navigation
- **Readability**: Maintain clear, scannable format with structured information
- **Scope boundaries**: Follow all links and files to understand domain context, but only modify files within $SPECIFY_DIR directory
- **Specification focus**: Create specifications only, do not implement the feature

**Note**: Do not examine any files or directories starting with `.` (hidden files).
