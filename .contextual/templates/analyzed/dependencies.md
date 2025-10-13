---
# Machine-readable dependency metadata
total_dependencies: 0
production_dependencies: 0
dev_dependencies: 0
health: ""  # excellent, good, needs-attention, poor
security:
  vulnerabilities: 0
  high: 0
  medium: 0
  low: 0
update_status:
  up_to_date: 0
  minor_updates: 0
  major_updates: 0
  outdated: 0
internal:
  circular_dependencies: 0
  coupling: ""  # loose, tight, mixed
critical_dependencies: []  # [{name, version, purpose}]
---

# Dependencies Analysis

## Overview
**Total External Dependencies**: [#]  
**Direct**: [#] | **Dev**: [#]  
**Overall Health**: [Excellent / Good / Needs Attention / Poor]

## Dependency Summary

### Production
| Category | Count | Key Examples |
|----------|-------|--------------|
| [Framework/Core] | [#] | [lib1, lib2] |
| [UI/Components] | [#] | [lib1, lib2] |
| [Data/API] | [#] | [lib1, lib2] |
| [Utilities] | [#] | [lib1, lib2] |

### Development
| Category | Count | Key Examples |
|----------|-------|--------------|
| [Build] | [#] | [lib1, lib2] |
| [Testing] | [#] | [lib1, lib2] |
| [Linting] | [#] | [lib1, lib2] |

## Critical Dependencies

### [Dependency Name]
**Version**: [v]  
**Purpose**: [What it provides]  
**Status**: [✅ Current / ⚠️ Update Available / ❌ Outdated]  
**Used By**: [Where in codebase]

<!-- Repeat for top 5-8 critical dependencies -->

## External Dependencies by Category

| Category | Package | Version | Status |
|----------|---------|---------|--------|
| [Category] | [name] | [v] | [✅/⚠️/❌] |

## Internal Dependencies

### Module Dependency Graph
```
[Module A] → depends on: [B], [C] | used by: [D]
[Module B] → depends on: [C] | used by: [A], [D]
```

### Most Depended-Upon
1. **`[path]`** - [#] importers - [Purpose] - Risk: [H/M/L]
2. **`[path]`** - [#] importers - [Purpose] - Risk: [H/M/L]

**Circular Dependencies**: [✅ None / ⚠️ [#] found]  
**Coupling**: [Loose / Tight / Mixed]

## Health Status

### Update Status
**Up-to-Date** ✅: [List key packages]  
**Minor Updates** ⚠️: [pkg] ([v] → [v])  
**Major Updates** ⚠️: [pkg] ([v] → [v]) - Breaking: [Y/N]  
**Outdated/Deprecated** ❌: [pkg] - [Migration path]

### Security
| Package | Severity | CVE | Fix |
|---------|----------|-----|-----|
| [name] | [H/M/L] | [ID] | [Y/N] |

**Summary**: [#] vulnerabilities ([#] high, [#] med, [#] low)

### Bundle Size (if applicable)
| Package | Size | Notes |
|---------|------|-------|
| [name] | [KB] | [Optimization opportunity?] |

## Unused & Redundant

**Potentially Unused**: [List packages to investigate]  
**Redundant**:
- [Functionality]: [pkg1], [pkg2] → Consolidate to [pkg]

## Risks

### High-Risk
1. **[Package]** - Risk: [description] - Mitigation: [approach]

### Single Points of Failure
1. **[Package]** - Critical because: [why] - Fallback: [plan]

### Maintenance Concerns
| Package | Last Update | Issues | Activity |
|---------|-------------|--------|----------|
| [name] | [date] | [#] | [Active/Slow/Dead] |

## Management

**Current Practices**: [How deps are managed]  
**Update Frequency**: [How often]  
**Automation**: [Dependabot / Renovate / None]

### Recommendations
1. [Improvement] - [Rationale]
2. [Improvement] - [Rationale]

## Licensing
**Project License**: [Type]  
**Dep Licenses**: [List if concerning]  
**Incompatibilities**: [✅ None / ⚠️ Issues]

## Recommendations

### Immediate
1. [Action] - [Why]
2. [Action] - [Why]

### Short-Term (1-3 Months)
1. [Action] - [Why]

### Long-Term (3-12 Months)
1. [Action] - [Why]

