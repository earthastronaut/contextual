# Feature: concise-specify-command

## Overview
Reduce `/specify` command from 69 to ~40 lines by removing verbose validation, redundant instructions, and forced context reading. Maintain compatibility with existing workflow commands.

## Requirements
- Cut command length by 40% while preserving core functionality
- Replace arbitrary 30-char minimum with intelligent validation
- Make context analysis conditional based on input detail level
- Add anti-duplication guidelines to improve generated spec quality

## Technical Specifications
Modify only `commands/specify.md` - no bash scripts, templates, or config changes.
Modify the `.contextual/templates/context.md` template to be more concise.

## Acceptance Criteria
- Command reduced to ~40 lines with simpler validation and conditional context reading
- Generated specs are concise with minimal duplication across sections
- Existing workflow commands remain compatible

## Implementation Notes

### Key Changes
1. **Merge Steps**: Combine validation + feature name generation; condense redundant instructions
2. **Conditional Context**: Read CONTEXT_ROOT only when user input lacks technical detail
3. **Remove Sections**: Delete "Output" (implicit) and condense "Next Steps" to one line
4. **Quality Guidelines**: Add 6 rules to prevent duplicate data in specs:
   - Avoid cross-section repetition
   - Keep sections focused and unique
   - Skip obvious details and template boilerplate
   - Cross-reference rather than duplicate
   - Distinguish acceptance criteria from requirements
   - Make tasks specific implementation steps, not requirement restatements

## Tasks
- [ ] Design streamlined command format
- [ ] Add anti-duplication guidelines to command
- [ ] Update specify.md
- [ ] Test with various inputs (short/long, technical/vague)
