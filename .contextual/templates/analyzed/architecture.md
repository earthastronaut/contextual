---
# Machine-readable architecture metadata
architectural_style: ""  # monolith, microservices, layered, hexagonal, etc.
patterns_used: []  # [repository, factory, observer, etc.]
state_management: ""  # redux, context, signals, etc.
authentication:
  method: ""  # oauth, jwt, session
  provider: ""  # auth0, firebase, custom
data_storage:
  type: ""  # sql, nosql, file-system
  technology: ""  # postgresql, mongodb, sqlite
  access_pattern: ""  # orm, query-builder, raw-sql
layers: []  # [{name, location, purpose}]
---

# Architecture & Design

## Architectural Style
**Type**: [Monolith / Microservices / Layered / Hexagonal / etc.]  
**Description**: [2-3 sentences explaining the approach]  
**Rationale**: [Why this was chosen]

## System Architecture

### Layers (if applicable)
1. **[Layer]** (`[location]`) - [Purpose] - [Dependencies]
2. **[Layer]** (`[location]`) - [Purpose] - [Dependencies]
3. **[Layer]** (`[location]`) - [Purpose] - [Dependencies]

### Component Diagram
```
┌─────────────┐
│ [Component] │
└──────┬──────┘
       ↓
┌─────────────┐
│ [Component] │
└──────┬──────┘
       ↓
┌─────────────┐
│ [Component] │
└─────────────┘
```

## Key Design Patterns

### [Pattern Name]
**Where**: `[location]`  
**Purpose**: [Problem it solves]  
**How**: [Implementation approach]

### [Pattern Name]
**Where**: `[location]`  
**Purpose**: [Problem it solves]  
**How**: [Implementation approach]

## Data Flow

### [Flow Type] (e.g., Request/Response)
```
1. [Step] → 2. [Step] → 3. [Step] → 4. [Step]
```

### State Management
**Pattern**: [Redux / Context / Signals / etc.]  
**Scope**: [Global / Feature / Component]  
**Location**: `[path]`

## Data Storage
**Type**: [Database type]  
**Technology**: [Specific DB]  
**Access**: [Direct SQL / ORM / Query Builder]  
**Caching**: [Strategy and technology]

## Authentication & Authorization
**Auth Method**: [OAuth / JWT / Session]  
**Provider**: [Auth0 / Firebase / Custom]  
**Authorization Model**: [RBAC / ABAC]

## Error Handling
**Client**: [How errors are handled]  
**Server**: [How errors are handled]  
**Logging**: [Dev vs Production]

## Configuration
**Development**: [How configured]  
**Production**: [How configured]  
**Secrets**: [How managed]  
**Feature Flags**: [If present]

## Performance
**Optimizations**: [Key strategies]  
**Known Bottlenecks**: [Areas of concern]

## Scalability
**Horizontal**: [Capability and approach]  
**Vertical**: [Capability and limits]

## Security
**Layers**: [Protection mechanisms]  
**Key Mitigations**:
- [Threat] → [Mitigation]
- [Threat] → [Mitigation]

## Testing Strategy
**Unit**: [How isolated and tested]  
**Integration**: [How tested]  
**E2E**: [How tested]

## Deployment
**Infrastructure**: [Where deployed]  
**Orchestration**: [K8s / Docker / etc.]  
**CI/CD**: [How automated]  
**Environments**: [Dev / Staging / Prod]
