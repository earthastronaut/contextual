# Specify New Feature

## Goal
Create a new feature context.md file in the spec-driven development flow based on the user input. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION AND INSTRUCTIONS.

## User Input

 $ARGUMENTS

## Steps

### 0. Validate User Input

Analyze the user input and make sure it is valid. Must be longer than 30 characters.
- **Feature Name & Description**: What the feature does and its purpose
- **User Stories**: Who uses it and what they want to accomplish  
- **Technical Details**: Technology stack, integrations, performance needs
- **User Experience**: UI/UX elements, workflows, and interactions


### 0. Generate Feature Input
From the user input, generate a concise (less than 30 characters) and santized kabab-case name and put into $FEATURE_INPUT.

### 1. Create Structure and Get Feature Name
Execute: `.specify/scripts/bash/specify.sh "$FEATURE_INPUT"`
This will output:
- FEATURE: The sanitized feature name
- FEATURE_BRANCH: The created branch name
- FEATURE_DIR: The feature directory path
- FEATURE_CONTEXT: The context file path

### 2. Analyze Context
READ THROUGH THE `.specify/context/README.md` file to understand the context. For each link in the file:
- Decide from the user input if this file should be included.
- If it should be included, read the file.

### . Update Specification
UPDATE THE `${FEATURE_CONTEXT}` file with the following information:

1. **Update Specification**: Update the `${FEATURE_CONTEXT}` file with the following information. Keep it concise and to the point with the key information.
- Overview
- Requirements
- Technical Specifications
- Acceptance Criteria
- Implementation Notes
- Tasks
2. **Analyze**: Analyze and put [NEEDS CLARIFICATION: question?] for anything that is not clear
3. **Verify clarifications**: Check spec has `## Clarifications` section or user override

## Output
- New feature directory structure: `specs/FEATURE_DIR/`
- Initial `specs/FEATURE_DIR/context.md` file with feature specification
- Feature branch created: `FEATURE_BRANCH`
- Global context analysis integrated into specification
- [NEEDS CLARIFICATION: question?] markers for ambiguous areas

## Next Steps
After running this command:
1. Review the generated context.md file for completeness
2. Use `/clarify` to resolve any [NEEDS CLARIFICATION: question?] markers
3. Use `/analyze` to examine project structure if needed
4. Use `/plan` to create detailed implementation plan
5. Use `/implement` to begin feature implementation
