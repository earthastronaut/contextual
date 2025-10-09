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
- $PROJECT_ROOT: The project root directory
- $FEATURE_CONTEXT: The context file path

### 2. Analyze Project Structure
- Execute: `.specify/scripts/bash/folder-analyzer.sh --input $PROJECT_ROOT --output $FEATURE_DIR/analyzed.md`
This will output: files and directories

### 3. File Analysis Loop
For each line with `FILE DESCRIPTION` in `$FEATURE_DIR/analyzed.md`
- Read the file link on that line
- Create a 1 line summary of the file's purpose
- Replace the `FILE DESCRIPTION` with the summary

### 4. Folder Analysis Loop
For each line with `FOLDER DESCRIPTION` in `$FEATURE_DIR/analyzed.md`
- Read the all the descriptions of files and folders in that folder.
- Create a 1 line summary of the folder's purpose
- Replace the `FOLDER DESCRIPTION` with the summary

### 5. Analysis
- Analyze all the files and folders descriptions.
- Replace `SUMMARY DESCRIPTION` with the analysis

## Output
- `$FEATURE_DIR/analyzed.md` file with comprehensive project analysis
- Updated $FEATURE_CONTEXT with link to the analysis

## Next Steps
After running this command:
1. Review the generated `$FEATURE_DIR/analyzed.md` file for project understanding
2. Use `/clarify` to resolve any ambiguities in the feature specification
3. Use `/plan` to create detailed implementation plan
4. Use `/implement` to begin feature implementation

## Guidelines
- **Separation of concerns**: Keep context file focused on requirements, reference detailed analysis rather than duplicating it
- **Comprehensive coverage**: Include all aspects of project structure, technologies, and patterns
- **Logical organization**: Organize findings into clear sections for easy navigation
- **Readability**: Maintain clear, scannable format with structured information
- **Scope boundaries**: Follow all links and files to understand domain context, but only modify files within $SPECIFY_DIR directory
- **Specification focus**: Create specifications only, do not implement the feature
