# flow.md — GharHold build flow (scratch to submission)

## How to use this file

1. Start every Antigravity session by giving it `brain.md`, `design.md`, this `flow.md`, and the relevant GharHold source documents.
2. Do exactly one numbered task at a time. Do not jump phases.
3. Antigravity must inspect the repository before editing, preserve working code, implement only the requested task, run the relevant tests, and report changed files and command output.
4. Write tests before implementation where specified.
5. At the end of every phase, update `brain.md` status, decisions, gotchas and update log.
6. Never let the code, architecture diagram, ADRs, tests and demo use different names.
7. If time runs short, cut optional polish and bonuses first. Never cut domain rules, persistence, recovery tests, diagnostics or the required artefacts.

## Session starter prompt

```text
You are the senior Flutter/Dart engineer implementing GharHold. Read brain.md, design.md and flow.md fully before acting. Also consult the supplied GharHold PRD, Architecture Document and Tier 2 Build Spec. The Tier 2 Build Spec is authoritative wherever earlier GharHold documents conflict.

Work only on the task I explicitly assign. Do not implement future phases early. Inspect the current repository before changing files. Preserve existing working code. Do not invent requirements, states, screens, APIs, cloud services or dependencies. Use the exact frozen names in brain.md. Keep the forest-and-lime design system identical across every screen.

For every task:
1. State the task scope and files you expect to touch.
2. Implement the task completely.
3. Add/update tests.
4. Run formatting, static analysis and relevant tests.
5. Fix failures caused by your changes.
6. Report changed files, commands run, test results, known limitations and any manual action required from me.
7. Update brain.md only at phase completion, not after every tiny task.

Do not claim a test passed unless you actually ran it. Do not claim a backend/cloud integration exists when it is simulated.
```

---

## P0 — Project setup and source-of-truth freeze

### 0.1 Inspect and initialise repository

- [x] Inspect current repository, Flutter/Dart versions and existing files. Do not overwrite working code blindly.
- [x] Create/verify Flutter project `gharhold`.
- [x] Create the documented structure:
  - `lib/domain/` or standalone pure-Dart `packages/domain/` as decided in task 0.2
  - `lib/data/`
  - `lib/observability/`
  - `lib/ui/`
  - `test/`
  - `docs/adr/`
- [x] Add README skeleton.

**Antigravity prompt**

```text
Inspect the repository and current Flutter toolchain. Initialise or adapt it as a Flutter app named gharhold without deleting existing work. Create only the GharHold modules and folders specified in brain.md and the Architecture Document. Add README.md with the product rule and setup placeholders. Do not build UI or add cloud services yet. Report the actual Flutter/Dart versions and all created/changed files.
```

### 0.2 Dependencies and domain package boundary

- [x] Use Flutter + Dart 3.
- [x] Use Drift, drift_dev, build_runner, sqlite3_flutter_libs/path_provider as needed.
- [x] Use Riverpod for reactive state and provider overrides. Keep it replaceable.
- [x] Use plain Navigator for the small screen set; do not add go_router without a demonstrated need.
- [x] Use `uuid` behind `IdGenerator`.
- [x] Use `flutter_test`; prefer hand-written fakes. Add mocktail only if it materially reduces test complexity.
- [x] Make domain a standalone pure-Dart package if practical, as required by Tier 2 amendment A2. Otherwise enforce purity with a compile/import fitness test and document the limitation.
- [x] Do not add Firebase, AWS, GCP, Supabase or any production cloud SDK.

**Prompt**

```text
Set up only the dependencies needed by the frozen GharHold architecture. Verify current compatible package versions from pub.dev rather than guessing. Keep the domain package pure Dart with no Flutter, Drift, database, network or platform dependencies. Use Riverpod only in the UI/application composition boundary. Use plain Navigator. Wrap UUID generation behind IdGenerator. Do not add any cloud SDK or real backend. Run flutter pub get, formatter and analyzer; report resolved versions.
```

### 0.3 Repository hygiene

