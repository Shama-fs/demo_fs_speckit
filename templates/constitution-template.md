# [PROJECT_NAME] Constitution
<!-- Base company standards + optional extendable principles -->

## Core Principles

### I. Frontend Standard (Next.js + Tailwind + TSX + shadcn/ui)
- Use Next.js (App Router) with TypeScript (TSX)
- Use a `src/` folder for all app code
- Use TailwindCSS for styling
- Use shadcn/ui as the shared UI library
- Write strictly typed React code (avoid `any` unless justified)

---

### II. BFF Standard (FastAPI + async + layered design)
- Use FastAPI (async)
- Required folders:
  - `router/` → define endpoints + validate inputs/outputs  
  - `service/` → business logic only  
  - `repository/` → DB reads/writes only  
  - `client/` → external API calls (must include timeouts + retries)


---

### III. Backend Standard (FastAPI + layered design)
- Use FastAPI (async)
- Must follow the same layers:
  - router → service → repository → client
- Validation, structure, and error handling must match BFF patterns

---

### IV. Database Standard (PostgreSQL or MongoDB)
- Default: PostgreSQL
- MongoDB allowed only with:
  - A written justification
  - Document schemas
  - Sample documents
  - Index plan (single, compound, TTL)
- DB connection strings must come from environment variables
- Use connection pooling

---

### V. Contract-First API Development
- Define API contracts before coding
- Use OpenAPI + Pydantic on FastAPI
- Document error shapes and version rules
- No breaking changes without version increments

---

### VI. Testing Requirements
**Frontend**
- Component tests  
- Integration tests  

**BFF / Backend**
- Unit tests  
- Service tests  
- Repository tests  
- Contract tests between FE ↔ BFF and BFF ↔ BE  

A feature is not complete until tests exist and pass.

---

### VII. Observability & Logging
- Use OpenTelemetry tracing (FE → BFF → BE)
- Use JSON logs with required keys:
  - `trace_id`
  - `service_name`
  - `request_path`
  - `error_type`

---

### VIII. Security & Reliability
- Use JWT authentication with short-lived tokens
- Authorization must be handled in the BFF
- Never commit secrets
- All HTTP calls must include:
  - timeout  
  - retry logic  
  - a standard error format

---

## Project-Specific Additional Principles (Optional)
<!-- This section lets each project add extra rules without touching base standards -->

Projects may add more principles here if needed.  
Examples:
- Domain-specific laws (e.g., "Analytics pipelines must use Kafka")
- Extra security rules (e.g., "Payment service must encrypt fields XYZ")
- Extra performance rules
- Architecture limits (e.g., "This project must remain serverless")

Each added principle MUST include:
- A title
- A clear explanation
- Why it is needed for this project

---

## Development Workflow & Quality Checks

### Developer Workflow
1. `/speckit.specify` → Write the feature spec  
2. `/speckit.plan` → Architecture, data model, contracts, folders  
3. `/speckit.tasks` → Generate task list  
4. `/speckit.checklist` → Confirm required sections  
5. `/speckit.implement` → Build the feature  
6. Testing + Code Review

### Quality Gates (must pass before merge)
- Layering rules followed  
- DB choice justified  
- Contracts written  
- Observability added  
- Test strategy complete  
- Acceptance criteria complete  
- No contract mismatch between FE ↔ BFF ↔ BE  

---

## Governance
- This Constitution overrides all other team rules  
- All PRs must check compliance  
- To change this Constitution, you must provide:
  - A written justification
  - A migration plan (if needed)
  - A version update  
- Any plan or spec breaking these rules must be fixed before implementation

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]