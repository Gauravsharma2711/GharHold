# GharHold Observability & Diagnostic Event Catalog

The GharHold prototype records structured audit events in SQLite (`audit_events` table) and exposes them through the persistent Architecture Inspection Bar's **Evidence Log** drawer (GH06).

---

## 1. Event Types

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

## 2. Privacy Guarantees

All events conform to the privacy baseline:
- `timestamp`: UTC/Local ISO 8601 timestamp.
- `correlationId`: Unique tracing UUID.
- `component`: Name of the architectural subsystem emitting the event.
- `eventType`: Standardized enum string.
- `previousState` & `newState`: State machine representations.
- `ruleOrErrorCode`: Machine-readable error or rule code.
- `summary`: Human-readable summary containing only safe IDs and property titles (never user notes, personal numbers, or precise addresses).