- [x] Add `.gitignore` for build output, `.dart_tool`, local config, API keys and secrets.
- [x] Enable strict Dart lints.
- [x] Add config loading only if needed for optional bonus integrations.
- [x] Ensure no secrets or real personal data are committed.

**Prompt**

```text
Add repository hygiene for GharHold: .gitignore, strict analysis_options.yaml and safe local configuration conventions. No secret values or API keys in tracked files. Do not add unnecessary environment/config abstractions for the core prototype. Run flutter analyze and report any baseline issues.
```

### 0.4 Create documentation skeleton

- [x] `ARCHITECTURE.md`
- [x] `docs/adr/ADR-001.md`
- [x] `docs/adr/ADR-002.md`
- [x] `docs/product-scope.md`
- [x] `docs/test-evidence.md`
- [x] `docs/security-baseline.md`
- [x] `docs/observability-events.md`
- [x] `docs/traceability.md`

Exactly two ADRs in the final submission. Do not create an ADR-003.

---

## P1 — Domain models, state machines and tests (tests first)

### 1.1 Freeze domain vocabulary

- [ ] Modules: `domain`, `data`, `observability`, `ui`.
- [ ] Roles: `RENTER`, `OWNER`.
- [ ] ListingState: `AVAILABLE`, `VIEWING_REQUESTED`, `TOKEN_LOCKED`, `UNAVAILABLE`.
- [ ] RequestStatus: `REQUESTED`, `APPROVED`, `DECLINED`, `REOPENED`, `TOKEN_REQUESTED`, `TOKEN_CONFIRMED`, `ABORTED`.
- [ ] SyncState: `PENDING_SYNC`, `SUBMITTED`, `SYNC_FAILED_RETRYABLE`, `CONFLICT_STALE_DATA`, `RESOLVED_ABORTED`.
- [ ] Preserve exact rule codes, failure codes, event types and `activeRequestStatuses` from brain.md.

**Prompt**

```text
Create a domain vocabulary/constants task only. Define all frozen enums, typed identifiers/value objects where useful, transition tables and the single activeRequestStatuses constant. Do not implement database, UI or network code. Add exhaustive tests for the transition tables and ensure names match brain.md exactly. Do not add states based on assumptions.
```

### 1.2 Models

- [ ] Immutable `PropertyListing`.
- [ ] Immutable `ViewingRequest`.
- [ ] Immutable `AuditEvent`.
- [ ] `CostBreakdown` value object only if needed for the optional bonus; keep it deterministic and domain-owned.
- [ ] Inject `Clock` and `IdGenerator` ports.
- [ ] Use INR integer minor/whole-unit convention consistently; document it. Do not use floating point for money.

**Prompt**

```text
Implement immutable pure-Dart domain models from the Architecture Document and Tier 2 Build Spec. PropertyListing includes id, title, neighbourhood (approximate only), BHK, monthlyRent, depositMonths, ListingState, version and ownerId. ViewingRequest includes id, unique idempotencyKey, listingId, renterId, kind, preferredWindow, note, RequestStatus, SyncState, clientListingVersion, optional reopenReason and timestamps. AuditEvent contains timestamp, correlationId, component, eventType, previousState, newState, ruleOrErrorCode and summary. Add injected Clock and IdGenerator ports. Do not add exact addresses, phone numbers, payments or medical/personal fields. Add model tests.
```

### 1.3 Business rules — write tests first

- [ ] `UNAVAILABLE` and `TOKEN_LOCKED` reject new requests with `ERR_LISTING_NOT_AVAILABLE`.
- [ ] `VIEWING_REQUESTED` rejects a second active request with `ERR_ACTIVE_REQUEST_EXISTS`.
- [ ] Trim note and reject more than 200 characters with `ERR_INVALID_NOTE`.
- [ ] Illegal request state edges return `ERR_ILLEGAL_TRANSITION`.
- [ ] `DECLINED → REOPENED` requires a non-empty trimmed reason.
- [ ] Reopen is blocked if the listing is not `AVAILABLE` or another active request exists.
- [ ] Renter cannot perform owner-only actions (`ERR_NOT_PERMITTED`).
- [ ] Rule evaluation order must be stable and tested.
- [ ] `DECLINED → APPROVED` directly is never allowed.

