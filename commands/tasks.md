# Create Tasks Specification

## Goal
Update the feature context by extracting tasks from `specs/FEATURE_DIR/context.md` and creating a dedicated `specs/FEATURE_DIR/tasks.md` file. Remove tasks from the context file and replace with a reference link to the tasks file. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input

```text
$ARGUMENTS
```

### 1. Prerequisites
Execute: `.contextual/scripts/bash/implement.sh`
This will output:
- $FEATURE_CONTEXT: The context file path

### 2. Analyze Context File
- Read the current $FEATURE_CONTEXT file
- Identify the "Tasks" section and extract all task items
- Note any task status indicators (completed, pending, etc.)

### 3. Check for Existing Plan File
- Check if `$FEATURE_DIR/plan.md` exists
- If plan exists, read and analyze the plan structure
- Extract phases, groupings, and task organization from the plan
- Use plan structure as the foundation for task organization

### 4. Examine Existing Tasks Structure
- Review current task organization and formatting
- Identify task categories or groupings if they exist
- Note any dependencies between tasks
- Cross-reference with plan phases if available

### 5. Create Tasks File
- Generate `$FEATURE_DIR/tasks.md` with comprehensive task breakdown
- If plan exists, organize tasks by phases and groupings from the plan
- If no plan exists, organize tasks by category or priority
- Preserve all existing task status and descriptions
- Include clear task descriptions and acceptance criteria

### 6. Update Context File
- Remove the "Tasks" section from $FEATURE_CONTEXT
- Add a reference link to the new `$FEATURE_DIR/tasks.md` file
- Maintain all other content and structure
- Ensure the context file remains focused on requirements and specifications

### 7. Validate Task Organization
- Ensure all tasks are properly categorized
- Verify task descriptions are clear and actionable
- Check that task status is preserved accurately

## Output
- `$FEATURE_DIR/tasks.md` file with comprehensive task breakdown
- Updated $FEATURE_CONTEXT with link to tasks file
- Tasks organized by phases and groupings (if plan exists) or by category/priority
- Clear task descriptions and status indicators
- Preserved task dependencies and relationships

## Next Steps
After running this command:
1. Review the generated `tasks.md` file for completeness
2. Use `/clarify` to resolve any task ambiguities
3. Use `/plan` to create detailed implementation plan
4. Use `/implement` to begin executing tasks
5. Update task status as work progresses

## Guidelines
- **Separate concerns** by moving tasks out of context file
- **Maintain task status** and progress tracking
- **Follow plan structure** if `plan.md` exists, organizing by phases and groupings
- **Organize logically** by category, priority, or dependency if no plan exists
- **Keep context focused** on requirements, not implementation details
- **Reference the detailed tasks** rather than duplicating them
