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

```text
$ARGUMENTS
```
You **MUST** consider the user input before proceeding (if not empty).

## Outline

## Goal
1.Update .specify/memory/constitution.md so it:
2.Uses simple English.
3.Enforces FutureStandard core stack rules:
    Frontend → Next.js (App Router) + TypeScript (TSX) +  TailwindCSS + shadcn/ui + src/ folder.
    BFF → FastAPI (async) with router / service / repository / client layers.
    Backend → FastAPI (async) with the same layered design.
    Database → PostgreSQL (default), or MongoDB with written justification, schemas, samples, indexes.


4.Provides an append‑only “Project‑Specific Additional Principles” section so teams can add extra rules per project without modifying base sections.
5.Synchronizes related templates (spec/plan/tasks) to match these rules.


If .specify/memory/constitution.md does not exist, copy it from .specify/templates/constitution-template.md before editing.


Execution Flow
1) Load Constitution

Read .specify/memory/constitution.md.
If missing, copy from .specify/templates/constitution-template.md.
Parse and collect any existing placeholders of the form [ALL_CAPS_IDENTIFIER].

2) Resolve Placeholders & Inputs

Use user input or repo context (README, prior constitution versions) to fill:

[PROJECT_NAME] ← project_name or infer from repo.
RATIFICATION_DATE ← ratified_on or keep existing (else TODO(RATIFICATION_DATE)).
LAST_AMENDED_DATE ← today only if you change content; else keep as is.
CONSTITUTION_VERSION (semantic versioning):

MAJOR → breaking governance/principle removals or redefinitions.
MINOR → new principle/section or materially expanded guidance.
PATCH → wording/clarity/typo, no semantic change.




If ambiguous, state your bump rationale before finalizing.

3) Draft Updated Content (Simple English, Base + Addenda)


Replace placeholders—no unresolved bracket tokens remain.


Keep headings from the template. Remove instructional comments unless keep_comments: true.


Ensure these Core Principles exist and are non‑negotiable:
Frontend

Next.js (App Router) + TypeScript (TSX) + TailwindCSS + shadcn/ui.
Use a src/ root folder for app code.
Typed React code; avoid any unless justified.

BFF

FastAPI (async).
Required folders: router/ (I/O validation), service/ (business logic only),
repository/ (DB only), client/ (external HTTP only, with timeouts + retries).
No business logic outside service/.

Backend

FastAPI (async).
Same four layers and rules as BFF.

Database

PostgreSQL is the default for all features.
MongoDB allowed only with a written reason and:

collection schemas, a few sample documents, planned indexes (single/compound/TTL).


Put DSNs in environment variables (no creds in code). Use pooling.

Contract‑First

Define API contracts before coding.
Use OpenAPI + Pydantic on FastAPI; Zod on FE when needed.
Document error shapes and version rules.
No breaking changes without a version bump and plan.

Testing

FE: component + integration tests.
BFF/BE: unit + service + repository + contract tests.
A feature is not done until tests exist and pass.

Observability & Logging

OTel tracing (FE → BFF → BE).
JSON logs with required keys: trace_id, service_name, request_path, error_type.

Security & Reliability

JWT with short‑lived tokens; authorization in the BFF.
No secrets in repo; use env or secret manager.
All HTTP calls have timeout + retry + standard error format.

Performance

FE LCP < 2.5s.
Internal APIs p95 < 200 ms; public APIs p95 < 500 ms.

Simplicity & Versioning

Keep designs simple; avoid extra complexity.
Use MAJOR.MINOR.PATCH; breaking changes require a major bump + migration plan.



Add Project‑Specific Additional Principles (Optional):


Append items from add_principles[] (title + details).


Mark the section with append‑only anchors:

<!-- FS:ADDENDA:BEGIN -->
... (project-specific principles go here; never edit base sections above) ...
<!-- FS:ADDENDA:END -->

4) Propagation: Keep Templates in Sync

Open .specify/templates/plan-template.md and VERIFY it enforces:

Frontend stack and src/ layout.
BFF/BE layered folders and responsibilities.
DB section with PostgreSQL default; MongoDB justification with schemas/samples/indexes.
Contract‑first content (OpenAPI/Pydantic/Zod).
Observability (OTel) + JSON logging keys.
Testing categories + performance targets.


Open .specify/templates/spec-template.md and require:

DB choice (+ MongoDB reason if chosen).
Frontend/Backend approach aligned to Constitution.
Acceptance criteria, test plan, perf and security notes.


Open .specify/templates/tasks-template.md and ensure it creates tasks for:

Next.js + Tailwind + shadcn/ui under src/.
FastAPI layered skeleton (router/service/repository/client).
DB models + migrations (Postgres) or schema/index docs (Mongo).
OpenAPI/Pydantic/Zod contracts; OTel setup; JSON logging keys.
Unit/service/repository/contract tests; FE component/integration tests.


Review every command in .specify/templates/commands/*.md and remove stale agent‑specific text; keep guidance generic.

5) Sync Impact Report (prepend as HTML comment at the top of the constitution)

Version: X.Y.Z(old) → X.Y.Z(new)
Modified principles (old title → new title if renamed)
Added/Removed sections
Templates needing updates with status:

.specify/templates/plan-template.md (✅ updated / ⚠ pending)
.specify/templates/spec-template.md (✅/⚠)
.specify/templates/tasks-template.md (✅/⚠)
Commands under .specify/templates/commands/*.md (list)


Deferred TODOs (e.g., TODO(RATIFICATION_DATE), pending MongoDB rationale)

6) Validation Gates (fail if any check fails)

No unresolved [PLACEHOLDER] tokens remain.
Core stack assertions present (exact matches):

Next.js, TypeScript, TSX, Tailwind, shadcn/ui, src/.
FastAPI, router/, service/, repository/, client/, async.
PostgreSQL (default), MongoDB (with justification language).
OpenTelemetry, trace_id, service_name, request_path, error_type.
component tests, integration tests, unit tests, contract tests.


Dates are ISO YYYY-MM-DD.
Version line matches the Sync Impact Report.
Language uses MUST/REQUIRED where non‑negotiable (avoid weak “should”).

7) Write File

Overwrite .specify/memory/constitution.md with the final content.

8) Final Output to User


New version and bump rationale (MAJOR/MINOR/PATCH).


Any files marked ⚠ pending manual edits.


Suggested commit message:
docs: amend constitution to vX.Y.Z (enforce core stack + addenda support)

Notes for the Agent

Treat the base core principles as immutable company standards.
Use the FS:ADDENDA block for project‑level additions only (append‑only).
If asked to remove a base principle, warn that this is a MAJOR governance change.
If db_choice: mongodb is provided without db_reason, halt with an actionable error asking for the reason, schemas, sample documents, and an index plan.
Keep the document short, clear, and testable. Prefer MUST/REQUIRED over should, unless you add a clear rationale.


Formatting & Style Requirements

Keep original Markdown heading levels (do not demote/promote).
Wrap long lines for readability (≈100 chars) but avoid awkward breaks.
Keep one blank line between sections.
Avoid trailing spaces.
Use bullet lists when they make rules easier to read.