**Prompt**

```text
First write the tests listed in Tier 2 Build Spec section 11 for domain/rules_test. Then implement ProptechBusinessRules as pure synchronous functions returning ValidationResult (Valid or Rejected with exact rule code). Use the exact rule evaluation order from section 4 of the Tier 2 Build Spec. No UI or database imports. Do not write to storage on a rejected action. Run all domain tests and report results.
```

### 1.4 State table and domain purity tests

- [ ] Test every listed transition edge and reject unlisted edges.
- [ ] Test `activeRequestStatuses` matches the partial index source.
- [ ] Test domain has no framework imports. Prefer compiler-enforced package boundary.
- [ ] Keep business status separate from sync status.

**Prompt**

```text
Add state_tables_test and domain_purity_test. Test every legal and illegal transition, and test that activeRequestStatuses is the sole source used to generate the partial unique index SQL. Enforce domain purity through the package boundary where possible, with an import scan as a second guard. Run the complete domain test suite.
```

---

## P2 — Drift database, seed data and simulated remote

### 2.1 Drift schema and migrations

- [ ] Tables: listings, requests, audit_events.
- [ ] `requests.idempotency_key` is UNIQUE.
- [ ] Add partial unique index `one_active_request_per_listing` using `activeRequestStatuses`.
- [ ] Foreign key from request to listing.
- [ ] Store listing version and client listing version.
- [ ] Store timestamps consistently.
- [ ] Audit row is written in the same transaction as each state change.
- [ ] Add database-level protection against a second active request even if domain validation is bypassed.

**Prompt**

```text
Implement the Drift schema from Tier 2 Build Spec section 6. Tables are listings, requests and audit_events. Add UNIQUE idempotency_key, foreign key constraints, version fields and the partial unique index one_active_request_per_listing. Generate the index status list from domain activeRequestStatuses; do not duplicate the list as a second hand-maintained constant. Every transaction that changes listing/request state must append its AuditEvent in that same transaction. Add migrations and database tests, including direct DB insertion rejection for a second active request.
```

### 2.2 Seed data

- [ ] Seed the exact 10 illustrative listings from Tier 2 Build Spec section 7.
- [ ] Neighbourhoods: Powai, Andheri East, Bandra West, Malad West.
- [ ] Keep IDs L1–L10 and states/rents/BHK exactly as specified.
- [ ] Seed L5's active request using renter `r2` and idempotency key `seed-r2-L5`.
- [ ] Demo renter `r1`; owner `o1`.
- [ ] Clearly label values as illustrative demo fixtures, not live market data.

**Prompt**

```text
Seed the exact 10 GharHold fixture listings from Tier 2 Build Spec section 7. Preserve IDs, neighbourhoods, BHK, monthly rent, listing states and demo purpose exactly. All versions start at 1. Seed the L5 active request for renter r2 with idempotency key seed-r2-L5. Demo renter is r1 and owner is o1. Add an idempotent seed routine that can safely run more than once. Mark fixture values as illustrative in app/docs. Do not invent extra listings or amenities.
```

### 2.3 SimulatedRemoteService and fault injection

- [ ] `RemoteService` interface/port.
- [ ] `SimulatedRemoteService` implementation.
- [ ] `FaultConfig`: `networkDrop`, `forceStaleVersionConflict`.
- [ ] Default latency 500ms.
- [ ] Drop Network throws `NetworkException`.
- [ ] Stale Conflict is one-shot: server listing becomes `UNAVAILABLE`, version 2; throw `StaleVersionConflict`.
- [ ] Fault flags are in-memory and reset to Normal after restart.
- [ ] The UI always labels this service as Simulation.

**Prompt**

