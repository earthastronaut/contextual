---
config:
    COMMAND: commands/contextualize.md
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
- Command has clear goal statement about updating contextual information
- User input section with `${ARGUMENTS}` placeholder
- Step-by-step process defined
- Critical constraint about only modifying files in `.contextual/context/`

## Test 2: Context Directory Initialization

**Description**: Test the context directory setup and initialization logic.

**Test Steps**:
1. Analyze Step 1 (Initialize Context Directory) in the command
2. Verify directory creation logic
3. Check default file creation when no user input provided

**Expected Results**:
- Creates `.contextual/context/` directory if it doesn't exist
- Creates default files (`technology.md`, `product.md`, `domains.md`) when no input
- Adds references to context files in `${CONTEXT_ROOT}`
- Stops after initialization when no user input provided

## Test 3: Context Scanning Logic

**Description**: Test the context directory scanning and analysis process.

**Test Steps**:
1. Analyze Step 2 (Scan Context Directory) in the command
2. Verify git diff integration for changed files
3. Check existing file discovery and linking logic

**Expected Results**:
- Uses `git diff --name-only --cached` and `git diff --name-only` to find changes
- Lists all existing `.contextual/context/` files
- Follows links to understand domain and technical context
- Reads `${CONTEXT_ROOT}` for global project context

## Test 4: Input Processing and Gap Analysis

**Description**: Test how the command processes user input and identifies information gaps.

**Test Steps**:
1. Analyze Steps 3-4 (Parse User Input, Identify Gaps) in the command
2. Check information extraction logic
3. Verify gap identification process

**Expected Results**:
- Extracts key information from user's request
- Determines what additional information is needed
- Identifies missing context information

## Test 5: Clarification and Update Workflow

**Description**: Test the clarification prompting and file update process.

**Test Steps**:
1. Analyze Steps 5-6 (Prompt User, Update Files) in the command
2. Check clarification marker usage
3. Verify file modification logic

**Expected Results**:
- Adds `[NEEDS CLARIFICATION: question?]` for unclear areas
- Modifies existing context files with new information
- Maintains focus on context documentation only

## Test 6: Cross-Reference Management

**Description**: Test the linking and cross-reference creation logic.

**Test Steps**:
1. Analyze Step 7 (Create Links) in the command
2. Check cross-reference creation between files
3. Verify link maintenance logic

**Expected Results**:
- Adds necessary cross-references between context files
- Maintains consistent linking structure
- Ensures related information is properly connected

## Test 7: Constraint Enforcement

**Description**: Test the critical constraint about file modifications.

**Test Steps**:
1. Analyze the constraint statements throughout the command
2. Check file modification rules in guidelines
3. Verify scope limitations

**Expected Results**:
- Clear constraints about only modifying `.contextual/context/` files
- Explicit prohibition against touching source code, commands, specs, or configs
- Focus on context documentation management only

## Test 8: Global Context Integration

**Description**: Test the global context reading and consistency maintenance.

**Test Steps**:
1. Analyze global context guidelines in the command
2. Check `${CONTEXT_ROOT}` integration
3. Verify consistency maintenance rules

**Expected Results**:
- Always reads `${CONTEXT_ROOT}` for project-wide context
- Uses global context to maintain consistency
- Avoids duplicating information from `${CONTEXT_ROOT}`
- Maintains single source of truth principle

# Summary

Evaluate each test case and provide:
- **Pass/Fail** status
- **Key findings** about command behavior
- **Potential issues** or improvements needed
- **Overall assessment** of command quality and completeness
