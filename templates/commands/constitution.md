---
description: Create or update the project constitution from interactive or provided inputs, enforce the FutureStandard core stack, and keep all dependent templates in sync.
handoffs:
  - label: Build Specification
    agent: speckit.specify
    prompt: Implement the feature specification based on the updated constitution. I want to build...
inputs:
  help: |
    Optional $ARGUMENTS you can pass in chat (plain text or YAML block):
      - project_name: string
      - ratified_on: YYYY-MM-DD (if unknown, leave blank; tool will TODO it)
      - add_principles:
          - title: string
            details: string (bullets or paragraph)
      - db_choice: postgresql | mongodb  (default: postgresql)
      - db_reason: string (if mongodb is selected, REQUIRED)
      - keep_comments: true|false (default: false)
---

## User Input

$ARGUMENTS

You **MUST** consider the user input before proceeding (if not empty).

---

## Goal

1. Update `.specify/memory/constitution.md`.
2. Use simple English.
3. Enforce **FutureStandard core stack** rules:

### Frontend (REQUIRED)
- Next.js (App Router)
- TypeScript (TSX)
- TailwindCSS
- shadcn/ui
- `src/` folder for all app code
- Typed React; avoid `any` unless justified

### BFF (REQUIRED)
- FastAPI (**async**)
- Required folders:
  - `router/` (I/O validation)
  - `service/` (business logic)
  - `repository/` (database)
  - `client/` (external HTTP, must have retries + timeouts)
- Business logic MUST NOT exist outside `service/`

### Backend (REQUIRED)
- FastAPI (**async**)
- Same layered structure as BFF

### Database (REQUIRED)
- **PostgreSQL** is the default
- MongoDB allowed only with:
  - Written justification
  - Collection schemas
  - Sample documents
  - Planned indexes (single / compound / TTL)
- DSNs MUST be in env variables
- No credentials in code

### Contract‑First (REQUIRED)
- API contracts MUST be defined before coding
- FastAPI: OpenAPI + Pydantic
- Frontend: Zod (when needed)
- Define error shapes
- No breaking changes without version bump + migration plan

### Testing (REQUIRED)
- Frontend: component + integration tests
- BFF/BE: unit + service + repository + contract tests
- A feature is NOT done until tests exist and pass

### Observability & Logging (REQUIRED)
- OpenTelemetry (FE → BFF → BE)
- JSON logs MUST include:
  - `trace_id`
  - `service_name`
  - `request_path`
  - `error_type`

### Security & Reliability (REQUIRED)
- JWT with short‑lived tokens
- Authorization in BFF
- No secrets in repo
- Every HTTP call MUST have timeout + retry

### Performance (REQUIRED)
- FE LCP < 2.5s
- Internal APIs p95 < 200 ms
- Public APIs p95 < 500 ms

### Simplicity & Versioning
- Keep design simple
- Use semantic versioning (MAJOR.MINOR.PATCH)

---

## Project‑Specific Additional Principles

Append items from `add_principles[]`.

**Must be append‑only. Do NOT edit base rules.**

<!-- FS:ADDENDA:BEGIN -->
(Your project-specific rules go here)
<!-- FS:ADDENDA:END -->

---

## Execution Flow

### 1) Load Constitution
- Load `.specify/memory/constitution.md`
- If missing, copy from `.specify/templates/constitution-template.md`
- Detect placeholders like `[PLACEHOLDER_NAME]`

### 2) Resolve Placeholders & Inputs

Fill values using:
- User input
- Repo metadata

Replace:

- `[PROJECT_NAME]`
- `RATIFICATION_DATE`
- `LAST_AMENDED_DATE`
- `CONSTITUTION_VERSION`

**Version rules:**
- MAJOR → Breaking governance changes  
- MINOR → New principles or expanded guidance  
- PATCH → Typos, grammar, clarity  

### 3) Draft Updated Content
- Replace ALL placeholders
- Keep headings unchanged
- Remove comments unless `keep_comments: true`
- Ensure ALL core principles appear exactly as specified

### 4) Propagate to Templates

Update:

- `.specify/templates/plan-template.md`  
- `.specify/templates/spec-template.md`  
- `.specify/templates/tasks-template.md`  
- `.specify/templates/commands/*.md`  

Each template MUST reflect:
- Core frontend/backend stack
- Layered architecture
- Database rules
- Contract-first requirements
- Observability/logging rules
- Testing obligations

### 5) Sync Impact Report

Add at top of constitution as HTML comment:

### 6) Validation Gates

The update MUST fail if:

- ANY `[PLACEHOLDER]` remains
- Missing required stack keywords:
  - Next.js, TypeScript, TSX, Tailwind, shadcn/ui, src/
  - FastAPI, async, router/, service/, repository/, client/
  - PostgreSQL, MongoDB (with justification)
  - OpenTelemetry, trace_id, service_name, request_path, error_type
  - component tests, integration tests, unit tests, contract tests
- Dates not in `YYYY-MM-DD`
- Version mismatch between header + report
- Weak language ("should") used instead of MUST/REQUIRED where needed

### 7) Write File
Overwrite `.specify/memory/constitution.md`.

### 8) Final Output

Return:
- New version
- Version bump rationale
- Pending manual edits (if any)
- Suggested commit message:


docs: amend constitution to vX.Y.Z (enforce core stack + addenda support)

---

## Notes for the Agent

- Base principles are **immutable**
- Addenda section is **append-only**
- Removing base rules = **MAJOR** version bump
- MongoDB requires full justification
- Prefer MUST/REQUIRED for enforceable rules
- Keep the document simple + testable

---

## Formatting Rules

- Keep original heading levels
- Wrap long lines (~100 chars)
- Leave one blank line between sections
- Avoid trailing spaces
- Use bullet lists for clarity

