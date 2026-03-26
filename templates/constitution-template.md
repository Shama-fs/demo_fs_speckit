# [PROJECT_NAME] Constitution
<!-- Base company standards + optional extendable principles -->

## Core Principles

### I. Frontend Standard (Next.js + Tailwind + TSX + shadcn/ui)
- Use Next.js (App Router) with TypeScript (TSX).
- Use a `src/` folder for all app code.
- Use TailwindCSS for styling.
- Use shadcn/ui as the shared UI library.
- Write strictly typed React code (avoid `any` unless justified).

---

### II. BFF Standard (FastAPI + async + layered design)
- Use FastAPI (async).   
- Required folders:
  - `router/` → define endpoints + validate inputs/outputs (server-side validation is mandatory).
  - `service/` → business logic only.
  - `repository/` → DB reads/writes only.
  - `client/` → external API calls (must include timeouts + retries).

---

### III. Backend Standard (FastAPI + layered design)
- Use FastAPI (async). 
- Must follow the same layers:
  - router → service → repository → client
- Validation, structure, and error handling must match BFF patterns. 

---

### IV. Database Standard (PostgreSQL or MongoDB)
- Default: PostgreSQL.
- MongoDB allowed only with:
  - Proper schemas
- DB connection strings must come from environment variables (never hardcoded). 
- Use connection pooling.

---

### V. Contract-First API Development
- Define API contracts before coding.
- Use OpenAPI + Pydantic on FastAPI for schema-driven validation and documentation.
- Document error shapes and version rules.
- No breaking changes without version increments.

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
- Use OpenTelemetry tracing (FE → BFF → BE) to track a request path through the system. 
- Use structured logs (JSON) that can correlate with tracing context (trace/span identifiers where available).
- Required log keys:
  - `trace_id`
  - `service_name`
  - `request_path`
  - `error_type`

---

### VIII. Security & Reliability (MANDATORY)
#### 8.1 Secrets & sensitive data
- Never commit secrets. Secrets include API keys, tokens, passwords, certificates, private keys, DB credentials. 
- Secrets must not be stored unprotected in repositories or configuration files checked into source control. 
- Secrets must be injected via environment variables or a dedicated secrets manager (preferred) and rotated as needed.

#### 8.2 Authentication & Authorization
- Use JWT authentication with short-lived tokens.
- Authorization must be enforced in the BFF (server-side) for all protected operations.

#### 8.3 Input validation (REQUIRED everywhere)
- All external input MUST be validated on the server as early as possible (request boundary). 
- Validation must include syntactic + semantic checks (type/format + business constraints).
- Prefer allowlists and strict schemas over blocklists.

#### 8.4 Safe external calls & resilience
- All HTTP calls must include:
  - timeout
  - retry logic (bounded)
  - a standard error format
- Avoid leaking internal errors/stack traces to clients.

---

### IX. AI Safety & Sensitive Information Guardrails (MANDATORY)

#### 9.1 Never read or process sensitive information
The AI must NOT read, summarize, transform, or request sensitive content, including secrets and confidential data.

Examples include:
- `.env`, tokens, API keys, private keys, certificates, database credentials.
- Any file or snippet containing production credentials or access keys.

#### 9.2 Sensitive file patterns (do not open / do not paste)
Do not read files matching these patterns (must warn user instead):
- `.env`, `.env.*`, `*.pem`, `*.key`, `*.pfx`, `*.p12`, `*.jks`
- `id_rsa`, `id_ed25519`, `known_hosts`
- `secrets.*`, `credentials.*`, `token.*`
- Cloud credentials and key stores (AWS/Azure/GCP credential files)
- Any folder named: `secrets/`, `private/`, `prod/credentials/`

Exception:
- Safe examples like `.env.example` with placeholders only (no real secrets).

#### 9.3 Mandatory warning behavior
If the user attempts to paste/upload sensitive content, the AI must:
1) Immediately warn: “This appears to be sensitive information.”  
2) Continue only with user permission and sanitized content.

#### 9.4 Safe examples only
All examples must use placeholders (never real secrets). 
Example:
- `DATABASE_URL="postgresql://USER:REDACTED@HOST:5432/DB"`

---

### X. Secure Coding Practices (MANDATORY)
- Use defense-in-depth: validate inputs, apply least privilege, and avoid unsafe patterns. 
- Use framework-native validation (Pydantic models in FastAPI) to enforce schema correctness. 
- Do not introduce unnecessary dependencies; prefer maintained, well-known libraries.

---

### XI. Output Quality: Optimized & Compact (REQUIRED)
- Generated code must be minimal, readable, and maintainable:
  - Avoid duplication; prefer small reusable functions.
  - Remove unused imports, dead code, and unused configs.
- Be performance-aware:
  - Avoid unnecessary loops, repeated work, and unbounded retries.
  - Prefer efficient data shapes and minimal payloads.
- Prefer “update existing files” over rewriting when iterating on an existing project, to preserve work and reduce churn. 

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
2.`/speckit.clarify` → Clarify the ambiguity
2. `/speckit.plan` → Architecture, data model, contracts, folders  
3. `/speckit.tasks` → Generate task list  
4. `/speckit.checklist` → Confirm required sections  
5. `/speckit.implement` → Build the feature  
6. Testing + Code Review

### Quality Gates (must pass before merge)
- Layering rules followed  
- DB choice justified  
- Contracts written  
- Observability added (trace correlation + structured logs) 
- Test strategy complete  
- Acceptance criteria complete  
- No contract mismatch between FE ↔ BFF ↔ BE  

---

## Governance
- This Constitution overrides all other team rules.  
- All PRs must check compliance.  
- To change this Constitution, you must provide:
  - A written justification
  - A migration plan (if needed)
  - A version update  
- Any plan or spec breaking these rules must be fixed before implementation.

---

## FutureStandard Compliance Checklist (MANDATORY)
Before considering work complete, confirm: 
- [ ] No secrets/sensitive information were requested, read, or included.  
- [ ] Server-side input validation exists for every external input.   
- [ ] No hardcoded credentials or unsafe logging of secrets. 
- [ ] Observability is present (trace correlation + structured logs).
- [ ] Output is compact and avoids unnecessary dependencies/boilerplate. 

---

**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]