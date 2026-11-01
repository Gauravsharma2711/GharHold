import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/preview_state.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/rules/rules.dart';

void main() {
  group('GharHoldPreviewState Tests', () {
    late GharHoldPreviewState state;

    setUp(() {
      state = GharHoldPreviewState();
    });

    test(
      'Initial state contains 10 listings, default RENTER role, and NORMAL fault mode',
      () {
        expect(state.listings.length, 10);
        expect(state.currentRole, Role.RENTER);
        expect(state.faultMode, PreviewFaultMode.NORMAL);
        expect(state.selectedNeighbourhood, 'All');
      },
    );

    test('Seed listing L5 has active request held by renter r2', () {
      final l5 = state.getListingById('L5');
      expect(l5, isNotNull);
      expect(l5!.state, ListingState.VIEWING_REQUESTED);

      final active = state.getActiveRequestForListing('L5');
      expect(active, isNotNull);
      expect(active!.renterId, 'r2');
      expect(active.idempotencyKey, 'seed-r2-L5');
    });

    test('Filter by neighbourhood filters listings correctly', () {
      state.filterNeighbourhood('Powai');
      expect(
        state.filteredListings.every((l) => l.neighbourhood == 'Powai'),
        isTrue,
      );

      state.filterNeighbourhood('All');
      expect(state.filteredListings.length, 10);
    });

    test(
      'Submit valid viewing request updates listing to VIEWING_REQUESTED and adds request',
      () {
        final result = state.submitViewingRequest(
          listingId: 'L1',
          preferredWindow: 'Tomorrow 10am',
          note: 'Interested',
        );

        expect(result.isValid, isTrue);
        final l1 = state.getListingById('L1');
        expect(l1!.state, ListingState.VIEWING_REQUESTED);

        final req = state.getActiveRequestForListing('L1');
        expect(req, isNotNull);
        expect(req!.status, RequestStatus.REQUESTED);
        expect(req.syncState, SyncState.SUBMITTED);
      },
    );

    test('Second viewing request on same listing is rejected by BR-1b', () {
      // First request on L1
      state.submitViewingRequest(
        listingId: 'L1',
        preferredWindow: 'Tomorrow 10am',
        note: 'First',
      );

      // Second request on L1
      final res2 = state.submitViewingRequest(
        listingId: 'L1',
        preferredWindow: 'Tomorrow 12pm',
        note: 'Second',
      );

      expect(res2.isRejected, isTrue);
      expect(
        (res2 as Rejected).ruleCode,
        ProptechBusinessRules.errActiveRequestExists,
      );
    });

    test(
      'Drop network fault sets SYNC_FAILED_RETRYABLE while keeping listing locked',
      () {
        state.setFaultMode(PreviewFaultMode.DROP_NETWORK);
        final res = state.submitViewingRequest(
          listingId: 'L2',
          preferredWindow: 'Today 5pm',
          note: 'Network test',
        );

        expect(res.isValid, isTrue);
        final l2 = state.getListingById('L2');
        expect(l2!.state, ListingState.VIEWING_REQUESTED);

        final req = state.getActiveRequestForListing('L2');
        expect(req, isNotNull);
        expect(req!.syncState, SyncState.SYNC_FAILED_RETRYABLE);

        // Retry reuses idempotency key
        final keyBefore = req.idempotencyKey;
        state.setFaultMode(PreviewFaultMode.NORMAL);
        state.retryRequest(req.id);

        final reqAfter = state.getRequestById(req.id);
        expect(reqAfter!.syncState, SyncState.SUBMITTED);
        expect(reqAfter.idempotencyKey, keyBefore);
      },
    );

    test(
      'Stale conflict fault aborts request and refreshes listing to UNAVAILABLE v2',
      () {
        state.setFaultMode(PreviewFaultMode.STALE_CONFLICT);
        final res = state.submitViewingRequest(
          listingId: 'L4',
          preferredWindow: 'Weekend 11am',
          note: 'Conflict test',
        );

        expect(res.isValid, isTrue);
        final l4 = state.getListingById('L4');
        expect(l4!.state, ListingState.UNAVAILABLE);
        expect(l4.version, 2);

        final reqs = state.requests.where((r) => r.listingId == 'L4').toList();
        expect(reqs.isNotEmpty, isTrue);
        expect(reqs.first.status, RequestStatus.ABORTED);
        expect(reqs.first.syncState, SyncState.CONFLICT_STALE_DATA);
        expect(state.faultMode, PreviewFaultMode.NORMAL); // One-shot reset
      },
    );

    test('Owner approve, decline, and reopen with reason work seamlessly', () {
      // Create request on L1
      state.submitViewingRequest(
        listingId: 'L1',
        preferredWindow: 'Tomorrow 10am',
        note: 'Owner workflow test',
      );
      final req = state.getActiveRequestForListing('L1')!;

      // Switch role to OWNER
      state.setRole(Role.OWNER);

      // Approve
      final appRes = state.ownerApprove(req.id);
      expect(appRes.isValid, isTrue);
      expect(state.getRequestById(req.id)!.status, RequestStatus.APPROVED);

      // Decline
      final decRes = state.ownerDecline(req.id);
      expect(decRes.isValid, isTrue);
      expect(state.getRequestById(req.id)!.status, RequestStatus.DECLINED);
      expect(state.getListingById('L1')!.state, ListingState.AVAILABLE);

      // Reopen without reason fails (BR-2)
      final reopenEmpty = state.ownerReopen(req.id, '');
      expect(reopenEmpty.isRejected, isTrue);

      // Reopen with reason succeeds
      final reopenValid = state.ownerReopen(req.id, 'Available again');
      expect(reopenValid.isValid, isTrue);
      expect(state.getRequestById(req.id)!.status, RequestStatus.REOPENED);
      expect(state.getListingById('L1')!.state, ListingState.VIEWING_REQUESTED);
    });

    test('Reset preview data restores 10 initial fixtures', () {
      state.submitViewingRequest(
        listingId: 'L1',
        preferredWindow: 'Tomorrow 10am',
        note: 'Before reset',
      );
      expect(state.getListingById('L1')!.state, ListingState.VIEWING_REQUESTED);

      state.resetPreviewData();

      expect(state.getListingById('L1')!.state, ListingState.AVAILABLE);
      expect(state.listings.length, 10);
      expect(state.faultMode, PreviewFaultMode.NORMAL);
    });
  });
}
