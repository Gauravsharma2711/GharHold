# GharHold Security & Privacy Baseline

This document summarizes the concrete security, privacy, and architectural audit findings for the GharHold prototype.

---

## 1. Secrets & Credentials Audit

- **Tracked Files Scan**: A full repository search was performed across all code, configuration, and documentation files.
- **Finding**: **0 secrets found**. No API keys, cloud tokens, database passwords, or private certificates exist in the repository.
- **Environment**: Cloud-independent hackathon build. No external network credentials or Firebase/AWS/GCP connection strings are used.

---

## 2. Privacy & Location Integrity

- **Approximate Neighbourhoods Only**: Listings and requests store and display only high-level Mumbai micromarkets (`Powai`, `Andheri East`, `Bandra West`, `Malad West`).
- **No Precise Addresses or GPS**: The system strictly avoids capturing, storing, or rendering building numbers, flat numbers, street names, lat/long coordinates, or live maps.
- **Request Note Sanitization**:
  - The optional user viewing note (max 200 trimmed characters) is stored strictly in `requests.note` for communication purposes.
  - Telemetry and the diagnostic audit trail (`audit_events` table and `DiagnosticSink`) **strictly exclude** the note text, phone numbers, or personal details.
  - Verified by automated regression test `test/data/recovery_test.dart`, which injects a confidential phone number into a note and proves it is never written to `audit_events.summary`, `previousState`, or `newState`.

---

## 3. Demo Role Switcher vs. Authentication

- **Honest Seam Disclosure**: The in-app Role Switcher in the persistent Architecture Inspection Bar is explicitly a presentation-layer demonstration convenience, not an authentication or authorization boundary.
- **Domain Role Validation**: Even within the demo, `ProptechBusinessRules` checks `actorRole`. Renters attempting owner-only actions (such as `approveRequest`, `declineRequest`, `reopenRequest`, `confirmToken`, `markOffMarket`, `relist`) are rejected with `ERR_NOT_PERMITTED`.

---

## 4. Input Validation & Data Integrity

- **Domain Boundary Validation**: All user inputs (preferred window, note length, reopen reason, target statuses) are validated in pure Dart before any database transaction is initiated.
- **Database Partial Unique Index**: SQLite enforces `one_active_request_per_listing` via a partial unique index on `requests(listing_id)` for active statuses (`REQUESTED`, `APPROVED`, `REOPENED`, `TOKEN_REQUESTED`, `TOKEN_CONFIRMED`), guaranteeing data integrity even if domain checks are bypassed.
- **Idempotency Protection**: `requests.idempotency_key` carries a SQLite `UNIQUE` constraint preventing duplicate submissions.

