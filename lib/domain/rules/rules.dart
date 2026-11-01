/// Frozen domain business rules for GharHold proptech coordination.
/// Pure Dart: zero Flutter, database or network imports.
library;

import '../models/listing.dart';
import '../models/request.dart';

sealed class ValidationResult {
  const ValidationResult();
  bool get isValid => this is Valid;
  bool get isRejected => this is Rejected;
}

final class Valid extends ValidationResult {
  const Valid();
}

final class Rejected extends ValidationResult {
  final String ruleCode;
  final String userMessage;

  const Rejected({required this.ruleCode, required this.userMessage});
}

class ProptechBusinessRules {
  static const String errListingNotAvailable = 'ERR_LISTING_NOT_AVAILABLE';
  static const String errActiveRequestExists = 'ERR_ACTIVE_REQUEST_EXISTS';
  static const String errInvalidNote = 'ERR_INVALID_NOTE';
  static const String errReopenReasonRequired = 'ERR_REOPEN_REASON_REQUIRED';
  static const String errIllegalTransition = 'ERR_ILLEGAL_TRANSITION';
  static const String errNotPermitted = 'ERR_NOT_PERMITTED';

  /// Validates a new viewing request creation by a renter.
  static ValidationResult validateNewViewingRequest({
    required PropertyListing listing,
    required bool hasActiveRequestOnListing,
    required String note,
    required Role actorRole,
  }) {
    if (actorRole != Role.RENTER) {
      return const Rejected(
        ruleCode: errNotPermitted,
        userMessage: 'Only renters can initiate viewing requests.',
      );
    }

    if (listing.state == ListingState.UNAVAILABLE ||
        listing.state == ListingState.TOKEN_LOCKED) {
      return const Rejected(
        ruleCode: errListingNotAvailable,
        userMessage: 'This listing is not available for new requests.',
      );
    }

    if (listing.state == ListingState.VIEWING_REQUESTED ||
        hasActiveRequestOnListing) {
      return const Rejected(
        ruleCode: errActiveRequestExists,
        userMessage:
            'A viewing is already in progress for this listing. Only one active request is allowed at a time.',
      );
    }

    final trimmedNote = note.trim();
    if (trimmedNote.length > 200) {
      return const Rejected(
        ruleCode: errInvalidNote,
        userMessage: 'Note cannot exceed 200 characters.',
      );
    }

    return const Valid();
  }

  /// Validates a request to hold with token (requires approved viewing).
  static ValidationResult validateTokenRequest({
    required ViewingRequest request,
    required PropertyListing listing,
    required Role actorRole,
  }) {
    if (actorRole != Role.RENTER) {
      return const Rejected(
        ruleCode: errNotPermitted,
        userMessage: 'Only renters can request token hold.',
      );
    }

    if (request.status != RequestStatus.APPROVED) {
      return const Rejected(
        ruleCode: errIllegalTransition,
        userMessage:
            'A token hold can only be requested after viewing is approved.',
      );
    }

    if (listing.state != ListingState.VIEWING_REQUESTED &&
        listing.state != ListingState.AVAILABLE) {
      return const Rejected(
        ruleCode: errListingNotAvailable,
        userMessage: 'Listing is not in a valid state for token hold.',
      );
    }

    return const Valid();
  }

  /// Validates owner response actions: approve, decline, mark off-market, confirm token.
  static ValidationResult validateOwnerAction({
    required Role actorRole,
    required ViewingRequest request,
    required RequestStatus targetStatus,
    String? reopenReason,
    PropertyListing? listing,
    bool hasOtherActiveRequest = false,
  }) {
    if (actorRole != Role.OWNER) {
      return const Rejected(
        ruleCode: errNotPermitted,
        userMessage: 'Owner role required to perform this action.',
      );
    }

    // Direct DECLINED -> APPROVED is strictly illegal
    if (request.status == RequestStatus.DECLINED &&
        targetStatus == RequestStatus.APPROVED) {
      return const Rejected(
        ruleCode: errIllegalTransition,
        userMessage:
            'Declined requests cannot be directly approved. Must reopen first with a reason.',
      );
    }

    // Reopening requires a non-empty reason and free listing
    if (targetStatus == RequestStatus.REOPENED) {
      if (request.status != RequestStatus.DECLINED) {
        return const Rejected(
          ruleCode: errIllegalTransition,
          userMessage: 'Only declined requests can be reopened.',
        );
      }
      final trimmedReason = reopenReason?.trim() ?? '';
      if (trimmedReason.isEmpty) {
        return const Rejected(
          ruleCode: errReopenReasonRequired,
          userMessage:
              'A non-empty reason is required to reopen a declined request.',
        );
      }
      if (listing != null &&
          (listing.state == ListingState.UNAVAILABLE ||
              listing.state == ListingState.TOKEN_LOCKED)) {
        return const Rejected(
          ruleCode: errListingNotAvailable,
          userMessage:
              'Cannot reopen request because listing is no longer available.',
        );
      }
      if (hasOtherActiveRequest) {
        return const Rejected(
          ruleCode: errActiveRequestExists,
          userMessage:
              'Cannot reopen request because another active request is holding this listing.',
        );
      }
      return const Valid();
    }

    // Standard state machine checks
    switch (targetStatus) {
      case RequestStatus.APPROVED:
        if (request.status != RequestStatus.REQUESTED &&
            request.status != RequestStatus.REOPENED) {
          return const Rejected(
            ruleCode: errIllegalTransition,
            userMessage: 'Only pending or reopened requests can be approved.',
          );
        }
        return const Valid();

      case RequestStatus.DECLINED:
        if (request.status == RequestStatus.ABORTED ||
            request.status == RequestStatus.TOKEN_CONFIRMED) {
          return const Rejected(
            ruleCode: errIllegalTransition,
            userMessage: 'Cannot decline a completed or aborted request.',
          );
        }
        return const Valid();

      case RequestStatus.TOKEN_CONFIRMED:
        if (request.status != RequestStatus.TOKEN_REQUESTED) {
          return const Rejected(
            ruleCode: errIllegalTransition,
            userMessage:
                'Can only confirm when token hold has been requested by the renter.',
          );
        }
        return const Valid();

      default:
        return Rejected(
          ruleCode: errIllegalTransition,
          userMessage:
              'Transition to ${targetStatus.name} is not permitted for owner.',
        );
    }
  }
}
