import 'package:drift/drift.dart';

import '../../domain/models/audit_event.dart';
import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';
import '../../domain/ports/clock.dart';
import '../../domain/ports/id_generator.dart';
import '../../domain/ports/proptech_repository.dart';
import '../../domain/ports/remote_service.dart';
import '../../domain/rules/rules.dart';
import '../local/database.dart';
import '../local/database_seeder.dart';

/// Authoritative repository implementation coordinating pure domain rules,
/// transactional Drift/SQLite persistence, simulated remote synchronization,
/// and structured audit logging.
class ProptechRepositoryImpl implements ProptechRepository {
  final AppDatabase db;
  final RemoteService remoteService;
  final Clock clock;
  final IdGenerator idGenerator;

  ProptechRepositoryImpl({
    required this.db,
    required this.remoteService,
    this.clock = const SystemClock(),
    IdGenerator? idGenerator,
  }) : idGenerator = idGenerator ?? StandardIdGenerator();

  @override
  Stream<List<PropertyListing>> watchListings() {
    return db
        .select(db.listings)
        .watch()
        .map((rows) => rows.map(AppDatabase.listingFromEntity).toList());
  }

  @override
  Stream<PropertyListing?> watchListing(String id) {
    return (db.select(db.listings)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row != null ? AppDatabase.listingFromEntity(row) : null);
  }

  @override
  Stream<List<ViewingRequest>> watchRequests({
    String? renterId,
    String? ownerId,
  }) {
    final query = db.select(db.requests);
    if (renterId != null) {
      query.where((tbl) => tbl.renterId.equals(renterId));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    return query.watch().map(
      (rows) => rows.map(AppDatabase.requestFromEntity).toList(),
    );
  }

  @override
  Stream<ViewingRequest?> watchRequest(String id) {
    return (db.select(db.requests)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row != null ? AppDatabase.requestFromEntity(row) : null);
  }

  @override
  Stream<List<AuditEvent>> watchAuditEvents() {
    final query = db.select(db.auditEvents)
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    return query.watch().map(
      (rows) => rows.map(AppDatabase.auditEventFromEntity).toList(),
    );
  }

  @override
  Future<List<PropertyListing>> getListings() async {
    final rows = await db.select(db.listings).get();
    return rows.map(AppDatabase.listingFromEntity).toList();
  }

  @override
  Future<PropertyListing?> getListing(String id) async {
    final row = await (db.select(
      db.listings,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row != null ? AppDatabase.listingFromEntity(row) : null;
  }

  @override
  Future<List<ViewingRequest>> getRequests({
    String? renterId,
    String? ownerId,
  }) async {
    final query = db.select(db.requests);
    if (renterId != null) {
      query.where((tbl) => tbl.renterId.equals(renterId));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    final rows = await query.get();
    return rows.map(AppDatabase.requestFromEntity).toList();
  }

  @override
  Future<List<AuditEvent>> getAuditEvents() async {
    final query = db.select(db.auditEvents)
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(AppDatabase.auditEventFromEntity).toList();
  }

  @override
  Future<ValidationResult> submitViewingRequest({
    required String listingId,
    required String renterId,
    required String preferredWindow,
    String? note,
  }) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    // 1. Fetch listing
    final listing = await getListing(listingId);
    if (listing == null) {
      return const Rejected(
        ruleCode: 'ERR_LISTING_NOT_FOUND',
        userMessage: 'Listing not found.',
      );
    }

    // 2. Check if an active request already exists for this listing
    final allRequestsForListing = await (db.select(
      db.requests,
    )..where((tbl) => tbl.listingId.equals(listingId))).get();
    final hasActiveRequest = allRequestsForListing.any(
      (r) => activeRequestStatuses.contains(r.status),
    );

    // 3. Domain validation
    final validation = ProptechBusinessRules.validateNewViewingRequest(
      listing: listing,
      hasActiveRequestOnListing: hasActiveRequest,
      note: note ?? '',
      actorRole: Role.RENTER,
    );

    if (validation is Rejected) {
      // Record rejection audit event without mutating state
      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('ProptechRepository'),
              eventType: const Value(AuditEventType.RULE_REJECTED),
              previousState: Value(listing.state.name),
              newState: Value(listing.state.name),
              ruleOrErrorCode: Value(validation.ruleCode),
              summary: Value(
                'Viewing request rejected by rule ${validation.ruleCode}: ${validation.userMessage}',
              ),
            ),
          );
      return validation;
    }

    // 4. Atomic local commit (REQUESTED + PENDING_SYNC + VIEWING_REQUESTED + AuditEvent)
    final requestId = idGenerator.nextId(prefix: 'req');
    final idempotencyKey = idGenerator.nextIdempotencyKey();

    final newRequest = ViewingRequest(
      id: requestId,
      idempotencyKey: idempotencyKey,
      listingId: listingId,
      renterId: renterId,
      kind: RequestKind.VIEWING,
      preferredWindow: preferredWindow,
      note: note?.trim() ?? '',
      status: RequestStatus.REQUESTED,
      syncState: SyncState.PENDING_SYNC,
      clientListingVersion: listing.version,
      createdAt: now,
      updatedAt: now,
    );

    await db.transaction(() async {
      // Update listing to VIEWING_REQUESTED
      await (db.update(
        db.listings,
      )..where((tbl) => tbl.id.equals(listingId))).write(
        const ListingsCompanion(state: Value(ListingState.VIEWING_REQUESTED)),
      );

      // Insert new request
      await db
          .into(db.requests)
          .insert(AppDatabase.requestToCompanion(newRequest));

      // Append state transition audit event
      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('ProptechRepository'),
              eventType: const Value(AuditEventType.STATE_TRANSITION),
              previousState: Value('${listing.state.name} / NONE'),
              newState: const Value(
                'VIEWING_REQUESTED / REQUESTED (PENDING_SYNC)',
              ),
              ruleOrErrorCode: const Value(null),
              summary: Value(
                'Viewing requested locally for ${listing.title} (Listing: VIEWING_REQUESTED, Sync: PENDING_SYNC)',
              ),
            ),
          );
    });

