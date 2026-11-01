# GharHold Test Evidence & Verification Report

This document records the exact test execution baseline and verification outputs from the GharHold test suite.

---

## 1. Test Suite Summary

- **Total Tests**: 50 passed, 0 failed, 0 skipped.
- **Static Analysis**: `dart analyze .` $\to$ **No issues found!** (0 errors, 0 warnings, 0 lints).
- **Code Formatting**: `dart format --set-exit-if-changed .` $\to$ **Clean (0 unformatted files)**.
- **Execution Date**: 2026-11-01

---

## 2. Test Execution Log (`flutter test`)

```text
00:00 +0: loading X:/test/data/database_test.dart
00:00 +0: X:/test/data/database_test.dart: Drift SQLite Database Tests buildActiveRequestPartialIndexSql uses domain activeRequestStatuses as single source
00:00 +1: X:/test/data/database_test.dart: Drift SQLite Database Tests Insert and query listing works
00:00 +2: X:/test/data/database_test.dart: Drift SQLite Database Tests Database partial unique index blocks second active request on same listing
00:00 +3: X:/test/data/database_test.dart: Drift SQLite Database Tests Database allows new active request after previous request becomes DECLINED
00:00 +4: X:/test/data/database_test.dart: Drift SQLite Database Tests Idempotency key UNIQUE constraint prevents duplicate keys
00:00 +5: X:/test/data/database_test.dart: Drift SQLite Database Tests Transaction rollback ensures all-or-nothing consistency
00:00 +6: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Initial state contains 10 listings, default RENTER role, and NORMAL fault mode
00:00 +7: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Seed listing L5 has active request held by renter r2
00:00 +8: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Filter by neighbourhood filters listings correctly
00:00 +9: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Submit valid viewing request updates listing to VIEWING_REQUESTED and adds request
00:00 +10: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Second viewing request on same listing is rejected by BR-1b
00:00 +11: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Drop network fault sets SYNC_FAILED_RETRYABLE while keeping listing locked
00:00 +12: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Stale conflict fault aborts request and refreshes listing to UNAVAILABLE v2
00:00 +13: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Owner approve, decline, and reopen with reason work seamlessly
00:00 +14: X:/test/data/preview_state_test.dart: GharHoldPreviewState Tests Reset preview data restores 10 initial fixtures
00:01 +15: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Initial seeded database contains 10 listings and L5 active request
00:01 +16: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Valid viewing request commits locally first and syncs remotely to SUBMITTED
00:01 +17: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Rule rejection on UNAVAILABLE listing creates no request and logs RULE_REJECTED
00:01 +18: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Rule rejection on listing with active request (L5) prevents duplicate request
00:01 +19: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Network drop fault retains active request and listing in SYNC_FAILED_RETRYABLE
00:01 +20: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Stale conflict fault aborts request, applies authoritative UNAVAILABLE v2, and logs CONFLICT
00:01 +21: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Owner approve, decline, and reopen flow
00:01 +22: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Token workflow: Hold with token requires approval and locks listing upon confirmation
00:01 +23: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Startup recovery converts leftover PENDING_SYNC to SYNC_FAILED_RETRYABLE
00:01 +24: X:/test/data/proptech_repository_test.dart: ProptechRepository Transactional & Coordination Tests Reset to seed restores 10 initial listings and logs DATA_RESET
00:01 +25: X:/test/data/recovery_test.dart: Startup Recovery & File-Backed Restart Tests File-backed restart recovers interrupted PENDING_SYNC without auto-sending
00:02 +26: X:/test/data/simulated_remote_service_test.dart: SimulatedRemoteService & Fault Injection Tests Normal mode succeeds when versions match
00:02 +27: X:/test/data/simulated_remote_service_test.dart: SimulatedRemoteService & Fault Injection Tests Normal mode throws StaleVersionConflict when client version is outdated
00:02 +28: X:/test/data/simulated_remote_service_test.dart: SimulatedRemoteService & Fault Injection Tests Network drop fault throws NetworkException
00:02 +29: X:/test/data/simulated_remote_service_test.dart: SimulatedRemoteService & Fault Injection Tests Stale conflict fault is one-shot and returns UNAVAILABLE v2
00:02 +30: X:/test/domain/domain_purity_test.dart: Domain Layer Purity Architecture Tests lib/domain/ contains zero framework, platform, database, or UI imports
00:03 +31: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests BR-1: UNAVAILABLE listing rejects new viewing request
00:03 +32: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests BR-1: TOKEN_LOCKED listing rejects new viewing request
00:03 +33: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests BR-1b: Listing in VIEWING_REQUESTED rejects a second active request
00:03 +34: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests Note length: Note over 200 trimmed characters rejects with ERR_INVALID_NOTE
00:03 +35: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests Valid viewing request passes validation
00:03 +36: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests BR-2: DECLINED request cannot jump directly to APPROVED
00:03 +37: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests BR-2: Reopening DECLINED request requires non-empty reason
00:03 +38: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests Owner-only actions reject Renter with ERR_NOT_PERMITTED
00:03 +39: X:/test/domain/rules_test.dart: ProptechBusinessRules - Invariant Tests Hold with token requires viewing request to be APPROVED
00:03 +40: X:/test/domain/state_tables_test.dart: Domain State Tables & Invariant Tests activeRequestStatuses contains exactly the 5 documented active statuses
00:03 +41: X:/test/domain/state_tables_test.dart: Domain State Tables & Invariant Tests Listing states: validate new viewing request across all states
00:03 +42: X:/test/domain/state_tables_test.dart: Domain State Tables & Invariant Tests Request transitions table for Owner
00:03 +43: X:/test/domain/state_tables_test.dart: Domain State Tables & Invariant Tests Hold with token requires viewing request to be APPROVED
00:03 +44: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Launches directly into GH01 Listing Feed without auth or onboarding
00:05 +45: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Neighbourhood filter filters listing feed
00:05 +46: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Tapping listing opens GH02 Listing Detail with Cost Breakdown
00:06 +47: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Role Switcher toggles between Renter and Owner views
00:06 +48: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Evidence button opens GH06 Evidence Drawer
00:06 +49: X:/test/widget_test.dart: GharHold UI Acceptance Widget Tests Settings tab reaches GH07 Settings & Reset Demo State
00:07 +50: All tests passed!
```

---

## 3. Static Analysis Output (`dart analyze .`)

```text
Analyzing ....
No issues found!
```