```text
Implement RemoteService and SimulatedRemoteService behind the existing domain port. Add FaultConfig with networkDrop and forceStaleVersionConflict. Simulate 500ms latency. Network drop throws NetworkException after local persistence has happened. Stale conflict is one-shot: simulated server listing becomes UNAVAILABLE at version 2 and throws StaleVersionConflict carrying the authoritative listing. Normal mode compares clientListingVersion to server version. Keep fault flags in memory only and reset to Normal on app restart. No HTTP, Firebase, AWS, GCP or external backend. Add deterministic tests using injected clock/fakes.
```

### 2.4 Repository and transaction consistency

- [ ] `ProptechRepository` validates before write.
- [ ] Valid request: one DB transaction inserts request as `REQUESTED` + `PENDING_SYNC`, updates listing to `VIEWING_REQUESTED`, and inserts audit event.
- [ ] Rejection: audit `RULE_REJECTED`; no request row or listing change.
- [ ] Remote success: set sync `SUBMITTED`, append audit event.
- [ ] Network failure: set sync `SYNC_FAILED_RETRYABLE`, keep request and listing active, append `SYNC_FAILURE`.
- [ ] Stale conflict: apply server listing, set request `ABORTED` and `CONFLICT_STALE_DATA`, append `CONFLICT` with both versions in one transaction.
- [ ] Retry reuses same idempotency key.
- [ ] Owner decisions are local in this build and logged as `OWNER_DECISION`.
- [ ] Startup scan converts leftover `PENDING_SYNC` to `SYNC_FAILED_RETRYABLE`; no automatic send.

**Prompt**

```text
Implement ProptechRepository exactly as Tier 2 Build Spec section 9. Validate before any write. On valid submit, in one Drift transaction insert REQUESTED/PENDING_SYNC request, update listing to VIEWING_REQUESTED and insert STATE_TRANSITION audit event. Then call SimulatedRemoteService. Success sets SUBMITTED; network failure sets SYNC_FAILED_RETRYABLE without releasing the listing; stale conflict applies authoritative listing version/state, sets request ABORTED and sync CONFLICT_STALE_DATA, and writes the CONFLICT event in one transaction. Retry uses the original idempotencyKey. Owner actions are local in this prototype, domain-validated, transactional and logged as OWNER_DECISION. On startup convert leftover PENDING_SYNC to SYNC_FAILED_RETRYABLE and log RESUME_SCAN; never auto-send. Add tests before implementation for every branch.
```

---

## P3 — Core Flutter UI

### 3.1 Theme and shared components

- [ ] Implement exact design.md tokens in one theme file.
- [ ] Use Inter typography and shared shape/spacing tokens.
- [ ] Build ListingCard, ListingStatusPill, CostBreakdownCard, RequestForm, RequestCard, RequestTimeline, SyncBadge, RecoveryBanner, EvidenceEventRow.
- [ ] Build shared Loading, Empty, Error/Conflict and Content patterns.
- [ ] Every component must reuse the same theme tokens.

**Prompt**

```text
Implement GharHold's Flutter theme from design.md. Preserve every exact colour value, Inter typography, spacing scale, radii and restrained elevation. Create shared components only: ListingCard, ListingStatusPill, CostBreakdownCard, RequestForm, RequestCard, RequestTimeline, SyncBadge, RecoveryBanner, EvidenceEventRow and shared state views. Do not hardcode alternate colours or create a new style. Every status uses icon + text. Add widget tests for component states and accessibility labels.
```

### 3.2 App shell and Inspection Bar

- [ ] Set up app entry and Riverpod composition.
- [ ] Add persistent Architecture Inspection Bar.
- [ ] Role switch: Renter / Owner.
- [ ] Fault controls: Normal / Drop Network / Stale Conflict.
- [ ] Evidence button opens drawer.
- [ ] Visible **SIMULATION** label.
- [ ] Role is not authentication; owner actions still pass through domain role checks.

**Prompt**

