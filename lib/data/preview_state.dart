/// State manager for GharHold frontend.
/// Backed by ProptechRepository (Drift/SQLite + SimulatedRemoteService)
/// with fallback to in-memory fixtures.
/// Decoupled provider seam preserving all GH01–GH07 UI contracts.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/audit_event.dart';
import '../domain/models/listing.dart';
import '../domain/models/request.dart';
import '../domain/ports/proptech_repository.dart';
import '../domain/rules/rules.dart';
import '../observability/diagnostic_sink.dart';
import '../observability/noop_observability_service.dart';
import '../observability/observability_service.dart';
import 'fixtures/seed_listings.dart';
import 'remote/fault_config.dart';

enum PreviewFaultMode { NORMAL, DROP_NETWORK, STALE_CONFLICT }

class GharHoldPreviewState extends ChangeNotifier {
  final ProptechRepository? repository;
  final FaultConfig? faultConfig;
  final DiagnosticSink _diagnosticSink;
  final ObservabilityService observability;
  final Uuid _uuid = const Uuid();

  StreamSubscription<List<PropertyListing>>? _listingsSub;
  StreamSubscription<List<ViewingRequest>>? _requestsSub;
  StreamSubscription<List<AuditEvent>>? _eventsSub;

  List<PropertyListing> _listings = [];
  List<ViewingRequest> _requests = [];
  List<AuditEvent> _repoAuditEvents = [];
  Role _currentRole = Role.RENTER;
  PreviewFaultMode _faultMode = PreviewFaultMode.NORMAL;
  String _selectedNeighbourhood = 'All';

  GharHoldPreviewState({
    this.repository,
    this.faultConfig,
    DiagnosticSink? diagnosticSink,
    ObservabilityService? observability,
  }) : _diagnosticSink = diagnosticSink ?? InMemDiagnosticSink(),
       observability = observability ?? NoOpObservabilityService() {
    if (repository == null) {
      _initFixtures();
    } else {
      _listings = createSeedListings();
      _requests = createSeedRequests();
      _subscribeToRepository();
    }
  }

  void _initFixtures() {
    _listings = createSeedListings();
    _requests = createSeedRequests();
    for (final ev in InMemDiagnosticSink.createSamplePreviewEvents()) {
      _diagnosticSink.log(ev);
    }
  }

