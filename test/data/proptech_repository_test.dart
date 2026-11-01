import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/local/database.dart';
import 'package:gharhold/data/local/database_seeder.dart';
import 'package:gharhold/data/remote/fault_config.dart';
import 'package:gharhold/data/remote/simulated_remote_service.dart';
import 'package:gharhold/data/repository/proptech_repository_impl.dart';
import 'package:gharhold/domain/models/audit_event.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/rules/rules.dart';

void main() {
  late AppDatabase db;
  late FaultConfig faultConfig;
  late SimulatedRemoteService remoteService;
  late ProptechRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.inMemory();
    await DatabaseSeeder(db).seed();
    faultConfig = FaultConfig(latency: Duration.zero);
    remoteService = SimulatedRemoteService(config: faultConfig);
    repository = ProptechRepositoryImpl(db: db, remoteService: remoteService);
  });

  tearDown(() async {
    await db.close();
  });

  group('ProptechRepository Transactional & Coordination Tests', () {
    test(
      'Initial seeded database contains 10 listings and L5 active request',
      () async {
        final listings = await repository.getListings();
        expect(listings.length, equals(10));

        final requests = await repository.getRequests();
        expect(requests.length, equals(1));
        expect(requests.first.idempotencyKey, equals('seed-r2-L5'));
        expect(requests.first.listingId, equals('L5'));
        expect(requests.first.status, equals(RequestStatus.REQUESTED));
        expect(requests.first.syncState, equals(SyncState.SUBMITTED));
      },
    );

    test(
      'Valid viewing request commits locally first and syncs remotely to SUBMITTED',
      () async {
        final result = await repository.submitViewingRequest(
          listingId: 'L1',
          renterId: 'r1',
          preferredWindow: 'Saturday 10:00 AM - 12:00 PM',
          note: 'Relocating to Powai.',
        );

        expect(result.isValid, isTrue);

        final updatedListing = await repository.getListing('L1');
        expect(updatedListing?.state, equals(ListingState.VIEWING_REQUESTED));

        final requests = await repository.getRequests(renterId: 'r1');
        expect(requests.length, equals(1));
        final req = requests.first;
        expect(req.listingId, equals('L1'));
        expect(req.status, equals(RequestStatus.REQUESTED));
        expect(req.syncState, equals(SyncState.SUBMITTED));

        // Verify audit events
        final events = await repository.getAuditEvents();
        expect(
          events.any((e) => e.eventType == AuditEventType.STATE_TRANSITION),
          isTrue,
        );
      },
    );

    test(
      'Rule rejection on UNAVAILABLE listing creates no request and logs RULE_REJECTED',
      () async {
        // L3 is seeded as UNAVAILABLE
        final result = await repository.submitViewingRequest(
          listingId: 'L3',
          renterId: 'r1',
          preferredWindow: 'Anytime',
          note: 'Interested',
        );

        expect(result.isRejected, isTrue);
        expect(
          (result as Rejected).ruleCode,
          equals(ProptechBusinessRules.errListingNotAvailable),
        );

        // No request created for L3
        final requests = await repository.getRequests(renterId: 'r1');
        expect(requests, isEmpty);

        // Listing state unchanged
        final listing = await repository.getListing('L3');
        expect(listing?.state, equals(ListingState.UNAVAILABLE));

        // Audit event logged
        final events = await repository.getAuditEvents();
        final rejEvent = events.firstWhere(
          (e) => e.eventType == AuditEventType.RULE_REJECTED,
        );
        expect(
          rejEvent.ruleOrErrorCode,
          equals(ProptechBusinessRules.errListingNotAvailable),
        );
      },
    );

    test(
      'Rule rejection on listing with active request (L5) prevents duplicate request',
      () async {
        // L5 has active request seed-r2-L5
        final result = await repository.submitViewingRequest(
          listingId: 'L5',
          renterId: 'r1',
          preferredWindow: 'Tomorrow',
          note: 'Second request',
        );

        expect(result.isRejected, isTrue);
        expect(
          (result as Rejected).ruleCode,
          equals(ProptechBusinessRules.errActiveRequestExists),
        );

        // Requests count still 1
        final requests = await repository.getRequests();
        expect(requests.length, equals(1));
      },
    );

    test(
      'Network drop fault retains active request and listing in SYNC_FAILED_RETRYABLE',
      () async {
        faultConfig.setDropNetwork();

        final result = await repository.submitViewingRequest(
          listingId: 'L2',
          renterId: 'r1',
          preferredWindow: 'Weekend Afternoon',
          note: 'Need parking space',
        );

        expect(result.isValid, isTrue);

        // Listing remains locked in VIEWING_REQUESTED
        final listing = await repository.getListing('L2');
        expect(listing?.state, equals(ListingState.VIEWING_REQUESTED));

        // Request is saved locally in SYNC_FAILED_RETRYABLE
        final requests = await repository.getRequests(renterId: 'r1');
        expect(requests.length, equals(1));
        final req = requests.first;
        expect(req.syncState, equals(SyncState.SYNC_FAILED_RETRYABLE));

        // Audit event logs SYNC_FAILURE
        final events = await repository.getAuditEvents();
        expect(
          events.any((e) => e.eventType == AuditEventType.SYNC_FAILURE),
          isTrue,
        );

        // Retrying while fault is still ON fails retryably
        await repository.retrySync(req.id);
        final reqAfterRetryFail = (await repository.getRequests(
          renterId: 'r1',
        )).first;
        expect(
          reqAfterRetryFail.syncState,
          equals(SyncState.SYNC_FAILED_RETRYABLE),
        );
        expect(reqAfterRetryFail.idempotencyKey, equals(req.idempotencyKey));

        // Turn network drop OFF and Retry Safely
        faultConfig.setNormal();
        final retryResult = await repository.retrySync(req.id);
        expect(retryResult.isValid, isTrue);

        final reqAfterSuccess = (await repository.getRequests(
          renterId: 'r1',
        )).first;
        expect(reqAfterSuccess.syncState, equals(SyncState.SUBMITTED));
        // Proves idempotency key and request ID were reused (exactly 1 request row for L2)
        expect(reqAfterSuccess.id, equals(req.id));
        expect(reqAfterSuccess.idempotencyKey, equals(req.idempotencyKey));

        final allRequestsForL2 = (await repository.getRequests()).where(
          (r) => r.listingId == 'L2',
        );
        expect(allRequestsForL2.length, equals(1));
      },
    );

    test(
      'Stale conflict fault aborts request, applies authoritative UNAVAILABLE v2, and logs CONFLICT',
      () async {
        faultConfig.setStaleConflict();

        final result = await repository.submitViewingRequest(
          listingId: 'L4',
          renterId: 'r1',
          preferredWindow: 'Sunday Morning',
          note: 'Moving next month',
        );

        expect(result.isRejected, isTrue);
        expect((result as Rejected).ruleCode, equals('ERR_STALE_VERSION'));

        // Listing is refreshed to authoritative version 2 and UNAVAILABLE
        final listing = await repository.getListing('L4');
        expect(listing?.state, equals(ListingState.UNAVAILABLE));
        expect(listing?.version, equals(2));

        // Request is marked ABORTED and CONFLICT_STALE_DATA
        final requests = await repository.getRequests(renterId: 'r1');
        expect(requests.length, equals(1));
        final req = requests.first;
        expect(req.status, equals(RequestStatus.ABORTED));
        expect(req.syncState, equals(SyncState.CONFLICT_STALE_DATA));

        // CONFLICT audit event with version info logged
        final events = await repository.getAuditEvents();
        final conflictEvent = events.firstWhere(
          (e) => e.eventType == AuditEventType.CONFLICT,
        );
        expect(conflictEvent.ruleOrErrorCode, equals('ERR_STALE_VERSION'));
        expect(conflictEvent.newState, contains('v2'));
      },
    );

    test('Owner approve, decline, and reopen flow', () async {
      // 1. Submit request on L1
      await repository.submitViewingRequest(
        listingId: 'L1',
        renterId: 'r1',
        preferredWindow: 'Weekend Morning',
      );
      final req = (await repository.getRequests(renterId: 'r1')).first;

      // 2. Owner approves
      final approveResult = await repository.approveRequest(req.id, 'o1');
      expect(approveResult.isValid, isTrue);
      var updatedReq = (await repository.getRequests(renterId: 'r1')).first;
      expect(updatedReq.status, equals(RequestStatus.APPROVED));

      // 3. Owner declines
      final declineResult = await repository.declineRequest(req.id, 'o1');
      expect(declineResult.isValid, isTrue);
      updatedReq = (await repository.getRequests(renterId: 'r1')).first;
      expect(updatedReq.status, equals(RequestStatus.DECLINED));

      // Listing is released back to AVAILABLE
      var listing = await repository.getListing('L1');
      expect(listing?.state, equals(ListingState.AVAILABLE));

      // 4. Direct approval of DECLINED request is rejected (BR-2)
      final directApprove = await repository.approveRequest(req.id, 'o1');
      expect(directApprove.isRejected, isTrue);

      // 5. Reopening without reason is rejected
      final reopenNoReason = await repository.reopenRequest(
        req.id,
        'o1',
        reason: '   ',
      );
      expect(reopenNoReason.isRejected, isTrue);

      // 6. Reopening with reason succeeds and reclaims listing
      final reopenValid = await repository.reopenRequest(
        req.id,
        'o1',
        reason: 'Slot freed up on Saturday',
      );
      expect(reopenValid.isValid, isTrue);
      updatedReq = (await repository.getRequests(renterId: 'r1')).first;
      expect(updatedReq.status, equals(RequestStatus.REOPENED));
      expect(updatedReq.reopenReason, equals('Slot freed up on Saturday'));

      listing = await repository.getListing('L1');
      expect(listing?.state, equals(ListingState.VIEWING_REQUESTED));
    });

    test(
      'Token workflow: Hold with token requires approval and locks listing upon confirmation',
      () async {
        // 1. Submit on L7
        await repository.submitViewingRequest(
          listingId: 'L7',
          renterId: 'r1',
          preferredWindow: 'Tomorrow Evening',
        );
        final req = (await repository.getRequests(renterId: 'r1')).first;

        // 2. Attempt token before approval -> Rejected
        final prematureToken = await repository.requestToken(req.id, 'r1');
        expect(prematureToken.isRejected, isTrue);

        // 3. Owner approves viewing
        await repository.approveRequest(req.id, 'o1');

        // 4. Renter requests token hold -> TOKEN_REQUESTED
        final tokenReq = await repository.requestToken(req.id, 'r1');
        expect(tokenReq.isValid, isTrue);
        var updatedReq = (await repository.getRequests(renterId: 'r1')).first;
        expect(updatedReq.status, equals(RequestStatus.TOKEN_REQUESTED));
        expect(updatedReq.kind, equals(RequestKind.TOKEN));

        // 5. Owner confirms token -> TOKEN_CONFIRMED & listing TOKEN_LOCKED
        final tokenConfirm = await repository.confirmToken(req.id, 'o1');
        expect(tokenConfirm.isValid, isTrue);
        updatedReq = (await repository.getRequests(renterId: 'r1')).first;
        expect(updatedReq.status, equals(RequestStatus.TOKEN_CONFIRMED));

        final listing = await repository.getListing('L7');
        expect(listing?.state, equals(ListingState.TOKEN_LOCKED));
      },
    );

    test(
      'Startup recovery converts leftover PENDING_SYNC to SYNC_FAILED_RETRYABLE',
      () async {
        // Insert a simulated interrupted request in PENDING_SYNC directly into DB
        final now = DateTime.now();
        await db
            .into(db.requests)
            .insert(
              RequestsCompanion(
                id: const drift.Value('req-interrupted'),
                idempotencyKey: const drift.Value('idem-interrupted'),
                listingId: const drift.Value('L8'),
                renterId: const drift.Value('r1'),
                kind: const drift.Value(RequestKind.VIEWING),
                preferredWindow: const drift.Value('Weekend'),
                note: const drift.Value('Interrupted submission'),
                status: const drift.Value(RequestStatus.REQUESTED),
                syncState: const drift.Value(SyncState.PENDING_SYNC),
                clientListingVersion: const drift.Value(1),
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
              ),
            );

        // Run startup recovery
        final recoveredCount = await repository.runStartupRecovery();
        expect(recoveredCount, equals(1));

        final recoveredReq = (await repository.getRequests(
          renterId: 'r1',
        )).firstWhere((r) => r.id == 'req-interrupted');
        expect(recoveredReq.syncState, equals(SyncState.SYNC_FAILED_RETRYABLE));

        final events = await repository.getAuditEvents();
        expect(
          events.any((e) => e.eventType == AuditEventType.RESUME_SCAN),
          isTrue,
        );
      },
    );

    test(
      'Reset to seed restores 10 initial listings and logs DATA_RESET',
      () async {
        // Modify a listing
        await repository.markOffMarket('L1', 'o1');
        var l1 = await repository.getListing('L1');
        expect(l1?.state, equals(ListingState.UNAVAILABLE));

        // Perform reset
        await repository.resetToSeed();

        // Verify L1 is back to AVAILABLE
        l1 = await repository.getListing('L1');
        expect(l1?.state, equals(ListingState.AVAILABLE));

        // Verify L5 has active request
        final requests = await repository.getRequests();
        expect(requests.length, equals(1));
        expect(requests.first.listingId, equals('L5'));

        // Verify DATA_RESET audit event
        final events = await repository.getAuditEvents();
        expect(
          events.any((e) => e.eventType == AuditEventType.DATA_RESET),
          isTrue,
        );
      },
    );
  });
}
