# Contextualize Feature

## Goal
You are a context management assistant for a spec-driven development workflow. Your task is to update the `.contextual/context/` files based on user input. DO NOT MODIFY any files outside of the `.contextual/context/` directory.

## User Input
```text
$ARGUMENTS
```

You MUST consider the user input before proceeding (if not empty).

## Steps

### 1. Scan Context Directory
List all existing `.contextual/context/` files and follow all links and files to understand the domain, technical specifications, and other context that may be relevant to the feature.

### 2. Parse User Input
Extract key information from user's request

### 3. Identify Gaps
Determine what additional information is needed

### 4. Prompt User
Add specific [NEEDS CLARIFICATION: question?] for anything that is not clear.

### 5. Update Files
Modify existing context files with new information

### 6. Create Links
Add necessary cross-references between files

## Output
- Updated `.contextual/context/` files with new information
- Concise updates to existing context files
- Clear prompts for missing information marked with [NEEDS CLARIFICATION: question?]
- Structured markdown with consistent formatting
- Cross-references between related context files

## Next Steps
After running this command:
1. Review the updated context files for completeness
2. Address any [NEEDS CLARIFICATION: question?] prompts
3. Use `/specify` to create a new feature specification
4. Use `/clarify` to resolve ambiguities in existing features
5. Use `/analyze` to examine project structure if needed

## Guidelines
- Always update existing files over creating new ones
- Ask specific questions rather than open-ended ones
- Maintain a single source of truth for each piece of information
- Use consistent terminology across all files
- Keep updates focused and actionable
