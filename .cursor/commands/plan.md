# Plan Feature

## Goal
Update the `specs/FEATURE_DIR/context.md` file with direct link to a `specs/FEATURE_DIR/plan.md` which is a detailed implementation plan with tasks for the feature. Follow all links and files to understand the domain, technical specifications, and other context that may be relevant to the feature. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input
 $ARGUMENTS

## Steps

### 1. Check Prerequisites
- Run `.specify/scripts/bash/plan.sh` to get feature variables
- Verify FEATURE_CONTEXT variables are set

### 2. Analyze FEATURE_CONTEXT File
- Extract requirements, specs, and acceptance criteria
- Identify key components and features to implement

### 3. Examine Existing Codebase
- If `./specs/FEATURE_DIR/analyzed.md` exists then look at that analysis first. Otherwise do a deep research look on the project.
- Scan for existing code and configurations. Do not examine `./specs/` directories.
- Identify what's already implemented vs. missing

### 4. Generate Concise Plan
- Create focused task breakdown (max 10 tasks) using `- [ ]` syntax and prioritize less tasks if possible
- Organize tasks into logical phases (e.g., "Phase 1: Foundation", "Phase 2: Core Features")
- Use `- [ ]` syntax for all tasks (markdown checkbox format)
- Prioritize by dependency and importance
- Include only essential technical decisions

### 5. Create Plan Output
- Generate `specs/FEATURE_DIR/plan.md` file
- Keep implementation steps concise and actionable
- Focus on critical decisions and next steps

### 6. Merge Back to Context
- Add plan summary to FEATURE_CONTEXT file
- Preserve existing content and structure

## Output
- `specs/FEATURE_DIR/plan.md` file with detailed implementation plan
- Updated `specs/FEATURE_DIR/context.md` with link to the plan
- Focused task breakdown (max 10 tasks) using `- [ ]` syntax and prioritize less tasks if possible
- Tasks organized into logical phases for better execution flow
- Prioritized by dependency and importance
- Essential technical decisions included

## Next Steps
After running this command:
1. Review the generated plan.md file for completeness
2. Use `/clarify` to resolve any remaining ambiguities
3. Use `/implement` to begin executing the implementation plan
4. Update the plan as needed during implementation

## Concise Output Format
The plan.md file should be **concise and actionable**

**Key Principles:**
- **Keep context file focused** on requirements, not implementation details
- **Reference the detailed plan** rather than duplicating it
- **Use `- [ ]` syntax** for all tasks to enable easy tracking
- **Organize into phases** for logical execution flow and better project management
- **Maintain readability** with brief, scannable format
