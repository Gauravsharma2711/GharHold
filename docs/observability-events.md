# GharHold Observability & Diagnostic Event Catalog

GharHold maintains two complementary, strictly isolated observability subsystems:

1. **GharHold Internal Audit Engine (`DiagnosticSink` / `AuditEvent`)**:
   - Durable local SQLite audit logging (`audit_events` table).
   - In-app inspection via GH06 Evidence Drawer.
   - Deterministic event verification for state transitions and rule enforcement.

2. **Measure.sh Mobile Telemetry (`ObservabilityService`)**:
   - Flutter crash and handled error tracking.
   - Android ANR monitoring.
   - App startup and performance span tracing.
   - Screen navigation tracking.
   - Client session context with privacy masking (`MsrMask`).

---

## 1. Internal Audit Events (GH06 Evidence Drawer)

| Event Type | Component | Description | Sample Previous $\to$ New State |
|---|---|---|---|
| `STATE_TRANSITION` | `ProptechRepository` / `SimulatedRemoteService` | Atomic local state changes and remote sync completions | `AVAILABLE / NONE` $\to$ `VIEWING_REQUESTED / REQUESTED (PENDING_SYNC)` |
| `RULE_REJECTED` | `ProptechRepository` / `OwnerInbox` | Action rejected by pure domain invariants | `AVAILABLE` $\to$ `AVAILABLE` (`ERR_ACTIVE_REQUEST_EXISTS`) |
| `SYNC_FAILURE` | `SimulatedRemoteService` | Simulated network drop; request retained locally | `PENDING_SYNC` $\to$ `SYNC_FAILED_RETRYABLE` (`ERR_NETWORK_DROP`) |
| `CONFLICT` | `SimulatedRemoteService` | Optimistic concurrency conflict; server version advanced | `v1 (AVAILABLE)` $\to$ `v2 (UNAVAILABLE)` (`ERR_STALE_VERSION`) |
| `RETRY` | `ProptechRepository` | Safe retry dispatch reusing existing idempotency key | `SYNC_FAILED_RETRYABLE` $\to$ `PENDING_SYNC` |
| `RESUME_SCAN` | `StartupRecovery` | Interrupted pending sync recovered at app launch | `PENDING_SYNC` $\to$ `SYNC_FAILED_RETRYABLE` |
| `FAULT_SET` | `InspectionBar` | Fault mode toggled in inspection bar | `NORMAL` $\to$ `DROP_NETWORK` |
| `OWNER_DECISION` | `OwnerInbox` | Owner decision committed transactionally | `REQUESTED` $\to$ `APPROVED` |
| `DATA_RESET` | `DatabaseSeeder` | Reseeded fixtures to default initial state | `PREVIOUS_STATE` $\to$ `SEEDED` |

---

## 2. Measure.sh Custom Application Events

| Event Name | Attributes | Description |
|---|---|---|
| `app_started` | `persistence`, `remote` | Emitted when application successfully initializes Drift and recovery scan |
| `screen_viewed` | `screen_name` | Automatic and manual screen transition tracking |
| `listing_detail_opened` | `listing_state` | Emitted when user views listing details in GH02 |
| `viewing_request_submitted` | `status`, `role` | Viewing request validated and committed |
| `viewing_request_failed` | `rule_code`, `role` | Viewing request rejected by business invariants |
| `owner_request_approved` | `status` | Owner approves a viewing request in GH05 |
| `owner_request_declined` | `status` | Owner declines a viewing request in GH05 |
| `sync_retry_attempted` | `operation`, `status` | Renter or system retries a failed synchronization |
| `sync_failed` | `reason`, `retryable` | Simulated network interruption or timeout occurred |
| `stale_conflict_detected` | `listing_version`, `result` | Concurrent modification detected on remote service |
| `demo_data_reset` | `operation` | Database reseeded from GH07 Settings |
| `fault_mode_changed` | `fault_mode` | Fault simulation toggle switched in Inspection Bar |

---

## 3. Measure.sh Performance Spans

| Span Name | Operation / Checkpoints | Target Budget |
|---|---|---|
| `app_startup` | `bootstrap` $\to$ `db_seed` $\to$ `recovery_scan` | $< 800$ ms |
| `startup_recovery_scan` | Database query for stuck `PENDING_SYNC` requests | $< 100$ ms |
| `viewing_request_transaction` | Pure validation $\to$ SQLite commit $\to$ Remote dispatch | $< 250$ ms |
| `owner_decision_transaction` | Action validation $\to$ Status transition $\to$ Lock release | $< 200$ ms |
| `retry_operation` | Local lookup $\to$ Idempotent remote resubmission | $< 300$ ms |

---

## 4. Privacy & Masking Invariants

1. **Strict Key Deny-List**:
   - `MeasureObservabilityService` intercepts and drops any attribute key containing `phone`, `email`, `address`, `location`, `note`, `secret`, or `token_value`.
2. **Visual PII Masking (`MsrMask`)**:
   - Renter viewing notes (`TextFormField` in GH03) are wrapped with `MsrMask` to redact text from screenshots and layout captures.
   - Owner decline and reopen reason inputs (GH05) are wrapped with `MsrMask`.
3. **Layout Snapshot Disabled by Default**:
   - Custom screen tracking executes with `captureLayoutSnapshot: false` to ensure sensitive off-market pricing and property notes are never transmitted.
4. **Zero-PII Summaries**:
   - Analytics events never transmit raw customer phone numbers, Aadhaar/ID numbers, GPS coordinates, or private conversation text.
