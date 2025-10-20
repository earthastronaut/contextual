---
config:
    COMMAND: commands/specify.md
---
# Goal

Test the `${COMMAND}` command by reading the command markdown file and evaluating its behavior in the LLM context.

# Test Cases

## Test 1: Command Structure Validation

**Description**: Verify the command has proper structure and required sections.

**Test Steps**:
1. Read `${COMMAND}` file
2. Check for required sections: Goal, User Input, Steps, Output
3. Verify critical constraints are clearly stated

**Expected Results**:
- Command has clear goal statement
- User input section with `${ARGUMENTS}` placeholder
- Step-by-step process defined
- Critical constraint about only modifying files in `${SPECIFY_DIR}/${CURRENT_BRANCH}/`

## Test 2: Branch Validation Logic

**Description**: Test the branch checking logic described in the command.

**Test Steps**:
1. Analyze Step 1 (Check Current Branch) in the command
2. Verify it checks for main branch and stops if on main
3. Check it suggests new branch name when on main

**Expected Results**:
- Command explicitly checks current branch
- Fails gracefully when on main branch
- Provides clear error message and branch suggestion

## Test 3: File Creation Logic

**Description**: Test the file creation and directory structure logic.

**Test Steps**:
1. Analyze Steps 2-3 (Create Specification Directory, Generate Context File)
2. Verify it creates proper directory structure
3. Check context file template structure

**Expected Results**:
- Creates `${SPECIFY_DIR}/${CURRENT_BRANCH}/` directory
- Generates context.md with proper template structure
- Includes Overview, Scope, Solution, Tasks sections

## Test 4: Input Processing

**Description**: Test how the command processes user input.

**Test Steps**:
1. Analyze Step 5 (Populate with User Request)
2. Check interpretation of different input types
3. Verify handling of ambiguous requests

**Expected Results**:
- Correctly interprets "implement X" as "create specification for X"
- Handles complex multi-part requirements
- Adds clarification markers for ambiguous areas

## Test 5: Constraint Enforcement

**Description**: Test the critical constraint about file modifications.

**Test Steps**:
1. Analyze the constraint statements throughout the command
2. Check validation steps (Step 6)
3. Verify final checkpoint warnings

**Expected Results**:
- Clear constraints about only modifying files in spec directory
- Multiple warnings about not touching source code
- Validation steps to confirm compliance

# Summary

Evaluate each test case and provide:
- **Pass/Fail** status
- **Key findings** about command behavior
- **Potential issues** or improvements needed
- **Overall assessment** of command quality and completeness
