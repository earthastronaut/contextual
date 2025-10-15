---
config:
  CONTEXT_ROOT: README.md
---
# Goal

Update contextual information files in `.contextual/context/` directory based on user input.

**CONSTRAINT: ONLY MODIFY FILES IN `.contextual/context/`**

This command manages **CONTEXT DOCUMENTATION**, not source code or specifications.

# User Input

```text
${ARGUMENTS}
```

# Steps

## 1. Initialize Context Directory

1. Check if `.contextual/context/` directory exists
2. If not, create it
3. If user input is empty:
   - Create `technology.md` (for technical stack and architecture details)
   - Create `product.md` (for product requirements and specifications)
   - Create `domains.md` (for business domains and terminology)
   - Add references to these files in `${CONTEXT_ROOT}` (README.md)
   - STOP after initialization

## 2. Scan Context Directory

1. Get changed files: `git diff --name-only --cached` and `git diff --name-only`
2. List all existing `.contextual/context/` files
3. Follow links to understand domain, technical specifications, and relevant context
4. If `${CONTEXT_ROOT}` exists, read it for global project context and conventions

## 3. Parse User Input

Extract key information from user's request.

## 4. Identify Gaps

Determine what additional information is needed.

## 5. Prompt User

Add specific `[NEEDS CLARIFICATION: question?]` for anything unclear.

## 6. Update Files

Modify existing context files with new information.

## 7. Create Links

Add necessary cross-references between files.

# Output

Summary:
- Updated `.contextual/context/` files with new information
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

**Global Context:**
- Always read `${CONTEXT_ROOT}` if it exists for project-wide context
- Use global context to maintain consistency with project conventions
- Avoid duplicating information that belongs in `${CONTEXT_ROOT}`

**Context Management:**
- Always update existing files over creating new ones
- Ask specific questions rather than open-ended ones
- Maintain single source of truth for each piece of information
- Use consistent terminology across all files
- Keep updates focused and actionable

**File Modification Rules:**
- ✅ ONLY modify files in `.contextual/context/` directory
- ❌ NEVER touch source code, commands, specs, or configs
- This command manages context documentation only
