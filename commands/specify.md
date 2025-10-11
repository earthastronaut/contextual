# Goal
Create a new feature context.md file in the spec-driven development flow based on user input. DO NOT MODIFY source code - only files within ${SPECS_DIR} directory. DO NOT IMPLEMENT THE FEATURE - ONLY CREATE THE SPECIFICATION.

# User Input

```text
$ARGUMENTS
```

You MUST consider the user input before proceeding (if not empty). Do not implement the feature - just create the specification. Ignore action words like update, implement, modify, etc. - focus on WHAT needs to be specified.

# Steps

## 1. Validate & Generate Feature Name
Analyze the user input to ensure it contains sufficient detail. From the input, generate a concise (less than 30 characters) sanitized kebab-case name and store in ${FEATURE_INPUT}.

## 2. Create Structure
Execute: `.contextual/scripts/bash/specify.sh "${FEATURE_INPUT}"`
This outputs:
- ${CONTEXT_ROOT}: Root context file
- ${FEATURE}: Sanitized feature name
- ${FEATURE_BRANCH}: Created branch name
- ${FEATURE_DIR}: Feature directory path
- ${FEATURE_CONTEXT}: Context file path

## 3. Gather Context (Conditional)
Read ${FEATURE_CONTEXT} to understand the required specification structure.

IF user input lacks technical detail or context:
- Read ${CONTEXT_ROOT} to understand project context
- Review linked files relevant to the feature
- Use this information to enrich the specification

### 4. Write Specification
Update ${FEATURE_CONTEXT} following it's structure.

Add [NEEDS CLARIFICATION: question?] markers for any ambiguous areas. Don't make up answers - ask questions.

## Quality Guidelines
- Keep each section distinct with no duplicate information across sections, cross-reference where needed.
- Be specific and measurable in requirements and acceptance criteria
- Make tasks actionable implementation steps, not requirement restatements
- Focus on key information - be concise and to the point

## Next Steps
- (optional) `/analyze` to do deeper analysis
- (optional) `/clarify` to resolve markers
- (optional) `/plan` for implementation details
- `/implement` to implement tasks from the spec
- `/commit` to commit the changes
- `/merge` to merge the changes into the main branch

