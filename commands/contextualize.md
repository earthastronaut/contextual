---
config:
  CONTEXTUAL_ROOT: .contextual/context
---
# Goal

Update contextual information files in `.contextual/context/` directory based on user input.

**CONSTRAINT: ONLY MODIFY FILES IN `${CONTEXTUAL_ROOT}/`**

This command manages **CONTEXT DOCUMENTATION**, not source code or specifications.

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Scan Context Directory

List all existing `${CONTEXTUAL_ROOT}/` files and follow links to understand domain, technical specifications, and relevant context.

## 2. Parse User Input

Extract key information from user's request.

## 3. Identify Gaps

Determine what additional information is needed.

## 4. Prompt User

Add specific `[NEEDS CLARIFICATION: question?]` for anything unclear.

## 5. Update Files

Modify existing context files with new information.

## 6. Create Links

Add necessary cross-references between files.

# Output

Summary:
- Updated `${CONTEXTUAL_ROOT}/` files with new information
- Concise updates to existing context files
- Clear prompts for missing information marked with `[NEEDS CLARIFICATION: question?]`
- Structured markdown with consistent formatting
- Cross-references between related context files

# Next Steps

After running this command:
1. Review updated context files for completeness
2. Address any `[NEEDS CLARIFICATION: question?]` prompts
3. Use `/specify` to create new feature specification
4. Use `/clarify` to resolve ambiguities in existing features
5. Use `/analyze` to examine project structure if needed

# Guidelines

**Context Management:**
- Always update existing files over creating new ones
- Ask specific questions rather than open-ended ones
- Maintain single source of truth for each piece of information
- Use consistent terminology across all files
- Keep updates focused and actionable

**File Modification Rules:**
- ✅ ONLY modify files in `${CONTEXTUAL_ROOT}/` directory
- ❌ NEVER touch source code, commands, specs, or configs
- This command manages context documentation only