  void _subscribeToRepository() {
    final repo = repository;
    if (repo == null) return;

    _listingsSub = repo.watchListings().listen((data) {
      if (data.isNotEmpty) {
        _listings = data;
        notifyListeners();
      }
    });

    _requestsSub = repo.watchRequests().listen((data) {
      _requests = data;
      notifyListeners();
    });

    _eventsSub = repo.watchAuditEvents().listen((data) {
      _repoAuditEvents = data;
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    final repo = repository;
    if (repo != null) {
      final listings = await repo.getListings();
      if (listings.isNotEmpty) {
        _listings = listings;
      }
      _requests = await repo.getRequests();
      _repoAuditEvents = await repo.getAuditEvents();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _listingsSub?.cancel();
    _requestsSub?.cancel();
    _eventsSub?.cancel();
    super.dispose();
  }

  // --- Getters ---
  List<PropertyListing> get listings => List.unmodifiable(_listings);
  List<ViewingRequest> get requests => List.unmodifiable(_requests);
  Role get currentRole => _currentRole;
  PreviewFaultMode get faultMode {
    if (faultConfig != null) {
      switch (faultConfig!.mode) {
        case FaultMode.normal:
          return PreviewFaultMode.NORMAL;
        case FaultMode.dropNetwork:
          return PreviewFaultMode.DROP_NETWORK;
        case FaultMode.staleConflict:
          return PreviewFaultMode.STALE_CONFLICT;
      }
    }
    return _faultMode;
  }

  String get selectedNeighbourhood => _selectedNeighbourhood;
  List<AuditEvent> get auditEvents => repository != null
      ? List.unmodifiable(_repoAuditEvents)
      : _diagnosticSink.events;
  DiagnosticSink get diagnosticSink => _diagnosticSink;

  List<PropertyListing> get filteredListings {
    if (_selectedNeighbourhood == 'All') {
      return listings;
    }
    return _listings
        .where(
          (l) =>
              l.neighbourhood.toLowerCase() ==
              _selectedNeighbourhood.toLowerCase(),
        )
        .toList();
  }

  List<ViewingRequest> get renterRequests => _requests;

  List<ViewingRequest> get ownerRequests {
    final ownedListingIds = _listings
        .where((l) => l.ownerId == 'o1')
        .map((l) => l.id)
        .toSet();
    return _requests
        .where((r) => ownedListingIds.contains(r.listingId))
        .toList();
  }

  PropertyListing? getListingById(String id) {
    try {
      return _listings.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  ViewingRequest? getRequestById(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  ViewingRequest? getActiveRequestForListing(String listingId) {
    try {
      return _requests.firstWhere(
        (r) => r.listingId == listingId && r.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  // --- State mutations ---

  void setRole(Role role) {
    if (_currentRole != role) {
      _currentRole = role;
      notifyListeners();
    }
  }

  void setFaultMode(PreviewFaultMode mode) {
    _faultMode = mode;
    if (faultConfig != null) {
      switch (mode) {
        case PreviewFaultMode.NORMAL:
          faultConfig!.setNormal();
          break;
        case PreviewFaultMode.DROP_NETWORK:
          faultConfig!.setDropNetwork();
          break;
        case PreviewFaultMode.STALE_CONFLICT:
          faultConfig!.setStaleConflict();
          break;
      }
    }

    observability.trackCustomEvent(
      'fault_mode_changed',
      attributes: {'fault_mode': mode.name},
    );

    _diagnosticSink.log(
      AuditEvent(
        timestamp: DateTime.now(),
        correlationId: _uuid.v4(),
        component: 'ui.inspection_bar',
        eventType: AuditEventType.FAULT_SET,
        previousState: _faultMode.name,
        newState: mode.name,
        ruleOrErrorCode: null,
        summary: 'Simulation fault mode set to ${mode.name}',
      ),
    );
    notifyListeners();
  }

  void filterNeighbourhood(String neighbourhood) {
    _selectedNeighbourhood = neighbourhood;
    notifyListeners();
  }

  /// Submit viewing request
  ValidationResult submitViewingRequest({
    required String listingId,
    required String preferredWindow,
    required String note,
    String renterId = 'r1',
  }) {
    final span = observability.startSpan('viewing_request_transaction');
    span.setAttribute('operation', 'submit_viewing_request');

    if (repository != null) {
      repository!.submitViewingRequest(
        listingId: listingId,
        renterId: renterId,
        preferredWindow: preferredWindow,
        note: note,
      );

      final listing = getListingById(listingId);
      final hasActive = _requests.any(
        (r) => r.listingId == listingId && r.isActive,
      );
      final result = ProptechBusinessRules.validateNewViewingRequest(
        listing:
            listing ??
            const PropertyListing(
              id: 'unknown',
              title: 'Unknown',
              neighbourhood: 'Unknown',
              bhk: 1,
              monthlyRent: 0,
              depositMonths: 0,
              state: ListingState.UNAVAILABLE,
              version: 1,
              ownerId: 'o1',
            ),
        hasActiveRequestOnListing: hasActive,
        note: note,
        actorRole: _currentRole,
      );

      if (result is Valid) {
        observability.trackCustomEvent(
          'viewing_request_submitted',
          attributes: {'role': _currentRole.name, 'result': 'valid'},
        );
        span.setStatusOk();
      } else if (result is Rejected) {
        observability.trackCustomEvent(
          'viewing_request_failed',
          attributes: {'rule_code': result.ruleCode, 'role': _currentRole.name},
        );
        span.setStatusError(result.ruleCode);
      }
      span.end();
      return result;
    }

    // In-memory fallback
    final listingIndex = _listings.indexWhere((l) => l.id == listingId);
    if (listingIndex == -1) {
      observability.trackCustomEvent(
        'viewing_request_failed',
        attributes: {'rule_code': ProptechBusinessRules.errListingNotAvailable},
      );
      span.setStatusError('listing_not_found');
      span.end();
      return const Rejected(
        ruleCode: ProptechBusinessRules.errListingNotAvailable,
        userMessage: 'Listing not found.',
      );
    }

    final listing = _listings[listingIndex];
    final hasActive = _requests.any(
      (r) => r.listingId == listingId && r.isActive,
    );

    final validation = ProptechBusinessRules.validateNewViewingRequest(
      listing: listing,
      hasActiveRequestOnListing: hasActive,
      note: note,
      actorRole: _currentRole,
    );

    final now = DateTime.now();
    final correlationId = _uuid.v4();

    if (validation is Rejected) {
      observability.trackCustomEvent(
        'viewing_request_failed',
        attributes: {
          'rule_code': validation.ruleCode,
          'role': _currentRole.name,
        },
      );
      span.setStatusError(validation.ruleCode);
      span.end();
      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'domain.rules',
          eventType: AuditEventType.RULE_REJECTED,
          previousState: listing.state.name,
          newState: listing.state.name,
          ruleOrErrorCode: validation.ruleCode,
          summary:
              'Rejected viewing request for ${listing.title}: ${validation.userMessage}',
        ),
      );
      notifyListeners();
      return validation;
    }

    final idempotencyKey = _uuid.v4();
    final requestId = 'req-${now.millisecondsSinceEpoch}';

    if (_faultMode == PreviewFaultMode.STALE_CONFLICT) {
      _faultMode = PreviewFaultMode.NORMAL;
      final updatedListing = listing.copyWith(
        state: ListingState.UNAVAILABLE,
        version: listing.version + 1,
      );
      _listings[listingIndex] = updatedListing;

      final abortedRequest = ViewingRequest(
        id: requestId,
        idempotencyKey: idempotencyKey,
        listingId: listingId,
        renterId: renterId,
        kind: RequestKind.VIEWING,
        preferredWindow: preferredWindow,
        note: note.trim(),
        status: RequestStatus.ABORTED,
        syncState: SyncState.CONFLICT_STALE_DATA,
        clientListingVersion: listing.version,
        createdAt: now,
        updatedAt: now,
      );
      _requests.insert(0, abortedRequest);

      observability.trackCustomEvent(
        'stale_conflict_detected',
        attributes: {'listing_version': listing.version, 'result': 'aborted'},
      );
      span.setStatusError('stale_conflict');
      span.end();

      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'data.remote_service',
          eventType: AuditEventType.CONFLICT,
          previousState: 'v${listing.version}:${listing.state.name}',
          newState: 'v${updatedListing.version}:${updatedListing.state.name}',
          ruleOrErrorCode: 'ERR_STALE_VERSION',
          summary:
              'Stale version conflict on ${listing.title}: Server moved listing to UNAVAILABLE v${updatedListing.version}. Request aborted.',
        ),
      );
      notifyListeners();
      return const Valid();
    }

    if (_faultMode == PreviewFaultMode.DROP_NETWORK) {
      final updatedListing = listing.copyWith(
        state: ListingState.VIEWING_REQUESTED,
      );
      _listings[listingIndex] = updatedListing;

      final failedRequest = ViewingRequest(
        id: requestId,
        idempotencyKey: idempotencyKey,
        listingId: listingId,
        renterId: renterId,
        kind: RequestKind.VIEWING,
        preferredWindow: preferredWindow,
        note: note.trim(),
        status: RequestStatus.REQUESTED,
        syncState: SyncState.SYNC_FAILED_RETRYABLE,
        clientListingVersion: listing.version,
        createdAt: now,
        updatedAt: now,
      );
      _requests.insert(0, failedRequest);

      observability.trackCustomEvent(
        'sync_failed',
        attributes: {'reason': 'network_dropped', 'retryable': true},
      );
      span.setStatusError('network_dropped');
      span.end();

      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'data.repository',
          eventType: AuditEventType.STATE_TRANSITION,
          previousState: listing.state.name,
          newState: ListingState.VIEWING_REQUESTED.name,
          ruleOrErrorCode: null,
          summary:
              'Saved locally: Viewing request created for ${listing.title}. Listing locked to VIEWING_REQUESTED.',
        ),
      );

      _diagnosticSink.log(
        AuditEvent(
          timestamp: now.add(const Duration(milliseconds: 100)),
          correlationId: correlationId,
          component: 'data.remote_service',
          eventType: AuditEventType.SYNC_FAILURE,
          previousState: SyncState.PENDING_SYNC.name,
          newState: SyncState.SYNC_FAILED_RETRYABLE.name,
          ruleOrErrorCode: 'ERR_NETWORK',
          summary:
              'Network simulation dropped connection. Saved locally with safe retry available.',
        ),
      );
      notifyListeners();
      return const Valid();
    }

    final updatedListing = listing.copyWith(
      state: ListingState.VIEWING_REQUESTED,
    );
    _listings[listingIndex] = updatedListing;

    final request = ViewingRequest(
      id: requestId,
      idempotencyKey: idempotencyKey,
      listingId: listingId,
      renterId: renterId,
      kind: RequestKind.VIEWING,
      preferredWindow: preferredWindow,
      note: note.trim(),
      status: RequestStatus.REQUESTED,
      syncState: SyncState.SUBMITTED,
      clientListingVersion: listing.version,
      createdAt: now,
      updatedAt: now,
    );
    _requests.insert(0, request);

    observability.trackCustomEvent(
      'viewing_request_submitted',
      attributes: {'status': 'submitted', 'role': _currentRole.name},
    );
    span.setStatusOk();
    span.end();

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: correlationId,
        component: 'data.repository',
        eventType: AuditEventType.STATE_TRANSITION,
        previousState: listing.state.name,
        newState: ListingState.VIEWING_REQUESTED.name,
        ruleOrErrorCode: null,
        summary:
            'Viewing request submitted for ${listing.title}. Status: REQUESTED / SUBMITTED.',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  void retryRequest(String requestId) {
    final span = observability.startSpan('retry_operation');
    span.setAttribute('operation', 'retry_sync');

    if (repository != null) {
      repository!.retrySync(requestId);
      observability.trackCustomEvent(
        'sync_retry_attempted',
        attributes: {'operation': 'retry_sync'},
      );
      span.setStatusOk();
      span.end();
      return;
    }

    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) {
      span.setStatusError('request_not_found');
      span.end();
      return;
    }

    final req = _requests[idx];
    final now = DateTime.now();
    final correlationId = _uuid.v4();

    if (_faultMode == PreviewFaultMode.DROP_NETWORK) {
      observability.trackCustomEvent(
        'sync_failed',
        attributes: {'reason': 'network_dropped_on_retry'},
      );
      span.setStatusError('network_dropped');
      span.end();

      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'data.repository',
          eventType: AuditEventType.RETRY,
          previousState: req.syncState.name,
          newState: SyncState.SYNC_FAILED_RETRYABLE.name,
          ruleOrErrorCode: 'ERR_NETWORK',
          summary:
              'Retry failed due to simulated offline mode. Reused idempotencyKey: ${req.idempotencyKey}',
        ),
      );
      notifyListeners();
      return;
    }

    final updated = req.copyWith(
      syncState: SyncState.SUBMITTED,
      updatedAt: now,
    );
    _requests[idx] = updated;

    observability.trackCustomEvent(
      'sync_retry_attempted',
      attributes: {'status': 'submitted'},
    );
    span.setStatusOk();
    span.end();

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: correlationId,
        component: 'data.repository',
        eventType: AuditEventType.RETRY,
        previousState: SyncState.SYNC_FAILED_RETRYABLE.name,
        newState: SyncState.SUBMITTED.name,
        ruleOrErrorCode: null,
        summary:
            'Retry successful with original idempotencyKey ${req.idempotencyKey}. Sync: SUBMITTED.',
      ),
    );
    notifyListeners();
  }

  void resolveConflict(String requestId) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;

    final req = _requests[idx];
    final now = DateTime.now();
    _requests[idx] = req.copyWith(
      syncState: SyncState.RESOLVED_ABORTED,
      updatedAt: now,
    );

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: _uuid.v4(),
        component: 'ui.preview_state',
        eventType: AuditEventType.STATE_TRANSITION,
        previousState: SyncState.CONFLICT_STALE_DATA.name,
        newState: SyncState.RESOLVED_ABORTED.name,
        ruleOrErrorCode: null,
        summary:
            'Renter acknowledged stale conflict on listing ${req.listingId}. Truth refreshed.',
      ),
    );
    notifyListeners();
  }

  ValidationResult requestToken(String requestId) {
    if (repository != null) {
      repository!.requestToken(
        requestId,
        _currentRole == Role.RENTER ? 'r1' : 'o1',
        actorRole: _currentRole,
      );
      final req = getRequestById(requestId);
      final listing = req != null ? getListingById(req.listingId) : null;
      if (req == null || listing == null) {
        return const Rejected(
          ruleCode: ProptechBusinessRules.errIllegalTransition,
          userMessage: 'Request or listing not found.',
        );
      }
      return ProptechBusinessRules.validateTokenRequest(
        request: req,
        listing: listing,
        actorRole: _currentRole,
      );
    }

    final reqIndex = _requests.indexWhere((r) => r.id == requestId);
    if (reqIndex == -1) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errIllegalTransition,
        userMessage: 'Request not found.',
      );
    }
    final req = _requests[reqIndex];
    final listing = getListingById(req.listingId);
    if (listing == null) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errListingNotAvailable,
        userMessage: 'Listing not found.',
      );
    }

    final validation = ProptechBusinessRules.validateTokenRequest(
      request: req,
      listing: listing,
      actorRole: _currentRole,
    );

    final now = DateTime.now();
    final correlationId = _uuid.v4();

    if (validation is Rejected) {
      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'domain.rules',
          eventType: AuditEventType.RULE_REJECTED,
          previousState: req.status.name,
          newState: req.status.name,
          ruleOrErrorCode: validation.ruleCode,
          summary: 'Rejected token hold: ${validation.userMessage}',
        ),
      );
      notifyListeners();
      return validation;
    }

    _requests[reqIndex] = req.copyWith(
      kind: RequestKind.TOKEN,
      status: RequestStatus.TOKEN_REQUESTED,
      updatedAt: now,
    );

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: correlationId,
        component: 'data.repository',
        eventType: AuditEventType.STATE_TRANSITION,
        previousState: RequestStatus.APPROVED.name,
        newState: RequestStatus.TOKEN_REQUESTED.name,
        ruleOrErrorCode: null,
        summary:
            'Renter requested token hold for ${listing.title}. Token is a workflow hold marker only.',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  ValidationResult ownerApprove(String requestId) {
    final span = observability.startSpan('owner_decision_transaction');
    span.setAttribute('operation', 'approve');

    if (repository != null) {
      repository!.approveRequest(requestId, 'o1', actorRole: _currentRole);
      final req = getRequestById(requestId);
      if (req == null) {
        span.setStatusError('request_not_found');
        span.end();
        return const Rejected(
          ruleCode: ProptechBusinessRules.errIllegalTransition,
          userMessage: 'Request not found.',
        );
      }
      final result = ProptechBusinessRules.validateOwnerAction(
        actorRole: _currentRole,
        request: req,
        targetStatus: RequestStatus.APPROVED,
      );
      if (result is Valid) {
        observability.trackCustomEvent(
          'owner_request_approved',
          attributes: {'status': 'approved'},
        );
        span.setStatusOk();
      } else if (result is Rejected) {
        span.setStatusError(result.ruleCode);
      }
      span.end();
      return result;
    }

    final res = _applyOwnerDecision(
      requestId: requestId,
      targetStatus: RequestStatus.APPROVED,
      summaryText: 'Owner approved viewing request',
    );
    if (res is Valid) {
      observability.trackCustomEvent(
        'owner_request_approved',
        attributes: {'status': 'approved'},
      );
      span.setStatusOk();
    } else if (res is Rejected) {
      span.setStatusError(res.ruleCode);
    }
    span.end();
    return res;
  }

  ValidationResult ownerDecline(String requestId) {
    final span = observability.startSpan('owner_decision_transaction');
    span.setAttribute('operation', 'decline');

    if (repository != null) {
      repository!.declineRequest(requestId, 'o1', actorRole: _currentRole);
      final req = getRequestById(requestId);
      if (req == null) {
        span.setStatusError('request_not_found');
        span.end();
        return const Rejected(
          ruleCode: ProptechBusinessRules.errIllegalTransition,
          userMessage: 'Request not found.',
        );
      }
      final result = ProptechBusinessRules.validateOwnerAction(
        actorRole: _currentRole,
        request: req,
        targetStatus: RequestStatus.DECLINED,
      );
      if (result is Valid) {
        observability.trackCustomEvent(
          'owner_request_declined',
          attributes: {'status': 'declined'},
        );
        span.setStatusOk();
      } else if (result is Rejected) {
        span.setStatusError(result.ruleCode);
      }
      span.end();
      return result;
    }

    final res = _applyOwnerDecision(
      requestId: requestId,
      targetStatus: RequestStatus.DECLINED,
      summaryText:
          'Owner declined viewing request. Listing released back to AVAILABLE.',
      onSuccess: (req, listingIndex) {
        if (listingIndex != -1) {
          _listings[listingIndex] = _listings[listingIndex].copyWith(
            state: ListingState.AVAILABLE,
          );
        }
      },
    );
    if (res is Valid) {
      observability.trackCustomEvent(
        'owner_request_declined',
        attributes: {'status': 'declined'},
      );
      span.setStatusOk();
    } else if (res is Rejected) {
      span.setStatusError(res.ruleCode);
    }
    span.end();
    return res;
  }

  ValidationResult ownerReopen(String requestId, String reason) {
    if (repository != null) {
      repository!.reopenRequest(
        requestId,
        'o1',
        reason: reason,
        actorRole: _currentRole,
      );
      final req = getRequestById(requestId);
      final listing = req != null ? getListingById(req.listingId) : null;
      if (req == null) {
        return const Rejected(
          ruleCode: ProptechBusinessRules.errIllegalTransition,
          userMessage: 'Request not found.',
        );
      }
      return ProptechBusinessRules.validateOwnerAction(
        actorRole: _currentRole,
        request: req,
        targetStatus: RequestStatus.REOPENED,
        reopenReason: reason,
        listing: listing,
      );
    }

    final reqIndex = _requests.indexWhere((r) => r.id == requestId);
    if (reqIndex == -1) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errIllegalTransition,
        userMessage: 'Request not found.',
      );
    }
    final req = _requests[reqIndex];
    final listingIndex = _listings.indexWhere((l) => l.id == req.listingId);
    final listing = listingIndex != -1 ? _listings[listingIndex] : null;

    final hasOtherActive = _requests.any(
      (r) => r.listingId == req.listingId && r.id != req.id && r.isActive,
    );

    final validation = ProptechBusinessRules.validateOwnerAction(
      actorRole: _currentRole,
      request: req,
      targetStatus: RequestStatus.REOPENED,
      reopenReason: reason,
      listing: listing,
      hasOtherActiveRequest: hasOtherActive,
    );

    final now = DateTime.now();
    final correlationId = _uuid.v4();

    if (validation is Rejected) {
      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'domain.rules',
          eventType: AuditEventType.RULE_REJECTED,
          previousState: req.status.name,
          newState: req.status.name,
          ruleOrErrorCode: validation.ruleCode,
          summary: 'Owner reopen rejected: ${validation.userMessage}',
        ),
      );
      notifyListeners();
      return validation;
    }

    _requests[reqIndex] = req.copyWith(
      status: RequestStatus.REOPENED,
      reopenReason: reason.trim(),
      updatedAt: now,
    );

    if (listingIndex != -1) {
      _listings[listingIndex] = _listings[listingIndex].copyWith(
        state: ListingState.VIEWING_REQUESTED,
      );
    }

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: correlationId,
        component: 'data.repository',
        eventType: AuditEventType.OWNER_DECISION,
        previousState: RequestStatus.DECLINED.name,
        newState: RequestStatus.REOPENED.name,
        ruleOrErrorCode: null,
        summary:
            'Owner reopened request with reason: "${reason.trim()}". Listing updated to VIEWING_REQUESTED.',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  ValidationResult ownerConfirmToken(String requestId) {
    if (repository != null) {
      repository!.confirmToken(requestId, 'o1', actorRole: _currentRole);
      final req = getRequestById(requestId);
      if (req == null) {
        return const Rejected(
          ruleCode: ProptechBusinessRules.errIllegalTransition,
          userMessage: 'Request not found.',
        );
      }
      return ProptechBusinessRules.validateOwnerAction(
        actorRole: _currentRole,
        request: req,
        targetStatus: RequestStatus.TOKEN_CONFIRMED,
      );
    }

    return _applyOwnerDecision(
      requestId: requestId,
      targetStatus: RequestStatus.TOKEN_CONFIRMED,
      summaryText: 'Owner confirmed token hold. Listing is now TOKEN_LOCKED.',
      onSuccess: (req, listingIndex) {
        if (listingIndex != -1) {
          _listings[listingIndex] = _listings[listingIndex].copyWith(
            state: ListingState.TOKEN_LOCKED,
          );
        }
      },
    );
  }

  ValidationResult ownerMarkOffMarket(String listingId) {
    if (repository != null) {
      repository!.markOffMarket(listingId, 'o1', actorRole: _currentRole);
      if (_currentRole != Role.OWNER) {
        return const Rejected(
          ruleCode: ProptechBusinessRules.errNotPermitted,
          userMessage: 'Owner role required to mark listing off-market.',
        );
      }
      return const Valid();
    }

    if (_currentRole != Role.OWNER) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errNotPermitted,
        userMessage: 'Owner role required to mark listing off-market.',
      );
    }
    final idx = _listings.indexWhere((l) => l.id == listingId);
    if (idx == -1) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errListingNotAvailable,
        userMessage: 'Listing not found.',
      );
    }
    final listing = _listings[idx];
    final now = DateTime.now();
    _listings[idx] = listing.copyWith(state: ListingState.UNAVAILABLE);

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: _uuid.v4(),
        component: 'data.repository',
        eventType: AuditEventType.OWNER_DECISION,
        previousState: listing.state.name,
        newState: ListingState.UNAVAILABLE.name,
        ruleOrErrorCode: null,
        summary:
            'Owner marked listing ${listing.title} off-market (UNAVAILABLE).',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  ValidationResult ownerRelist(String listingId) {
    if (repository != null) {
      repository!.relist(listingId, 'o1', actorRole: _currentRole);
      if (_currentRole != Role.OWNER) {
        return const Rejected(
          ruleCode: ProptechBusinessRules.errNotPermitted,
          userMessage: 'Owner role required to relist property.',
        );
      }
      return const Valid();
    }

    if (_currentRole != Role.OWNER) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errNotPermitted,
        userMessage: 'Owner role required to relist property.',
      );
    }
    final idx = _listings.indexWhere((l) => l.id == listingId);
    if (idx == -1) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errListingNotAvailable,
        userMessage: 'Listing not found.',
      );
    }
    final listing = _listings[idx];
    final now = DateTime.now();
    _listings[idx] = listing.copyWith(state: ListingState.AVAILABLE);

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: _uuid.v4(),
        component: 'data.repository',
        eventType: AuditEventType.OWNER_DECISION,
        previousState: listing.state.name,
        newState: ListingState.AVAILABLE.name,
        ruleOrErrorCode: null,
        summary: 'Owner relisted ${listing.title} as AVAILABLE.',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  ValidationResult _applyOwnerDecision({
    required String requestId,
    required RequestStatus targetStatus,
    required String summaryText,
    void Function(ViewingRequest req, int listingIndex)? onSuccess,
  }) {
    final reqIndex = _requests.indexWhere((r) => r.id == requestId);
    if (reqIndex == -1) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errIllegalTransition,
        userMessage: 'Request not found.',
      );
    }
    final req = _requests[reqIndex];
    final listingIndex = _listings.indexWhere((l) => l.id == req.listingId);
    final listing = listingIndex != -1 ? _listings[listingIndex] : null;

    final validation = ProptechBusinessRules.validateOwnerAction(
      actorRole: _currentRole,
      request: req,
      targetStatus: targetStatus,
      listing: listing,
    );

    final now = DateTime.now();
    final correlationId = _uuid.v4();

    if (validation is Rejected) {
      _diagnosticSink.log(
        AuditEvent(
          timestamp: now,
          correlationId: correlationId,
          component: 'domain.rules',
          eventType: AuditEventType.RULE_REJECTED,
          previousState: req.status.name,
          newState: req.status.name,
          ruleOrErrorCode: validation.ruleCode,
          summary: 'Owner action rejected: ${validation.userMessage}',
        ),
      );
      notifyListeners();
      return validation;
    }

    final updatedReq = req.copyWith(status: targetStatus, updatedAt: now);
    _requests[reqIndex] = updatedReq;

    if (onSuccess != null) {
      onSuccess(updatedReq, listingIndex);
    }

    _diagnosticSink.log(
      AuditEvent(
        timestamp: now,
        correlationId: correlationId,
        component: 'data.repository',
        eventType: AuditEventType.OWNER_DECISION,
        previousState: req.status.name,
        newState: targetStatus.name,
        ruleOrErrorCode: null,
        summary: '$summaryText (Request ID: $requestId)',
      ),
    );
    notifyListeners();
    return const Valid();
  }

  void resetPreviewData() {
    observability.trackCustomEvent(
      'demo_data_reset',
      attributes: {'operation': 'reset_fixtures'},
    );

    if (repository != null) {
      repository!.resetToSeed();
      if (faultConfig != null) {
        faultConfig!.setNormal();
      }
      _selectedNeighbourhood = 'All';
      notifyListeners();
      return;
    }

    _initFixtures();
    _faultMode = PreviewFaultMode.NORMAL;
    _selectedNeighbourhood = 'All';

    _diagnosticSink.log(
      AuditEvent(
        timestamp: DateTime.now(),
        correlationId: _uuid.v4(),
        component: 'ui.preview_state',
        eventType: AuditEventType.DATA_RESET,
        previousState: 'MODIFIED',
        newState: 'INITIAL_FIXTURES',
        ruleOrErrorCode: null,
        summary:
            'In-memory preview data reset and reseeded to default fixtures.',
      ),
    );
    notifyListeners();
  }
}
