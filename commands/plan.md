# Goal
Update the ${FEATURE_CONTEXT} file to move all tasks into a linked file `${FEATURE_DIR}/plan.md` which is a detailed implementation plan with tasks for the feature and remove any tasks from the ${FEATURE_CONTEXT} file.

# User Input

```text
${ARGUMENTS}
```

You MUST consider the user input before proceeding (if not empty).

# Steps

## 1. Prerequisites
Execute: `.contextual/scripts/bash/plan.sh`
This will output:
- ${SPECIFY_DIR}: The specify directory path
- ${FEATURE_CONTEXT}: The context file path

## 2. Analyze Context File
- Extract requirements, specs, and acceptance criteria from ${FEATURE_CONTEXT}
- Identify key components and features to implement

## 3. Examine Existing Code
- If `${FEATURE_DIR}/analyzed.md` exists then look at that analysis first. Otherwise do a deep research look on the project.
- Scan for existing code and configurations. Do not examine ${SPECIFY_DIR} directories.
- Identify what's already implemented vs. missing

## 4. Generate Concise Plan
- Create focused task breakdown (max 10 tasks) using `- [ ]` syntax and prioritize less tasks if possible
- Organize tasks into logical phases (e.g., "Phase 1: Foundation", "Phase 2: Core Features")
- Use `- [ ]` syntax for all tasks (markdown checkbox format)
- Prioritize by dependency and importance
- Include only essential technical decisions

## 5. Create Plan Output
- Generate `${FEATURE_DIR}/plan.md` file
- Keep implementation steps concise and actionable
- Focus on critical decisions and next steps

## 6. Merge Back to Context
- Add plan summary to ${FEATURE_CONTEXT} file
- Preserve existing content and structure

# Output
- `${FEATURE_DIR}/plan.md` file with detailed implementation plan
- Updated ${FEATURE_CONTEXT} with link to the plan
- Focused task breakdown (max 10 tasks) using `- [ ]` syntax and prioritize less tasks if possible
- Tasks organized into logical phases for better execution flow
- Prioritized by dependency and importance
- Essential technical decisions included

# Next Steps
After running this command:
1. Review the generated `${FEATURE_DIR}/plan.md` file for completeness
2. Use `/clarify` to resolve any remaining ambiguities
3. Use `/implement` to begin executing the implementation plan
4. Update the plan as needed during implementation

# Guidelines
- **Separation of concerns**: Keep context file focused on requirements, reference detailed plan rather than duplicating it
- **Task tracking**: Use `- [ ]` syntax for all tasks to enable easy progress tracking
- **Logical organization**: Organize tasks into phases for clear execution flow and better project management
- **Readability**: Maintain brief, scannable format with concise, actionable steps
- **Scope boundaries**: Follow all links and files to understand domain context, but only modify files within ${SPECIFY_DIR} directory
- **Specification focus**: Create specifications only, do not implement the feature