```text
Build the GharHold app shell and persistent Architecture Inspection Bar using the design system. It must show a clear SIMULATION label, Renter/Owner role switch, Normal/Drop Network/Stale Conflict controls and View Evidence action. Fault flags are wired to FaultConfig. The role switch is a demo-only seam, not authentication. Do not place business rules in the bar or widgets. Make the bar responsive and accessible with 48dp targets.
```

### 3.3 GH01 Listing Feed

- [ ] Show 10 seeded listings from Drift only.
- [ ] Neighbourhood filter.
- [ ] Search is not required unless explicitly added later; do not add scope creep.
- [ ] Show rent, BHK, approximate area and state.
- [ ] Handle Loading, Empty, Error and Content.
- [ ] No exact address, map or invented amenities.

**Prompt**

```text
Build GH01 Listing Feed. The UI reads only from Drift-backed repository streams. Display the exact seeded fixture listings, filter by the four documented neighbourhoods and show BHK, monthly rent, approximate neighbourhood and icon+text ListingState. Make it clear that prices are illustrative demo fixtures, not live market data. Implement Loading, Empty, Error and Content. Do not add maps, exact addresses, photos, amenities or unrequested search functionality.
```

### 3.4 GH02 Listing Detail and GH03 Request Viewing

- [ ] Listing detail with cost fields that actually exist.
- [ ] Request Viewing bottom sheet.
- [ ] Preferred window and optional note (max 200 characters).
- [ ] Rule rejection shows exact user-facing message and no write.
- [ ] Local save happens before simulated remote call.
- [ ] No payment/token collection.

**Prompt**

```text
Build GH02 Listing Detail and GH03 Request Viewing sheet. Show title, BHK, approximate neighbourhood, rent, deposit and only other cost fields that are present in the fixture/model. The request form accepts preferred viewing window and optional note up to 200 trimmed characters. Dispatch a repository command; do not write directly from UI. On rule rejection show the exact mapped message and do not create a request. On valid action show the honest local pending state before sync outcome. Token is not money and no payment UI may be added.
```

### 3.5 GH04 My Requests

- [ ] Show renter `r1` requests.
- [ ] Business status and sync status separately.
- [ ] Show audit timeline.
- [ ] Retry Safely for retryable sync.
- [ ] Show conflict resolution state and explanation.
- [ ] Approved requests expose Hold with token action.

**Prompt**

```text
Build GH04 My Requests from Drift streams for renter r1. Show request business status and SyncState separately, with a chronological AuditEvent timeline. Provide Retry Safely only for SYNC_FAILED_RETRYABLE and reuse the existing idempotency key through the repository. For CONFLICT_STALE_DATA explain that the listing changed and the request was aborted. Show Hold with token only for APPROVED requests. Do not imply SUBMITTED means APPROVED.
```

### 3.6 GH05 Owner Inbox / Review

- [ ] Show requests for owner `o1`.
- [ ] Approve, Decline, Reopen with reason, Confirm token, Mark off-market, Relist where legal.
- [ ] Domain enforces owner role and state transitions.
- [ ] Owner actions are local in this prototype and logged.
- [ ] Renter view updates from the same local DB.

**Prompt**

```text
Build GH05 Owner Inbox and Request Review. Show requests for owner o1. Implement only documented actions: Approve, Decline, Reopen with a required reason, Confirm token, Mark off-market and Relist where allowed by the state machine. All commands go through ProptechRepository and ProptechBusinessRules. Owner actions are local in this hackathon build and must append OWNER_DECISION audit events in the same transaction as state changes. Switching back to renter must show updates from the same Drift source of truth without manual reload.
```

### 3.7 GH06 Evidence Drawer and GH07 Settings

- [ ] Evidence drawer: local DB state and structured event log.
- [ ] Show timestamp, correlation ID, component, event, states, rule/error code and summary.
- [ ] Do not expose private notes or exact addresses.
- [ ] Settings: project/simulation explanation and reset/reseed.
- [ ] Reset requires confirmation and logs DATA_RESET.

**Prompt**

