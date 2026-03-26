---
description: Create or update the project constitution, enforce the FutureStandard core stack, add AI safety/security/compactness guardrails, and keep dependent templates in sync.
argument-hint: |
  Optional $ARGUMENTS (plain text or YAML). Use YAML for structured updates:
    project_name: string
    ratified_on: YYYY-MM-DD (optional; if unknown, leave TODO)
    last_amended_on: YYYY-MM-DD (optional; if unknown, leave TODO)
    constitution_version: X.Y.Z (optional; if missing, auto-bump)
    keep_comments: true|false (default: false)
    add_principles:
      - title: string
        details: string
    db_choice: postgresql|mongodb (default: postgresql)
    db_reason: string (required if mongodb selected)
handoffs:
  - label: Build Specification
    agent: speckit.specify
    prompt: Implement the feature specification based on the updated constitution. I want to build...
---

## User Input

$ARGUMENTS

You **MUST** consider the user input before proceeding (if not empty).

---

## Goal

1. Update `.specify/memory/constitution.md` so it matches the **FutureStandard Constitution Template** below.
2. Use simple English.
3. Enforce FutureStandard core stack rules (immutable base rules).
4. Add guardrails:
   - Sensitive information must not be read by AI; must warn users.
   - Secure coding practices + mandatory input validation.
   - Optimized and compact output; avoid unnecessary boilerplate.

---

## Canonical FutureStandard Constitution Content (MUST MATCH)

You MUST ensure the constitution file contains the following sections and rules (same meaning, same headings, minimal wording changes allowed for clarity only):

### I. Frontend Standard (Next.js + Tailwind + TSX + shadcn/ui)
- Use Next.js (App Router) with TypeScript (TSX).
- Use a `src/` folder for all app code.
- Use TailwindCSS for styling.
- Use shadcn/ui as the shared UI library.
- Write strictly typed React code (avoid `any` unless justified).

### II. BFF Standard (FastAPI + async + layered design)
- Use FastAPI (async).
- Required folders:
  - `router/` → define endpoints + validate inputs/outputs (server-side validation is mandatory).
  - `service/` → business logic only.
  - `repository/` → DB reads/writes only.
  - `client/` → external API calls (must include timeouts + retries).

### III. Backend Standard (FastAPI + layered design)
- Use FastAPI (async).
- Must follow the same layers:
  - router → service → repository → client
- Validation, structure, and error handling must match BFF patterns.

### IV. Database Standard (PostgreSQL or MongoDB)
- Default: PostgreSQL.
- MongoDB allowed only with proper schemas.
- DB connection strings must come from environment variables (never hardcoded).
- Use connection pooling.

### V. Contract-First API Development
- Define API contracts before coding.
- Use OpenAPI + Pydantic on FastAPI for schema-driven validation and documentation.
- Document error shapes and version rules.
- No breaking changes without version increments.

### VI. Testing Requirements
Frontend:
- Component tests
- Integration tests

BFF / Backend:
- Unit tests
- Service tests
- Repository tests
- Contract tests between FE ↔ BFF and BFF ↔ BE

A feature is not complete until tests exist and pass.

### VII. Observability & Logging
- Use OpenTelemetry tracing (FE → BFF → BE).
- Use structured logs (JSON) that can correlate with tracing context.
- Required log keys:
  - `trace_id`
  - `service_name`
  - `request_path`
  - `error_type`

### VIII. Security & Reliability (MANDATORY)
8.1 Secrets & sensitive data
- Never commit secrets (API keys, tokens, passwords, certificates, private keys, DB credentials).
- Secrets must not be stored unprotected in repositories.
- Secrets must be injected via environment variables or secrets manager and rotated as needed.

8.2 Authentication & Authorization
- Use JWT authentication with short-lived tokens.
- Authorization must be enforced in the BFF (server-side) for all protected operations.

