# Goal
Update the feature context with comprehensive project analysis. Perform multi-level analysis (shallow/standard/deep) of the project structure and create detailed documentation of the project structure, key files, technologies, architecture, dependencies, and relationships. Add analysis to `$FEATURE_DIR/analyzed/` directory and reference in the `$FEATURE_CONTEXT` file. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

# User Input
```text
$ARGUMENTS
```

# Steps

## 1. Prerequisites
- Parse User Input for the directory to analyze and depth level. 
- Use the parsed arguments to execute: `.contextual/scripts/bash/analyze.sh {ANALYSIS_INPUT_DIRECTORY:-PROJECT_ROOT} --analysis-depth {ANALYSIS_DEPTH:-standard}`
This will output:
- {ANALYSIS_OUTPUT_DIR}: The output directory path
- {ANALYSIS_OUTPUT_ROOT}: The output root file path
- {FEATURE_DIR}: The feature directory path
- {FEATURE_CONTEXT}: The context file path

## 2. Analysis
- For each file in the {ANALYSIS_OUTPUT_DIR} directory, create a plan to read the file and tasks to update it based on its content. Ignore {ANALYSIS_OUTPUT_ROOT} file.
   - General Guidelines:
        - **Separation of concerns**: Keep context file focused on requirements, reference detailed analysis rather than duplicating it
        - **Comprehensive coverage**: Include all aspects based on depth level
        - **Logical organization**: Organize findings into clear sections for easy navigation
        - **Readability**: Maintain clear, scannable format with structured information
        - **Scope boundaries**: Follow all links and files to understand domain context, but only modify files within {ANALYSIS_OUTPUT_DIR} directory
        - **Specification focus**: Create specifications only, do not implement the feature, only update the analysis files.
        - **Performance**: Complete analysis in reasonable time (less than 5 minutes for deep mode on large projects)
- Update the {ANALYSIS_OUTPUT_ROOT} file with links to the other templates in the {ANALYSIS_OUTPUT_DIR} directory.
- Update the {ANALYSIS_OUTPUT_ROOT} file with all summary information.

## 3. Update Context
- Update the {FEATURE_CONTEXT} file with simple link to the{ANALYSIS_OUTPUT_ROOT} file with description to know what should look for. Do not duplicate infromation from the analysis files.

## Output
- Very concise summary and link to the {ANALYSIS_OUTPUT_ROOT} file.

## Next Steps
After running this command:
1. Review the generated analysis files for project understanding
2. Use `/clarify` to resolve any ambiguities in the feature specification
3. Use `/plan` to create detailed implementation plan
