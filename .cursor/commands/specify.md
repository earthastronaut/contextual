# Specify New Feature

## Goal
Create a new feature context.md file in the spec-driven development flow based on the user input. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input
 $ARGUMENTS

## Steps

### 1. Generate Feature Input
From the user input, generate a concise (less than 30 characters) and santized kabab-case name and put into $FEATURE_INPUT.

### 2. Create Structure and Get Feature Name
Execute: `.specify/scripts/bash/specify.sh "$FEATURE_INPUT"`

This will output:
- FEATURE: The sanitized feature name
- FEATURE_BRANCH: The created branch name
- FEATURE_DIR: The feature directory path
- FEATURE_CONTEXT: The context file path

### 3. Analyze Context
MUST READ ALL FILES `.specify/context/*` directory. These are the global context for the project. Follow all links and files to understand the domain, technical specifications, and other context that may be relevant to the feature.

### 4. Update Specification
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

### 5. Report Progress
Provide a concise report of the progress made and next steps:
- Use `/clarify` to highlight any uncertainties or questions
- Use `/implement` to make changes based on the context.md file

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