    // 5. Coordinated simulated remote sync
    try {
      await remoteService.submitViewingRequest(newRequest, listing.version);

      // Sync accepted remotely -> SUBMITTED
      final syncTime = clock.now();
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          syncState: const Value(SyncState.SUBMITTED),
          updatedAt: Value(syncTime),
        ),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(syncTime),
              correlationId: Value(correlationId),
              component: const Value('SimulatedRemoteService'),
              eventType: const Value(AuditEventType.STATE_TRANSITION),
              previousState: const Value('PENDING_SYNC'),
              newState: const Value('SUBMITTED'),
              ruleOrErrorCode: const Value(null),
              summary: Value(
                'Viewing request $requestId synced remotely with server.',
              ),
            ),
          );

      return const Valid();
    } on NetworkException catch (e) {
      // Network drop: set SYNC_FAILED_RETRYABLE while keeping listing and request active
      final failTime = clock.now();
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          syncState: const Value(SyncState.SYNC_FAILED_RETRYABLE),
          updatedAt: Value(failTime),
        ),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(failTime),
              correlationId: Value(correlationId),
              component: const Value('SimulatedRemoteService'),
              eventType: const Value(AuditEventType.SYNC_FAILURE),
              previousState: const Value('PENDING_SYNC'),
              newState: const Value('SYNC_FAILED_RETRYABLE'),
              ruleOrErrorCode: const Value('ERR_NETWORK_DROP'),
              summary: Value(
                'Network drop simulated: request $requestId retained locally in SYNC_FAILED_RETRYABLE. ${e.message}',
              ),
            ),
          );

      return const Valid();
    } on StaleVersionConflict catch (e) {
      // Optimistic concurrency conflict: apply authoritative listing and abort request
      final conflictTime = clock.now();
      await db.transaction(() async {
        // Apply authoritative server listing
        await (db.update(
          db.listings,
        )..where((tbl) => tbl.id.equals(listingId))).write(
          ListingsCompanion(
            state: Value(e.authoritativeListing.state),
            version: Value(e.serverVersion),
          ),
        );

        // Mark request ABORTED with CONFLICT_STALE_DATA
        await (db.update(
          db.requests,
        )..where((tbl) => tbl.id.equals(requestId))).write(
          RequestsCompanion(
            status: const Value(RequestStatus.ABORTED),
            syncState: const Value(SyncState.CONFLICT_STALE_DATA),
            updatedAt: Value(conflictTime),
          ),
        );

        // Insert CONFLICT audit event with both versions
        await db
            .into(db.auditEvents)
            .insert(
              AuditEventsCompanion(
                timestamp: Value(conflictTime),
                correlationId: Value(correlationId),
                component: const Value('SimulatedRemoteService'),
                eventType: const Value(AuditEventType.CONFLICT),
                previousState: Value('v${e.clientVersion} (AVAILABLE)'),
                newState: Value(
                  'v${e.serverVersion} (${e.authoritativeListing.state.name})',
                ),
                ruleOrErrorCode: const Value('ERR_STALE_VERSION'),
                summary: Value(
                  'Conflict: Listing changed remotely from v${e.clientVersion} to v${e.serverVersion} (${e.authoritativeListing.state.name}). Request aborted.',
                ),
              ),
            );
      });

      return const Rejected(
        ruleCode: 'ERR_STALE_VERSION',
        userMessage:
            'Listing was modified remotely. Request has been aborted and listing updated.',
      );
    }
  }

  @override
  Future<ValidationResult> retrySync(String requestId) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    final reqRow = await (db.select(
      db.requests,
    )..where((tbl) => tbl.id.equals(requestId))).getSingleOrNull();

    if (reqRow == null) {
      return const Rejected(
        ruleCode: 'ERR_REQUEST_NOT_FOUND',
        userMessage: 'Request not found.',
      );
    }

    if (reqRow.syncState != SyncState.SYNC_FAILED_RETRYABLE) {
      return const Rejected(
        ruleCode: 'ERR_NOT_RETRYABLE',
        userMessage: 'Only retryable requests can be retried.',
      );
    }

    final request = AppDatabase.requestFromEntity(reqRow);

    // Update to PENDING_SYNC before retrying
    await (db.update(
      db.requests,
    )..where((tbl) => tbl.id.equals(requestId))).write(
      RequestsCompanion(
        syncState: const Value(SyncState.PENDING_SYNC),
        updatedAt: Value(now),
      ),
    );

    await db
        .into(db.auditEvents)
        .insert(
          AuditEventsCompanion(
            timestamp: Value(now),
            correlationId: Value(correlationId),
            component: const Value('ProptechRepository'),
            eventType: const Value(AuditEventType.RETRY),
            previousState: const Value('SYNC_FAILED_RETRYABLE'),
            newState: const Value('PENDING_SYNC'),
            ruleOrErrorCode: const Value(null),
            summary: Value(
              'Retrying sync for request $requestId using original idempotency key: ${request.idempotencyKey}',
            ),
          ),
        );

    // Perform simulated remote sync reusing the same request & idempotencyKey
    try {
      await remoteService.submitViewingRequest(
        request,
        request.clientListingVersion,
      );

      final successTime = clock.now();
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          syncState: const Value(SyncState.SUBMITTED),
          updatedAt: Value(successTime),
        ),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(successTime),
              correlationId: Value(correlationId),
              component: const Value('SimulatedRemoteService'),
              eventType: const Value(AuditEventType.STATE_TRANSITION),
              previousState: const Value('PENDING_SYNC'),
              newState: const Value('SUBMITTED'),
              ruleOrErrorCode: const Value(null),
              summary: Value(
                'Retry successful: Request $requestId synced remotely with server.',
              ),
            ),
          );

      return const Valid();
    } on NetworkException catch (e) {
      final failTime = clock.now();
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          syncState: const Value(SyncState.SYNC_FAILED_RETRYABLE),
          updatedAt: Value(failTime),
        ),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(failTime),
              correlationId: Value(correlationId),
              component: const Value('SimulatedRemoteService'),
              eventType: const Value(AuditEventType.SYNC_FAILURE),
              previousState: const Value('PENDING_SYNC'),
              newState: const Value('SYNC_FAILED_RETRYABLE'),
              ruleOrErrorCode: const Value('ERR_NETWORK_DROP'),
              summary: Value(
                'Retry failed: Network drop persisted for request $requestId. ${e.message}',
              ),
            ),
          );

      return const Valid();
    } on StaleVersionConflict catch (e) {
      final conflictTime = clock.now();
      await db.transaction(() async {
        await (db.update(
          db.listings,
        )..where((tbl) => tbl.id.equals(request.listingId))).write(
          ListingsCompanion(
            state: Value(e.authoritativeListing.state),
            version: Value(e.serverVersion),
          ),
        );

        await (db.update(
          db.requests,
        )..where((tbl) => tbl.id.equals(requestId))).write(
          RequestsCompanion(
            status: const Value(RequestStatus.ABORTED),
            syncState: const Value(SyncState.CONFLICT_STALE_DATA),
            updatedAt: Value(conflictTime),
          ),
        );

        await db
            .into(db.auditEvents)
            .insert(
              AuditEventsCompanion(
                timestamp: Value(conflictTime),
                correlationId: Value(correlationId),
                component: const Value('SimulatedRemoteService'),
                eventType: const Value(AuditEventType.CONFLICT),
                previousState: Value('v${e.clientVersion}'),
                newState: Value('v${e.serverVersion}'),
                ruleOrErrorCode: const Value('ERR_STALE_VERSION'),
                summary: Value(
                  'Conflict on retry: Listing changed remotely to v${e.serverVersion}. Request aborted.',
                ),
              ),
            );
      });

      return const Rejected(
        ruleCode: 'ERR_STALE_VERSION',
        userMessage: 'Listing was modified remotely. Request has been aborted.',
      );
    }
  }

  @override
  Future<ValidationResult> approveRequest(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  }) async {
    return _applyOwnerRequestTransition(
      requestId: requestId,
      actorId: actorId,
      actorRole: actorRole,
      targetStatus: RequestStatus.APPROVED,
      summarySuffix: 'Viewing request approved by owner.',
    );
  }

  @override
  Future<ValidationResult> declineRequest(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  }) async {
    return _applyOwnerRequestTransition(
      requestId: requestId,
      actorId: actorId,
      actorRole: actorRole,
      targetStatus: RequestStatus.DECLINED,
      releaseListingToAvailable: true,
      summarySuffix: 'Viewing request declined by owner. Listing released.',
    );
  }

  @override
  Future<ValidationResult> reopenRequest(
    String requestId,
    String actorId, {
    required String reason,
    Role actorRole = Role.OWNER,
  }) async {
    return _applyOwnerRequestTransition(
      requestId: requestId,
      actorId: actorId,
      actorRole: actorRole,
      targetStatus: RequestStatus.REOPENED,
      reopenReason: reason,
      reclaimListingToViewingRequested: true,
      summarySuffix: 'Viewing request reopened by owner: $reason',
    );
  }

  @override
  Future<ValidationResult> requestToken(
    String requestId,
    String actorId, {
    Role actorRole = Role.RENTER,
  }) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    final reqRow = await (db.select(
      db.requests,
    )..where((tbl) => tbl.id.equals(requestId))).getSingleOrNull();

    if (reqRow == null) {
      return const Rejected(
        ruleCode: 'ERR_REQUEST_NOT_FOUND',
        userMessage: 'Request not found.',
      );
    }

    final request = AppDatabase.requestFromEntity(reqRow);
    final listing = await getListing(request.listingId);
    if (listing == null) {
      return const Rejected(
        ruleCode: 'ERR_LISTING_NOT_FOUND',
        userMessage: 'Listing not found.',
      );
    }

    final validation = ProptechBusinessRules.validateTokenRequest(
      request: request,
      listing: listing,
      actorRole: actorRole,
    );

    if (validation is Rejected) {
      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('ProptechRepository'),
              eventType: const Value(AuditEventType.RULE_REJECTED),
              previousState: Value(request.status.name),
              newState: Value(request.status.name),
              ruleOrErrorCode: Value(validation.ruleCode),
              summary: Value(
                'Token hold request rejected: ${validation.userMessage}',
              ),
            ),
          );
      return validation;
    }

    await db.transaction(() async {
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          kind: const Value(RequestKind.TOKEN),
          status: const Value(RequestStatus.TOKEN_REQUESTED),
          updatedAt: Value(now),
        ),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('ProptechRepository'),
              eventType: const Value(AuditEventType.STATE_TRANSITION),
              previousState: const Value('APPROVED'),
              newState: const Value('TOKEN_REQUESTED'),
              ruleOrErrorCode: const Value(null),
              summary: Value(
                'Renter requested to hold property with token for request $requestId.',
              ),
            ),
          );
    });

    return const Valid();
  }

  @override
  Future<ValidationResult> confirmToken(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  }) async {
    return _applyOwnerRequestTransition(
      requestId: requestId,
      actorId: actorId,
      actorRole: actorRole,
      targetStatus: RequestStatus.TOKEN_CONFIRMED,
      setListingTokenLocked: true,
      summarySuffix:
          'Token confirmed by owner. Property transitioned to TOKEN_LOCKED.',
    );
  }

  @override
  Future<ValidationResult> markOffMarket(
    String listingId,
    String actorId, {
    Role actorRole = Role.OWNER,
  }) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    if (actorRole != Role.OWNER) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errNotPermitted,
        userMessage: 'Owner role required to take listing off-market.',
      );
    }

    final listing = await getListing(listingId);
    if (listing == null) {
      return const Rejected(
        ruleCode: 'ERR_LISTING_NOT_FOUND',
        userMessage: 'Listing not found.',
      );
    }

    await db.transaction(() async {
      await (db.update(
        db.listings,
      )..where((tbl) => tbl.id.equals(listingId))).write(
        const ListingsCompanion(state: Value(ListingState.UNAVAILABLE)),
      );

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('OwnerInbox'),
              eventType: const Value(AuditEventType.OWNER_DECISION),
              previousState: Value(listing.state.name),
              newState: const Value('UNAVAILABLE'),
              ruleOrErrorCode: const Value(null),
              summary: Value('Owner marked listing $listingId off-market.'),
            ),
          );
    });

    return const Valid();
  }

  @override
  Future<ValidationResult> relist(
    String listingId,
    String actorId, {
    Role actorRole = Role.OWNER,
  }) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    if (actorRole != Role.OWNER) {
      return const Rejected(
        ruleCode: ProptechBusinessRules.errNotPermitted,
        userMessage: 'Owner role required to relist.',
      );
    }

    final listing = await getListing(listingId);
    if (listing == null) {
      return const Rejected(
        ruleCode: 'ERR_LISTING_NOT_FOUND',
        userMessage: 'Listing not found.',
      );
    }

    await db.transaction(() async {
      await (db.update(db.listings)..where((tbl) => tbl.id.equals(listingId)))
          .write(const ListingsCompanion(state: Value(ListingState.AVAILABLE)));

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('OwnerInbox'),
              eventType: const Value(AuditEventType.OWNER_DECISION),
              previousState: Value(listing.state.name),
              newState: const Value('AVAILABLE'),
              ruleOrErrorCode: const Value(null),
              summary: Value('Owner relisted $listingId as AVAILABLE.'),
            ),
          );
    });

    return const Valid();
  }

  @override
  Future<int> runStartupRecovery() async {
    final pending = await (db.select(
      db.requests,
    )..where((tbl) => tbl.syncState.equals(SyncState.PENDING_SYNC.name))).get();

    if (pending.isEmpty) return 0;

    final now = clock.now();
    final correlationId = idGenerator.nextCorrelationId();

    await db.transaction(() async {
      for (final req in pending) {
        await (db.update(
          db.requests,
        )..where((tbl) => tbl.id.equals(req.id))).write(
          RequestsCompanion(
            syncState: const Value(SyncState.SYNC_FAILED_RETRYABLE),
            updatedAt: Value(now),
          ),
        );

        await db
            .into(db.auditEvents)
            .insert(
              AuditEventsCompanion(
                timestamp: Value(now),
                correlationId: Value(correlationId),
                component: const Value('StartupRecovery'),
                eventType: const Value(AuditEventType.RESUME_SCAN),
                previousState: const Value('PENDING_SYNC'),
                newState: const Value('SYNC_FAILED_RETRYABLE'),
                ruleOrErrorCode: const Value(null),
                summary: Value(
                  'Startup scan recovered interrupted pending sync for request ${req.id}. Safe retry available.',
                ),
              ),
            );
      }
    });

    return pending.length;
  }

  @override
  Future<void> resetToSeed() async {
    await DatabaseSeeder(db).seed(reset: true);
  }

  // --- Helper for owner request transitions ---

  Future<ValidationResult> _applyOwnerRequestTransition({
    required String requestId,
    required String actorId,
    required Role actorRole,
    required RequestStatus targetStatus,
    String? reopenReason,
    bool releaseListingToAvailable = false,
    bool reclaimListingToViewingRequested = false,
    bool setListingTokenLocked = false,
    required String summarySuffix,
  }) async {
    final correlationId = idGenerator.nextCorrelationId();
    final now = clock.now();

    final reqRow = await (db.select(
      db.requests,
    )..where((tbl) => tbl.id.equals(requestId))).getSingleOrNull();

    if (reqRow == null) {
      return const Rejected(
        ruleCode: 'ERR_REQUEST_NOT_FOUND',
        userMessage: 'Request not found.',
      );
    }

    final request = AppDatabase.requestFromEntity(reqRow);
    final listing = await getListing(request.listingId);

    // Check if another active request exists on the listing
    final otherRequests =
        await (db.select(db.requests)..where(
              (tbl) =>
                  tbl.listingId.equals(request.listingId) &
                  tbl.id.isNotIn([requestId]),
            ))
            .get();
    final hasOtherActive = otherRequests.any(
      (r) => activeRequestStatuses.contains(r.status),
    );

    final validation = ProptechBusinessRules.validateOwnerAction(
      actorRole: actorRole,
      request: request,
      targetStatus: targetStatus,
      reopenReason: reopenReason,
      listing: listing,
      hasOtherActiveRequest: hasOtherActive,
    );

    if (validation is Rejected) {
      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('OwnerInbox'),
              eventType: const Value(AuditEventType.RULE_REJECTED),
              previousState: Value(request.status.name),
              newState: Value(request.status.name),
              ruleOrErrorCode: Value(validation.ruleCode),
              summary: Value(
                'Owner action rejected: ${validation.userMessage}',
              ),
            ),
          );
      return validation;
    }

    // Atomic update
    await db.transaction(() async {
      await (db.update(
        db.requests,
      )..where((tbl) => tbl.id.equals(requestId))).write(
        RequestsCompanion(
          status: Value(targetStatus),
          reopenReason: reopenReason != null
              ? Value(reopenReason)
              : const Value.absent(),
          updatedAt: Value(now),
        ),
      );

      if (releaseListingToAvailable) {
        await (db.update(
          db.listings,
        )..where((tbl) => tbl.id.equals(request.listingId))).write(
          const ListingsCompanion(state: Value(ListingState.AVAILABLE)),
        );
      } else if (reclaimListingToViewingRequested) {
        await (db.update(
          db.listings,
        )..where((tbl) => tbl.id.equals(request.listingId))).write(
          const ListingsCompanion(state: Value(ListingState.VIEWING_REQUESTED)),
        );
      } else if (setListingTokenLocked) {
        await (db.update(
          db.listings,
        )..where((tbl) => tbl.id.equals(request.listingId))).write(
          const ListingsCompanion(state: Value(ListingState.TOKEN_LOCKED)),
        );
      }

      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: Value(correlationId),
              component: const Value('OwnerInbox'),
              eventType: const Value(AuditEventType.OWNER_DECISION),
              previousState: Value(request.status.name),
              newState: Value(targetStatus.name),
              ruleOrErrorCode: const Value(null),
              summary: Value(summarySuffix),
            ),
          );
    });

    return const Valid();
  }
}