8.3 Input validation (REQUIRED everywhere)
- All external input MUST be validated on the server as early as possible.
- Validation must include syntactic + semantic checks.
- Prefer allowlists and strict schemas over blocklists.

8.4 Safe external calls & resilience
- All HTTP calls must include timeout + bounded retry + standard error format.
- Avoid leaking internal errors/stack traces to clients.

### IX. AI Safety & Sensitive Information Guardrails (MANDATORY)
9.1 Never read or process sensitive information
- The AI must NOT read, summarize, transform, or request sensitive content, including secrets and confidential data.

9.2 Sensitive file patterns (do not open / do not paste)
- Do not read `.env`, `.env.*`, `*.pem`, `*.key`, `*.pfx`, `*.p12`, `*.jks`
- Do not read `id_rsa`, `id_ed25519`, `known_hosts`
- Do not read `secrets.*`, `credentials.*`, `token.*`
- Do not read cloud credential stores
- Do not read folders named: `secrets/`, `private/`, `prod/credentials/`
Exception: `.env.example` with placeholders only.

9.3 Mandatory warning behavior
- If the user attempts to paste/upload sensitive content:
  1) Warn immediately: “This appears to be sensitive information.”
  2) Proceed only with sanitized content.

9.4 Safe examples only
- Examples must use placeholders (never real secrets).

### X. Secure Coding Practices (MANDATORY)
- Defense-in-depth: validate inputs, least privilege, avoid unsafe patterns.
- Use Pydantic validation for FastAPI schema correctness.
- Avoid unnecessary dependencies; prefer maintained libraries.

### XI. Output Quality: Optimized & Compact (REQUIRED)
- Minimize boilerplate; remove unused imports, dead code, unused configs.
- Be performance-aware; avoid unbounded retries and unnecessary loops.
- Prefer updating existing files over rewriting during iteration.

---

## Project-Specific Additional Principles (Append-Only)
- Append add_principles[] content into the addenda section.
- Must be append-only. Do NOT edit base rules.

Use markers:

<!-- FS:ADDENDA:BEGIN -->
(Your project-specific rules go here)
<!-- FS:ADDENDA:END -->

---

## Execution Flow

### 1) Load Constitution
- Load `.specify/memory/constitution.md`
- If missing, copy from `.specify/templates/constitution-template.md`

### 2) Resolve Placeholders
Replace ALL placeholders:
- `[PROJECT_NAME]`
- `[CONSTITUTION_VERSION]`
- `[RATIFICATION_DATE]`
- `[LAST_AMENDED_DATE]`

If unknown dates, write `TODO:YYYY-MM-DD`.

### 3) Versioning
If `constitution_version` not provided:
- PATCH for typos/clarity only
- MINOR for new principles/guardrails
- MAJOR if removing/weakening base principles

### 4) Write Updated Constitution
- Keep heading levels unchanged.
- Remove comments unless `keep_comments: true`.
- Ensure ALL core principles + guardrails exist.

### 5) Propagate to Templates (Sync)
Update these so they reflect the constitution:
- `.specify/templates/plan-template.md`
- `.specify/templates/spec-template.md`
- `.specify/templates/tasks-template.md`
- `.specify/templates/commands/*.md`

### 6) Validation Gates (FAIL HARD)
Fail if:
- Any `[PLACEHOLDER]` remains (except TODO dates)
- Missing required keywords: Next.js, TypeScript, TSX, Tailwind, shadcn/ui, src/
- Missing: FastAPI, async, router/, service/, repository/, client/
- Missing: PostgreSQL/MongoDB rules, OpenAPI, Pydantic
- Missing: OpenTelemetry, trace_id, service_name, request_path, error_type
- Missing: AI safety guardrails section
- Missing: secure coding + input validation section
- Uses weak language (“should”) where MUST/REQUIRED is needed

### 7) Final Output
Return:
- New version
- Version bump rationale
- List of synced templates
- Suggested commit message:
  docs: amend constitution to vX.Y.Z (FutureStandard guardrails + sync templates)
``