# brain.md — GharHold project memory
Read this first in every Antigravity session. Keep it concise. Update it after every completed phase in `flow.md`.
## Product
GharHold is a Flutter mobile prototype for transparent Mumbai rental discovery and safe viewing/token coordination.
- Core loop: Discover listing → Request viewing → Owner responds → Renter tracks outcome.
- A listing can have at most one active request.
- A token is a workflow hold marker only. No money is collected or transferred.
- Approximate neighbourhood only. Never show or store exact home addresses or precise GPS.
- Hackathon prototype: one device simulates Renter and Owner roles. Role switch is a demo seam, not authentication.
## Frozen scope
P0: neighbourhood feed, listing detail, viewing request, owner inbox, approve/decline/reopen, token request/confirmation, My Requests, local persistence, safe retry, stale-version conflict, inspection bar, evidence drawer, tests.
P1: reset/reseed control and polished empty/error states.
P2 bonuses only after P0/P1 and demo are stable: deterministic move-in cost audit + Gemini explanation; Measure SDK telemetry.
Out of scope: real auth, payments, live maps, chat, listing photo upload, brokerage marketplace, push notifications, multi-device sync, society NOC workflow, admin web.
## Stack
- Flutter + Dart 3.
- Drift + SQLite: local database is the UI's single source of truth.
- State boundary: `GharHoldPreviewState` backed by `ProptechRepository` and reactive database streams.
- Plain Navigator with AppShell tab & sheet coordination.
- `uuid` behind an `IdGenerator` port.
- `flutter_test`; pure Dart fakes, in-memory Drift connections, and injected `Clock`/`IdGenerator`.
- `SimulatedRemoteService` behind `RemoteService`; no AWS, GCP, Firebase, Supabase or production cloud dependency in the hackathon build.
- Gemini and Measure are optional adapters and must not block the core app.
## Architecture — do not break
Four modules only: `domain`, `data`, `observability`, `ui`.
- Dependency direction: `ui → domain ← data`; `observability` implements diagnostic sink/telemetry ports.
- `domain` is pure Dart with zero Flutter, Drift, database, network or platform imports (verified via `domain_purity_test.dart`).
- UI dispatches commands and observes Drift-backed repository streams. No business rules, SQL, network or SDK calls in widgets.
- `ProptechRepository` validates, writes local state and audit event in one transaction, then syncs through `RemoteService`.
- Local SQLite is the single source of truth for every screen.
- Every command has a UUID idempotency key. Every remote write carries the client listing version.
- Every state change and its `AuditEvent` are committed in the same DB transaction.
- `activeRequestStatuses` is the one shared source for domain checks and the partial unique index.
- The in-app Renter/Owner role switcher is demo-only. Domain rules still reject renter-only attempts at owner actions.
## Frozen names
Modules: `domain`, `data`, `observability`, `ui`.
Roles: `RENTER`, `OWNER`.
ListingState: `AVAILABLE`, `VIEWING_REQUESTED`, `TOKEN_LOCKED`, `UNAVAILABLE`.
RequestStatus: `REQUESTED`, `APPROVED`, `DECLINED`, `REOPENED`, `TOKEN_REQUESTED`, `TOKEN_CONFIRMED`, `ABORTED`.
SyncState: `PENDING_SYNC`, `SUBMITTED`, `SYNC_FAILED_RETRYABLE`, `CONFLICT_STALE_DATA`, `RESOLVED_ABORTED`.
Classes: `ProptechBusinessRules`, `ValidationResult` (`Valid`, `Rejected`), `ProptechRepository`, `ProptechRepositoryImpl`, `SimulatedRemoteService`, `FaultConfig`, `DiagnosticLogger`, `AuditEvent`.
Rule codes: `ERR_LISTING_NOT_AVAILABLE`, `ERR_ACTIVE_REQUEST_EXISTS`, `ERR_INVALID_NOTE`, `ERR_REOPEN_REASON_REQUIRED`, `ERR_ILLEGAL_TRANSITION`, `ERR_NOT_PERMITTED`.
Failure codes: `ERR_NETWORK_DROP`, `ERR_STALE_VERSION`.
Events: `RULE_REJECTED`, `STATE_TRANSITION`, `SYNC_FAILURE`, `CONFLICT`, `RETRY`, `RESUME_SCAN`, `FAULT_SET`, `OWNER_DECISION`, `DATA_RESET`.
`activeRequestStatuses`: `REQUESTED`, `APPROVED`, `REOPENED`, `TOKEN_REQUESTED`, `TOKEN_CONFIRMED`.
## Business rules
1. `UNAVAILABLE` and `TOKEN_LOCKED` listings reject new requests.
2. `VIEWING_REQUESTED` rejects a second active request.
3. Notes are trimmed and limited to 200 characters.
4. `DECLINED → APPROVED` is illegal. Reopen first with a non-empty reason; reopening also requires the listing to be free.
5. Owner-only actions reject `RENTER`.
6. A request's `idempotencyKey` is generated once and reused on every retry. Never create a duplicate.
7. Listing, request and audit event changes that belong together use one transaction.
8. Listing flips to `VIEWING_REQUESTED` when the request is saved locally. Network failure keeps the active request and listing state. Stale conflict aborts the request and refreshes listing state/version.
## State and recovery
- Sync is separate from business status.
- Drop Network: persist `PENDING_SYNC` first; then transition to `SYNC_FAILED_RETRYABLE`; show Retry Safely; same key on retry.
- Startup: convert leftover `PENDING_SYNC` to `SYNC_FAILED_RETRYABLE`, log `RESUME_SCAN`, and show recovery banner. Do not auto-send.
- Stale Conflict: simulated server moves listing to `UNAVAILABLE`, version 2; request becomes `ABORTED`, sync becomes `CONFLICT_STALE_DATA`; log both versions; refresh resolves to `RESOLVED_ABORTED`.
- Fault flags are in-memory and reset to Normal after restart. Stale conflict is one-shot.
- Never claim the simulated service is a real backend.
## Seed data
Use the 10 illustrative listings from Tier 2 Build Spec section 7. Values are demo fixtures, not live market data. Demo renter `r1`; owner `o1`. Neighbourhoods: Powai, Andheri East, Bandra West, Malad West. Approximate area only. L5 has active request `seed-r2-L5` for renter `r2`.
## UI screens
1. Listing Feed (neighbourhood filter)
2. Listing Detail (cost breakdown)
3. Request Viewing sheet
4. My Requests / request timeline
5. Owner Inbox / request review
6. Architecture Inspection Bar (persistent, labelled Simulation)
7. Diagnostic Evidence Drawer
8. Settings / Reset Data
## Design system
Preserve the exact forest-and-lime palette and Inter typography. No new palette, gradients, glass effects or separate Owner theme. Use 48dp targets, 200% text scaling, icon + text statuses, and responsive phone-first layouts.
## Tests and acceptance
Mandatory test suites:
- Domain purity (`domain_purity_test.dart`)
- Domain rules & invariants (`rules_test.dart`, `state_tables_test.dart`)
- Drift SQLite schema, migrations, partial active index, rollback (`database_test.dart`)
- SimulatedRemoteService & fault injection (`simulated_remote_service_test.dart`)
- ProptechRepository transactional actions & sync branches (`proptech_repository_test.dart`)
- File-backed restart persistence & startup recovery (`recovery_test.dart`)
- State seam tests (`preview_state_test.dart`)
- UI acceptance widget tests (`widget_test.dart`)
Current test baseline: 50/50 tests passing green.
## Decisions
- Local-First single source of truth: SQLite via Drift.
- Simulated remote service: in-memory fault config (Drop Network, one-shot Stale Conflict) with explicit SIMULATION tag.
- One active request per listing; enforced both at domain boundary and by database partial unique index.
- Token hold requires an approved viewing.
- Owner actions are local in this prototype and logged as `OWNER_DECISION`.
- Exactly two ADRs: ADR-001 (Persistence/Outbox/Concurrency) and ADR-002 (Domain State Machine/Fault Boundary).
## Status
- [x] P0 Product and design freeze
- [x] P1 Domain package, states, rules and tests
- [x] P2 Drift schema, seed, repository and simulated remote
- [x] P3 Core renter and owner UI
- [x] P4 Recovery, restart and evidence
- [x] P5 Accessibility, security and consistency hardening
- [x] P6 Architecture docs, ADRs, README and demo
- [ ] P7 Optional Gemini and Measure bonuses (deferred/standalone)
## Update log
- 2026-11-01: Complete frontend implementation (GH01-GH07) delivered with decoupled in-memory preview state, full invariant enforcement (BR-1, BR-1b, BR-2, BR-3), persistent Inspection Bar with SIMULATION disclosure, exact forest-and-lime tokens, and passing unit/widget test suite (24 tests green).
- 2026-11-01: Complete local-first backend implementation delivered and integrated with frontend. Implemented Drift SQLite tables with partial unique index, pure Dart domain layer and ports, SimulatedRemoteService with in-memory FaultConfig, ProptechRepositoryImpl with transactional writes, startup recovery scan, and file-backed persistence. All 50 tests pass green with 0 analyzer issues. Exactly two ADRs, ARCHITECTURE.md, test evidence, traceability matrix, and security baseline completed.
