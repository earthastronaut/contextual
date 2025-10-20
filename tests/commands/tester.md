---
config:
  COMMANDS_DIR: commands
  TEST_OUTPUT_DIR: tests/.tester_results_cache
---
# Goal

Evaluate a specific command file for clarity, consistency, structure, and effectiveness as a prompt command.

**CRITICAL CONSTRAINT: ONLY MODIFY FILES IN `${TEST_OUTPUT_DIR}/`**

This command performs **EVALUATION AND ANALYSIS**, DO NOT MODIFY SOURCE COMMANDS!

**What this command does:**
- Analyze command structure, clarity, and consistency
- Evaluate prompt engineering effectiveness
- Identify gaps and improvement opportunities
- Generate comprehensive evaluation report
- You analyze and document, you don't modify the original commands

**ALLOWED MODIFICATIONS:**
- ✅ `${TEST_OUTPUT_DIR}/` files only (evaluation reports)

**FORBIDDEN (NEVER TOUCH):**
- ❌ `commands/*.md` files (original commands)
- ❌ Any files outside `${TEST_OUTPUT_DIR}/`

# User Input

```text
${ARGUMENTS}
```

**How to interpret user input:**
- Parse for: `[command_name]` (e.g., `specify`, `clarify`, `analyze`)
- Command name should match a file in `${COMMANDS_DIR}/`
- If no command specified, evaluate all commands in `${COMMANDS_DIR}/`

# Steps

## 1. Determine Command to Test

1. Parse user input for command name
2. If command specified: `${TARGET_COMMAND}` = `${COMMANDS_DIR}/${COMMAND_NAME}.md`
3. If no command: evaluate all `.md` files in `${COMMANDS_DIR}/`
4. Verify command file exists

## 2. Create Output Directory

1. Create `${TEST_OUTPUT_DIR}` if it doesn't exist
2. Set `${EVALUATION_FILE}` = `${TEST_OUTPUT_DIR}/${COMMAND_NAME}-evaluation.md`

## 3. Read and Parse Command

1. Read the target command file
2. Extract key sections: Goal, User Input, Steps, Output, Guidelines
3. Parse configuration variables and constraints
4. Identify command structure and flow

## 4. Analyze File Size and Token Usage

**File Size Analysis:**
- Calculate file size in bytes and lines
- Estimate token count (roughly 4 characters per token)
- Identify sections that contribute most to size
- Check for redundancy or verbosity

**Token Efficiency Assessment:**
- Essential vs non-essential content ratio
- Redundancy in constraint messaging
- Verbose explanations vs concise instructions
- Template sections that could be streamlined

**Size Optimization Opportunities:**
- Remove redundant constraint statements
- Consolidate similar sections
- Streamline verbose explanations
- Remove unnecessary examples or details

## 5. Evaluate Command Structure

**Required Sections Check:**
- [ ] Clear Goal statement
- [ ] User Input section with `${ARGUMENTS}` placeholder
- [ ] Step-by-step process (numbered steps)
- [ ] Output section
- [ ] Critical constraints clearly stated
- [ ] Next Steps or Guidelines section

**Structure Quality:**
- Logical flow from input → process → output
- Clear separation of concerns
- Consistent formatting and style
- Proper use of markdown formatting

## 6. Evaluate Clarity and Consistency

**Clarity Assessment:**
- Goal statement is specific and actionable
- User input interpretation is clear
- Steps are detailed and unambiguous
- Constraints are prominently displayed
- Language is clear and professional

**Consistency Check:**
- Consistent terminology throughout
- Consistent formatting patterns
- Consistent variable naming (`${VARIABLE}`)
- Consistent constraint messaging
- Consistent section organization

## 7. Evaluate Prompt Engineering Effectiveness

**Command Design:**
- Clear role definition for the AI
- Specific constraints prevent unwanted behavior
- Input processing is well-defined
- Output format is specified
- Error handling is addressed

**Constraint Effectiveness:**
- Critical constraints are prominent
- Multiple warnings about forbidden actions
- Clear allowed/forbidden file lists
- Validation steps included
- Final checkpoint implemented

**User Experience:**
- Easy to understand what the command does
- Clear input requirements
- Helpful next steps provided
- Good error messaging

## 8. Identify Gaps and Issues

**Potential Issues:**
- Missing required sections
- Unclear instructions
- Inconsistent formatting
- Weak constraint enforcement
- Missing error handling
- Ambiguous user input processing

**Improvement Opportunities:**
- Better clarity in specific areas
- Enhanced constraint messaging
- Improved user guidance
- Better error handling
- More specific instructions

## 9. Generate Evaluation Report

Create `${EVALUATION_FILE}` with this structure:

```markdown
---
# Machine-readable evaluation metadata
command: ""
evaluated_date: ""
evaluator: "tester.md"
overall_score: 0  # 1-10
structure_score: 0  # 1-10
clarity_score: 0  # 1-10
consistency_score: 0  # 1-10
effectiveness_score: 0  # 1-10
efficiency_score: 0  # 1-10
file_size_bytes: 0
file_size_lines: 0
estimated_tokens: 0
---

# Command Evaluation: [COMMAND_NAME]

## Executive Summary
**Overall Score**: [X/10]
**Grade**: [A-F]
**Status**: [Excellent/Good/Needs Improvement/Poor]
**File Size**: [X] bytes ([X] lines, ~[X] tokens)

[2-3 sentence summary of the command's quality and main findings]

## Detailed Scores

### Structure (X/10)
**Strengths:**
- [List structural strengths]

**Issues:**
- [List structural problems]

### Clarity (X/10)
**Strengths:**
- [List clarity strengths]

**Issues:**
- [List clarity problems]

### Consistency (X/10)
**Strengths:**
- [List consistency strengths]

**Issues:**
- [List consistency problems]

### Effectiveness (X/10)
**Strengths:**
- [List effectiveness strengths]

**Issues:**
- [List effectiveness problems]

### Efficiency (X/10)
**Strengths:**
- [List efficiency strengths - concise, essential content]

**Issues:**
- [List efficiency problems - redundancy, verbosity, size]

## File Size and Token Analysis

**File Metrics:**
- **Size**: [X] bytes ([X] lines)
- **Estimated Tokens**: ~[X] tokens (4 chars/token)
- **Size Category**: [Small <5KB/Medium 5-15KB/Large 15-30KB/Very Large >30KB]

**Size Breakdown:**
- **Goal Section**: [X]% of file
- **Steps Section**: [X]% of file  
- **Constraints**: [X]% of file
- **Guidelines**: [X]% of file
- **Other**: [X]% of file

**Efficiency Assessment:**
- **Essential Content**: [X]% (core functionality)
- **Redundant Content**: [X]% (repeated information)
- **Verbose Content**: [X]% (could be more concise)
- **Template Content**: [X]% (boilerplate/examples)

**Optimization Opportunities:**
- [Specific areas where content could be reduced]
- [Redundant sections that could be consolidated]
- [Verbose explanations that could be streamlined]

## Critical Findings

### ✅ Strengths
- [Top 3-5 strengths]

### ⚠️ Critical Issues
- [Top 3-5 issues that need immediate attention]

### 🔧 Improvement Recommendations
- [Specific, actionable recommendations]

## Section-by-Section Analysis

### Goal Section
**Score**: [X/10]
**Analysis**: [Detailed analysis of goal clarity and specificity]

### User Input Section
**Score**: [X/10]
**Analysis**: [Analysis of input processing and interpretation]

### Steps Section
**Score**: [X/10]
**Analysis**: [Analysis of step clarity, completeness, and flow]

### Output Section
**Score**: [X/10]
**Analysis**: [Analysis of output specification and usefulness]

### Constraints Section
**Score**: [X/10]
**Analysis**: [Analysis of constraint clarity and enforcement]

### Guidelines Section
**Score**: [X/10]
**Analysis**: [Analysis of additional guidance and best practices]

## Specific Recommendations

### Immediate Fixes (High Priority)
1. [Specific fix 1]
2. [Specific fix 2]
3. [Specific fix 3]

### Short-term Improvements (Medium Priority)
1. [Improvement 1]
2. [Improvement 2]
3. [Improvement 3]

### Long-term Enhancements (Low Priority)
1. [Enhancement 1]
2. [Enhancement 2]
3. [Enhancement 3]

## Comparison with Best Practices

### What This Command Does Well
- [List of best practices followed]

### Where It Falls Short
- [List of best practices not followed]

## Final Assessment

**Overall Quality**: [Excellent/Good/Fair/Poor]
**Readiness**: [Production Ready/Needs Minor Fixes/Needs Major Work/Not Ready]
**Recommendation**: [Keep as-is/Update and improve/Needs complete rewrite]

**Key Takeaway**: [One sentence summary of the most important finding]
```

## 10. Validate Changes

Before completing:
1. Confirm ONLY modified files in `${TEST_OUTPUT_DIR}/`
2. Verify evaluation file was created
3. Check no original command files were touched

# Output

Summary:
- Command evaluated: `${COMMAND_NAME}`
- Evaluation file: `${EVALUATION_FILE}`
- Overall score and grade
- Key findings and recommendations

# ⚠️ FINAL CHECKPOINT ⚠️

**Before you finish, verify:**
- [ ] Created ONLY files in `${TEST_OUTPUT_DIR}/`
- [ ] Did NOT touch original command files
- [ ] Generated comprehensive evaluation report

**If you modified ANY files outside `${TEST_OUTPUT_DIR}/`, you did it WRONG.**

# Next Steps

After running this command:
1. Review the evaluation report for insights
2. Use recommendations to improve command quality
3. Run evaluation on other commands for comparison
4. Consider creating command templates based on best practices

# Guidelines

**Evaluation Approach:**
- Be thorough but fair in assessment
- Focus on practical usability and effectiveness
- Consider both technical accuracy and user experience
- Provide specific, actionable recommendations

**Scoring Criteria:**
- **Structure (1-10)**: Completeness, organization, logical flow
- **Clarity (1-10)**: Language clarity, instruction precision, ambiguity
- **Consistency (1-10)**: Formatting, terminology, patterns
- **Effectiveness (1-10)**: Constraint enforcement, user guidance, error handling
- **Efficiency (1-10)**: Token usage, conciseness, essential content ratio

**File Modification Rules:**
- ✅ ONLY create files in `${TEST_OUTPUT_DIR}/`
- ❌ NEVER modify original command files
- This command analyzes and documents, does NOT implement changes
- When in doubt, you're probably trying to modify the wrong file

**Quality Standards:**
- Provide detailed, specific feedback
- Focus on actionable improvements
- Consider the command's intended use case
- Balance thoroughness with readability