```text
Build GH06 Evidence Drawer and GH07 Settings. Evidence drawer shows current listing/request/sync state and structured audit events with timestamp, correlationId, component, eventType, previousState, newState, ruleOrErrorCode and summary. Never display request note text, exact addresses or personal data. Settings includes a clear explanation that the remote service is simulated and a Reset Demo Data action. Confirm reset, wipe and reseed atomically where possible, then append DATA_RESET evidence. Keep the drawer out of normal navigation.
```

---

## P4 — Recovery and acceptance behaviour

### 4.1 Network-drop recovery

- [ ] Turn Drop Network ON.
- [ ] Submit valid request for L2.
- [ ] Verify request is saved locally first.
- [ ] Verify `SYNC_FAILED_RETRYABLE`, listing remains `VIEWING_REQUESTED`.
- [ ] Force-close and relaunch; recovery banner appears.
- [ ] Turn fault off and Retry Safely.
- [ ] Same idempotency key, exactly one request, final sync `SUBMITTED`.

**Prompt**

```text
Implement and verify the full interrupted submission flow from Tier 2 acceptance criteria AC-05 to AC-07. Persist before remote call. On network failure set SYNC_FAILED_RETRYABLE and retain the active request/listing state. On app relaunch scan pending commands, convert leftover PENDING_SYNC to SYNC_FAILED_RETRYABLE and show Retry Safely. Retry must reuse the same idempotencyKey. Prove there is exactly one request row after multiple retries. Add a file-backed restart test. Do not auto-send on startup.
```

### 4.2 Stale conflict recovery

- [ ] Turn Stale Conflict ON.
- [ ] Submit against client listing version 1.
- [ ] Simulated server returns version 2, `UNAVAILABLE`.
- [ ] Request becomes `ABORTED`; sync becomes `CONFLICT_STALE_DATA`.
- [ ] Local listing refreshes to authoritative version 2.
- [ ] Evidence contains both versions.
- [ ] No automatic retry.

**Prompt**

```text
Implement and verify stale conflict flow AC-08. The one-shot simulated server fault changes the server listing to UNAVAILABLE version 2 and rejects a client request based on version 1. In one local transaction apply the authoritative listing, mark request ABORTED and sync CONFLICT_STALE_DATA, and append a CONFLICT event containing client and server versions. Show a clear conflict card and explicit acknowledgement/refresh action. Never retry this request automatically.
```

### 4.3 Token workflow and reopen rule

- [ ] Owner approves viewing.
- [ ] Renter can Hold with token only after approval.
- [ ] Owner confirms token.
- [ ] Listing becomes `TOKEN_LOCKED`.
- [ ] Owner decline → renter sees decline and listing reopens.
- [ ] Reopen without reason rejected; with reason accepted only if listing is free.

**Prompt**

```text
Implement and test the documented token and reopen workflow. A viewing request must be APPROVED before renter can create TOKEN_REQUESTED. Owner confirmation transitions to TOKEN_CONFIRMED and listing TOKEN_LOCKED in one transaction. Declined requests cannot jump directly to APPROVED. Reopen requires a non-empty trimmed reason and an AVAILABLE listing with no other active request. Enforce owner-only transitions in domain rules. Add tests for every legal and illegal transition.
```

---

## P5 — Hardening, accessibility, privacy and consistency

### 5.1 UI states and accessibility

- [ ] Every screen handles Loading, Empty, Error/Conflict and Content.
- [ ] 48dp tap targets.
- [ ] 200% text scaling.
- [ ] WCAG AA text contrast.
- [ ] Semantic labels and logical screen-reader order.
- [ ] Error/status icon + text.
- [ ] Keyboard and safe-area checks.

**Prompt**

```text
Run an accessibility and UI-state audit across GH01–GH07 and the Inspection Bar. Verify 48dp tap targets, 200% text scale, WCAG AA normal-text contrast, semantic labels, screen-reader order, visible focus and reduce-motion behaviour. Verify Loading, Empty, Error/Conflict and Content states. Fix issues without changing the design palette or adding new features. Record concrete checks and results in docs/security-baseline.md or the appropriate accessibility section of README.
```

