# Goal

Improve the quality of the commands in the `commands/` directory based on the `/tester` command output.

# Steps

## Phase 1: task.md

### Immediate Fixes
- [x] Expand all step descriptions with detailed, actionable instructions. Balance this with still being concise.
- [x] Add error handling and edge case guidance. Concise but helpful.

### Short-term Improvements (Medium Priority)
- [x] Improve step-by-step clarity.
- [x] Add troubleshooting guidance.
- [x] Enhance guidelines section.

## Additional Tasks


### task.md
- [x] Update Implement Task section with detailed, actionable steps for better clarity

### analyze.md
- [x] Implement immediate fixes and short-term improvements for analyze.md command
### Immediate Fixes (High Priority)
1. Simplify the command structure and reduce complexity by 50-70%
2. Clarify depth level explanations and make them more intuitive
3. Streamline the analysis process steps
4. Reduce redundancy in output specifications
### Short-term Improvements (Medium Priority)
1. Better organize the analysis process into clearer phases
2. Simplify the output template specifications
3. Add more practical examples and guidance
4. Improve step-by-step clarity

### contextualize.md
- [x] Expand all step descriptions with detailed, actionable instructions but keep it concise.
- [x] Add error handling and edge case guidance
- [x] Provide clear file organization guidelines
- [x] Add input interpretation guidelines
- [x] Add examples of context file organization
- [x] Improve step-by-step clarity
- [x] Add troubleshooting guidance
- [x] Add the file structure as configuration at the top of the command file and reference it as ${STRUCTURE}.
```markdown
---
config:
    STRUCTURE:
        "technology.md": "Concentrate on technical implementation details (specifications, architecture, APIs, etc.)"
        "product.md": "Emphasize user experience and product strategy aspects (personas, user stories, design, etc.)"
        "domains.md": "Focus on pure business logic elements (definitions, entities, business rules, etc.)"
        "README.md": "Central point of contact to reference other files."
---
```
