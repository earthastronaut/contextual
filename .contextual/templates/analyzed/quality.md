---
# Machine-readable quality metadata
overall_grade: ""  # A, B, C, D, F
metrics:
  lines_of_code: 0
  test_coverage: 0
  doc_coverage: 0
  duplication_level: ""  # low, medium, high
file_sizes:
  small: 0  # < 100 LOC
  medium: 0  # 100-500 LOC
  large: 0  # 500-1000 LOC
  very_large: 0  # > 1000 LOC
tools:
  formatter: ""  # prettier, black, etc.
  linter: ""  # eslint, pylint, etc.
  test_framework: ""  # jest, pytest, etc.
security:
  vulnerabilities: 0
  high_severity: 0
  medium_severity: 0
  low_severity: 0
maintainability_score: 0  # 1-10
---

# Code Quality Analysis

## Overall Score
**Grade**: [A-F]  
**Summary**: [One paragraph assessment]

## Code Metrics

### Size & Complexity
| Category | Count | Status |
|----------|-------|--------|
| Small (< 100 LOC) | [#] | [✅/⚠️/❌] |
| Medium (100-500) | [#] | [✅/⚠️/❌] |
| Large (500-1000) | [#] | [✅/⚠️/❌] |
| Very Large (> 1000) | [#] | [✅/⚠️/❌] |

**Files Needing Attention**:
- `[path]` ([#] lines) - [Issue] - Priority: [H/M/L]

**High Complexity Areas**: [List files/modules]

### Code Duplication
**Level**: [Low / Medium / High]  
**Key Patterns**:
1. [Pattern] in [locations] - [How to refactor] - [Priority]

## Testing Coverage

**Framework**: [Jest / pytest / etc.]  
**Organization**: [How tests are structured]

| Module | Coverage | Status |
|--------|----------|--------|
| [Module] | [%] | [✅/⚠️/❌] |
| **Overall** | **[%]** | [✅/⚠️/❌] |

### Critical Untested Areas
1. **[Module]** - [Why critical] - [Test recommendation]
2. **[Module]** - [Why critical] - [Test recommendation]

## Documentation

| Type | Status | Notes |
|------|--------|-------|
| README | [✅/⚠️/❌] | [Assessment] |
| API Docs | [✅/⚠️/❌] | [Assessment] |
| Code Comments | [✅/⚠️/❌] | [Assessment] |
| Architecture | [✅/⚠️/❌] | [Assessment] |

**Top Needs**: [What needs documentation most]

## Code Consistency

**Formatter**: [Prettier/Black/etc.] - [✅/❌]  
**Linter**: [ESLint/pylint/etc.] - [✅/❌]  
**Style Guide**: [Followed/Partial/Missing]

**Naming**: Files: [✅/⚠️] | Functions: [✅/⚠️] | Variables: [✅/⚠️]  
**Pattern Consistency**: [Assessment]

## Error Handling

**Quality**: [How thorough]  
**Consistency**: [Across codebase]  
**Missing**: [Areas lacking error handling]  
**Logging**: Dev: [approach] | Prod: [approach]

## Security

### Strengths ✅
- [Practice] - [Implementation]

### Concerns ⚠️
1. **[Concern]** - Risk: [level] - [Recommendation] - Priority: [level]

### Security Checklist
| Item | Status |
|------|--------|
| Input Validation | [✅/⚠️/❌] |
| Authentication | [✅/⚠️/❌] |
| Authorization | [✅/⚠️/❌] |
| Injection Protection | [✅/⚠️/❌] |
| XSS Protection | [✅/⚠️/❌] |
| Secrets Management | [✅/⚠️/❌] |

## Maintainability

| Factor | Score (1-10) | Notes |
|--------|--------------|-------|
| Code Clarity | [#] | [Assessment] |
| Test Coverage | [#] | [Assessment] |
| Documentation | [#] | [Assessment] |
| Modularity | [#] | [Assessment] |
| Consistency | [#] | [Assessment] |
| **Overall** | **[#]** | [Summary] |

## Technical Debt

### High-Impact
1. **[Item]** - Impact: [description] - Effort: [time] - [Action plan]

### Quick Wins (High Impact, Low Effort)
1. **[Item]** - Benefit: [what] - Effort: [time] - Priority: [H/M/L]

## Recommendations

### Immediate (This Week)
1. [Action] - [Rationale]
2. [Action] - [Rationale]
3. [Action] - [Rationale]

### Short-Term (1-3 Months)
1. [Goal] - [Rationale]
2. [Goal] - [Rationale]
3. [Goal] - [Rationale]

### Long-Term (3-12 Months)
1. [Improvement] - [Rationale]
2. [Improvement] - [Rationale]
