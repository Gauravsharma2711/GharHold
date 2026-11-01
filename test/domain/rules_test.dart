import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/rules/rules.dart';

void main() {
  group('ProptechBusinessRules - Invariant Tests', () {
    const sampleAvailableListing = PropertyListing(
      id: 'L1',
      title: 'Lakeview Horizon 2BHK',
      neighbourhood: 'Powai',
      bhk: 2,
      monthlyRent: 62000,
      depositMonths: 2,
      state: ListingState.AVAILABLE,
      version: 1,
      ownerId: 'o1',
    );

    test('BR-1: UNAVAILABLE listing rejects new viewing request', () {
      final unavail = sampleAvailableListing.copyWith(
        state: ListingState.UNAVAILABLE,
      );
      final result = ProptechBusinessRules.validateNewViewingRequest(
        listing: unavail,
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );

      expect(result.isRejected, isTrue);
      expect(
        (result as Rejected).ruleCode,
        ProptechBusinessRules.errListingNotAvailable,
      );
    });

    test('BR-1: TOKEN_LOCKED listing rejects new viewing request', () {
      final locked = sampleAvailableListing.copyWith(
        state: ListingState.TOKEN_LOCKED,
      );
      final result = ProptechBusinessRules.validateNewViewingRequest(
        listing: locked,
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );

      expect(result.isRejected, isTrue);
      expect(
        (result as Rejected).ruleCode,
        ProptechBusinessRules.errListingNotAvailable,
      );
    });

    test(
      'BR-1b: Listing in VIEWING_REQUESTED rejects a second active request',
      () {
        final viewingRequested = sampleAvailableListing.copyWith(
          state: ListingState.VIEWING_REQUESTED,
        );
        final result = ProptechBusinessRules.validateNewViewingRequest(
          listing: viewingRequested,
          hasActiveRequestOnListing: true,
          note: 'Second request',
          actorRole: Role.RENTER,
        );

        expect(result.isRejected, isTrue);
        expect(
          (result as Rejected).ruleCode,
          ProptechBusinessRules.errActiveRequestExists,
        );
      },
    );

    test(
      'Note length: Note over 200 trimmed characters rejects with ERR_INVALID_NOTE',
      () {
        final longNote = 'A' * 201;
        final result = ProptechBusinessRules.validateNewViewingRequest(
          listing: sampleAvailableListing,
          hasActiveRequestOnListing: false,
          note: longNote,
          actorRole: Role.RENTER,
        );

        expect(result.isRejected, isTrue);
        expect(
          (result as Rejected).ruleCode,
          ProptechBusinessRules.errInvalidNote,
        );
      },
    );

    test('Valid viewing request passes validation', () {
      final result = ProptechBusinessRules.validateNewViewingRequest(
        listing: sampleAvailableListing,
        hasActiveRequestOnListing: false,
        note: 'Looking for 11 months lease',
        actorRole: Role.RENTER,
      );

      expect(result.isValid, isTrue);
    });

    test('BR-2: DECLINED request cannot jump directly to APPROVED', () {
      final req = ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idemp-1',
        listingId: 'L1',
        renterId: 'r1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Tomorrow 10am',
        note: '',
        status: RequestStatus.DECLINED,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: req,
        targetStatus: RequestStatus.APPROVED,
      );

      expect(result.isRejected, isTrue);
      expect(
        (result as Rejected).ruleCode,
        ProptechBusinessRules.errIllegalTransition,
      );
    });

    test('BR-2: Reopening DECLINED request requires non-empty reason', () {
      final req = ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idemp-1',
        listingId: 'L1',
        renterId: 'r1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Tomorrow 10am',
        note: '',
        status: RequestStatus.DECLINED,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Empty reason
      final resEmpty = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: req,
        targetStatus: RequestStatus.REOPENED,
        reopenReason: '   ',
        listing: sampleAvailableListing,
      );
      expect(resEmpty.isRejected, isTrue);
      expect(
        (resEmpty as Rejected).ruleCode,
        ProptechBusinessRules.errReopenReasonRequired,
      );

      // Valid reason
      final resValid = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: req,
        targetStatus: RequestStatus.REOPENED,
        reopenReason: 'Schedule conflict resolved',
        listing: sampleAvailableListing,
      );
      expect(resValid.isValid, isTrue);
    });

    test('Owner-only actions reject Renter with ERR_NOT_PERMITTED', () {
      final req = ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idemp-1',
        listingId: 'L1',
        renterId: 'r1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Tomorrow 10am',
        note: '',
        status: RequestStatus.REQUESTED,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.RENTER,
        request: req,
        targetStatus: RequestStatus.APPROVED,
      );

      expect(result.isRejected, isTrue);
      expect(
        (result as Rejected).ruleCode,
        ProptechBusinessRules.errNotPermitted,
      );
    });

    test('Hold with token requires viewing request to be APPROVED', () {
      final pendingReq = ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idemp-1',
        listingId: 'L1',
        renterId: 'r1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Tomorrow 10am',
        note: '',
        status: RequestStatus.REQUESTED,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final resPending = ProptechBusinessRules.validateTokenRequest(
        request: pendingReq,
        listing: sampleAvailableListing,
        actorRole: Role.RENTER,
      );
      expect(resPending.isRejected, isTrue);
      expect(
        (resPending as Rejected).ruleCode,
        ProptechBusinessRules.errIllegalTransition,
      );

      final approvedReq = pendingReq.copyWith(status: RequestStatus.APPROVED);
      final resApproved = ProptechBusinessRules.validateTokenRequest(
        request: approvedReq,
        listing: sampleAvailableListing,
        actorRole: Role.RENTER,
      );
      expect(resApproved.isValid, isTrue);
    });
  });
}