### 5.2 Security and privacy

- [ ] No secrets in tracked files.
- [ ] No exact addresses or GPS.
- [ ] No personal request notes in telemetry/evidence.
- [ ] Input validation in domain.
- [ ] Reset works.
- [ ] Role switch is documented as demo-only.

**Prompt**

```text
Perform a GharHold privacy/security review. Search tracked files for secrets and API keys. Confirm only approximate neighbourhood data is stored/displayed; no exact addresses or precise GPS. Confirm telemetry and evidence do not contain notes or personal text. Verify note validation at the domain boundary, reset/reseed works, and README clearly says role switching is a demo seam, not authentication. Write docs/security-baseline.md with actual findings, not generic claims.
```

### 5.3 Architecture fitness and database consistency

- [ ] `activeRequestStatuses` equals partial index statuses.
- [ ] Listing/request consistency test.
- [ ] Database rejects second active request even if domain bypassed.
- [ ] Every state change writes event in same transaction.
- [ ] Domain purity enforced.
- [ ] Run full test suite.

**Prompt**

```text
Run the architecture fitness and consistency suite. Verify activeRequestStatuses generates the partial index SQL; no duplicated status list exists. Verify listing and request state changes stay consistent transactionally. Verify DB-level unique partial index blocks a second active request even if repository/domain checks are bypassed. Verify every state transition writes its AuditEvent in the same transaction. Verify domain has no framework imports. Fix violations and run flutter test.
```

---

## P6 — Documentation and judging evidence

### 6.1 Architecture diagram

- [ ] One Mermaid diagram in `ARCHITECTURE.md`.
- [ ] Diagram boxes match exact folder/module names.
- [ ] Show `ACTION → RULES → STATE → EVIDENCE`.
- [ ] Show Drift/SQLite as single source of truth.
- [ ] Show SimulatedRemoteService and both fault modes.
- [ ] Show optional Gemini/Measure adapters only if implemented.

**Prompt**

```text
Create one readable Mermaid architecture diagram in ARCHITECTURE.md. It must match the real codebase exactly and show UI action → ProptechBusinessRules → Drift local source of truth → SimulatedRemoteService sync/recovery → DiagnosticLogger evidence. Mark SQLite as the single source of truth. Show fault injection and role switch as demo seams. Only show Gemini or Measure if the corresponding adapter is actually implemented. Do not draw AWS, GCP, Firebase or any cloud service.
```

### 6.2 Exactly two ADRs

- [x] `docs/adr/ADR-001.md`: Local-first persistence, outbox, idempotency and optimistic concurrency.
- [x] `docs/adr/ADR-002.md`: Pure domain state machines and simulated fault-injection boundary.
- [ ] Each ADR: Decision, Alternative Considered, Consequence/Limitation.
- [ ] No third ADR.

**Prompt**

```text
Write exactly two concise ADRs based on actual code. ADR-001 covers Drift/SQLite as local source of truth, local-first outbox, idempotency and optimistic listing versions. ADR-002 covers pure domain state machines, owner role demo seam and controllable SimulatedRemoteService fault boundary. Each must contain Decision, Alternative Considered and Consequence/Limitation. Do not claim a real backend or cloud deployment. Do not create ADR-003.
```

### 6.3 README, tests and traceability

- [ ] README states problem, headline rule, scope, architecture, setup, test command and simulated-vs-real table.
- [ ] Add test evidence with real output.
- [ ] Traceability matrix: rule → module → ADR → test → demo.
- [ ] Ensure exactly five artefacts agree: runnable app, source, diagram, 2 ADRs, test/diagnostic evidence.

**Prompt**

```text
Complete README.md, docs/test-evidence.md and docs/traceability.md from the actual repository. README must state the Mumbai rental problem, exact headline business rule, in/out scope, Flutter setup/run commands, flutter test command, simulation disclaimer and a table separating local/persisted from simulated behaviour. Trace every business rule and failure path to code, ADR, test and demo step. Include only test output that was actually observed. Verify exact names match across all artefacts.
```

