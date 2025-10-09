# Clarify Feature

## Goal
Update the feature context. Identify and resolve ambiguous areas in the feature $FEATURE_CONTEXT. DO NOT MODIFY the source code only the files within the `./specs/` directory. DO NOT IMPLEMENT THE FEATURE ONLY CREATE THE SPECIFICATION.

## User Input
 $ARGUMENTS

## Steps

### 1. Prerequisites
Execute: `.specify/scripts/bash/clarify.sh`
This will output:
- $FEATURE_CONTEXT: The context file path

### 2. Load Spec File
Analyze $FEATURE_CONTEXT. Perform a structured ambiguity & coverage scan using this taxonomy. For each category, mark status: Clear / Partial / Missing:

   **Functional Scope & Behavior**: Core user goals, success criteria, out-of-scope declarations, user roles
   **Domain & Data Model**: Entities, attributes, relationships, identity rules, lifecycle transitions
   **Interaction & UX Flow**: Critical user journeys, error/empty/loading states, accessibility
   **Non-Functional Quality**: Performance, scalability, reliability, observability, security, compliance
   **Integration & Dependencies**: External services/APIs, data formats, protocol assumptions
   **Edge Cases & Failure**: Negative scenarios, rate limiting, conflict resolution
   **Constraints & Tradeoffs**: Technical constraints, explicit tradeoffs
   **Terminology & Consistency**: Canonical glossary terms, avoided synonyms
   **Completion Signals**: Acceptance criteria testability, measurable Definition of Done

### 3. Generate Clarification Questions
Generate a prioritized queue of candidate clarification questions (maximum 5):
   - Each question must be answerable with multiple-choice (2-5 options) OR short answer (≤5 words)
   - Only include questions that materially impact architecture, data modeling, test design, UX behavior, or compliance
   - Favor clarifications that reduce downstream rework risk
   - If more than 5 categories remain unresolved, select top 5 by (Impact * Uncertainty) heuristic

### 4. Sequential Questioning Loop
Sequential questioning loop (interactive):
   - Present EXACTLY ONE question at a time
   - For multiple-choice: render options as Markdown table with A/B/C options + "Short" for free-form
   - For short-answer: output "Format: Short answer (≤5 words)"
   - After user answers: validate answer maps to option or fits constraint
   - Stop when: all critical ambiguities resolved, user signals completion, or 5 questions reached
   - Never reveal future queued questions in advance

### 5. Integration After Each Answer
Integration after EACH accepted answer:
   - Ensure `## Clarifications` section exists with `### Session YYYY-MM-DD` subheading
   - Append bullet: `- Q: <question> → A: <final answer>`
   - Apply clarification to appropriate section(s) in ${FEATURE_CONTEXT} file:
     * Functional ambiguity → Update Functional Requirements
     * User interaction → Update User Stories or Actors
     * Data shape → Update Data Model
     * Non-functional → Add/modify Quality Attributes
     * Edge case → Add to Edge Cases / Error Handling
     * Terminology → Normalize term across spec
   - Save ${FEATURE_CONTEXT} file AFTER each integration
   - Preserve formatting and heading hierarchy

### 6. Validation
Validation (after EACH write plus final pass):
   - Clarifications session contains exactly one bullet per accepted answer
   - Total asked questions ≤ 5
   - Updated sections contain no lingering vague placeholders
   - No contradictory statements remain
   - Markdown structure valid

### 7. Report Completion
Concise report completion:
   - Number of questions asked & answered
   - Path to updated ${FEATURE_CONTEXT} file
   - Coverage summary table with Status: Resolved/Deferred/Clear/Outstanding
   - Suggested next command

## Output
- Updated $FEATURE_CONTEXT file with clarifications integrated into appropriate sections
- `## Clarifications` section with session subheading and Q&A format
- Resolved ambiguities marked as clear in the specification
- Coverage summary table showing status of all categories

## Next Steps
After running this command:
1. Review the updated $FEATURE_CONTEXT file for completeness
2. Use `/plan` to create implementation plan if all clarifications are resolved
3. Use `/analyze` to examine project structure if needed
4. Use `/implement` to begin implementation once planning is complete

## Guidelines
- Create `## Clarifications` section if missing in $FEATURE_CONTEXT file
- Add session subheading with date
- Update appropriate spec sections in $FEATURE_CONTEXT file
- Remove contradictory statements
- Preserve formatting and structure
