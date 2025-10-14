# Command Template Specification

This document defines the standard structure and formatting conventions for all command files in the `commands/` directory.

## Purpose

Standardize command file structure to improve:
- **Consistency**: Uniform format across all commands
- **Maintainability**: Easy to update and modify
- **Readability**: Clear, predictable structure
- **Comprehension**: Easier for users and AI to understand

## Standard Structure

All command files MUST follow this exact section ordering:

```markdown
# Goal
[Single paragraph describing the command's purpose]

# User Input
```text
${ARGUMENTS}
```

[Optional note about considering user input]

# Steps

## 1. Prerequisites
[First step - often script execution]

## 2. {Step Name}
[Subsequent steps numbered sequentially]

## N. {Final Step}
[Last step]

# Output
- [Expected output items]
- [As bulleted list]

# Next Steps
After running this command:
1. [Numbered list]
2. [Of recommended actions]
3. [After command completion]

# Guidelines
- **Key Point**: Description
- **Another Point**: Description
```

## Section Details

### Goal Section

**Format**: `# Goal`

**Content**: 
- Single paragraph describing the command's purpose
- Focus on WHAT the command does, not HOW
- Mention key outcomes
- Reference key variables if relevant (e.g., `${FEATURE_CONTEXT}`)

**Example**:
```markdown
# Goal
Implement the feature based on the context and all linked files.
```

### User Input Section

**Format**: `# User Input`

**Content**:
```markdown
# User Input

```text
${ARGUMENTS}
```

You MUST consider the user input before proceeding (if not empty).
```

**Rules**:
- Always use `${ARGUMENTS}` variable notation
- Always include the consideration note (or appropriate variant)
- Some commands may add additional guidance about input parsing

### Steps Section

**Format**: `# Steps`

**Content Rules**:
- Use `## N. {Step Name}` format for all steps
- Number steps sequentially starting from 1
- First step is often "## 1. Prerequisites"
- Use descriptive step names

**Sub-steps**:
- Use `-` for bullet points under steps
- Use `1.` for ordered sub-lists
- Keep nesting to 2-3 levels maximum

**Example**:
```markdown
# Steps

## 1. Prerequisites
Execute: `.contextual/scripts/bash/implement.sh`
This will output:
- ${FEATURE_CONTEXT}: The context file path

## 2. Analyze Context
1. **Find all linked files**: Scan ${FEATURE_CONTEXT} for links
2. **Read all files**: Extract content
```

### Output Section

**Format**: `# Output`

**Content**:
- Bulleted list of expected outputs
- Use `-` for bullets
- Be specific about files, paths, or results
- Reference variables using `${VAR}` notation

**Example**:
```markdown
# Output
- Progress updates during execution
- Updated ${FEATURE_CONTEXT} with completed task markers
- Final summary with suggested commit message
```

### Next Steps Section

**Format**: `# Next Steps`

**Content**:
```markdown
# Next Steps
After running this command:
1. [First recommended action]
2. [Second recommended action]
3. [Third recommended action]
```

**Rules**:
- Always start with "After running this command:"
- Use numbered list format
- List actions in recommended execution order
- Reference other commands using `/command` format (e.g., `/clarify`, `/implement`)

### Guidelines Section

**Format**: `# Guidelines`

**Content**:
- Bulleted list of important rules and best practices
- Use `- **Bold Title**: Description` format
- Focus on constraints, error handling, and important notes

**Example**:
```markdown
# Guidelines
- **Task tracking**: Mark completed tasks as `[x]` in ALL relevant files
- **Error handling**: Continue with independent tasks if some fail
- **Scope boundaries**: Only modify files within the project scope
```

**Optional**: This section may be omitted for simple commands that don't require additional guidelines.

## Variable Notation

**Standard Format**: `${VARIABLE_NAME}`

**Rules**:
- Always use `${VAR}` format (with curly braces)
- Never use `$VAR` (without braces) or `{VAR}` (without dollar sign)
- Use UPPER_SNAKE_CASE for all variable names
- Be consistent across all references to the same variable

**Common Variables**:
- `${ARGUMENTS}` - User input arguments
- `${FEATURE}` - Feature name
- `${FEATURE_NAME}` - Feature display name
- `${FEATURE_CONTEXT}` - Path to feature context file
- `${FEATURE_DIR}` - Path to feature directory
- `${FEATURE_BRANCH}` - Current feature branch name
- `${CONTEXT_ROOT}` - Root context file path
- `${SPECIFY_DIR}` - Specification directory path