### 6.4 Final validation

- [ ] `dart format --set-exit-if-changed .`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Build and run on emulator/physical device.
- [ ] Verify restart persistence manually.
- [ ] Verify network-drop retry and stale conflict manually.
- [ ] Verify no secrets and no exact location data.
- [ ] Rehearse demo twice.

**Prompt**

```text
Run final GharHold validation. Execute formatter check, flutter analyze, flutter test and a debug build. Do not suppress warnings or edit tests to hide failures. Report exact command outputs and any remaining known limitations. Verify all acceptance criteria AC-01 through AC-14 from Tier 2 Build Spec. Check the five submission artefacts agree. Do not start optional AI/Measure work until the core app is green and demo-rehearsed.
```

---

## P7 — Optional bonuses (only after P0–P6 are green)

### 7.1 Deterministic move-in cost audit

- [ ] Domain computes numbers.
- [ ] Use only supplied rent/deposit/brokerage/charges.
- [ ] Stamp duty/registration values are labelled illustrative/configurable assumptions.
- [ ] AI only explains/flags; it never calculates authoritative totals.
- [ ] Validate structured JSON, timeout and fallback.

**Prompt**

```text
Only if all core acceptance criteria and demo rehearsal are green, add the optional Move-in Cost Audit. Compute every numeric amount deterministically in the domain CostBreakdown. Treat stamp duty and registration as configurable illustrative assumptions, not legal advice or official current rates. Gemini may explain the already-computed breakdown and flag unusual terms; it must never calculate or overwrite authoritative totals. Place AI behind the domain AiPropertyAdvisorService port and data adapter. Validate strict JSON schema, use an 8-second timeout, log no personal text, and provide a deterministic fallback badge. Before coding, verify the requested gemini-4-argon model identifier and account access from current official documentation; if unavailable, keep the adapter disabled/mock and do not substitute an invented model name.
```

### 7.2 Measure SDK

- [ ] Only after core app is stable.
- [ ] App launch and `proptech_action_sync` spans.
- [ ] Handled sync exceptions.
- [ ] PII scrubber sends codes/durations only.
- [ ] Before/after measurement is real and reproducible.

**Prompt**

```text
Only after core acceptance is green, integrate Measure SDK behind MeasureTelemetry/DiagnosticSink. Verify current official SDK setup instructions and supported Flutter version. Track app launch, proptech_action_sync duration and handled sync failures. Send only event codes, safe component names and durations; never notes, names, exact addresses or personal text. Measure one real bottleneck before and after a specific optimisation. If SDK setup is blocked, keep a documented local debug sink and do not claim Measure is integrated.
```

---

## Demo runbook (5 minutes)

1. **0:00–0:45 — Frame:** Explain the Mumbai ghost-availability/double-commitment problem and state the headline rule.
2. **0:45–2:00 — Happy path:** Renter discovers L1, requests a viewing, switches to Owner, approves, switches back and tracks the status.
3. **2:00–3:15 — Rule proof:** Try L3 (unavailable), L5 (active request exists) or L6 (token locked). Show clear rejection and evidence.
4. **3:15–4:15 — Recovery proof:** Enable Drop Network, request L2, show saved/retryable state, relaunch if time allows, restore Normal and Retry Safely. Show exactly one request and audit events.
5. **4:15–5:00 — Defence:** Show diagram, two ADRs, passing tests and explain why SQLite is the source of truth and remote service is simulated.

## Final rules

- The Tier 2 Build Spec wins where earlier GharHold documents disagree.
- No cloud provider is part of the hackathon prototype. Do not add AWS/GCP/Firebase infrastructure.
- Never claim real remote sync, real authentication, real payments or live rental-market data.
- No extra screens/features without explicit approval and a corresponding PRD update.
- If code, diagram, ADR, test or demo names differ, fix all affected artefacts before proceeding.
- Stop at the last point where tests are green and the architecture is defensible.
