import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/rules/rules.dart';

void main() {
  group('Domain State Tables & Invariant Tests', () {
    const dummyListing = PropertyListing(
      id: 'L1',
      title: '1 BHK Powai',
      neighbourhood: 'Powai',
      bhk: 1,
      monthlyRent: 35000,
      depositMonths: 2,
      state: ListingState.AVAILABLE,
      version: 1,
      ownerId: 'o1',
    );

    test(
      'activeRequestStatuses contains exactly the 5 documented active statuses',
      () {
        expect(
          activeRequestStatuses,
          equals({
            RequestStatus.REQUESTED,
            RequestStatus.APPROVED,
            RequestStatus.REOPENED,
            RequestStatus.TOKEN_REQUESTED,
            RequestStatus.TOKEN_CONFIRMED,
          }),
        );

        // Verify inactive statuses are NOT in the set
        expect(activeRequestStatuses.contains(RequestStatus.DECLINED), isFalse);
        expect(activeRequestStatuses.contains(RequestStatus.ABORTED), isFalse);
      },
    );

    test('Listing states: validate new viewing request across all states', () {
      // AVAILABLE with no active request -> Valid
      final resAvail = ProptechBusinessRules.validateNewViewingRequest(
        listing: dummyListing.copyWith(state: ListingState.AVAILABLE),
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );
      expect(resAvail.isValid, isTrue);

      // UNAVAILABLE -> Rejected with ERR_LISTING_NOT_AVAILABLE
      final resUnavail = ProptechBusinessRules.validateNewViewingRequest(
        listing: dummyListing.copyWith(state: ListingState.UNAVAILABLE),
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );
      expect(resUnavail.isRejected, isTrue);
      expect(
        (resUnavail as Rejected).ruleCode,
        equals(ProptechBusinessRules.errListingNotAvailable),
      );

      // TOKEN_LOCKED -> Rejected with ERR_LISTING_NOT_AVAILABLE
      final resLocked = ProptechBusinessRules.validateNewViewingRequest(
        listing: dummyListing.copyWith(state: ListingState.TOKEN_LOCKED),
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );
      expect(resLocked.isRejected, isTrue);
      expect(
        (resLocked as Rejected).ruleCode,
        equals(ProptechBusinessRules.errListingNotAvailable),
      );

      // VIEWING_REQUESTED -> Rejected with ERR_ACTIVE_REQUEST_EXISTS
      final resActive = ProptechBusinessRules.validateNewViewingRequest(
        listing: dummyListing.copyWith(state: ListingState.VIEWING_REQUESTED),
        hasActiveRequestOnListing: false,
        note: 'Interested',
        actorRole: Role.RENTER,
      );
      expect(resActive.isRejected, isTrue);
      expect(
        (resActive as Rejected).ruleCode,
        equals(ProptechBusinessRules.errActiveRequestExists),
      );

      // AVAILABLE but hasActiveRequestOnListing=true -> Rejected with ERR_ACTIVE_REQUEST_EXISTS
      final resActiveFlag = ProptechBusinessRules.validateNewViewingRequest(
        listing: dummyListing.copyWith(state: ListingState.AVAILABLE),
        hasActiveRequestOnListing: true,
        note: 'Interested',
        actorRole: Role.RENTER,
      );
      expect(resActiveFlag.isRejected, isTrue);
      expect(
        (resActiveFlag as Rejected).ruleCode,
        equals(ProptechBusinessRules.errActiveRequestExists),
      );
    });

    test('Request transitions table for Owner', () {
      final now = DateTime.now();
      ViewingRequest makeReq(RequestStatus status) => ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idem-1',
        listingId: 'L1',
        renterId: 'renter-1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Weekend Morning',
        note: 'Hello',
        status: status,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: now,
        updatedAt: now,
      );

      // 1. Direct DECLINED -> APPROVED is forbidden
      final resDeclinedToApproved = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.DECLINED),
        targetStatus: RequestStatus.APPROVED,
      );
      expect(resDeclinedToApproved.isRejected, isTrue);
      expect(
        (resDeclinedToApproved as Rejected).ruleCode,
        equals(ProptechBusinessRules.errIllegalTransition),
      );

      // 2. Reopen without reason is forbidden
      final resReopenNoReason = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.DECLINED),
        targetStatus: RequestStatus.REOPENED,
        reopenReason: '   ',
      );
      expect(resReopenNoReason.isRejected, isTrue);
      expect(
        (resReopenNoReason as Rejected).ruleCode,
        equals(ProptechBusinessRules.errReopenReasonRequired),
      );

      // 3. Reopen with reason is allowed when listing is available
      final resReopenValid = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.DECLINED),
        targetStatus: RequestStatus.REOPENED,
        reopenReason: 'Slot opened up on Saturday',
        listing: dummyListing.copyWith(state: ListingState.AVAILABLE),
      );
      expect(resReopenValid.isValid, isTrue);

      // 4. Reopen fails if listing is UNAVAILABLE or TOKEN_LOCKED
      final resReopenUnavailable = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.DECLINED),
        targetStatus: RequestStatus.REOPENED,
        reopenReason: 'Slot opened',
        listing: dummyListing.copyWith(state: ListingState.UNAVAILABLE),
      );
      expect(resReopenUnavailable.isRejected, isTrue);
      expect(
        (resReopenUnavailable as Rejected).ruleCode,
        equals(ProptechBusinessRules.errListingNotAvailable),
      );

      // 5. Reopen fails if another active request exists
      final resReopenConflict = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.DECLINED),
        targetStatus: RequestStatus.REOPENED,
        reopenReason: 'Slot opened',
        listing: dummyListing.copyWith(state: ListingState.AVAILABLE),
        hasOtherActiveRequest: true,
      );
      expect(resReopenConflict.isRejected, isTrue);
      expect(
        (resReopenConflict as Rejected).ruleCode,
        equals(ProptechBusinessRules.errActiveRequestExists),
      );

      // 6. REQUESTED -> APPROVED: Valid
      final resReqApprove = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.REQUESTED),
        targetStatus: RequestStatus.APPROVED,
      );
      expect(resReqApprove.isValid, isTrue);

      // 7. REOPENED -> APPROVED: Valid
      final resReopenApprove = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.REOPENED),
        targetStatus: RequestStatus.APPROVED,
      );
      expect(resReopenApprove.isValid, isTrue);

      // 8. REQUESTED -> DECLINED: Valid
      final resReqDecline = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.REQUESTED),
        targetStatus: RequestStatus.DECLINED,
      );
      expect(resReqDecline.isValid, isTrue);

      // 9. ABORTED -> DECLINED: Rejected
      final resAbortedDecline = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.ABORTED),
        targetStatus: RequestStatus.DECLINED,
      );
      expect(resAbortedDecline.isRejected, isTrue);

      // 10. TOKEN_REQUESTED -> TOKEN_CONFIRMED: Valid
      final resConfirm = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.TOKEN_REQUESTED),
        targetStatus: RequestStatus.TOKEN_CONFIRMED,
      );
      expect(resConfirm.isValid, isTrue);

      // 11. REQUESTED -> TOKEN_CONFIRMED: Rejected (must be TOKEN_REQUESTED first)
      final resIllegalConfirm = ProptechBusinessRules.validateOwnerAction(
        actorRole: Role.OWNER,
        request: makeReq(RequestStatus.REQUESTED),
        targetStatus: RequestStatus.TOKEN_CONFIRMED,
      );
      expect(resIllegalConfirm.isRejected, isTrue);
    });

    test('Hold with token requires viewing request to be APPROVED', () {
      final now = DateTime.now();
      ViewingRequest makeReq(RequestStatus status) => ViewingRequest(
        id: 'r1',
        idempotencyKey: 'idem-1',
        listingId: 'L1',
        renterId: 'renter-1',
        kind: RequestKind.VIEWING,
        preferredWindow: 'Weekend Morning',
        note: 'Hello',
        status: status,
        syncState: SyncState.SUBMITTED,
        clientListingVersion: 1,
        createdAt: now,
        updatedAt: now,
      );

      // Renter requesting token on APPROVED viewing -> Valid
      final resValidToken = ProptechBusinessRules.validateTokenRequest(
        request: makeReq(RequestStatus.APPROVED),
        listing: dummyListing.copyWith(state: ListingState.VIEWING_REQUESTED),
        actorRole: Role.RENTER,
      );
      expect(resValidToken.isValid, isTrue);

      // Renter requesting token on REQUESTED viewing -> Rejected
      final resReqToken = ProptechBusinessRules.validateTokenRequest(
        request: makeReq(RequestStatus.REQUESTED),
        listing: dummyListing.copyWith(state: ListingState.VIEWING_REQUESTED),
        actorRole: Role.RENTER,
      );
      expect(resReqToken.isRejected, isTrue);

      // Owner attempting to request token -> Rejected with ERR_NOT_PERMITTED
      final resOwnerToken = ProptechBusinessRules.validateTokenRequest(
        request: makeReq(RequestStatus.APPROVED),
        listing: dummyListing.copyWith(state: ListingState.VIEWING_REQUESTED),
        actorRole: Role.OWNER,
      );
      expect(resOwnerToken.isRejected, isTrue);
      expect(
        (resOwnerToken as Rejected).ruleCode,
        equals(ProptechBusinessRules.errNotPermitted),
      );
    });
  });
}