**Variable Definition**:
When defining variables in Prerequisites sections, use this format:
```markdown
This will output:
- ${VARIABLE_NAME}: Description of what it contains
```

## Heading Hierarchy

**Level 1 (`#`)**: Main sections
- Goal
- User Input
- Steps
- Output
- Next Steps
- Guidelines

**Level 2 (`##`)**: Numbered steps
- Used for all steps: `## 1. Step Name`
- Used for subsections within main sections (rare)

**Level 3 (`###`)**: Detailed breakdowns (if needed)
- Use sparingly for complex step breakdowns
- Not required in most commands

## Formatting Conventions

### Code Blocks

**Inline code**: Use backticks for file paths, commands, variables
- File paths: `` `commands/implement.md` ``
- Commands: `` `git status` ``
- Variables: `` `${VAR}` ``

**Code blocks**: Use triple backticks with language identifier
```markdown
```bash
git commit -m "message"
```
```

### Lists

**Bulleted lists**: Use `-` (hyphen)
```markdown
- First item
- Second item
```

**Numbered lists**: Use `1.` format
```markdown
1. First item
2. Second item
```

**Bold emphasis in lists**: Use for key terms
```markdown
- **Key concept**: Description here
```

### Text Emphasis

- **Bold** (`**text**`): For section headings within lists, key terms, variable labels
- *Italic* (`*text*`): Rarely used, avoid unless necessary
- `Code` (`` `text` ``): For file paths, commands, variables, technical terms

## Special Patterns

### Prerequisites Pattern

When a command calls a bash script:
```markdown
## 1. Prerequisites
Execute: `.contextual/scripts/bash/{script-name}.sh`
This will output:
- ${VARIABLE_1}: Description
- ${VARIABLE_2}: Description
```

### Error Handling Pattern

When documenting error handling:
```markdown
## N. Error Handling
- **Error Type**: How to handle
- **Another Error**: How to handle
```

### Conditional Logic Pattern

When steps have conditional execution:
```markdown
## N. Step Name (Conditional)
Description of when this step applies.

IF condition:
- Action 1
- Action 2

ELSE:
- Alternative action
```

## Command Categories

Commands fall into two categories with slightly different patterns:

### Script-Based Commands
Commands that execute bash scripts (specify, implement, plan, clarify, analyze, merge)
- MUST have Prerequisites section as Step 1
- MUST define output variables from script
- MUST reference variables throughout subsequent steps

### Direct Commands
Commands without bash scripts (commit, task, tasks, contextualize)
- Steps begin with action items directly
- May reference feature context file
- Focus on direct actions rather than script outputs

## Validation Checklist

Use this checklist to validate command files:

- [ ] Has all required sections in correct order: Goal → User Input → Steps → Output → Next Steps
- [ ] Main sections use `#` heading (Level 1): Goal, User Input, Steps, Output, Next Steps, Guidelines
- [ ] User Input section includes `${ARGUMENTS}` in code block
- [ ] Steps section uses `## N. {Name}` format with sequential numbering
- [ ] All variables use `${VAR}` notation (no `$VAR` or `{VAR}`)
- [ ] Output section uses bulleted list format
- [ ] Next Steps section starts with "After running this command:"
- [ ] Guidelines section uses `- **Title**: Description` format (if present)
- [ ] All file paths use inline code formatting
- [ ] No duplicate information across sections
- [ ] Consistent verb tense (imperative for actions, present for descriptions)

## Examples

See the standardized versions of existing commands:
- `commands/implement.md` - Complex script-based command with multiple steps
- `commands/plan.md` - Script-based command with file generation
- `commands/commit.md` - Direct command without bash script
- `commands/clarify.md` - Interactive command with loops

## Migration Notes

When standardizing an existing command:

1. **Preserve functionality**: Don't change what the command does
2. **Update structure**: Apply the template structure
3. **Fix variables**: Convert all variables to `${VAR}` format
4. **Verify scripts**: Ensure bash script interface remains unchanged
5. **Test compatibility**: Verify the command still works with its script
6. **Update references**: Fix any cross-references to other commands

## Version

This specification applies to all command files as of the 0010-standardize-command-structure feature implementation.

Last updated: 2025-10-14

